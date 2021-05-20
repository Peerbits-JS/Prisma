using System.Collections.Generic;

namespace F3M.Dashboard.API.Models
{
    public class Shop
    {
        public decimal Id { get; set; }
        public string ShopName { get; set; }
        public string ShopDesc { get; set; }
    }

    public class ShopSummary
    {
        public ShopSummary()
        {
            Shops = new();
        }

        public List<Shop> Shops { get; set; }
    }
}
