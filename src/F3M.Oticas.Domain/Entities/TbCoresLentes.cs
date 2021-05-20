using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbCoresLentes
    {
        public TbCoresLentes()
        {
            TbLentesOftalmicas = new HashSet<TbLentesOftalmicas>();
        }

        public long Id { get; set; }
        public long Idmarca { get; set; }
        public long? Idmodelo { get; set; }
        public long IdtipoLente { get; set; }
        public long IdmateriaLente { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Cor { get; set; }
        public double? PrecoVenda { get; set; }
        public double? PrecoCusto { get; set; }
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
        public TbSistemaMateriasLentes IdmateriaLenteNavigation { get; set; }
        public TbModelos IdmodeloNavigation { get; set; }
        public TbSistemaTiposLentes IdtipoLenteNavigation { get; set; }
        public ICollection<TbLentesOftalmicas> TbLentesOftalmicas { get; set; }
    }
}
