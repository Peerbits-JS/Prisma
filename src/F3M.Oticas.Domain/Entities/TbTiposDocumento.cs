using F3M.Core.Domain.Entity;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposDocumento : EntityBase
    {
        public TbTiposDocumento()
        {
            InverseIdtipoDocCustoNavigation = new HashSet<TbTiposDocumento>();
            InverseIdtipoDocFinalizacaoNavigation = new HashSet<TbTiposDocumento>();
            InverseIdtipoDocLibertaReservaNavigation = new HashSet<TbTiposDocumento>();
            InverseIdtipoDocReservaNavigation = new HashSet<TbTiposDocumento>();
            TbArtigos = new HashSet<Product>();
            TbAtestadoComunicacao = new HashSet<TbAtestadoComunicacao>();
            TbCcstockArtigosIdtipoDocumentoNavigation = new HashSet<CurrentAccountStockProduct>();
            TbCcstockArtigosIdtipoDocumentoOrigemInicialNavigation = new HashSet<CurrentAccountStockProduct>();
            TbCcstockArtigosIdtipoDocumentoOrigemNavigation = new HashSet<CurrentAccountStockProduct>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosComprasLinhasIdtipoDocumentoOrigemInicialNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosComprasLinhasIdtipoDocumentoOrigemNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            TbDocumentosStockLinhasIdtipoDocumentoOrigemInicialNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosStockLinhasIdtipoDocumentoOrigemNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbDocumentosVendasLinhasIdtipoDocumentoOrigemInicialNavigation = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasIdtipoDocumentoOrigemNavigation = new HashSet<SaleDocumentLine>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
            TbTiposDocumentoIdioma = new HashSet<TbTiposDocumentoIdioma>();
            TbTiposDocumentoSeries = new HashSet<TbTiposDocumentoSeries>();
            TbTiposDocumentoTipEntPermDoc = new HashSet<TbTiposDocumentoTipEntPermDoc>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long Idmodulo { get; set; }
        public long IdsistemaTiposDocumento { get; set; }
        public string Observacoes { get; set; }
        public long? IdsistemaTiposDocumentoFiscal { get; set; }
        public bool? GereStock { get; set; }
        public bool? GereContaCorrente { get; set; }
        public bool? GereCaixasBancos { get; set; }
        public bool? RegistarCosumidorFinal { get; set; }
        public bool? AnalisesEstatisticas { get; set; }
        public bool? CalculaComissoes { get; set; }
        public bool? ControlaPlafondEntidade { get; set; }
        public bool? AcompanhaBensCirculacao { get; set; }
        public bool? DocNaoValorizado { get; set; }
        public long? IdsistemaAcoes { get; set; }
        public long? IdsistemaTiposLiquidacao { get; set; }
        public bool? CalculaNecessidades { get; set; }
        public bool? CustoMedio { get; set; }
        public bool? UltimoPrecoCusto { get; set; }
        public bool? DataPrimeiraEntrada { get; set; }
        public bool? DataUltimaEntrada { get; set; }
        public bool? DataPrimeiraSaida { get; set; }
        public bool? DataUltimaSaida { get; set; }
        public long? IdsistemaAcoesRupturaStock { get; set; }
        public long? IdsistemaTiposDocumentoMovStock { get; set; }
        public long? IdsistemaTiposDocumentoPrecoUnitario { get; set; }
        public bool? AtualizaFichaTecnica { get; set; }
        public long? Idestado { get; set; }
        public long? Idcliente { get; set; }
        public long? IdsistemaAcoesStockMinimo { get; set; }
        public long? IdsistemaAcoesStockMaximo { get; set; }
        public long? IdsistemaAcoesReposicaoStock { get; set; }
        public long? IdsistemaNaturezas { get; set; }
        public bool? ReservaStock { get; set; }
        public bool? GeraPendente { get; set; }
        public bool? Adiantamento { get; set; }
        public bool? Predefinido { get; set; }
        public long? IdtipoDocReserva { get; set; }
        public long? IdtipoDocLibertaReserva { get; set; }
        public long? IdtipoDocCusto { get; set; }
        public long? IdtipoDocFinalizacao { get; set; }

        public TbClientes IdclienteNavigation { get; set; }
        public State IdestadoNavigation { get; set; }
        public TbSistemaModulos IdmoduloNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesReposicaoStockNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesRupturaStockNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesStockMaximoNavigation { get; set; }
        public TbSistemaAcoes IdsistemaAcoesStockMinimoNavigation { get; set; }
        public TbSistemaNaturezas IdsistemaNaturezasNavigation { get; set; }
        public TbSistemaTiposDocumentoFiscal IdsistemaTiposDocumentoFiscalNavigation { get; set; }
        public TbSistemaTiposDocumentoMovStock IdsistemaTiposDocumentoMovStockNavigation { get; set; }
        public TbSistemaTiposDocumento IdsistemaTiposDocumentoNavigation { get; set; }
        public TbSistemaTiposDocumentoPrecoUnitario IdsistemaTiposDocumentoPrecoUnitarioNavigation { get; set; }
        public TbSistemaTiposLiquidacao IdsistemaTiposLiquidacaoNavigation { get; set; }
        public TbTiposDocumento IdtipoDocCustoNavigation { get; set; }
        public TbTiposDocumento IdtipoDocFinalizacaoNavigation { get; set; }
        public TbTiposDocumento IdtipoDocLibertaReservaNavigation { get; set; }
        public TbTiposDocumento IdtipoDocReservaNavigation { get; set; }
        public ICollection<TbTiposDocumento> InverseIdtipoDocCustoNavigation { get; set; }
        public ICollection<TbTiposDocumento> InverseIdtipoDocFinalizacaoNavigation { get; set; }
        public ICollection<TbTiposDocumento> InverseIdtipoDocLibertaReservaNavigation { get; set; }
        public ICollection<TbTiposDocumento> InverseIdtipoDocReservaNavigation { get; set; }
        public ICollection<Product> TbArtigos { get; set; }
        public ICollection<TbAtestadoComunicacao> TbAtestadoComunicacao { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigosIdtipoDocumentoNavigation { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigosIdtipoDocumentoOrigemInicialNavigation { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigosIdtipoDocumentoOrigemNavigation { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdtipoDocumentoOrigemInicialNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdtipoDocumentoOrigemNavigation { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdtipoDocumentoOrigemInicialNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdtipoDocumentoOrigemNavigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdtipoDocumentoOrigemInicialNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdtipoDocumentoOrigemNavigation { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
        public ICollection<TbTiposDocumentoIdioma> TbTiposDocumentoIdioma { get; set; }
        public ICollection<TbTiposDocumentoSeries> TbTiposDocumentoSeries { get; set; }
        public ICollection<TbTiposDocumentoTipEntPermDoc> TbTiposDocumentoTipEntPermDoc { get; set; }
    }
}
