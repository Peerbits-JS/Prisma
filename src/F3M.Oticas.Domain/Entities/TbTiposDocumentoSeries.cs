using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposDocumentoSeries
    {
        public TbTiposDocumentoSeries()
        {
            TbAtestadoComunicacao = new HashSet<TbAtestadoComunicacao>();
            TbCcstockArtigosIdtiposDocumentoSeriesNavigation = new HashSet<CurrentAccountStockProduct>();
            TbCcstockArtigosIdtiposDocumentoSeriesOrigemNavigation = new HashSet<CurrentAccountStockProduct>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosComprasLinhas = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            TbDocumentosStockLinhas = new HashSet<StockDocumentLine>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
            TbTiposDocumentoSeriesPermissoes = new HashSet<TbTiposDocumentoSeriesPermissoes>();
        }

        public long Id { get; set; }
        public string CodigoSerie { get; set; }
        public string DescricaoSerie { get; set; }
        public bool SugeridaPorDefeito { get; set; }
        public long IdtiposDocumento { get; set; }
        public bool Sistema { get; set; }
        public bool AtivoSerie { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Ordem { get; set; }
        public bool CalculaComissoesSerie { get; set; }
        public bool AnalisesEstatisticasSerie { get; set; }
        public bool Ivaincluido { get; set; }
        public bool IvaregimeCaixa { get; set; }
        public DateTime? DataInicial { get; set; }
        public DateTime? DataFinal { get; set; }
        public DateTime? DataUltimoDoc { get; set; }
        public long? NumUltimoDoc { get; set; }
        public long? IdsistemaTiposDocumentoOrigem { get; set; }
        public long? IdsistemaTiposDocumentoComunicacao { get; set; }
        public long? IdparametrosEmpresaCae { get; set; }
        public long? NumeroVias { get; set; }
        public long? IdmapasVistas { get; set; }
        public long? Idloja { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbMapasVistas IdmapasVistasNavigation { get; set; }
        public TbParametrosEmpresaCae IdparametrosEmpresaCaeNavigation { get; set; }
        public TbSistemaTiposDocumentoComunicacao IdsistemaTiposDocumentoComunicacaoNavigation { get; set; }
        public TbSistemaTiposDocumentoOrigem IdsistemaTiposDocumentoOrigemNavigation { get; set; }
        public TbTiposDocumento IdtiposDocumentoNavigation { get; set; }
        public ICollection<TbAtestadoComunicacao> TbAtestadoComunicacao { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigosIdtiposDocumentoSeriesNavigation { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigosIdtiposDocumentoSeriesOrigemNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhas { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhas { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
        public ICollection<TbTiposDocumentoSeriesPermissoes> TbTiposDocumentoSeriesPermissoes { get; set; }
    }
}
