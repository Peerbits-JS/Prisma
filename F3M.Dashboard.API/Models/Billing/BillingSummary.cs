namespace F3M.Dashboard.API.Models
{
    public class BillingSummary
    {
        public Billing BillingDay { get; set; }
        public Billing BillingLastDay { get; set; }
        public Billing BillingMonth { get; set; }
        public Billing BillingYear { get; set; }
    }
}
