using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosDadosFinanceiros
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long Idiva { get; set; }
        public double? PercentagemDedutivel { get; set; }
        public double? PercentagemIncidencia { get; set; }
        public string TextoMotivoIsencaoPersonalizado { get; set; }
        public bool SujeitoProRata { get; set; }
        public long? IdartigoImpostoSelo { get; set; }
        public double? UltimoPrecoCusto { get; set; }
        public double? CustoMedio { get; set; }
        public double? PrecoPadrao { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
    }
}
