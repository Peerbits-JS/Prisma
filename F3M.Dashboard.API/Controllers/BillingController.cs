using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using F3M.Middleware.Constants;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class BillingController : ControllerBase
    {
        readonly IBillingSummaryService _billingSummaryService;

        #region "ctor"
        public BillingController(
            IBillingSummaryService billingSummaryService)
        {
            _billingSummaryService = billingSummaryService;
        }
        #endregion

        [HttpPost]
        public async Task<IActionResult> GetBillingTotalForToday(Filter filter = null)
        {
            return Ok(await _billingSummaryService.GetBillingTotalForToday(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetBillingTotalForYesterday(Filter filter = null)
        {
            return Ok(await _billingSummaryService.GetBillingTotalForYesterday(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetBillingTotalForCurrentMonth(Filter filter = null)
        {
            return Ok(await _billingSummaryService.GetBillingTotalForCurrentMonth(filter));
        }

        [HttpPost]
        public async Task<IActionResult> GetBillingTotalForCurrentYear(Filter filter = null)
        {
            return Ok(await _billingSummaryService.GetBillingTotalForCurrentYear(filter));
        }
    }
}