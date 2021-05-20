using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;
using System.Collections.Generic;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingExportDocumentReadRepository
    {
        List<DocumentBase> GetDocuments(AccountingExportFilterDto filter);
        List<DocumentBase> GetDocuments(AccountingExportDto model);
    }
}
