using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Models
{
    public class MonthSales
    {
        public decimal JanSales { get; set; }
        public decimal FebSales { get; set; }
        public decimal MarSales { get; set; }
        public decimal AprSales { get; set; }
        public decimal MaySales { get; set; }
        public decimal JunSales { get; set; }
        public decimal JulSales { get; set; }
        public decimal AugSales { get; set; }
        public decimal SepSales { get; set; }
        public decimal OctSales { get; set; }
        public decimal NovSales { get; set; }
        public decimal DecSales { get; set; }

        //New columns due to recent changes - 16Mar2021
        //public Int64 Id { get; set; }
        //public string ShopNo { get; set; } = "";
        //public string ShopName { get; set; } = "";
        //public int Year { get; set; } = 2021;
    }
}
