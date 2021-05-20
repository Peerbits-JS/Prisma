using System.Collections.Generic;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;

namespace F3M.Oticas.Interfaces.Application.Services
{
    public interface IDocumentTypeRepositoryMapperService
    {
        IList<AccountingExportDocumentsDto> GetDocuments(AccountingExportFilterDto filter);
        IList<DocumentBase> GetDocuments(AccountingExportDto model);
    }
}