using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using System.Collections.Generic;
using System.Linq;
using static F3M.Oticas.Domain.Constants.AccountingExportConstants;

namespace F3M.Oticas.Domain.Extensions
{
    public static class AccountingConfigurationDetailExtensions
    {
        public static string GetAccountWithHeadTokenReplaced(this AccountingConfigurationDetail accountingConfigurationDetail, DocumentBase documentBase, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var account = accountingConfigurationDetail.Account.ToUpper();
            var module = documentBase.DocumentType.IdmoduloNavigation.Codigo;

            account = accountingConfigurations.ReplaceCustomerTokens(documentBase, account, module);
            account = accountingConfigurations.ReplaceProvidersTokens(documentBase, account, module);
            account = accountingConfigurations.ReplaceStoreTokens(documentBase, account);
            account = accountingConfigurations.ReplaceCountriesTokens(documentBase, account);
            account = accountingConfigurations.ReplaceEntitiesTokens(documentBase, account, module);

            return account;
        }

        public static string GetAccountWithLineTokenReplaced(this AccountingConfigurationDetail accountingConfigurationDetail, DocumentLineMain documentLineBase, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var account = accountingConfigurationDetail.Account.ToUpper();
            var documentBase = documentLineBase.GetDocumentBase();
            var module = documentBase.DocumentType.IdmoduloNavigation.Codigo;

            account = accountingConfigurations.ReplaceProductTypesTokens(documentLineBase, account);
            account = accountingConfigurations.ReplaceProductTokens(documentLineBase, account);
            account = accountingConfigurations.ReplaceDestinationWarehouseTokens(documentLineBase, account);
            account = accountingConfigurations.ReplaceOriginWarehouseTokens(documentLineBase, account);
            account = accountingConfigurations.ReplaceVatRatesTokens(documentLineBase, account);
            account = accountingConfigurations.ReplaceCustomerTokens(documentBase, account, module);
            account = accountingConfigurations.ReplaceProvidersTokens(documentBase, account, module);
            account = accountingConfigurations.ReplaceStoreTokens(documentBase, account);
            account = accountingConfigurations.ReplaceCountriesTokens(documentBase, account);

            return account;
        }

        public static string GetAccountWithLineTokenReplaced(this AccountingConfigurationDetail accountingConfigurationDetail, DocumentLineBase documentLineBase, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var account = accountingConfigurationDetail.Account.ToUpper();
            var documentBase = documentLineBase.GetDocumentBase();
            var module = documentBase.DocumentType.IdmoduloNavigation.Codigo;

            //account = accountingConfigurations.ReplaceCustomerTokens(documentBase, account, module);
            account = accountingConfigurations.ReplaceProvidersTokens(documentBase, account, module);

            return account;
        }

        public static string ReplaceCountriesTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentBase documentBase, string account)
        {
            if (account.Contains(Tokens.Countries))
            {
                var Idpais = documentBase.FiscalCountryId;
                if (Idpais == null)
                {
                    var obj = ((object)documentBase.GetDocumentBaseEntity());
                    var propertypais = obj.GetType().GetProperty("Idpais");
                    if (propertypais != null)
                    {
                        Idpais = (long?)obj.GetType().GetProperty("Idpais").GetValue(obj);
                    }
                }

                var entity = accountingConfigurations
                     .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "paises" && x.EntityId == Idpais)
                     .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.Countries, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceCustomerTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentBase documentBase, string account, string module)
        {
            if (account.Contains(Tokens.Customers) && (module == DocumentTypeConstants.Module.Sale || module == DocumentTypeConstants.Module.Stock || module == DocumentTypeConstants.Module.CurrentAccount))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "clientes" && x.EntityId == documentBase.EntityId && documentBase.EntityType.Code == "Clt")
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.Customers, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceEntitiesTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentBase documentBase, string account, string module)
        {
            if (account.Contains(Tokens.Entities) && module == DocumentTypeConstants.Module.Sale)
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "entidades" && x.EntityId == documentBase.GetEntityOne()?.Id)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.Entities, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplacePaymentTypeTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurationDetails, AccountingConfigurationDetail accountingConfigurationDetail, DocumentPaymentTypeBase PaymentType)
        {
            var account = accountingConfigurationDetail.Account.ToUpper();

            if (account.Contains(Tokens.PaymentType))
            {
                var entity = accountingConfigurationDetails
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "formaspagamento" && x.EntityId == PaymentType.PaymentTypeId)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                { 
                    return account;
                }

                account = account.Replace(Tokens.PaymentType, entity.AccountingVariable);
            }

            account = accountingConfigurationDetails.ReplaceCustomerTokens(PaymentType.GetDocumentBase(), account, DocumentTypeConstants.Module.Sale);

            return account;
        }

        public static string ReplaceProductTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase, string account)
        {
            if (account.Contains(Tokens.Products))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "artigos" && x.EntityId == documentLineBase.IdartigoNavigation.Id)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                { 
                    return account;
                }

                account = account.Replace(Tokens.Products, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceProductTypesTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase, string account)
        {
            if (account.Contains(Tokens.ProductTypes))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "tiposartigo" && x.EntityId == documentLineBase.IdartigoNavigation.ProductType.Id)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.ProductTypes, entity.AccountingVariable);
            }
            return account;
        }

        public static string ReplaceProvidersTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentBase documentBase, string account, string module)
        {
            if (account.Contains(Tokens.Providers) && (module == DocumentTypeConstants.Module.Purchase ||module == DocumentTypeConstants.Module.CurrentAccount))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "fornecedores" && x.EntityId == documentBase.EntityId && documentBase.EntityType.Code == "Fnd")
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.Providers, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceStoreTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentBase documentBase, string account)
        {
            if (account.Contains(Tokens.Stores))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "lojas" && x.EntityId == documentBase.StoreId)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.Stores, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceVatRatesTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase, string account)
        {
            if (account.Contains(Tokens.VatRates))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "taxasiva" && x.EntityId == documentLineBase.IdtaxaIva)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.VatRates, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceDestinationWarehouseTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase, string account)
        {
            if (account.Contains(Tokens.DestinationWarehouse))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "armazens" && x.EntityId == documentLineBase.Idarmazem)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.DestinationWarehouse, entity.AccountingVariable);
            }

            return account;
        }

        public static string ReplaceOriginWarehouseTokens(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase, string account)
        {
            if (account.Contains(Tokens.OriginWarehouse))
            {
                var entity = accountingConfigurations
                    .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "armazens" && x.EntityId == documentLineBase.Idarmazem)
                    .FirstOrDefault();

                if (string.IsNullOrEmpty(entity?.AccountingVariable))
                {
                    return account;
                }

                account = account.Replace(Tokens.OriginWarehouse, entity.AccountingVariable);
            }

            return account;
        }

        public static bool HasNoGoodsCostInPurchase(this IEnumerable<AccountingConfigurationDetail> accountingConfigurations, DocumentLineMain documentLineBase)
        {
            return accountingConfigurations
                        .Where(x => x.AccountingConfiguration.TypeCode.ToLower() == "tiposartigo" && x.EntityId == documentLineBase.IdartigoNavigation.ProductType.Id)
                        .Select(s => s.GoodsCostInPurchase ?? false)
                        .FirstOrDefault() is false;
        }
    }
}
