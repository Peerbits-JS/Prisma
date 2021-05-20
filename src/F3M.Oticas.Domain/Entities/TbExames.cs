using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbExames
    {
        public TbExames()
        {
            TbExamesAnexos = new HashSet<TbExamesAnexos>();
            TbExamesProps = new HashSet<TbExamesProps>();
            TbExamesPropsFotos = new HashSet<TbExamesPropsFotos>();
        }

        public long Id { get; set; }
        public long Numero { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Idcliente { get; set; }
        public long IdmedicoTecnico { get; set; }
        public long Idespecialidade { get; set; }
        public long Idloja { get; set; }
        public DateTime DataExame { get; set; }
        public long Idtemplate { get; set; }
        public long? Idagendamento { get; set; }
        public long? IdtipoConsulta { get; set; }

        public TbAgendamento IdagendamentoNavigation { get; set; }
        public TbClientes IdclienteNavigation { get; set; }
        public TbEspecialidades IdespecialidadeNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbMedicosTecnicos IdmedicoTecnicoNavigation { get; set; }
        public TbTemplates IdtemplateNavigation { get; set; }
        public TbTiposConsultas IdtipoConsultaNavigation { get; set; }
        public ICollection<TbExamesAnexos> TbExamesAnexos { get; set; }
        public ICollection<TbExamesProps> TbExamesProps { get; set; }
        public ICollection<TbExamesPropsFotos> TbExamesPropsFotos { get; set; }
    }
}
