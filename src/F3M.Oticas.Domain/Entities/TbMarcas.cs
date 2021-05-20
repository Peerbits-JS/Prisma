using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMarcas
    {
        public TbMarcas()
        {
            TbArtigos = new HashSet<Product>();
            TbCoresLentes = new HashSet<TbCoresLentes>();
            TbModelos = new HashSet<TbModelos>();
            TbSuplementosLentes = new HashSet<TbSuplementosLentes>();
            TbTratamentosLentes = new HashSet<TbTratamentosLentes>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string VariavelContabilidade { get; set; }
        public bool? AtualizaPrecos { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<Product> TbArtigos { get; set; }
        public ICollection<TbCoresLentes> TbCoresLentes { get; set; }
        public ICollection<TbModelos> TbModelos { get; set; }
        public ICollection<TbSuplementosLentes> TbSuplementosLentes { get; set; }
        public ICollection<TbTratamentosLentes> TbTratamentosLentes { get; set; }
    }
}
