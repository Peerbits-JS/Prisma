namespace F3M.Oticas.Domain.Entities.Base
{
    public class DocumentLineMain : DocumentLineBase
    {
        public double? VatValue { get; set; }

        public double? IncidenceValue { get; set; }

        public double? TotalPrice { get; set; }

        public double? EffectiveDiscountValueWithoutVat { get; set; }

        public long? Idarmazem { get; set; }

        public long? IdtaxaIva { get; set; }

        public Product IdartigoNavigation { get; set; }

        public override double GetVatValue() => VatValue ?? 0;

        public override double GetIncidenceValue() => IncidenceValue ?? 0;

        public override double GetTotalPrice() => TotalPrice ?? 0;

        public override double GetMerchandiseWithVat()
        {
            var vatValue = VatValue ?? 0;
            var incidenceValue = IncidenceValue ?? 0;

            return vatValue + incidenceValue;
        }
    }
}