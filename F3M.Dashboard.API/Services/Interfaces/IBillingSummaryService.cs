using F3M.Dashboard.API.Models;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface IBillingSummaryService
    {
        Task<BillingSummary> GetBillingSummary(Filter filter);

        Task<Billing> GetBillingTotalForToday(Filter filter);

        Task<Billing> GetBillingTotalForYesterday(Filter filter);

        Task<Billing> GetBillingTotalForCurrentMonth(Filter filter);

        Task<Billing> GetBillingTotalForCurrentYear(Filter filter);
    }
}
