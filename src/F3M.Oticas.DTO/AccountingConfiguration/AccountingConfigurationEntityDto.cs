using System;

namespace F3M.Oticas.DTO
{
    public class AccountingConfigurationEntityDto
    {
        public long Id { get; set; }
        public long AccountingConfigurationId { get; set; }
        public long EntityId { get; set; }
        public string EntityCode { get; set; }
        public string EntityDescription { get; set; }
        public string AccountingVariable { get; set; }
        public bool? GoodsCostInPurchase { get; set; }
        public bool? HasGoodsCostInPurchase { get; set; }
        //public DateTime CreatedAt { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime? UpdatedAt { get; set; }
        //public string UpdatedBy { get; set; }
        public byte[] F3MMarker { get; set; }

    }
}
