using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Extensions
{
    public static class DocumentLineBaseExtensions
    {
        public static double GetLineValue(this DocumentLineBase documentLineBase, AccountingConfigurationDetail accountingConfigurationDetail, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            if (accountingConfigurationDetail.IsIvaConfiguration()) return documentLineBase.GetVatValue();

            if (accountingConfigurationDetail.IsMerchandiseWithoutVAT()) return documentLineBase.GetIncidenceValue();

            if (accountingConfigurationDetail.IsMerchandiseWithVAT()) return documentLineBase.GetMerchandiseWithVat();

            if (accountingConfigurationDetail.IsGoodsCost() && accountingConfigurations.HasNoGoodsCostInPurchase(documentLineBase as DocumentLineMain))
            {
                return documentLineBase.GetCostOfGoods();
            }

            if (accountingConfigurationDetail.IsPurcharGoodsCost() && accountingConfigurations.HasNoGoodsCostInPurchase(documentLineBase as DocumentLineMain))
            {
                return documentLineBase.GetPurchaseCostOfGoods();
            }

            if (accountingConfigurationDetail.IsDiscount()) return documentLineBase.GetDiscount();

            if (accountingConfigurationDetail.IsTotalOfDocument()) return documentLineBase.GetDocumentBase().GetTotalCurrencyDocument();

            if (accountingConfigurationDetail.IsTotalReimbursement()) return documentLineBase.GetDocumentBase().GetTotalEntityOne();

            return 0;
        }

        public static AccountingExport CreateAccountingExport(this DocumentLineBase documentLineBase, AccountingConfiguration accountingConfiguration, AccountingConfigurationDetail accountingConfigurationDetail, IEnumerable<AccountingConfigurationDetail> accountingConfigurations, double value)
        {
            if (documentLineBase.GetType().BaseType == typeof(DocumentLineMain)) {
                return documentLineBase
                .GetDocumentBase()
                .CreateAccountingExport(accountingConfiguration, accountingConfigurationDetail, accountingConfigurationDetail.GetAccountWithLineTokenReplaced(documentLineBase as DocumentLineMain, accountingConfigurations), value);
            }

            return documentLineBase
                .GetDocumentBase()
                .CreateAccountingExport(accountingConfiguration, accountingConfigurationDetail, accountingConfigurationDetail.GetAccountWithLineTokenReplaced(documentLineBase, accountingConfigurations), value);
        }
    }
}