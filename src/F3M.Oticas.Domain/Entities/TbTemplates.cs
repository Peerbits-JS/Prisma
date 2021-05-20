using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTemplates
    {
        public TbTemplates()
        {
            TbExames = new HashSet<TbExames>();
            TbExamesTemplate = new HashSet<TbExamesTemplate>();
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
            TbTiposConsultas = new HashSet<TbTiposConsultas>();
        }

        public long Id { get; set; }
        public long IdsistemaTipoTemplate { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Idloja { get; set; }
        public string Descricao { get; set; }
        public string Codigo { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbExamesTemplate> TbExamesTemplate { get; set; }
        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
        public ICollection<TbTiposConsultas> TbTiposConsultas { get; set; }
    }
}
