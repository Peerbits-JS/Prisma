using F3M.Oticas.Domain.Constants;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.DTO
{
    public class AccountingConfigurationDto
    {
        public AccountingConfigurationDto()
        {
            Entities = new List<AccountingConfigurationEntityDto>();
            DocumentTypes = new List<AccountingConfigurationDocumentTypeDto>();
            Filter = new AccountingConfigurationFilterDto();
            AlternativeCode = AccountingConfigurationConstants.DefaultValues.DocumentTypesAlternativeCode;
            AlternativeDescription = AccountingConfigurationConstants.DefaultValues.DocumentTypesAlternativeDescription;
        }

        public long Id { get; set; }
        public string Year { get; set; }
        public string ModuleCode { get; set; }
        public string ModuleDescription { get; set; }
        public string TypeCode { get; set; }
        public string TypeDescription { get; set; }
        public string AlternativeCode { get; set; }
        public string AlternativeDescription { get; set; }
        public bool? IsPreset { get; set; }
        public string JournalCode { get; set; }
        public string DocumentCode { get; set; }
        public bool? ReflectsIVAClassByFinancialAccount { get; set; }
        public bool? ReflectsCostCenterByFinancialAccount { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public byte[] F3MMarker { get; set; }
        public string Observations { get; set; }
        public AccountingConfigurationFilterDto Filter { get; set; }
        public IList<AccountingConfigurationEntityDto> Entities { get; set; }
        public IList<AccountingConfigurationDocumentTypeDto> DocumentTypes { get; set; }
    }
}
