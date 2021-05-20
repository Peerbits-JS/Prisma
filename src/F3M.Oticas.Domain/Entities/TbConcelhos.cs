using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbConcelhos
    {
        public TbConcelhos()
        {
            TbArmazens = new HashSet<TbArmazens>();
            TbBancosMoradas = new HashSet<TbBancosMoradas>();
            TbClientesMoradas = new HashSet<TbClientesMoradas>();
            TbCodigosPostais = new HashSet<TbCodigosPostais>();
            TbContasBancariasMoradas = new HashSet<TbContasBancariasMoradas>();
            TbDocumentosComprasIdconcelhoCargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdconcelhoDescargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdconcelhoDestinatarioNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdconcelhoFiscalNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosStockIdconcelhoCargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdconcelhoDescargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdconcelhoDestinatarioNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdconcelhoFiscalNavigation = new HashSet<StockDocument>();
            TbDocumentosVendasIdconcelhoCargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdconcelhoDescargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdconcelhoDestinatarioNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdconcelhoFiscalNavigation = new HashSet<SaleDocument>();
            TbEntidadesMoradas = new HashSet<TbEntidadesMoradas>();
            TbFornecedoresMoradas = new HashSet<TbFornecedoresMoradas>();
            TbMedicosTecnicosMoradas = new HashSet<TbMedicosTecnicosMoradas>();
            TbPagamentosComprasIdconcelhoCargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdconcelhoDescargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdconcelhoDestinatarioNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdconcelhoFiscalNavigation = new HashSet<ProviderPaymentDocument>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long Iddistrito { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbDistritos IddistritoNavigation { get; set; }
        public ICollection<TbArmazens> TbArmazens { get; set; }
        public ICollection<TbBancosMoradas> TbBancosMoradas { get; set; }
        public ICollection<TbClientesMoradas> TbClientesMoradas { get; set; }
        public ICollection<TbCodigosPostais> TbCodigosPostais { get; set; }
        public ICollection<TbContasBancariasMoradas> TbContasBancariasMoradas { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdconcelhoCargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdconcelhoDescargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdconcelhoDestinatarioNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdconcelhoFiscalNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdconcelhoCargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdconcelhoDescargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdconcelhoDestinatarioNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdconcelhoFiscalNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdconcelhoCargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdconcelhoDescargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdconcelhoDestinatarioNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdconcelhoFiscalNavigation { get; set; }
        public ICollection<TbEntidadesMoradas> TbEntidadesMoradas { get; set; }
        public ICollection<TbFornecedoresMoradas> TbFornecedoresMoradas { get; set; }
        public ICollection<TbMedicosTecnicosMoradas> TbMedicosTecnicosMoradas { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdconcelhoCargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdconcelhoDescargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdconcelhoDestinatarioNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdconcelhoFiscalNavigation { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
    }
}
