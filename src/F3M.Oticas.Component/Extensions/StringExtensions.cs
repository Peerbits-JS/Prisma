using F3M.Oticas.Domain.Constants;
using F3M.Oticas.DTO.Enum;
using System.Collections.Generic;

namespace F3M.Oticas.Component.Extensions
{
    public static class StringExtensions
    {
        public static AccountingExportNatureType ToAccountingExportNatureType(this string natureDescription)
        {
            switch (natureDescription.ToLower())
            {
                case "c":
                    return AccountingExportNatureType.Credit;
                case "d":
                    return AccountingExportNatureType.Debit;
                default:
                    throw new KeyNotFoundException("A natureza informada não é conhecida.");
            }
        }

        public static AccountingExportModule ToAccountingExportModule(this string module)
        {
            switch (module)
            {
                case DocumentTypeConstants.Module.Stock:
                    return AccountingExportModule.Stock;
                case DocumentTypeConstants.Module.Purchase:
                    return AccountingExportModule.Purchase;
                case DocumentTypeConstants.Module.Sale:
                    return AccountingExportModule.Sales;
                case DocumentTypeConstants.Module.CurrentAccount:
                    return AccountingExportModule.CurrentAccount;

                default:
                    throw new KeyNotFoundException("O módulo informado não é conhecido.");
            }
        }
    }
}
