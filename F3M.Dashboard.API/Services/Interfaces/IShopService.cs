using F3M.Dashboard.API.Models;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface IShopService
    {
        //Task<List<Shop>> GetShopList();
        Task<ShopSummary> GetShopList();
    }
}
