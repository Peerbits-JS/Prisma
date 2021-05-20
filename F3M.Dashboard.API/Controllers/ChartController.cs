using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class ChartController : ControllerBase
    {
        readonly IPerformanceSummaryService _performanceSummaryService;
        readonly ISalesSummaryService _salesSummaryService;

        #region "ctor"
        public ChartController(
            IPerformanceSummaryService performanceSummaryService,
            ISalesSummaryService salesSummaryService)
        {
            _performanceSummaryService = performanceSummaryService;
            _salesSummaryService = salesSummaryService;
        }
        #endregion

        [HttpPost]
        public async Task<IActionResult> GetChart(Filter filter = null)
        {
            return Ok(await _performanceSummaryService.GetChartSummary(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetSales(int year = 2021)
        {
            return Ok(await _salesSummaryService.GetShopWiseSalesSummary(year));
        }

        [HttpPost]
        public async Task<IActionResult> PostSales(ShopWiseSalesSummary shopWiseSalesSummary)
        {
            var test = await _salesSummaryService.PostShopWiseSalesSummary(shopWiseSalesSummary);
            return Ok(test);
        }
    }
}