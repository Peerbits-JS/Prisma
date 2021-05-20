using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingExportRepository : IRepositoryOticasBase<AccountingExport>
    {
        List<AccountingExport> GetDocumentsDetails(AccountingExportDto model, Expression<Func<AccountingExport, bool>> expression = null);
        List<AccountingExport> GetDocumentsDetails(List<AccountingExportDocumentsDto> documents, Expression<Func<AccountingExport, bool>> expression = null);
    }
}