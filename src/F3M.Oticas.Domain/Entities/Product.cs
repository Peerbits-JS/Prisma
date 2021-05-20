using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public class Product : EntityBase
    {
        public Product()
        {
            Frames = new HashSet<TbAros>();
            Attachments = new HashSet<TbArtigosAnexos>();
            WarehouseLocations = new HashSet<TbArtigosArmazensLocalizacoes>();
            Providers = new HashSet<TbArtigosFornecedores>();
            Languages = new HashSet<TbArtigosIdiomas>();
            Lots = new HashSet<TbArtigosLotes>();
            SerialNumbers = new HashSet<TbArtigosNumerosSeries>();
            Prices = new HashSet<TbArtigosPrecos>();
            ProductStocks = new HashSet<TbArtigosStock>();
            Units = new HashSet<TbArtigosUnidades>();
            CurrentAccounts = new HashSet<CurrentAccountStockProduct>();
            TaxAuthorityComunicationProducts = new HashSet<TaxAuthorityComunicationProduct>();
            PurchaseDocumentProducts = new HashSet<PurchaseDocumentLine>();
            StocksCountProducts = new HashSet<TbDocumentosStockContagemLinhas>();
            TbDocumentosStockLinhasIdartigoNavigation = new HashSet<StockDocumentLine>();
            SalesDocumentProducts = new HashSet<SaleDocumentLine>();
            ContactLenses = new HashSet<TbLentesContato>();
            OphthalmicLenses = new HashSet<TbLentesOftalmicas>();
            Sunglasses = new HashSet<TbOculosSol>();
            StockProducts = new HashSet<TbStockArtigos>();
        }

        public ICollection<TbArtigosAnexos> Attachments { get; set; }

        public double? AveragePrice { get; set; }

        public string BarCode { get; set; }

        public TbMarcas Brand { get; set; }

        public long BrandId { get; set; }

        public bool? CanManageLot { get; set; }

        public bool? CanManageSerialNumber { get; set; }

        public bool? CanManageStock { get; set; }

        public bool? CanRecalculateUpc { get; set; }

        public TbSistemaClassificacoesTiposArtigos ClassificationSystem { get; set; }

        public long ClassificationSystemId { get; set; }

        public string Code { get; set; }

        public TbComposicoes Composition { get; set; }

        public long? CompositionId { get; set; }

        public TbSistemaTiposComposicoes CompositionType { get; set; }

        public long? CompositionTypeId { get; set; }

        public TbSistemaCompostoTransformacaoMetodoCusto CompoundTransformationMethodCost { get; set; }

        public long? CompoundTransformationMethodCostId { get; set; }

        public ICollection<TbLentesContato> ContactLenses { get; set; }

        public ICollection<CurrentAccountStockProduct> CurrentAccounts { get; set; }

        public double? DeductivePercentage { get; set; }

        public double? DefaultPrice { get; set; }

        public string Description { get; set; }

        public TbFamilias Family { get; set; }

        public long? FamilyId { get; set; }

        public TbArtigosDadosFinanceiros FinancialData { get; set; }

        public TbArtigosDadosFinanceirosPvsUpcperc FinancialDataPvsUpcperc { get; set; }

        public ICollection<TbAros> Frames { get; set; }

        public double? FTOFPercentageFactor { get; set; }

        public bool? HasVariableDescription { get; set; }

        public double? IncidencePercentage { get; set; }

        public ICollection<TbArtigosIdiomas> Languages { get; set; }

        public double? LastCostPrice { get; set; }

        public double? LastPurchasePrice { get; set; }

        public double? LatestAdditionalCosts { get; set; }

        public double? LatestCommercialDiscounts { get; set; }

        public ICollection<TbArtigosLotes> Lots { get; set; }

        public double? MaximumLimit { get; set; }

        public double? MinimumLimit { get; set; }

        public string Observation { get; set; }

        public ICollection<TbLentesOftalmicas> OphthalmicLenses { get; set; }

        public TbSistemaOrdemLotes OrderLotMovementEntry { get; set; }

        public long? OrderLotMovementEntryId { get; set; }

        public TbSistemaOrdemLotes OrderLotOutputMovement { get; set; }

        public long? OrderLotOutputMovementId { get; set; }

        public TbSistemaOrdemLotes OrderLotPresent { get; set; }

        public long? OrderLotPresentId { get; set; }

        public string Picture { get; set; }

        public string PicturePath { get; set; }

        public ICollection<TbArtigosPrecos> Prices { get; set; }

        public TbGruposArtigo ProductGroup { get; set; }

        public long? ProductGroupId { get; set; }

        public ICollection<TbArtigosStock> ProductStocks { get; set; }

        public TbTiposArtigos ProductType { get; set; }

        public long ProductTypeId { get; set; }

        public ICollection<TbArtigosFornecedores> Providers { get; set; }

        public ICollection<PurchaseDocumentLine> PurchaseDocumentProducts { get; set; }

        public TbUnidades PurchaseUnit { get; set; }

        public long PurchaseUnitId { get; set; }

        public string Qrcode { get; set; }

        public double? Reposition { get; set; }

        public ICollection<SaleDocumentLine> SalesDocumentProducts { get; set; }

        public TbUnidades SalesUnit { get; set; }

        public long SalesUnitId { get; set; }

        public TbUnidades SecondUnitStock { get; set; }

        public long? SecondUnitStockId { get; set; }

        public ICollection<TbArtigosNumerosSeries> SerialNumbers { get; set; }

        public string ShortDescription { get; set; }

        public TbEstacoes Station { get; set; }

        public long? StationId { get; set; }

        public string StatisticalCode { get; set; }

        public ICollection<TbStockArtigos> StockProducts { get; set; }

        public ICollection<TbDocumentosStockContagemLinhas> StocksCountProducts { get; set; }

        public TbSubFamilias SubFamily { get; set; }

        public long? SubFamilyId { get; set; }

        public ICollection<TbOculosSol> Sunglasses { get; set; }

        public string SupplierBarCode { get; set; }

        public string SupplierReference { get; set; }

        public Vat Tax { get; set; }

        public string TaxAuthorityCode { get; set; }

        public ICollection<TaxAuthorityComunicationProduct> TaxAuthorityComunicationProducts { get; set; }

        public long? TaxId { get; set; }

        public TbImpostoSelo TaxStamp { get; set; }

        public long? TaxStampId { get; set; }

        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdartigoNavigation { get; set; }

        public double? TotalQuantityDefaultVSPC { get; set; }

        public double? TotalQuantityVSPCM { get; set; }

        public double? TotalQuantityVSUPC { get; set; }

        public TbSistemaTiposPrecos TypePrice { get; set; }

        public long TypePriceId { get; set; }

        public TbUnidades Unit { get; set; }

        public long UnitId { get; set; }

        public ICollection<TbArtigosUnidades> Units { get; set; }

        public DateTime? UpcDateControl { get; set; }

        public long? UpcDocumentId { get; set; }

        public TbTiposDocumento UpcDocumentType { get; set; }

        public long? UpcDocumentTypeId { get; set; }

        public string VariableAccounting { get; set; }

        public ICollection<TbArtigosArmazensLocalizacoes> WarehouseLocations { get; set; }

        public bool? IsInventory { get; set; }

        public double? ComputeCurrentAccountBalance() 
            => CurrentAccounts.Sum(currentAccount => currentAccount.IsEntry() ? currentAccount.Quantity : (currentAccount.Quantity * -1));
    }
}
