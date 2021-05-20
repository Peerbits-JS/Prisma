using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;

namespace F3M.Oticas.Data.Repository
{
    public class StockDocumentLineRepository : OticasBaseRepository<StockDocumentLine>, IStockDocumentLineRepository
    {
        public StockDocumentLineRepository(OticasContext context)
            : base(context)
        {
        }
    }
}