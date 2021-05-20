using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;

namespace F3M.Oticas.Data.Repository
{
    public class ProviderPaymentDocumentLineRepository : OticasBaseRepository<ProviderPaymentDocumentLine>, IProviderPaymentDocumentLineRepository
    {
        public ProviderPaymentDocumentLineRepository(OticasContext context)
            : base(context)
        {
        }
    }
}