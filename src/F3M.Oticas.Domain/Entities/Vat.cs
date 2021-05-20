using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class Vat : EntityBase
    {
        public Vat()
        {
            Product = new HashSet<Product>();
            PurchaseDocument = new HashSet<PurchaseDocument>();
            PurchaseDocumentLine = new HashSet<PurchaseDocumentLine>();
            StockDocument = new HashSet<StockDocument>();
            StockDocumentLine = new HashSet<StockDocumentLine>();
            SaleDocument = new HashSet<SaleDocument>();
            SaleDocumentLine = new HashSet<SaleDocumentLine>();
            TbIvadescontos = new HashSet<TbIvadescontos>();
            TbIvaregioesIdivaNavigation = new HashSet<TbIvaregioes>();
            TbIvaregioesIdivaRegiaoNavigation = new HashSet<TbIvaregioes>();
            ProviderPaymentDocument = new HashSet<ProviderPaymentDocument>();
        }

        public string Code { get; set; }
        public string Description { get; set; }
        public decimal Tax { get; set; }
        public long IdtipoIva { get; set; }
        public long? SystemVatCodeId { get; set; }
        public string Mencao { get; set; }

        public SystemVatCode SystemVatCode { get; set; }
        public SystemVatType SystemVatType { get; set; }
        public ICollection<Product> Product { get; set; }
        public ICollection<PurchaseDocument> PurchaseDocument { get; set; }
        public ICollection<PurchaseDocumentLine> PurchaseDocumentLine { get; set; }
        public ICollection<StockDocument> StockDocument { get; set; }
        public ICollection<StockDocumentLine> StockDocumentLine { get; set; }
        public ICollection<SaleDocument> SaleDocument { get; set; }
        public ICollection<SaleDocumentLine> SaleDocumentLine { get; set; }
        public ICollection<TbIvadescontos> TbIvadescontos { get; set; }
        public ICollection<TbIvaregioes> TbIvaregioesIdivaNavigation { get; set; }
        public ICollection<TbIvaregioes> TbIvaregioesIdivaRegiaoNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> ProviderPaymentDocument { get; set; }
    }
}
