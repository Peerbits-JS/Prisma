using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class PerformanceSummaryService : IPerformanceSummaryService
    {
        readonly IUnitOfWork _unitOfWork;

        public PerformanceSummaryService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<PerformanceSummary> GetPerformanceSummary(Filter filter)
        {
            return new PerformanceSummary
            {
                Total = await GetTotal(filter),
                Aros = await GetAros(filter),
                OpthalmicLenses = await GetOpthalmicLenses(filter),
                ContactLenses = await GetContactLenses(filter),
                SunGlasses = await GetSunGlasses(filter),
                Several = await GetSeveral(filter)
            };
        }

        public async Task<ChartData> GetChartSummary(Filter filter)
        {
            return new ChartData
            {
                Chart = await GetChart(filter)
            };
        }

        public async Task<Total> GetTotal(Filter filter)
        {
            string query = "SELECT 15647.45 as 'TotalCurrency', 340.0 as 'AverageCurrency', 2598 as 'NumberOfDocuments'";
            return await _unitOfWork.ExecQuerySingleAsync<Total>(query, null);
        }

        public async Task<Aros> GetAros(Filter filter)
        {
            string query = "SELECT 5721.60 as 'TotalCurrency', 444.0 as 'AverageCurrency', 781 as 'NumberOfDocuments', 93.0 as 'Percentage'";
            return await _unitOfWork.ExecQuerySingleAsync<Aros>(query, null);
        }

        public async Task<OpthalmicLenses> GetOpthalmicLenses(Filter filter)
        {
            string query = "SELECT 3598.0 as 'TotalCurrency', 524.0 as 'AverageCurrency', 562 as 'NumberOfDocuments', 45.0 as 'Percentage'";
            return await _unitOfWork.ExecQuerySingleAsync<OpthalmicLenses>(query, null);
        }

        public async Task<ContactLenses> GetContactLenses(Filter filter)
        {
            string query = "SELECT 4587.0 as 'TotalCurrency', 541.0 as 'AverageCurrency', 541 as 'NumberOfDocuments', 47.0 as 'Percentage'";
            return await _unitOfWork.ExecQuerySingleAsync<ContactLenses>(query, null);
        }

        public async Task<SunGlasses> GetSunGlasses(Filter filter)
        {
            string query = "SELECT 5451.0 as 'TotalCurrency', 251.0 as 'AverageCurrency', 441 as 'NumberOfDocuments', 15.0 as 'Percentage'";
            return await _unitOfWork.ExecQuerySingleAsync<SunGlasses>(query, null);
        }

        public async Task<Several> GetSeveral(Filter filter)
        {
            string query = "SELECT 5441.0 as 'TotalCurrency', 254.0 as 'AverageCurrency', 414 as 'NumberOfDocuments', 74.0 as 'Percentage'";
            return await _unitOfWork.ExecQuerySingleAsync<Several>(query, null);
        }

        public async Task<Chart> GetChart(Filter filter)
        {
            string query = "SELECT '[\"AROS\",\"LENTES OFTÁLMICAS\",\"LENTES CONTACTO\",\"ÓCULOS DE SO\",\"DIVERSOS\"]' as 'XAxis', '[90,50,60,80,40]' as 'YAxis'";
            return await _unitOfWork.ExecQuerySingleAsync<Chart>(query, null);
        }
    }
}