using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbUnidadesRelacoes
    {
        public long Id { get; set; }
        public long Idunidade { get; set; }
        public long IdunidadeConversao { get; set; }
        public double FatorConversao { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbUnidades IdunidadeConversaoNavigation { get; set; }
        public TbUnidades IdunidadeNavigation { get; set; }
    }
}
