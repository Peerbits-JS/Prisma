using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbEspecialidades
    {
        public TbEspecialidades()
        {
            TbAgendamento = new HashSet<TbAgendamento>();
            TbExames = new HashSet<TbExames>();
            TbMedicosTecnicosEspecialidades = new HashSet<TbMedicosTecnicosEspecialidades>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string Cor { get; set; }

        public ICollection<TbAgendamento> TbAgendamento { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbMedicosTecnicosEspecialidades> TbMedicosTecnicosEspecialidades { get; set; }
    }
}
