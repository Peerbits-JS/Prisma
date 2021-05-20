using F3M.Dashboard.API.Models;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface IHeaderService
    {
        Task<MenusDTO> GetMenu(long idMenu);
        Task<bool> GetFavouriteMenu(long idMenu);
        Task<bool> GetHomePageMenu(long idMenu);
    }
}
