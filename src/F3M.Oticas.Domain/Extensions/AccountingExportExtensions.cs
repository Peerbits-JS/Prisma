using F3M.Oticas.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Extensions
{
    public static class AccountingExportExtensions
    {
        public static bool AreAllTokensReplaced(this IEnumerable<AccountingExport> accountingsToExport)
            => accountingsToExport.All(t => t.Account.IndexOfAny(new char[] { 'T', 'L', 'P', 'E', 'G', 'A', 'N', 'I', 'F', 'M' }) == -1);

        public static bool AreAllTokensReplaced(this AccountingExport accountingToExport)
            => accountingToExport.Account.IndexOfAny(new char[] { 'T', 'L', 'P', 'E', 'G', 'A', 'N', 'I', 'F', 'M' }) == -1;

        public static bool IsAccountingExportBalanced(this IEnumerable<AccountingExport> accountingsToExport)
        {
            var totalOfCredits = accountingsToExport
               .Where(accountingExport => accountingExport.IsCredit()  && string.IsNullOrEmpty(accountingExport.OriginAccount))
               .Sum(accountingExport => accountingExport.Value);

            var totalOfDebits = accountingsToExport
                .Where(accountingExport => accountingExport.IsDebit() && string.IsNullOrEmpty(accountingExport.OriginAccount))
                .Sum(accountingExport => accountingExport.Value);

            return Math.Round(totalOfCredits ?? 0, 2) == Math.Round(totalOfDebits ?? 0, 2);
        }
    }
}
