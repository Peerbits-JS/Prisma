using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposConsultas
    {
        public TbTiposConsultas()
        {
            TbExames = new HashSet<TbExames>();
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long Idtemplate { get; set; }
        public long Idloja { get; set; }
        public long? IdmapaVista1 { get; set; }
        public long? IdmapaVista2 { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbMapasVistas IdmapaVista1Navigation { get; set; }
        public TbMapasVistas IdmapaVista2Navigation { get; set; }
        public TbTemplates IdtemplateNavigation { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
    }
}
