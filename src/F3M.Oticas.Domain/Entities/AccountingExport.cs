using F3M.Core.Domain.Entity;
using F3M.Core.Domain.Validators;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.Domain.Enum;
using F3M.Oticas.Domain.Extensions;
using F3M.Oticas.Translate;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public class AccountingExport : EntityBase
    {
        public AccountingExport()
        {
        }
        // -- main
        public long Order { get; set; }
        public string DocumentModuleTypeCode { get; protected set; }
        public string DocumentModuleTypeDescription { get; protected set; }
        // -- doc
        public long DocumentId { get; protected set; }
        public string Document { get; protected set; }
        public string ExternalDocumentNumber { get; protected set; }
        public long? DocumentNumber { get; protected set; }
        public DateTime DocumentDate { get; protected set; }
        public long? StoreId { get; protected set; }
        public string StoreCode { get; protected set; }
        public long DocumentTypeId { get; protected set; }
        public string DocumentTypeCode { get; protected set; }
        public long SerieDocumentTypeId { get; protected set; }
        public string SerieDocumentTypeCode { get; protected set; }
        public long? EntityId { get; protected set; }
        public string EntityCode { get; protected set; }
        public string Entity { get; protected set; }
        public long? EntityTypeId { get; protected set; }
        public string EntityTypeCode { get; protected set; }
        // -- config
        public string AlternativeCode { get; protected set; }
        public string AlternativeDescription { get; protected set; }
        public string JournalCode { get; protected set; }
        public string DocumentCode { get; protected set; }
        public bool? ReflectsVatClass { get; protected set; }
        public string VatClassAccount { get; protected set; }
        public bool? ReflectsCostCenter { get; protected set; }
        public string CostCenterAccount { get; protected set; }
        // -- config lines
        public string Account { get; protected set; }
        public string OriginAccount { get; protected set; }



        public double? Value { get; protected set; }
        public string NatureDescription { get; protected set; }
        public bool IsGenerated { get; protected set; }
        public bool IsExported { get; set; }
        public bool HasErrors { get; protected set; }
        public string ErrorNotes { get; protected set; }


        public bool? IsCostCenter { get; protected set; }

        public static AccountingExport Create(DocumentBase documentBase)
           => new AccountingExport(documentBase);

        private AccountingExport(DocumentBase documentBase)
        {
            DocumentId = documentBase.Id;
            Document = documentBase.Document;
            DocumentNumber = documentBase.DocumentNumber;
            ExternalDocumentNumber = documentBase.ExternalDocumentNumber;
            DocumentDate = documentBase.DocumentDate;

            DocumentTypeId = documentBase.DocumentTypeId;
            DocumentTypeCode = documentBase.DocumentType.Codigo;
            DocumentModuleTypeCode = documentBase.DocumentType.IdmoduloNavigation.Codigo;
            DocumentModuleTypeDescription = SystemModuleResources.ResourceManager.GetString(documentBase.DocumentType.IdmoduloNavigation.Descricao);

            SerieDocumentTypeId = documentBase.DocumentTypeSeriesId;
            SerieDocumentTypeCode = documentBase.DocumentTypeSeries.CodigoSerie;

            StoreId = documentBase.StoreId;
            StoreCode = documentBase.Store.Codigo;

            EntityId = documentBase.EntityId;
            EntityCode = documentBase.GetDocumentBaseEntity()?.Codigo;
            Entity = documentBase.FiscalName;

            EntityTypeId = documentBase.EntityTypeId;
            EntityTypeCode = documentBase.EntityType.Code;
        }

        public AccountingExport MarkWithHeadError(string error)
        {
            HasErrors = true;
            ErrorNotes = error;
            return this;
        }

        public AccountingExport MarkWithErrors(List<string> errors)
        {
            HasErrors = true;
            ErrorNotes = string.Join("; ", errors);
            IsGenerated = false;
            IsExported = false;
            return this;
        }

        public AccountingExport MarkAsGeneratedIfLinesIsValid()
        {
            if (HasErrors is true)
            {
                IsGenerated = false;
                return this;
            }

            IsGenerated = true;
            return this;
        }

        public AccountingExport SetOrder()
        {
            Order = 1;
            return this;
        }

        public AccountingExport SetAlternativeCode(string alternativeCode)
        {
            AlternativeCode = alternativeCode;
            return this;
        }

        public AccountingExport SetAlternativeDescription(string alternativeDescription)
        {
            AlternativeDescription = alternativeDescription;
            return this;
        }

        public AccountingExport SetJournalCode(string journalCode)
        {
            JournalCode = journalCode;
            return this;
        }

        public AccountingExport SetDocumentCode(string documentCode)
        {
            DocumentCode = documentCode;
            return this;
        }

        public AccountingExport SetReflectsVatClass(bool? reflectsVatClass)
        {
            ReflectsVatClass = reflectsVatClass;
            return this;
        }

        public AccountingExport SetVatClassAccount(string vatClassAccount)
        {
            VatClassAccount = vatClassAccount;
            return this;
        }

        public AccountingExport SetReflectsCostCenter(bool? reflectsCostCenter)
        {
            ReflectsCostCenter = reflectsCostCenter;
            return this;
        }

        public AccountingExport SetCostCenterAccount(string costCenterAccount)
        {
            CostCenterAccount = costCenterAccount;
            return this;
        }

        public AccountingExport SetAccount(string account)
        {
            Account = account;
            return this;
        }

        public AccountingExport SetNatureDescription(string natureDescription)
        {
            NatureDescription = natureDescription;
            return this;
        }

        public AccountingExport SetOriginAccount(string originAccount)
        {
            OriginAccount = originAccount;
            return this;
        }

        public AccountingExport SetValue(double? value)
        {
            Value = value;
            return this;
        }

        public AccountingExport SetIsGenerated(bool isGenerated)
        {
            IsGenerated = isGenerated;
            return this;
        }

        public AccountingExport SetCostCenter(bool? isCostCenter)
        {
            IsCostCenter = isCostCenter;
            return this;
        }

        public bool IsDebit() => NatureDescription == "D";

        public bool IsCredit() => NatureDescription == "C";

        public AccountingExport ReplicateWithAccountingConfigurationDetail(DocumentBase documentBase, AccountingConfigurationDetail accountingConfigurationDetail, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var other = (AccountingExport)MemberwiseClone();
            other.SetCostCenterAccount(Account).SetOriginAccount(Account).SetAccount(accountingConfigurationDetail.CostCenter).SetCostCenter(true);

            var accountAux = accountingConfigurationDetail.Account;
            accountingConfigurationDetail.Account = accountingConfigurationDetail.CostCenter;

            other.SetAccount(accountingConfigurationDetail.GetAccountWithHeadTokenReplaced(documentBase.GetDocumentBase(), accountingConfigurations));

            accountingConfigurationDetail.Account = accountAux;
            return other;
        }

    }
}
