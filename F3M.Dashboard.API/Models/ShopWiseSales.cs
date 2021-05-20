using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Models
{
    public class ShopWiseSales
    {
        public string ShopNo { get; set; }
        public string ShopName { get; set; }
        public int Year { get; set; }
        public MonthSales MonthSales { get; set; }
    }

    public class ShopWiseSalesSummary
    {
        public List<MonthSalesNew> ShopWiseSales { get; set; }
    }
}
