using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class PerformanceController : ControllerBase
    {
        readonly IPerformanceSummaryService _performanceSummaryService;

        #region "ctor"
        public PerformanceController(
            IPerformanceSummaryService performanceSummaryService)
        {
            _performanceSummaryService = performanceSummaryService;
        }
        #endregion

        [HttpPost]
        public async Task<IActionResult> GetPerformance(Filter filter = null)
        {
            return Ok(new PerformanceSummary
            {
                Aros = new Aros { AverageCurrency = 1, NumberOfDocuments = 2, Percentage = 50, TotalCurrency = 100 },
                ContactLenses = new ContactLenses { AverageCurrency = 1, NumberOfDocuments = 2, Percentage = 50, TotalCurrency = 100 },
                OpthalmicLenses = new OpthalmicLenses { AverageCurrency = 1, NumberOfDocuments = 2, Percentage = 50, TotalCurrency = 100 },
                Several = new Several { AverageCurrency = 1, NumberOfDocuments = 2, Percentage = 50, TotalCurrency = 100 },
                SunGlasses = new SunGlasses { AverageCurrency = 1, NumberOfDocuments = 2, Percentage = 50, TotalCurrency = 100 },
                Total = new Total { AverageCurrency = 1, TotalCurrency = 100, NumberOfDocuments = 1 },
                Chart = await _performanceSummaryService.GetChart(filter)
            });
        }

        [HttpPost]
        public async Task<IActionResult> GetTotal(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetTotal(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetAros(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetAros(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetOpthalmicLenses(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetOpthalmicLenses(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetContactLenses(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetContactLenses(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetSunGlasses(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetSunGlasses(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetSeveral(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetSeveral(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetChart(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetChart(filter));
        }
    }
}