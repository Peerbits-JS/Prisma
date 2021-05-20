using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace F3M.Oticas.Data.Repository
{
    public class SaleDocumentRepository : OticasBaseRepository<SaleDocument>, ISaleDocumentRepository
    {
        public SaleDocumentRepository(OticasContext context)
            : base(context)
        {
        }

        public List<DocumentBase> GetDocuments(AccountingExportFilterDto filter)
        {
            log("c.1");
            return GetDocumentsIQueryable(filter)
                .Include(entity => entity.DocumentType).ThenInclude(documentType => documentType.IdmoduloNavigation)
                .Include(entity => entity.DocumentTypeSeries)
                .Include(entity => entity.State.SystemStateType)
                .Include(entity => entity.EntityType)
                .Include(entity => entity.Store)
                .Select(entity => entity.GetDocumentBase())
                .ToList();
        }

        public List<DocumentBase> GetDocuments(AccountingExportDto model)
        {
            log("a.1");
            List<DocumentBase> saleDocuments = GetDocumentsIQueryable(model.Filter)
                .Include(entity => entity.DocumentType).ThenInclude(documentType => documentType.IdmoduloNavigation)
                .Include(entity => entity.DocumentTypeSeries)
                .Include(entity => entity.EntityType)
                .Include(entity => entity.Store)
                .Include(entity => entity.Lines).ThenInclude(line => line.IdartigoNavigation).ThenInclude(product => product.ProductType)
                .Include(entiy => entiy.Entity)
                .Include(entity => entity.EntityOne)
                .Include(entity => entity.PaymentsTypes).ThenInclude(line => line.PaymentType).ThenInclude(l => l.IdtipoFormaPagamentoNavigation)
                .Select(entity => entity.GetDocumentBase())
                .ToList();
            log("a.2");

            return saleDocuments
                .Where(entity => model.Documents.Any(document => document.Id == entity.Id && document.DocumenTypetId == entity.DocumentTypeId))
                .ToList();
        }

        private void log(string text)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(text + "\r\n");
            File.AppendAllText(AppDomain.CurrentDomain.BaseDirectory + "expAcc.log", sb.ToString());
            sb.Clear();
        }

        private IQueryable<SaleDocument> GetDocumentsIQueryable(AccountingExportFilterDto filter)
        {
            log("b.1");

            IQueryable<SaleDocument> saleDocuments = EntitySet
                .AsNoTracking()
                .Where(entity =>
                entity.State.SystemStateType.Code == StateTypeConstants.Effective &&
                entity.IDTemp == null && entity.AcaoTemp == null &&
                (filter.InitDate == null ? true : entity.DocumentDate >= filter.InitDate) &&
                (filter.EndDate == null ? true : entity.DocumentDate <= filter.EndDate))
                .AsQueryable();

            log("b.2");

            if (filter.DocumentTypesId != null && filter.DocumentTypesId.Any())
            {
                saleDocuments = saleDocuments.Where(entity => filter.DocumentTypesCode.Contains(entity.DocumentType.Codigo));
            }

            if (filter.StoresId != null && filter.StoresId.Any())
            {
                saleDocuments = saleDocuments.Where(entity => filter.StoresId.Contains(entity.StoreId ?? 0));
            }

            log("b.3");

            if (filter.InitValue != null)
            {
                saleDocuments = saleDocuments.Where(entity => entity.TotalCurrencyDocument >= filter.InitValue);
            }

            log("b.4");

            if (filter.EndValue != null)
            {
                saleDocuments = saleDocuments.Where(entity => entity.TotalCurrencyDocument >= filter.EndValue);
            }

            log("b.5");

            if (filter.DocumentNumber != null)
            {
                saleDocuments = saleDocuments.Where(entity => entity.DocumentNumber == filter.DocumentNumber);
            }

            log("b.6");

            if (!string.IsNullOrEmpty(filter.DocumentSerie))
            {
                saleDocuments = saleDocuments.Where(entity => entity.DocumentTypeSeries.CodigoSerie == filter.DocumentSerie);
            }

            log("b.7");

            if (!string.IsNullOrEmpty(filter.Entity))
            {
                saleDocuments = saleDocuments.Where(entity => entity.FiscalName == filter.Entity);
            }

            log("b.10");

            return saleDocuments;
        }
    }
}
