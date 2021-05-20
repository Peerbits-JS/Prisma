using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbCodigosPostais
    {
        public TbCodigosPostais()
        {
            TbArmazens = new HashSet<TbArmazens>();
            TbBancosMoradas = new HashSet<TbBancosMoradas>();
            TbClientesMoradas = new HashSet<TbClientesMoradas>();
            TbContasBancariasMoradas = new HashSet<TbContasBancariasMoradas>();
            TbDocumentosComprasIdcodigoPostalCargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdcodigoPostalDescargaNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdcodigoPostalDestinatarioNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosComprasIdcodigoPostalFiscalNavigation = new HashSet<PurchaseDocument>();
            TbDocumentosStockIdcodigoPostalCargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdcodigoPostalDescargaNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdcodigoPostalDestinatarioNavigation = new HashSet<StockDocument>();
            TbDocumentosStockIdcodigoPostalFiscalNavigation = new HashSet<StockDocument>();
            TbDocumentosVendasIdcodigoPostalCargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdcodigoPostalDescargaNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdcodigoPostalDestinatarioNavigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdcodigoPostalFiscalNavigation = new HashSet<SaleDocument>();
            TbEntidadesMoradas = new HashSet<TbEntidadesMoradas>();
            TbFornecedoresMoradas = new HashSet<TbFornecedoresMoradas>();
            TbMedicosTecnicosMoradas = new HashSet<TbMedicosTecnicosMoradas>();
            TbPagamentosComprasIdcodigoPostalCargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdcodigoPostalDescargaNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdcodigoPostalDestinatarioNavigation = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasIdcodigoPostalFiscalNavigation = new HashSet<ProviderPaymentDocument>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long Idconcelho { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbConcelhos IdconcelhoNavigation { get; set; }
        public ICollection<TbArmazens> TbArmazens { get; set; }
        public ICollection<TbBancosMoradas> TbBancosMoradas { get; set; }
        public ICollection<TbClientesMoradas> TbClientesMoradas { get; set; }
        public ICollection<TbContasBancariasMoradas> TbContasBancariasMoradas { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdcodigoPostalCargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdcodigoPostalDescargaNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdcodigoPostalDestinatarioNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosComprasIdcodigoPostalFiscalNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdcodigoPostalCargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdcodigoPostalDescargaNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdcodigoPostalDestinatarioNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStockIdcodigoPostalFiscalNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdcodigoPostalCargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdcodigoPostalDescargaNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdcodigoPostalDestinatarioNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdcodigoPostalFiscalNavigation { get; set; }
        public ICollection<TbEntidadesMoradas> TbEntidadesMoradas { get; set; }
        public ICollection<TbFornecedoresMoradas> TbFornecedoresMoradas { get; set; }
        public ICollection<TbMedicosTecnicosMoradas> TbMedicosTecnicosMoradas { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdcodigoPostalCargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdcodigoPostalDescargaNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdcodigoPostalDestinatarioNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosComprasIdcodigoPostalFiscalNavigation { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
    }
}
