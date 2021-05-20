using F3M.Dashboard.API.Models;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface IPerformanceSummaryService
    {
        Task<PerformanceSummary> GetPerformanceSummary(Filter filter);
        
        Task<ChartData> GetChartSummary(Filter filter);

        //New code
        Task<Total> GetTotal(Filter filter);
        
        Task<Aros> GetAros(Filter filter);
        
        Task<OpthalmicLenses> GetOpthalmicLenses(Filter filter);
        
        Task<ContactLenses> GetContactLenses(Filter filter);
        
        Task<SunGlasses> GetSunGlasses(Filter filter);
        
        Task<Several> GetSeveral(Filter filter);
        
        Task<Chart> GetChart(Filter filter);
    }
}
