using F3M.Core.Domain.Entity;
using System;

namespace F3M.Oticas.Domain.Entities
{
    public partial class CurrentAccountStockProduct : EntityBase
    {
        public long ProductId { get; set; }
        public string Description { get; set; }
        public string Natureza { get; set; }
        public long? StoreId { get; set; }
        public long? WarehouseId { get; set; }
        public long? WarehouseLocationId { get; set; }
        public long? ProductBatchId { get; set; }
        public long? ProductSerialNumberId { get; set; }
        public long? CurrencyId { get; set; }
        public long? EntityTypeId { get; set; }
        public long? EntityId { get; set; }
        public long? DocumentTypeId { get; set; }
        public long? DocumentId { get; set; }
        public long? DocumentLineId { get; set; }
        public string DocumentNumber { get; set; }
        public long? OriginDocumentTypeId { get; set; }
        public long? OriginDocumentId { get; set; }
        public long? OriginDocumentLineId { get; set; }
        public DateTime? DocumentDate { get; set; }
        public double? Quantity { get; set; }
        public double? StockQuantity { get; set; }
        public double? LastStockQuantity { get; set; }
        public double? CurrentStockQuantity { get; set; }
        public double? RateConversion { get; set; }
        public double? UnitPrice { get; set; }
        public double? EffectiveUnitPrice { get; set; }
        public double? UnitPriceInReferenceCurrency { get; set; }
        public double? EffectiveUnitPriceInReferenceCurrency { get; set; }
        public double? UpcInReferenceCurrency { get; set; }
        public double? LastUpcInReferenceCurrency { get; set; }
        public double? CurrentUpcInReferenceCurrency { get; set; }
        public double? PvInReferenceCurrency { get; set; }
        public bool? NeedToRecalculate { get; set; }
        public double? AffectedStockQuantity { get; set; }
        public double? UpPurchaseReferenceCurrency { get; set; }
        public double? LastAdditionalCostsInReferenceCurrency { get; set; }
        public double? LastComercialDiscountInReferenceCurrency { get; set; }
        public DateTime? InternalControlDate { get; set; }
        public long? DocumentTypeSeriesId { get; set; }
        public long? OriginDocumentTypeSeriesId { get; set; }
        public string YourDocumentNumber { get; set; }
        public string YourOriginDocumentNumber { get; set; }
        public long? OriginDocumentNumber { get; set; }
        public long? InitialOriginDocumentTypeId { get; set; }
        public long? InitialOriginDocumentId { get; set; }
        public long? InitialDocumentLineOrigin { get; set; }
        public string PrintInitialOriginDocument { get; set; }
        public double? StockQuantityReservation { get; set; }

        public TbArmazensLocalizacoes WarehouseLocation { get; set; }
        public TbArmazens Warehouse { get; set; }
        public TbArtigosLotes ProductBatch { get; set; }
        public Product Product { get; set; }
        public TbArtigosNumerosSeries ProductSerialNumber { get; set; }
        public TbMoedas Currency { get; set; }
        public TbTiposDocumento DocumentType { get; set; }
        public TbTiposDocumento InitialOriginDocumentType { get; set; }
        public TbTiposDocumento OriginDocumentType { get; set; }
        public SystemEntityType EntityType { get; set; }
        public TbTiposDocumentoSeries DocumentTypeSeries { get; set; }
        public TbTiposDocumentoSeries OriginDocumentTypeSeries { get; set; }

        public bool IsEntry() => Natureza == "E";
    }
}
