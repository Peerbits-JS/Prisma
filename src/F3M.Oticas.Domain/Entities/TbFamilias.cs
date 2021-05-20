using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbFamilias
    {
        public TbFamilias()
        {
            TbArtigos = new HashSet<Product>();
            TbEscaloesEspecificos = new HashSet<TbEscaloesEspecificos>();
            TbSubFamilias = new HashSet<TbSubFamilias>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string VariavelContabilidade { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<Product> TbArtigos { get; set; }
        public ICollection<TbEscaloesEspecificos> TbEscaloesEspecificos { get; set; }
        public ICollection<TbSubFamilias> TbSubFamilias { get; set; }
    }
}
