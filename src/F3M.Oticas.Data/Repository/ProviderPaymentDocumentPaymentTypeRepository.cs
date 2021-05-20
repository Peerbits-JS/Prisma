using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;

namespace F3M.Oticas.Data.Repository
{
    public class ProviderPaymentDocumentPaymentTypeRepository : OticasBaseRepository<ProviderPaymentDocumentPaymentType>, IProviderPaymentDocumentPaymentTypeRepository
    {
        public ProviderPaymentDocumentPaymentTypeRepository(OticasContext context)
            : base(context)
        {
        }
    }
}