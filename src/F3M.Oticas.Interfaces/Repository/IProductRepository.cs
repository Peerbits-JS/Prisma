using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IProductRepository
    {
        Task<IEnumerable<Product>> GetToTaxAuthorityComunicationAsync(TaxAuthorityComunicationFilterDto filter);
    }
}