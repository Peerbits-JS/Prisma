using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Domain.Extensions
{
    public static class AccountingConfigurationExtensions
    {
        public static IEnumerable<AccountingExport> GetDocumentDetailsWithHeadConfiguration(this AccountingConfiguration configuration, DocumentBase documentBase, IEnumerable<DocumentLineBase> documentLines, IEnumerable<AccountingConfigurationDetail> entities)
        {
            return configuration.Lines
                .Where(x => x.IsTotalOfDocument() || x.IsTotalReimbursement())
                .Select(configurationLine => documentBase.CreateAccountingExport(configuration,
                                                                                 configurationLine,
                                                                                 configurationLine.GetAccountWithHeadTokenReplaced(documentBase, entities),
                                                                                 documentLines.FirstOrDefault().GetLineValue(configurationLine, entities)));
        }

        public static IEnumerable<AccountingExport> GetDocumentDetailsWithLinesConfiguration(this AccountingConfiguration configuration, IEnumerable<DocumentLineBase> documentLines, IEnumerable<AccountingConfigurationDetail> accountingConfigurations)
        {
            var accountingExports = new List<AccountingExport>();
            var configurationLines = configuration.Lines.Where(x => (x.IsTotalOfDocument() || x.IsTotalReimbursement() || x.IsReceivedValue()) is false);

            foreach (var configurationLine in configurationLines)
            {
                foreach (var documentLine in documentLines)
                {
                    var accountingExport = documentLine.CreateAccountingExport(configuration, configurationLine, accountingConfigurations, documentLine.GetLineValue(configurationLine, accountingConfigurations));

                    accountingExports.Add(accountingExport);

                    if (configurationLine.HasCostCenter())
                    {
                        var duplicatedAccountingExport = accountingExport.ReplicateWithAccountingConfigurationDetail(documentLine.GetDocumentBase(), configurationLine, accountingConfigurations);

                        accountingExports.Add(duplicatedAccountingExport);
                    }
                }
            }

            return accountingExports;
        }

        public static IEnumerable<AccountingExport> GetDocumentDetailsWithPaymentConfiguration(this AccountingConfiguration configuration, DocumentBase documentBase, IEnumerable<AccountingConfigurationDetail> accountingConfigurations, IEnumerable<DocumentPaymentTypeBase> SalePaymentTypes)
            => configuration.Lines
            .Where(x => x.IsReceivedValue())
            .SelectMany(configurationLine => SalePaymentTypes
            .Select(salePaymentType => documentBase.CreateAccountingExport(configuration, configurationLine, accountingConfigurations, salePaymentType)));
    }
}
