using F3M.Oticas.Domain.Constants;
using System;
using System.ComponentModel.DataAnnotations;

namespace F3M.Oticas.DTO
{
    public class AccountingExportFilterDto
    {
        public AccountingExportFilterDto()
        {
            InitDate  = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-1);
            EndDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(-1);
            Generated = AccountingExportConstants.Generated.All;
            Exported =  AccountingExportConstants.Exported.All;
            ExportFormat = AccountingExportConstants.ExportFormats.PBSSV9;
        }

        [Required]
        public DateTime? InitDate { get; set; }
        [Required]
        public DateTime? EndDate { get; set; }

        public long[] StoresId { get; set; }

        public long[] ModulesId { get; set; }
        public string[] ModulesCode { get; set; }

        public long[] DocumentTypesId { get; set; }
        public string[] DocumentTypesCode { get; set; }

        [StringLength(20)]
        public string DocumentSerie { get; set; }
        public long? DocumentNumber { get; set; }

        public double? InitValue { get; set; }
        public double? EndValue { get; set; }

        [Required]
        public string Generated { get; set; }

        [Required]
        public string Exported { get; set; }

        public string EntityType{ get; set; }
        [StringLength(100)]
        public string Entity { get; set; }

        [Required]
        public string ExportFormat { get; set; }
    }
}