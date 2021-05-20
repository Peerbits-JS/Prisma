using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class BillingSummaryService : IBillingSummaryService
    {
        readonly IUnitOfWork _unitOfWork;

        public BillingSummaryService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<BillingSummary> GetBillingSummary(Filter filter)
        {
            return new BillingSummary
            {
                BillingDay = await GetBillingDay(filter),
                BillingLastDay = await GetBillingYesterday(filter),
                BillingMonth = await GetBillingMonth(filter),
                BillingYear = await GetBillingYear(filter)
            };
        }

        private async Task<Billing> GetBillingDay(Filter filter)
        {
            return await _unitOfWork.ExecQuerySingleAsync<Billing>(filter.GetQueryBillingToday(), filter.GetParametersForBillingToday());
        }

        private async Task<Billing> GetBillingYesterday(Filter filter)
        {
            return await _unitOfWork.ExecQuerySingleAsync<Billing>(filter.GetQueryBillingYesterday(), filter.GetParametersForBillingYesterday());
        }

        private async Task<Billing> GetBillingMonth(Filter filter)
        {
            return await _unitOfWork.ExecQuerySingleAsync<Billing>(filter.GetQueryMonth(), filter.GetParametersForMonth());
        }

        private async Task<Billing> GetBillingYear(Filter filter)
        {
            return await _unitOfWork.ExecQuerySingleAsync<Billing>(filter.GetQueryBillingYear(), filter.GetParametersForBillingYear());
        }

        public async Task<Billing> GetBillingTotalForToday(Filter filter)
        {
            return await GetBillingDay(filter);
        }

        public async Task<Billing> GetBillingTotalForYesterday(Filter filter)
        {
            return await GetBillingYesterday(filter);
        }

        public async Task<Billing> GetBillingTotalForCurrentMonth(Filter filter)
        {
            return await GetBillingMonth(filter);
        }

        public async Task<Billing> GetBillingTotalForCurrentYear(Filter filter)
        {
            return await GetBillingYear(filter);
        }
    }
}
