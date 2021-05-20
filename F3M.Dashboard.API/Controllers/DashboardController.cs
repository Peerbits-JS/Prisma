using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Controllers
{
    namespace DashboardWeb.Controllers
    {
        [ApiController]
        [Route("api/[controller]/[action]")]
        public class DashboardController : ControllerBase
        {
            //readonly IBillingSummaryService _billingSummaryService;
            //readonly IPerformanceSummaryService _performanceSummaryService;
            //readonly ISalesSummaryService _salesSummaryService;
            readonly IUserService _userService;
            readonly IShopService _shopService;

            #region "ctor"
            public DashboardController(
                //IBillingSummaryService billingSummaryService,
                //IPerformanceSummaryService performanceSummaryService,
                //ISalesSummaryService salesSummaryService,
                IUserService userService,
                IShopService shopService)
            {
                //_billingSummaryService = billingSummaryService;
                //_performanceSummaryService = performanceSummaryService;
                //_salesSummaryService = salesSummaryService;
                _userService = userService;
                _shopService = shopService;
            }
            #endregion

            //[HttpPost]
            //public async Task<IActionResult> GetDashboard(Filter filter = null)
            //{
            //    return Ok(new Dashboard
            //    {
            //        BillingSummary = await _billingSummaryService.GetBillingSummary(filter),
            //        PerformanceSummary = await _performanceSummaryService.GetPerformanceSummary(filter),
            //        ChartData = await _performanceSummaryService.GetChartSummary(filter),
            //        ShopData = await _shopService.GetShopList(),
            //        UserData = await _userService.GetUserList()
            //    });
            //}

            //[HttpPost]
            //public async Task<IActionResult> GetSales(int year = 2021)
            //{
            //    return Ok(await _salesSummaryService.GetShopWiseSalesSummary(year));
            //}

            //[HttpPost]
            //public async Task<IActionResult> PostSales(ShopWiseSalesSummary shopWiseSalesSummary )
            //{
            //    var test = await _salesSummaryService.PostShopWiseSalesSummary(shopWiseSalesSummary);
            //    return Ok(test);
            //}

            [HttpPost]
            public async Task<IActionResult> GetShopList(Filter filter = null)
            {
                return Ok(await _shopService.GetShopList());
            }

            [HttpPost]
            public async Task<IActionResult> GetUserList(Filter filter = null)
            {
                return Ok(await _userService.GetUserList());
            }
        }
    }
}
