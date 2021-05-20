using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Controllers
{
    [Route("api/Header")]
    [ApiController]
    public class HeaderController : ControllerBase
    {
        readonly IHeaderService _headerService;

        #region "ctor"
        public HeaderController(
            IHeaderService headerService)
        {
            _headerService = headerService;
        }
        #endregion

        [HttpGet, Route("GetMenu/{idMenu}")]
        public async Task<IActionResult> GetMenu([FromRoute] long idMenu)
        {
            return Ok(await _headerService.GetMenu(idMenu));
        }

        [HttpGet, Route("GetFavouriteMenu/{idMenu}")]
        public async Task<IActionResult> GetFavouriteMenu([FromRoute] long idMenu)
        {
            return Ok(await _headerService.GetFavouriteMenu(idMenu));
        }
     
        [HttpGet, Route("GetHomePageMenu/{idMenu}")]
        public async Task<IActionResult> GetHomePageMenu([FromRoute] long idMenu)
        {
            return Ok(await _headerService.GetHomePageMenu(idMenu));
        }
    }
}