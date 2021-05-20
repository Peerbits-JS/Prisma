using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SystemVatType : SystemBase
    {
        public SystemVatType()
        {
            PurchaseDocumentLine = new HashSet<PurchaseDocumentLine>();
            StockDocumentLine = new HashSet<StockDocumentLine>();
            SalesDocumentLine = new HashSet<SaleDocumentLine>();
            Vat = new HashSet<Vat>();
        }

        public ICollection<PurchaseDocumentLine> PurchaseDocumentLine { get; set; }
        public ICollection<StockDocumentLine> StockDocumentLine { get; set; }
        public ICollection<SaleDocumentLine> SalesDocumentLine { get; set; }
        public ICollection<Vat> Vat { get; set; }
    }
}