using F3M.Core.Domain.Entity;
using F3M.Core.Domain.Validators;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Translate;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public class AccountingConfiguration : EntityBase
    {

        public AccountingConfiguration()
        {
            Lines = new HashSet<AccountingConfigurationDetail>();
            AlternativeCode = AccountingConfigurationConstants.DefaultValues.DocumentTypesAlternativeCode;
            AlternativeDescription = AccountingConfigurationConstants.DefaultValues.DocumentTypesAlternativeDescription;
        }

        public string Year { get; set; }
        public string ModuleCode { get; set; }
        public string ModuleDescription { get; set; }
        public string TypeCode { get; set; }
        public string TypeDescription { get; set; }
        public string AlternativeCode { get; set; }
        public string AlternativeDescription { get; set; }
        public bool? IsPreset { get; set; }
        public string JournalCode { get; set; }
        public string DocumentCode { get; set; }
        public bool? ReflectsIVAClassByFinancialAccount { get; set; }
        public bool? ReflectsCostCenterByFinancialAccount { get; set; }
        public ICollection<AccountingConfigurationDetail> Lines { get; set; }
        public bool IsDocumentType() => Lines.Any(x => x.Account != null);
        public bool HasNoLines() => Lines.Any() is false;
        public bool HasNoDebitLines() => Lines.Any(line => line.IsDebit()) is false;
        public bool HasNoCreditLines() => Lines.Any(line => line.IsCredit()) is false;
        public bool HasInvalidLines() => Lines.Any(line => line.HasNoAccount() && line.HasNoValueDescription() && line.HasNoNatureDescription());

        public (bool, string) ValidateDocumentTypes()
        {
            if (string.IsNullOrEmpty(TypeCode) || string.IsNullOrEmpty(TypeDescription))
            {
                return (false, AccountingConfigurationResources.TypeIsRequired);
            }

            if (HasNoLines())
            {
                return (false, AccountingConfigurationResources.ConfigurationMustHaveAtLeastOneLine);
            }

            if (HasNoCreditLines() || HasNoDebitLines())
            {
                return (false, AccountingConfigurationResources.ConfigurationMustHaveAtLeastOneDebitAndCreditLine);
            }

            if (HasInvalidLines())
            {
                return (false, AccountingConfigurationResources.ConfigurationHasInvalidLines);
            }

            return (true, string.Empty);
        }

        public (bool, string) ValidateAccounts()
        {
            if (string.IsNullOrEmpty(TypeCode) || string.IsNullOrEmpty(TypeDescription))
            {
                return (false, AccountingConfigurationResources.TypeIsRequired);
            }

            return (true, string.Empty);
        }

        public bool IsHeadConfiguration()
            => GetRulesToDocumentLines().Any() is false && GetRulesToDocumentHead().Any();


        public IEnumerable<AccountingConfigurationDetail> GetRulesToDocumentLines()
        {
            var linesRulesValue = new List<long>
            {
                AccountingConfigurationConstants.Value.Vat,
                AccountingConfigurationConstants.Value.MerchandiseWithoutVat,
                AccountingConfigurationConstants.Value.MerchandiseWithVat,
                AccountingConfigurationConstants.Value.MerchandiseCost,
                AccountingConfigurationConstants.Value.MerchandisePurchaseCost,
                AccountingConfigurationConstants.Value.Discount
            };

            return Lines.Where(line => linesRulesValue.Any(ruleValue => ruleValue == line.ValueId));
        }

        public IEnumerable<AccountingConfigurationDetail> GetRulesToDocumentHead()
        {
            var headRulesValue = new List<long>
            {
                AccountingConfigurationConstants.Value.TotalDocument,
                AccountingConfigurationConstants.Value.TotalReimbursement,
                AccountingConfigurationConstants.Value.ReceiptValue
            };

            return Lines.Where(line => headRulesValue.Any(ruleValue => ruleValue == line.ValueId));
        }

        public void AddLines(ICollection<AccountingConfigurationDetail> lines)
            => Lines = lines;

        public void MarkPresetAsFalse() => IsPreset = false;
    }
}
