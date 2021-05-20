namespace F3M.Dashboard.API.Models
{
    public class Billing
    {
        public decimal Total { get; set; }
        public decimal Percentage { get; set; }
        public decimal AverageAmount { get; set; }
        public int NoOfDocsIssued { get; set; }
    }
}
