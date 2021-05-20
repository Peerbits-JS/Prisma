using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArmazensLocalizacoes
    {
        public TbArmazensLocalizacoes()
        {
            TbArtigosArmazensLocalizacoes = new HashSet<TbArtigosArmazensLocalizacoes>();
            TbCcstockArtigos = new HashSet<CurrentAccountStockProduct>();
            TbDocumentosComprasLinhasIdarmazemLocalizacaoDestinoNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosComprasLinhasIdarmazemLocalizacaoNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            TbDocumentosStockLinhasIdarmazemLocalizacaoDestinoNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosStockLinhasIdarmazemLocalizacaoNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosVendasLinhasIdarmazemLocalizacaoDestinoNavigation = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasIdarmazemLocalizacaoNavigation = new HashSet<SaleDocumentLine>();
            TbStockArtigos = new HashSet<TbStockArtigos>();
            TbStockArtigosNecessidades = new HashSet<TbStockArtigosNecessidades>();
        }

        public long Id { get; set; }
        public long Idarmazem { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string CodigoBarras { get; set; }
        public int? Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbArmazens IdarmazemNavigation { get; set; }
        public ICollection<TbArtigosArmazensLocalizacoes> TbArtigosArmazensLocalizacoes { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigos { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdarmazemLocalizacaoDestinoNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdarmazemLocalizacaoNavigation { get; set; }
        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdarmazemLocalizacaoDestinoNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdarmazemLocalizacaoNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdarmazemLocalizacaoDestinoNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdarmazemLocalizacaoNavigation { get; set; }
        public ICollection<TbStockArtigos> TbStockArtigos { get; set; }
        public ICollection<TbStockArtigosNecessidades> TbStockArtigosNecessidades { get; set; }
    }
}
