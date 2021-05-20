using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbDistritos
    {
        public TbDistritos()
        {
            TbArmazens = new HashSet<TbArmazens>();
            TbBancosMoradas = new HashSet<TbBancosMoradas>();
            TbClientesMoradas = new HashSet<TbClientesMoradas>();
            TbConcelhos = new HashSet<TbConcelhos>();
            TbContasBancariasMoradas = new HashSet<TbContasBancariasMoradas>();
            TbDocumentosComprasIddistritoCargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIddistritoDescargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIddistritoDestinatarioNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIddistritoFiscalNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosStockIddistritoCargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIddistritoDescargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIddistritoDestinatarioNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIddistritoFiscalNavigation = new HashSet<StockDocument>();
            TbDocumentosVendasIddistritoCargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIddistritoDescargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIddistritoDestinatarioNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIddistritoFiscalNavigation = new HashSet<SaleDocument>();
            TbEntidadesMoradas = new HashSet<TbEntidadesMoradas>();
            TbFornecedoresMoradas = new HashSet<TbFornecedoresMoradas>();
            TbMedicosTecnicosMoradas = new HashSet<TbMedicosTecnicosMoradas>();
            TbPagamentosComprasIddistritoCargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIddistritoDescargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIddistritoDestinatarioNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIddistritoFiscalNavigation = new HashSet<ProviderPaymentDocument>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbArmazens> TbArmazens { get; set; }
        public ICollection<TbBancosMoradas> TbBancosMoradas { get; set; }
        public ICollection<TbClientesMoradas> TbClientesMoradas { get; set; }
        public ICollection<TbConcelhos> TbConcelhos { get; set; }
        public ICollection<TbContasBancariasMoradas> TbContasBancariasMoradas { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIddistritoCargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIddistritoDescargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIddistritoDestinatarioNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIddistritoFiscalNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIddistritoCargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIddistritoDescargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIddistritoDestinatarioNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIddistritoFiscalNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIddistritoCargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIddistritoDescargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIddistritoDestinatarioNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIddistritoFiscalNavigation { get; set; }
        public ICollection<TbEntidadesMoradas> TbEntidadesMoradas { get; set; }
        public ICollection<TbFornecedoresMoradas> TbFornecedoresMoradas { get; set; }
        public ICollection<TbMedicosTecnicosMoradas> TbMedicosTecnicosMoradas { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIddistritoCargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIddistritoDescargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIddistritoDestinatarioNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIddistritoFiscalNavigation { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
    }
}
