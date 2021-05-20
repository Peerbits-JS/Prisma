namespace F3M.Dashboard.API.Models
{
    public class Dashboard
    {
        #region "billing"
        public BillingSummary BillingSummary { get; set; }
        #endregion

        #region "performance"
        public PerformanceSummary PerformanceSummary { get; set; }
        #endregion

        #region "chart"
        public ChartData ChartData { get; set; }
        #endregion

        #region "chart"
        //public List<User> UserData { get; set; }
        public UserSummary UserData { get; set; }
        #endregion

        #region "chart"
        //public List<Shop> ShopData { get; set; }
        public ShopSummary ShopData { get; set; }
        #endregion
    }
}
