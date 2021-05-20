using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.DTO;
using F3M.Oticas.Translate;

namespace F3M.Oticas.Component.Extensions
{
    public static class DocumentBaseExtensions
    {
        public static AccountingExportDocumentsDto MapperToAccountingExportDocumentsDto(this DocumentBase documentBase)
        {
            return new AccountingExportDocumentsDto
            {
                Id = documentBase.Id,
                DocumentId = documentBase.Id,
                DocumenTypetId = documentBase.DocumentTypeId,
                DocumentTypeCode = documentBase.DocumentType.Codigo,
                Store = documentBase.Store.Codigo,
                DocumentModuleTypeCode = documentBase.DocumentType.IdmoduloNavigation.Codigo,
                DocumentModuleTypeDescription = SystemModuleResources.ResourceManager.GetValue(documentBase.DocumentType.IdmoduloNavigation.Descricao),
                Document = documentBase.Document,
                DocumentDate = documentBase.DocumentDate,
                DocumentDateFormated = documentBase.DocumentDate.ToShortDateString(),
                Value = documentBase.TotalCurrencyDocument,
                Entity = documentBase.FiscalName,
                EntityType = documentBase.EntityType.Code == "Clt" ? "C" : "F",
                IsGenerated = false,
                IsExported = false,
                HasErrors = false
            };
        }
    }
}