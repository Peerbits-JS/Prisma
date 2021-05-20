
using System;

namespace F3M.Oticas.DTO
{
    public class AccountingExportDocumentsDto
    {
        public AccountingExportDocumentsDto()
        {
        }

        public long ?Id { get; set; }
        public long DocumentId { get; set; }
        public long DocumenTypetId { get; set; }
        public string DocumentTypeCode { get; set; }
        public string Store { get; set; }
        public string DocumentModuleTypeCode { get; set; }
        public string DocumentModuleTypeDescription { get; set; }
        public string Document { get; set; }
        public DateTime DocumentDate { get; set; }
        public string DocumentDateFormated { get; set; }
        public double ?Value { get; set; }
        public string EntityType { get; set; }
        public string Entity { get; set; }
        public bool IsGenerated { get; set; }
        public bool IsExported { get; set; }
        public bool Selected { get; set; }
        public bool HasErrors{ get; set; }
        public string ErrorNotes { get; set; }
    }
}