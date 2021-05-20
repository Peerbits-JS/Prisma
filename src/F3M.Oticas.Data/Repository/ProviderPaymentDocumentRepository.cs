using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Data.Repository
{
    public class ProviderPaymentDocumentRepository : OticasBaseRepository<ProviderPaymentDocument>, IProviderPaymentDocumentRepository
    {
        public ProviderPaymentDocumentRepository(OticasContext context)
            : base(context)
        {
        }

        public List<DocumentBase> GetDocuments(AccountingExportFilterDto filter)
        {
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
            List<DocumentBase> providerPaymentDocuments = GetDocumentsIQueryable(model.Filter)
                .Include(entity => entity.DocumentType).ThenInclude(documentType => documentType.IdmoduloNavigation)
                .Include(entity => entity.DocumentTypeSeries)
                .Include(entity => entity.State.SystemStateType)
                .Include(entity => entity.EntityType)
                .Include(entity => entity.Store)
                .Include(entity => entity.Lines)
                .Include(entiy => entiy.Entity)
                .Include(entity => entity.ProviderPaymentDocumentPaymentType).ThenInclude(entity => entity.PaymentType).ThenInclude(entity => entity.IdtipoFormaPagamentoNavigation)
               .Select(entity => entity.GetDocumentBase())
               .ToList();

            return providerPaymentDocuments
                .Where(entity => model.Documents.Any(document => document.Id == entity.Id && document.DocumenTypetId == entity.DocumentTypeId))
                .ToList();
        }

        private IQueryable<ProviderPaymentDocument> GetDocumentsIQueryable(AccountingExportFilterDto filter)
        {
            IQueryable<ProviderPaymentDocument> providerPaymentDocuments = EntitySet
                .AsNoTracking()
                .Where(entity =>
                entity.State.SystemStateType.Code == StateTypeConstants.Effective &&
                (filter.InitDate == null ? true : entity.DocumentDate >= filter.InitDate) &&
                (filter.EndDate == null ? true : entity.DocumentDate <= filter.EndDate))
                .AsQueryable();

            if (filter.DocumentTypesId != null && filter.DocumentTypesId.Any())
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => filter.DocumentTypesCode.Contains(entity.DocumentType.Codigo));
            }

            if (filter.StoresId != null && filter.StoresId.Any())
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => filter.StoresId.Contains(entity.StoreId ?? 0));
            }

            if (filter.InitValue != null)
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => entity.TotalCurrencyDocument >= filter.InitValue);
            }

            if (filter.EndValue != null)
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => entity.TotalCurrencyDocument >= filter.EndValue);
            }

            if (filter.DocumentNumber != null)
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => entity.DocumentNumber == filter.DocumentNumber);
            }

            if (!string.IsNullOrEmpty(filter.DocumentSerie))
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => entity.DocumentTypeSeries.CodigoSerie == filter.DocumentSerie);
            }

            if (!string.IsNullOrEmpty(filter.Entity))
            {
                providerPaymentDocuments = providerPaymentDocuments.Where(entity => entity.FiscalName == filter.Entity);
            }

            return providerPaymentDocuments;
        }
    }
}