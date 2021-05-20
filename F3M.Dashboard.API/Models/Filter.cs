using System;
using System.Collections.Generic;

namespace F3M.Dashboard.API.Models
{
    public class Filter
    {
        public long[] StoresId { get; set; }

        public long[] UsersId { get; set; }

        public DateTime ReferenceDate { get; set; }

        public bool IsSale { get; set; }

        #region "billing today"
        public string GetQueryBillingToday()
        {
            if (IsSale)
            {
                return "select * from[dbo].[fnSalesTotalQtyAverage] (@DataDe, @DataAte, @Lojas, @Utilizadores, @Objetivo)";
            }

            return "select * from[dbo].[fnSalesMargins] (@DataDe, @DataAte, @Lojas, @Utilizadores)";
        }

        public Dictionary<string, object> GetParametersForBillingToday()
        {
            var parameters = new Dictionary<string, object>() {
                { "@DataDe", ReferenceDate },
                { "@DataAte", ReferenceDate },
                { "@Lojas", String.Join(",", StoresId) },
                { "@Utilizadores", String.Join(",", UsersId) }
            };

            if (IsSale)
            {
                parameters.Add("@Objetivo", 0);
            }

            return parameters;
        }
        #endregion

        #region "last day"
        public string GetQueryBillingYesterday()
        {
            if (IsSale)
            {
                return "select * from[dbo].[fnSalesTotalQtyAverage] (@DataDe, @DataAte, @Lojas, @Utilizadores, @Objetivo)";
            }

            return "select * from[dbo].[fnSalesMargins] (@DataDe, @DataAte, @Lojas, @Utilizadores)";
        }

        public Dictionary<string, object> GetParametersForBillingYesterday()
        {
            var parameters = new Dictionary<string, object>() {
                { "@DataDe", ReferenceDate.AddDays(-1) },
                { "@DataAte", ReferenceDate.AddDays(-1) },
                { "@Lojas", String.Join(",", StoresId) },
                { "@Utilizadores", String.Join(",", UsersId) }
            };

            if (IsSale)
            {
                parameters.Add("@Objetivo", 750);
            }

            return parameters;
        }
        #endregion

        #region "month"
        public string GetQueryMonth()
        {
            if (IsSale)
            {
                return "select * from[dbo].[fnSalesTotalQtyAverage] (@DataDe, @DataAte, @Lojas, @Utilizadores, @Objetivo)";
            }

            return "select * from[dbo].[fnSalesMargins] (@DataDe, @DataAte, @Lojas, @Utilizadores)";
        }

        public Dictionary<string, object> GetParametersForMonth()
        {
            var firstDayOfMonth = new DateTime(ReferenceDate.Year, ReferenceDate.Month, 1);
            var lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            var parameters = new Dictionary<string, object>() {
                { "@DataDe", firstDayOfMonth },
                { "@DataAte", lastDayOfMonth },
                { "@Lojas", String.Join(",", StoresId) },
                { "@Utilizadores", String.Join(",", UsersId) }
            };

            if (IsSale)
            {
                parameters.Add("@Objetivo", 0);
            }

            return parameters;
        }
        #endregion

        #region "year"
        public string GetQueryBillingYear()
        {
            if (IsSale)
            {
                return "select * from[dbo].[fnSalesTotalQtyAverage] (@DataDe, @DataAte, @Lojas, @Utilizadores, @Objetivo)";
            }

            return "select * from[dbo].[fnSalesMargins] (@DataDe, @DataAte, @Lojas, @Utilizadores)";
        }

        public Dictionary<string, object> GetParametersForBillingYear()
        {
            var firstDayOfYear = new DateTime(ReferenceDate.Year, 1, 1);
            var lastDayOfYear = new DateTime(ReferenceDate.Year, 12, 31);

            var parameters = new Dictionary<string, object>() {
                { "@DataDe", firstDayOfYear },
                { "@DataAte", lastDayOfYear },
                { "@Lojas", String.Join(",", StoresId) },
                { "@Utilizadores", String.Join(",", UsersId) }
            };


            if (IsSale)
            {
                parameters.Add("@Objetivo", 10000);
            }

            return parameters;
        }
        #endregion
    }
}
