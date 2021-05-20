using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTratamentosLentes
    {
        public TbTratamentosLentes()
        {
            TbGamasLentes = new HashSet<TbGamasLentes>();
            TbLentesOftalmicas = new HashSet<TbLentesOftalmicas>();
            TbPrecosLentes = new HashSet<TbPrecosLentes>();
        }

        public long Id { get; set; }
        public long Idmarca { get; set; }
        public long Idmodelo { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Cor { get; set; }
        public string CodForn { get; set; }
        public string Referencia { get; set; }
        public string ModeloForn { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbMarcas IdmarcaNavigation { get; set; }
        public TbModelos IdmodeloNavigation { get; set; }
        public ICollection<TbGamasLentes> TbGamasLentes { get; set; }
        public ICollection<TbLentesOftalmicas> TbLentesOftalmicas { get; set; }
        public ICollection<TbPrecosLentes> TbPrecosLentes { get; set; }
    }
}
