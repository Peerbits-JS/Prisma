using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbUnidades
    {
        public TbUnidades()
        {
            TbArtigosIdunidadeCompraNavigation = new HashSet<Product>();
            TbArtigosIdunidadeNavigation = new HashSet<Product>();
            TbArtigosIdunidadeStock2Navigation = new HashSet<Product>();
            TbArtigosIdunidadeVendaNavigation = new HashSet<Product>();
            TbArtigosPrecos = new HashSet<TbArtigosPrecos>();
            TbArtigosUnidadesIdunidadeConversaoNavigation = new HashSet<TbArtigosUnidades>();
            TbArtigosUnidadesIdunidadeNavigation = new HashSet<TbArtigosUnidades>();
            TbComunicacaoAutoridadeTributariaLinhas = new HashSet<TaxAuthorityComunicationProduct>();
            TbDocumentosComprasLinhasIdunidadeNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosComprasLinhasIdunidadeStock2Navigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosComprasLinhasIdunidadeStockNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockContagemLinhas = new HashSet<TbDocumentosStockContagemLinhas>();
            TbDocumentosStockLinhasIdunidadeNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosStockLinhasIdunidadeStock2Navigation = new HashSet<StockDocumentLine>();
            TbDocumentosStockLinhasIdunidadeStockNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosVendasLinhasIdunidadeNavigation = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasIdunidadeStock2Navigation = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasIdunidadeStockNavigation = new HashSet<SaleDocumentLine>();
            TbUnidadesRelacoesIdunidadeConversaoNavigation = new HashSet<TbUnidadesRelacoes>();
            TbUnidadesRelacoesIdunidadeNavigation = new HashSet<TbUnidadesRelacoes>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public short NumeroDeCasasDecimais { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool? PorDefeito { get; set; }

        public ICollection<Product> TbArtigosIdunidadeCompraNavigation { get; set; }
        public ICollection<Product> TbArtigosIdunidadeNavigation { get; set; }
        public ICollection<Product> TbArtigosIdunidadeStock2Navigation { get; set; }
        public ICollection<Product> TbArtigosIdunidadeVendaNavigation { get; set; }
        public ICollection<TbArtigosPrecos> TbArtigosPrecos { get; set; }
        public ICollection<TbArtigosUnidades> TbArtigosUnidadesIdunidadeConversaoNavigation { get; set; }
        public ICollection<TbArtigosUnidades> TbArtigosUnidadesIdunidadeNavigation { get; set; }
        public ICollection<TaxAuthorityComunicationProduct> TbComunicacaoAutoridadeTributariaLinhas { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdunidadeNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdunidadeStock2Navigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdunidadeStockNavigation { get; set; }
        public ICollection<TbDocumentosStockContagemLinhas> TbDocumentosStockContagemLinhas { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdunidadeNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdunidadeStock2Navigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdunidadeStockNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdunidadeNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdunidadeStock2Navigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdunidadeStockNavigation { get; set; }
        public ICollection<TbUnidadesRelacoes> TbUnidadesRelacoesIdunidadeConversaoNavigation { get; set; }
        public ICollection<TbUnidadesRelacoes> TbUnidadesRelacoesIdunidadeNavigation { get; set; }
    }
}
