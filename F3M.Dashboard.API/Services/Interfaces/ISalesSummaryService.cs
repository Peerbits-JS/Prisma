using F3M.Dashboard.API.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface ISalesSummaryService
    {
        Task<ShopWiseSalesSummary> GetShopWiseSalesSummary(int year = 2021);
        //Task<List<MonthSalesNew>> GetShopWiseSalesSummary(int year = 2021);

        Task<List<MonthSalesNew>> PostShopWiseSalesSummary(ShopWiseSalesSummary shopWiseSalesSummary);
    }
}
