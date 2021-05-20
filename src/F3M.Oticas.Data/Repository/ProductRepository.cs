using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class ProductRepository : OticasBaseRepository<Product>, IProductRepository
    {
        public ProductRepository(OticasContext context)
              : base(context)
        {
        }

        public async Task<IEnumerable<Product>> GetToTaxAuthorityComunicationAsync(TaxAuthorityComunicationFilterDto filter)
        {
            var query = EntitySet.Include(product => product.WarehouseLocations)
                .Include(product => product.CurrentAccounts)
                .Include(product => product.Unit)
                .Include(product => product.ProductType)
                .Include(product => product.ProductType.IdsistemaClassificacaoGeralNavigation)
                .Where(x => x.CanManageStock == true && x.IsInventory == true && x.IsActive);

            Product CreateProductWithCurentAccountFilteres(Product product)
            {
                product.CurrentAccounts = product.CurrentAccounts.Where(x => x.DocumentDate?.Date <= filter.FilterDate.Date).ToList();

                if (filter.Warehouses.Any())
                {
                    product.CurrentAccounts = product.CurrentAccounts.Where(x => filter.Warehouses.Any(y => y.Id == x.WarehouseId)).ToList();
                }
                return product;
            }

            var products = await query.ToListAsync();

            return products.Select(CreateProductWithCurentAccountFilteres);
        }
    }
}
