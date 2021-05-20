using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
   public partial class PurchaseDocumentLine : DocumentLineMain
    {
        public PurchaseDocumentLine()
        {
            InverseIdlinhaDocumentoCompraInicialNavigation = new HashSet<PurchaseDocumentLine>();
            InverseIdlinhaDocumentoCompraNavigation = new HashSet<PurchaseDocumentLine>();
        }

        public long IddocumentoCompra { get; set; }
        public long? Idartigo { get; set; }
        public string Descricao { get; set; }
        public long? Idunidade { get; set; }
        public short? NumCasasDecUnidade { get; set; }
        public double? Quantidade { get; set; }
        public double? PrecoUnitario { get; set; }
        public double? PrecoUnitarioEfetivo { get; set; }
        public string Observacoes { get; set; }
        public long? Idlote { get; set; }
        public string CodigoLote { get; set; }
        public string DescricaoLote { get; set; }
        public DateTime? DataFabricoLote { get; set; }
        public DateTime? DataValidadeLote { get; set; }
        public long? IdartigoNumSerie { get; set; }
        public string ArtigoNumSerie { get; set; }
        public long? IdarmazemLocalizacao { get; set; }
        public long? IdarmazemDestino { get; set; }
        public long? IdarmazemLocalizacaoDestino { get; set; }
        public long? NumLinhasDimensoes { get; set; }
        public double? Desconto1 { get; set; }
        public double? Desconto2 { get; set; }
        public double? TaxaIva { get; set; }
        public string MotivoIsencaoIva { get; set; }
        public long? IdespacoFiscal { get; set; }
        public string EspacoFiscal { get; set; }
        public long? IdregimeIva { get; set; }
        public string RegimeIva { get; set; }
        public string SiglaPais { get; set; }
        public int Ordem { get; set; }
        public long? IdunidadeStock { get; set; }
        public long? IdunidadeStock2 { get; set; }
        public double? QuantidadeStock { get; set; }
        public double? QuantidadeStock2 { get; set; }
        public double? PrecoUnitarioMoedaRef { get; set; }
        public double? PrecoUnitarioEfetivoMoedaRef { get; set; }
        public double? QtdStockAnterior { get; set; }
        public double? QtdStockAtual { get; set; }
        public double? UpcmoedaRef { get; set; }
        public double? PcmanteriorMoedaRef { get; set; }
        public double? PcmatualMoedaRef { get; set; }
        public double? PvmoedaRef { get; set; }
        public bool? Alterada { get; set; }
        public DateTime? DataDocOrigem { get; set; }
        public bool? ValorizouOrigem { get; set; }
        public bool? MovStockOrigem { get; set; }
        public long? IdtipoDocumentoOrigem { get; set; }
        public long? IddocumentoOrigem { get; set; }
        public long? IdlinhaDocumentoOrigem { get; set; }
        public short? NumCasasDecUnidadeStk { get; set; }
        public short? NumCasasDec2UnidadeStk { get; set; }
        public double? FatorConvUnidStk { get; set; }
        public double? FatorConv2UnidStk { get; set; }
        public double? QtdStockAnteriorOrigem { get; set; }
        public double? QtdStockAtualOrigem { get; set; }
        public double? PcmanteriorMoedaRefOrigem { get; set; }
        public double? QtdAfetacaoStock { get; set; }
        public double? QtdAfetacaoStock2 { get; set; }
        public string CodigoTaxaIva { get; set; }
        public long? IdtipoIva { get; set; }
        public string OperacaoConvUnidStk { get; set; }
        public string OperacaoConv2UnidStk { get; set; }
        public long? IdtipoPreco { get; set; }
        public string CodigoTipoPreco { get; set; }
        public long? IdcodigoIva { get; set; }
        public string CodigoArtigo { get; set; }
        public string CodigoBarrasArtigo { get; set; }
        public string CodigoUnidade { get; set; }
        public string CodigoTipoIva { get; set; }
        public string CodigoRegiaoIva { get; set; }
        public double? UpcompraMoedaRef { get; set; }
        public double? UltCustosAdicionaisMoedaRef { get; set; }
        public double? UltDescComerciaisMoedaRef { get; set; }
        public double? PercIncidencia { get; set; }
        public double? PercDeducao { get; set; }
        public double? ValorIvaDedutivel { get; set; }
        public double? PrecoUnitarioEfetivoMoedaRefOrigem { get; set; }
        public string CodigoMotivoIsencaoIva { get; set; }
        public double? ValorDescontoLinha { get; set; }
        public double? TotalComDescontoLinha { get; set; }
        public double? ValorDescontoCabecalho { get; set; }
        public double? TotalComDescontoCabecalho { get; set; }
        public double? QuantidadeSatisfeita { get; set; }
        public double? QuantidadeDevolvida { get; set; }
        public string DocumentoOrigem { get; set; }
        public string VossoNumeroDocumentoOrigem { get; set; }
        public long? NumeroDocumentoOrigem { get; set; }
        public long? IdtiposDocumentoSeriesOrigem { get; set; }
        public bool? Satisfeito { get; set; }
        public long? IdlinhaDocumentoCompra { get; set; }
        public long? IdlinhaDocumentoVenda { get; set; }
        public long? IdlinhaDocumentoStock { get; set; }
        public long? IdartigoPara { get; set; }
        public long? IdtipoDocumentoOrigemInicial { get; set; }
        public long? IddocumentoOrigemInicial { get; set; }
        public long? IdlinhaDocumentoOrigemInicial { get; set; }
        public string DocumentoOrigemInicial { get; set; }
        public long? IdlinhaDocumentoStockInicial { get; set; }
        public long? IdlinhaDocumentoCompraInicial { get; set; }
        public long? Idofartigo { get; set; }
        public double? QtdStockSatisfeita { get; set; }
        public double? QtdStockDevolvida { get; set; }
        public double? QtdStockAcerto { get; set; }
        public double? QtdStock2Satisfeita { get; set; }
        public double? QtdStock2Devolvida { get; set; }
        public double? QtdStock2Acerto { get; set; }
        public long? IdartigoPa { get; set; }
        public double? QtdStockReserva { get; set; }
        public double? QtdStockReserva2Uni { get; set; }
        public DateTime? DataEntrega { get; set; }
        public double? PrecoUnitarioEfetivoSemIva { get; set; }

        public TbArmazens IdarmazemDestinoNavigation { get; set; }
        public TbArmazensLocalizacoes IdarmazemLocalizacaoDestinoNavigation { get; set; }
        public TbArmazensLocalizacoes IdarmazemLocalizacaoNavigation { get; set; }
        public TbArmazens IdarmazemNavigation { get; set; }
        public TbArtigosNumerosSeries IdartigoNumSerieNavigation { get; set; }
        public SystemVatCode IdcodigoIvaNavigation { get; set; }
        public PurchaseDocument IddocumentoCompraNavigation { get; set; }
        public TbSistemaEspacoFiscal IdespacoFiscalNavigation { get; set; }
        public PurchaseDocumentLine IdlinhaDocumentoCompraInicialNavigation { get; set; }
        public PurchaseDocumentLine IdlinhaDocumentoCompraNavigation { get; set; }
        public StockDocumentLine IdlinhaDocumentoStockInicialNavigation { get; set; }
        public StockDocumentLine IdlinhaDocumentoStockNavigation { get; set; }
        public SaleDocumentLine IdlinhaDocumentoVendaNavigation { get; set; }
        public TbArtigosLotes IdloteNavigation { get; set; }
        public TbSistemaRegimeIva IdregimeIvaNavigation { get; set; }
        public Vat IdtaxaIvaNavigation { get; set; }
        public TbTiposDocumento IdtipoDocumentoOrigemInicialNavigation { get; set; }
        public TbTiposDocumento IdtipoDocumentoOrigemNavigation { get; set; }
        public SystemVatType SystemVatType { get; set; }
        public TbSistemaTiposPrecos IdtipoPrecoNavigation { get; set; }
        public TbTiposDocumentoSeries IdtiposDocumentoSeriesOrigemNavigation { get; set; }
        public TbUnidades IdunidadeNavigation { get; set; }
        public TbUnidades IdunidadeStock2Navigation { get; set; }
        public TbUnidades IdunidadeStockNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> InverseIdlinhaDocumentoCompraInicialNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> InverseIdlinhaDocumentoCompraNavigation { get; set; }

        public override DocumentBase GetDocumentBase() => IddocumentoCompraNavigation;

        public override double GetDiscount() => EffectiveDiscountValueWithoutVat ?? 0;

        public override double GetCostOfGoods() => 0;

        public override double GetPurchaseCostOfGoods() => TotalPrice ?? 0;
    }
}
