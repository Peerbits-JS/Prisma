using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMedicosTecnicosEspecialidades
    {
        public long Id { get; set; }
        public long IdmedicoTecnico { get; set; }
        public long Idespecialidade { get; set; }
        public bool Selecionado { get; set; }
        public bool Principal { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbEspecialidades IdespecialidadeNavigation { get; set; }
        public TbMedicosTecnicos IdmedicoTecnicoNavigation { get; set; }
    }
}
