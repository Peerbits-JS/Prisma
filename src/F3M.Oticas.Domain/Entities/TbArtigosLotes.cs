using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosLotes
    {
        public TbArtigosLotes()
        {
            TbCcstockArtigos = new HashSet<CurrentAccountStockProduct>();
            TbDocumentosComprasLinhas = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockContagemLinhas = new HashSet<TbDocumentosStockContagemLinhas>();
            TbDocumentosStockLinhas = new HashSet<StockDocumentLine>();
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbStockArtigos = new HashSet<TbStockArtigos>();
            TbStockArtigosNecessidades = new HashSet<TbStockArtigosNecessidades>();
        }

        public long Id { get; set; }
        public long Idartigo { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public DateTime? DataFabrico { get; set; }
        public DateTime? DataValidade { get; set; }
        public bool? Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Ordem { get; set; }

        public Product IdartigoNavigation { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigos { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhas { get; set; }
        public ICollection<TbDocumentosStockContagemLinhas> TbDocumentosStockContagemLinhas { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhas { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<TbStockArtigos> TbStockArtigos { get; set; }
        public ICollection<TbStockArtigosNecessidades> TbStockArtigosNecessidades { get; set; }
    }
}
