using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosStock
    {
        public long Id { get; set; }
        public DateTime? PrimeiraEntrada { get; set; }
        public DateTime? UltimaEntrada { get; set; }
        public DateTime? PrimeiraSaida { get; set; }
        public DateTime? UltimaSaida { get; set; }
        public double? Atual { get; set; }
        public double? Reservado { get; set; }
        public bool? Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public double? StockAtual2 { get; set; }
        public long? Idartigo { get; set; }
        public double? Reservado2 { get; set; }
        public double? StockReqPendente { get; set; }
        public double? StockReqPendente2Uni { get; set; }

        public Product IdartigoNavigation { get; set; }
    }
}
