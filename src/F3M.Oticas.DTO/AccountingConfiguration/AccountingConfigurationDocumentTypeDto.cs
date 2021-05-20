using System;

namespace F3M.Oticas.DTO
{
    public class AccountingConfigurationDocumentTypeDto
    {
        public long Id { get; set; }
        public long AccountingConfigurationId { get; set; }
        public string Account { get; set; }
        public long ValueId { get; set; }
        public string ValueDescription { get; set; }
        public string NatureDescription { get; set; }
        public string IVAClass { get; set; }
        public string CostCenter { get; set; }
        public byte[] F3MMarker { get; set; }
        public int EntityState { get; set; }

        public bool IsNotMarkedAsDeleted() => EntityState != 2;

        public bool IsMarkedAsDeleted() => EntityState == 2;
    }
}
