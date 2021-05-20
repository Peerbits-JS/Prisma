namespace F3M.Oticas.DTO
{
    public class TaxAuthorityComunicationProductDto
    {
        public long Id { get; set; }

        public long TaxAuthorityComunicationId { get; set; }

        public long ProductId { get; set; }

        public string ProductCode { get; set; }

        public string ProductDescription { get; set; }

        public string Category { get; set; }

        public string BarCode { get; set; }

        public long UnitId { get; set; }

        public string UnitCode { get; set; }

        public string UnitDescription { get; set; }

        public double? StockQuantity { get; set; }
        public double? StockValue { get; set; }
    }
}
