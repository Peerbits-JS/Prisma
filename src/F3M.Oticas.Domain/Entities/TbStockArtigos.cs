using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbStockArtigos
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long? Idloja { get; set; }
        public long? Idarmazem { get; set; }
        public long? IdarmazemLocalizacao { get; set; }
        public long? IdartigoLote { get; set; }
        public long? IdartigoNumeroSerie { get; set; }
        public long? IdartigoDimensao { get; set; }
        public double? Quantidade { get; set; }
        public double? QuantidadeStock { get; set; }
        public double? QuantidadeStock2 { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public double? QuantidadeReservada { get; set; }
        public double? QuantidadeReservada2 { get; set; }

        public TbArmazensLocalizacoes IdarmazemLocalizacaoNavigation { get; set; }
        public TbArmazens IdarmazemNavigation { get; set; }
        public TbArtigosLotes IdartigoLoteNavigation { get; set; }
        public Product IdartigoNavigation { get; set; }
        public TbArtigosNumerosSeries IdartigoNumeroSerieNavigation { get; set; }
    }
}
