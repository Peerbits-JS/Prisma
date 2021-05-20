using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaEspacoFiscal
    {
        public TbSistemaEspacoFiscal()
        {
            TbClientes = new HashSet<TbClientes>();
            TbDocumentosComprasIdespacoFiscalNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdespacoFiscalPortesNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasLinhas = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockIdespacoFiscalNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdespacoFiscalPortesNavigation = new HashSet<StockDocument>();
            TbDocumentosStockLinhas = new HashSet<StockDocumentLine>();
            TbDocumentosVendasIdespacoFiscalNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdespacoFiscalPortesNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbPagamentosComprasIdespacoFiscalNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdespacoFiscalPortesNavigation = new HashSet<ProviderPaymentDocument>();
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
        public ICollection<PurchaseDocument> TbDocumentosComprasIdespacoFiscalNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdespacoFiscalPortesNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhas { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdespacoFiscalNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdespacoFiscalPortesNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhas { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdespacoFiscalNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdespacoFiscalPortesNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdespacoFiscalNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdespacoFiscalPortesNavigation { get; set; }
        public ICollection<TbSistemaRelacaoEspacoFiscalRegimeIva> TbSistemaRelacaoEspacoFiscalRegimeIva { get; set; }
    }
}
