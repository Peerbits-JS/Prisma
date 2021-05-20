using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class ShopService : IShopService
    {
        readonly IUnitOfWork _unitOfWork;

        public ShopService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<ShopSummary> GetShopList()
        {
            ShopSummary shopSummary = new ShopSummary();

            shopSummary.Shops.AddRange(await _unitOfWork.StoresRepository.
                GetEntityAsNoTracking(entity => entity.Ativo).
                Select(entity => new Shop
                {
                    Id = entity.ID,
                    ShopDesc = entity.Descricao,
                    ShopName = entity.Descricao
                }).
                OrderBy(entity => entity.ShopDesc).
                ToListAsync());

            return shopSummary;
        }
    }
}