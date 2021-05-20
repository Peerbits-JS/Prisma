using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaRegimeIva
    {
        public TbSistemaRegimeIva()
        {
            TbClientes = new HashSet<TbClientes>();
            TbDocumentosComprasIdregimeIvaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdregimeIvaPortesNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasLinhas = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockIdregimeIvaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdregimeIvaPortesNavigation = new HashSet<StockDocument>();
            TbDocumentosStockLinhas = new HashSet<StockDocumentLine>();
            TbDocumentosVendasIdregimeIvaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdregimeIvaPortesNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbPagamentosComprasIdregimeIvaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdregimeIvaPortesNavigation = new HashSet<ProviderPaymentDocument>();
            TbSistemaRelacaoEspacoFiscalRegimeIva = new HashSet<TbSistemaRelacaoEspacoFiscalRegimeIva>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdregimeIvaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdregimeIvaPortesNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhas { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdregimeIvaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdregimeIvaPortesNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhas { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdregimeIvaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdregimeIvaPortesNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdregimeIvaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdregimeIvaPortesNavigation { get; set; }
        public ICollection<TbSistemaRelacaoEspacoFiscalRegimeIva> TbSistemaRelacaoEspacoFiscalRegimeIva { get; set; }
    }
}
