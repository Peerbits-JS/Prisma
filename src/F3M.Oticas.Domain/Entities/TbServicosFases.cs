using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbServicosFases
    {
        public long Id { get; set; }
        public long IdtipoFase { get; set; }
        public long Idservico { get; set; }
        public DateTime? Data { get; set; }
        public string Observacoes { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbServicos IdservicoNavigation { get; set; }
        public TbTiposFases IdtipoFaseNavigation { get; set; }
    }
}
