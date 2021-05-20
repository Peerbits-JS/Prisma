using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbEscaloesPenalizacoes
    {
        public long Id { get; set; }
        public long Idescalao { get; set; }
        public double? AteDias { get; set; }
        public double? Percentagem { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbEscaloes IdescalaoNavigation { get; set; }
    }
}
