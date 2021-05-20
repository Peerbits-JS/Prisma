using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Models
{
    public class MonthSalesNew
    {
        public Decimal JanSales { get; set; }
        public Decimal FebSales { get; set; }
        public Decimal MarSales { get; set; }
        public Decimal AprSales { get; set; }
        public Decimal MaySales { get; set; }
        public Decimal JunSales { get; set; }
        public Decimal JulSales { get; set; }
        public Decimal AugSales { get; set; }
        public Decimal SepSales { get; set; }
        public Decimal OctSales { get; set; }
        public Decimal NovSales { get; set; }
        public Decimal DecSales { get; set; }

        //New columns due to recent changes - 16Mar2021
        public Int64 Id { get; set; }
        public string ShopNo { get; set; } = "";
        public string ShopName { get; set; } = "";
        public Decimal Year { get; set; } = 2021;
    }
}
