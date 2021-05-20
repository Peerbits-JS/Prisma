using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArmazens
    {
        public TbArmazens()
        {
            TbArmazensLocalizacoes = new HashSet<TbArmazensLocalizacoes>();
            TbArtigosArmazensLocalizacoes = new HashSet<TbArtigosArmazensLocalizacoes>();
            TbCcstockArtigos = new HashSet<CurrentAccountStockProduct>();
            TbDocumentosComprasLinhasIdarmazemDestinoNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosComprasLinhasIdarmazemNavigation = new HashSet<PurchaseDocumentLine>();
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            TbDocumentosStockLinhasIdarmazemDestinoNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosStockLinhasIdarmazemNavigation = new HashSet<StockDocumentLine>();
            TbDocumentosVendasLinhasIdarmazemDestinoNavigation = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasIdarmazemNavigation = new HashSet<SaleDocumentLine>();
            TbStockArtigos = new HashSet<TbStockArtigos>();
            TbStockArtigosNecessidades = new HashSet<TbStockArtigosNecessidades>();
        }

        public long Id { get; set; }
        public long? Idloja { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long? IdcodigoPostal { get; set; }
        public long? Idconcelho { get; set; }
        public long? Iddistrito { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string Morada { get; set; }
        public long? Idpais { get; set; }

        public TbCodigosPostais IdcodigoPostalNavigation { get; set; }
        public TbConcelhos IdconcelhoNavigation { get; set; }
        public TbDistritos IddistritoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public Country IdpaisNavigation { get; set; }
        public ICollection<TbArmazensLocalizacoes> TbArmazensLocalizacoes { get; set; }
        public ICollection<TbArtigosArmazensLocalizacoes> TbArtigosArmazensLocalizacoes { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigos { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdarmazemDestinoNavigation { get; set; }
        public ICollection<PurchaseDocumentLine> TbDocumentosComprasLinhasIdarmazemNavigation { get; set; }
        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdarmazemDestinoNavigation { get; set; }
        public ICollection<StockDocumentLine> TbDocumentosStockLinhasIdarmazemNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdarmazemDestinoNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhasIdarmazemNavigation { get; set; }
        public ICollection<TbStockArtigos> TbStockArtigos { get; set; }
        public ICollection<TbStockArtigosNecessidades> TbStockArtigosNecessidades { get; set; }
    }
}
