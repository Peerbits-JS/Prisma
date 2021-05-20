using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace F3M.Oticas.Data.Repository
{
    public class AccountingExportRepository : OticasBaseRepository<AccountingExport>, IAccountingExportRepository
    {
        public AccountingExportRepository(OticasContext context)
            : base(context)
        {
        }

        public List<AccountingExport> GetDocumentsDetails(AccountingExportDto model, Expression<Func<AccountingExport, bool>> expression = null) 
            => GetDocumentsDetails(model.Documents.ToList(), expression);

        public List<AccountingExport> GetDocumentsDetails(List<AccountingExportDocumentsDto> documents, Expression<Func<AccountingExport, bool>> expression = null)
        {
            var query = EntitySet.AsEnumerable().Where(accountingExport => documents.Any(document => document.DocumentId == accountingExport.DocumentId && document.DocumenTypetId == accountingExport.DocumentTypeId));

            if (expression != null) query.Where(expression.Compile());

            return query.OrderBy(doc => doc.DocumentId).ThenBy(doc => doc.DocumentTypeId).ToList();
        }
    }
}