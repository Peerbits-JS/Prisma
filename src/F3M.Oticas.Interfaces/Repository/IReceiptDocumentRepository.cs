using F3M.Oticas.Domain.Entities;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IReceiptDocumentRepository : IRepositoryOticasBase<ReceiptDocument>, IAccountingExportDocumentReadRepository
    {
    }
}