using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;
using System.Text;

namespace F3M.Oticas.Domain.Extensions
{
    public static class DocumentBaseExtensions
    {
        public static AccountingExport CreateAccountingExport(this DocumentBase documentBase, AccountingConfiguration accountingConfiguration, AccountingConfigurationDetail accountingConfigurationDetail, string account, double? value)
            => AccountingExport.Create(documentBase)
                .SetOrder()
                .SetAlternativeCode(accountingConfiguration.AlternativeCode)
                .SetAlternativeDescription(accountingConfiguration.AlternativeDescription)
                .SetJournalCode(accountingConfiguration.JournalCode)
                .SetDocumentCode(accountingConfiguration.DocumentCode)
                .SetReflectsVatClass(accountingConfiguration.ReflectsIVAClassByFinancialAccount)
                .SetVatClassAccount(accountingConfigurationDetail.IVAClass)
                .SetReflectsCostCenter(accountingConfiguration.ReflectsCostCenterByFinancialAccount)
                .SetCostCenterAccount(accountingConfigurationDetail.CostCenter)
                .SetAccount(account)
                .SetNatureDescription(accountingConfigurationDetail.NatureDescription)
                .SetValue(value)
                .MarkAsGeneratedIfLinesIsValid();

        public static AccountingExport CreateAccountingExport(this DocumentBase documentBase, AccountingConfiguration accountingConfiguration, AccountingConfigurationDetail accountingConfigurationDetail, IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentPaymentTypeBase paymentType) 
            => documentBase.CreateAccountingExport(accountingConfiguration, 
                                                   accountingConfigurationDetail, 
                                                   accountingConfigurations.ReplacePaymentTypeTokens(accountingConfigurationDetail, paymentType), 
                                                   paymentType.GetPaymentTypeValue());
    }


}
