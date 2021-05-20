using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbStockArtigosNecessidades
    {
        public long Id { get; set; }
        public long? IdtipoDocumento { get; set; }
        public long? Iddocumento { get; set; }
        public long? IdlinhaDocumento { get; set; }
        public long? IdordemFabrico { get; set; }
        public long? Idencomenda { get; set; }
        public string Documento { get; set; }
        public long? IdartigoPa { get; set; }
        public long Idartigo { get; set; }
        public long? Idloja { get; set; }
        public long? Idarmazem { get; set; }
        public long? IdarmazemLocalizacao { get; set; }
        public long? IdartigoLote { get; set; }
        public long? IdartigoNumeroSerie { get; set; }
        public long? IdartigoDimensao { get; set; }
        public long? Iddimensaolinha1 { get; set; }
        public long? Iddimensaolinha2 { get; set; }
        public double? QtdStockReservado { get; set; }
        public double? QtdStockReservado2 { get; set; }
        public double? QtdStockRequisitado { get; set; }
        public double? QtdStockRequisitado2 { get; set; }
        public double? QtdStockRequisitadoPnd { get; set; }
        public double? QtdStockRequisitadoPnd2 { get; set; }
        public double? QtdStockConsumido { get; set; }
        public double? QtdStockConsumido2 { get; set; }
        public long? IdartigoPara { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbArmazensLocalizacoes IdarmazemLocalizacaoNavigation { get; set; }
        public TbArmazens IdarmazemNavigation { get; set; }
        public TbArtigosLotes IdartigoLoteNavigation { get; set; }
        public Product IdartigoNavigation { get; set; }
        public TbArtigosNumerosSeries IdartigoNumeroSerieNavigation { get; set; }
        public Product IdartigoPaNavigation { get; set; }
        public Product IdartigoParaNavigation { get; set; }
    }
}
