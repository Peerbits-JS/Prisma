using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class State : EntityBase
    {
        public State()
        {
            PurchaseDocument = new HashSet<PurchaseDocument>();
            StockDocument = new HashSet<StockDocument>();
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            SaleDocument = new HashSet<SaleDocument>();
            ProviderPaymentDocument = new HashSet<ProviderPaymentDocument>();
            ReceiptDocument = new HashSet<ReceiptDocument>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
        }

        public string Code { get; set; }
        public string Description { get; set; }
        public long EntityStateId { get; set; }
        public long IdtipoEstado { get; set; }
        public bool IsPreset { get; set; }
        public bool IsInitialState { get; set; }

        public SystemEntityState SystemEntityState { get; set; }
        public SystemStateType SystemStateType { get; set; }
        public ICollection<PurchaseDocument> PurchaseDocument { get; set; }
        public ICollection<StockDocument> StockDocument { get; set; }
        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<SaleDocument> SaleDocument { get; set; }
        public ICollection<ProviderPaymentDocument> ProviderPaymentDocument { get; set; }
        public ICollection<ReceiptDocument> ReceiptDocument { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }
    }
}
