using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;
namespace F3M.Oticas.Data.Repository
{
    public class PurchaseDocumentLineRepository : OticasBaseRepository<PurchaseDocumentLine>, IPurchaseDocumentLineRepository
    {
        public PurchaseDocumentLineRepository(OticasContext context)
            : base(context)
        {
        }
    }
}