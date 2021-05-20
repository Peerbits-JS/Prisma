using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TaxAuthorityComunicationProduct : EntityBase
    {
        public string BarCode { get; set; }
        public string Category { get; set; }
        public int Order { get; set; }
        public Product Product { get; set; }
        public string ProductCode { get; set; }
        public string ProductDescription { get; set; }
        public long ProductId { get; set; }
        public double StockQuantity { get; set; }
        public double StockValue { get; set; }
        public TaxAuthorityComunication TaxAuthorityComunication { get; set; }
        public long TaxAuthorityComunicationId { get; set; }
        public TbUnidades Unit { get; set; }
        public string UnitCode { get; set; }
        public string UnitDescription { get; set; }
        public long UnitId { get; set; }
    }
}
