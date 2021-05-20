using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class SalesSummaryService : ISalesSummaryService
    {
        readonly IUnitOfWork _unitOfWork;

        public SalesSummaryService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<List<MonthSalesNew>> GetShopWiseSalesSummaryNew(int year = 2021)
        {
            ShopWiseSalesSummary shopWiseSalesSummary = new ShopWiseSalesSummary();
            List<MonthSalesNew> monthSales = new List<MonthSalesNew>();
            string strQuery = "select * from MonthSalesNew";

            return await _unitOfWork.ExecQueryListAsync<MonthSalesNew>(strQuery, null);
        }

        private async Task<Shop> GetShopFirst()
        {
            string query = "SELECT 1.0 as 'Id', 'Shop 1' as 'ShopName', 'Shop' as 'ShopDesc'";
            return await _unitOfWork.ExecQuerySingleAsync<Shop>(query, null);
        }

        public async Task<ShopWiseSalesSummary> GetShopWiseSalesSummary(int year = 2021)
        {
            ShopWiseSalesSummary shopWiseSalesSummary = new ShopWiseSalesSummary();
            List<MonthSalesNew> list;

            string strQuery = "select * from MonthSalesNew where Year=" + year;
            list = await _unitOfWork.ExecQueryListAsync<MonthSalesNew>(strQuery, null);
            shopWiseSalesSummary.ShopWiseSales = list;

            return shopWiseSalesSummary;
        }

        private async Task<string> GetShopName()
        {
            string query = "SELECT \"Shop 1\" as 'ShopName'";
            return await _unitOfWork.ExecQuerySingleAsync<string>(query, null);
        }

        private async Task<string> GetShopNo()
        {
            string query = "SELECT \"1\" as 'ShopNo'";
            return await _unitOfWork.ExecQuerySingleAsync<string>(query, null);
        }

        private async Task<string> GetYear()
        {
            string query = "SELECT \"2021\" as 'Year'";
            return await _unitOfWork.ExecQuerySingleAsync<string>(query, null);
        }

        private async Task<List<MonthSalesNew>> MonthlySalesReport(ShopWiseSalesSummary shopWiseSalesSummary)
        {
            List<MonthSalesNew> listMonthSales = new List<MonthSalesNew>();
            List<MonthSalesNew> shopWiseSales = shopWiseSalesSummary.ShopWiseSales;

            foreach (var item in shopWiseSales)
            {
                MonthSalesNew monthSales = new MonthSalesNew();
                try
                {
                    monthSales.JanSales = item.JanSales;
                    monthSales.FebSales = item.FebSales;
                    monthSales.MarSales = item.MarSales;
                    monthSales.AprSales = item.AprSales;

                    monthSales.MaySales = item.MaySales;
                    monthSales.JunSales = item.JunSales;
                    monthSales.JulSales = item.JulSales;
                    monthSales.AugSales = item.AugSales;

                    monthSales.SepSales = item.SepSales;
                    monthSales.OctSales = item.OctSales;
                    monthSales.NovSales = item.NovSales;
                    monthSales.DecSales = item.DecSales;

                    monthSales.Year = 2021;
                    monthSales.ShopName = item.ShopName;
                    monthSales.ShopNo = item.ShopNo;

                    //_unitOfWork.ExecQueryUpdateAsync(monthSales);
                    _unitOfWork.ExecQueryNonAsync(monthSales);
                    _unitOfWork.Commit();

                    listMonthSales.Add(monthSales);
                }
                catch (System.Exception ex)
                {
                    throw;
                }
            }

            return listMonthSales;
        }

        public async Task<List<MonthSalesNew>> PostShopWiseSalesSummary(ShopWiseSalesSummary shopWiseSalesSummary)
        {
            List<MonthSalesNew> listMonthSales = new List<MonthSalesNew>();
            listMonthSales = await MonthlySalesReport(shopWiseSalesSummary);

            return listMonthSales;
        }
    }
}
