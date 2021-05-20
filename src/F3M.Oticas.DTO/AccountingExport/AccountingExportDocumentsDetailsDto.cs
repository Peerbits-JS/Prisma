using System;

namespace F3M.Oticas.DTO
{
    public class AccountingExportDocumentsDetailsDto
    {
        public string Account { get; set; }
        public string AlternativeCode { get; set; }
        public string AlternativeDescription { get; set; }
        public string CostCenterAccount { get; set; }
        public string Document { get; set; }
        public string DocumentCode { get; set; }
        public DateTime DocumentDate { get; set; }
        public string DocumentDateFormated { get; set; }
        public long DocumentId { get; set; }
        public string DocumentModuleTypeCode { get; set; }
        public string DocumentModuleTypeDescription { get; set; }
        public long? DocumentNumber { get; set; }
        public string DocumentTypeCode { get; set; }
        public long DocumentTypeId { get; set; }
        public string Entity { get; set; }
        public string EntityCode { get; set; }
        public long? EntityId { get; set; }
        public string EntityTypeCode { get; set; }
        public long? EntityTypeId { get; set; }
        public string ErrorNotes { get; set; }
        public string ExternalDocumentNumber { get; set; }
        public bool HasErrors { get; set; }
        public long Id { get; set; }
        public bool IsExported { get; set; }
        public bool IsGenerated { get; set; }
        public string JournalCode { get; set; }
        public string NatureDescription { get; set; }
        public long Order { get; set; }
        public string OriginAccount { get; set; }
        public bool? ReflectsCostCenter { get; set; }
        public bool? ReflectsVatClass { get; set; }
        public string SerieDocumentTypeCode { get; set; }
        public long SerieDocumentTypeId { get; set; }
        public string StoreCode { get; set; }
        public long? StoreId { get; set; }
        public double? Value { get; set; }
        public string VatClassAccount { get; set; }
    }
}