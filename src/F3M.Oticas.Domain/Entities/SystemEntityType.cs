using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SystemEntityType : SystemBase
    {
        public SystemEntityType()
        {
            CurrentAccountStockProduct = new HashSet<CurrentAccountStockProduct>();
            TbClientes = new HashSet<TbClientes>();
            TbCondicoesPagamentoDescontos = new HashSet<TbCondicoesPagamentoDescontos>();
            PurchaseDocument = new HashSet<PurchaseDocument>();
            StockDocument = new HashSet<StockDocument>();
            SaleDocument = new HashSet<SaleDocument>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
            ProviderPaymentDocument = new HashSet<ProviderPaymentDocument>();
            ReceiptDocument = new HashSet<ReceiptDocument>();
            TbSistemaTiposEntidadeModulos = new HashSet<TbSistemaTiposEntidadeModulos>();
        }

        public string Entity { get; set; }
        public string Type { get; set; }
        public string TypeAux { get; set; }
        public bool? IsDefault { get; set; }

        public ICollection<CurrentAccountStockProduct> CurrentAccountStockProduct { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbCondicoesPagamentoDescontos> TbCondicoesPagamentoDescontos { get; set; }
        public ICollection<PurchaseDocument> PurchaseDocument { get; set; }
        public ICollection<StockDocument> StockDocument { get; set; }
        public ICollection<SaleDocument> SaleDocument { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
        public ICollection<ProviderPaymentDocument> ProviderPaymentDocument { get; set; }
        public ICollection<ReceiptDocument> ReceiptDocument { get; set; }
        public ICollection<TbSistemaTiposEntidadeModulos> TbSistemaTiposEntidadeModulos { get; set; }

        #region "NOTMAPPED PROPERTIES"
        [NotMapped]
        public override string Description { get => base.Description; set => base.Description = value; }
        #endregion
    }
}
