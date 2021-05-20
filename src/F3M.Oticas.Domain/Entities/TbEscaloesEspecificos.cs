using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbEscaloesEspecificos
    {
        public long Id { get; set; }
        public long Idescalao { get; set; }
        public long? IdgruposArtigo { get; set; }
        public long? Idfamilia { get; set; }
        public long? IdsubFamilia { get; set; }
        public long? Idartigo { get; set; }
        public double? Percentagem { get; set; }
        public int Ordem { get; set; }
        public string Descricao { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbEscaloes IdescalaoNavigation { get; set; }
        public TbFamilias IdfamiliaNavigation { get; set; }
        public TbGruposArtigo IdgruposArtigoNavigation { get; set; }
        public TbSubFamilias IdsubFamiliaNavigation { get; set; }
    }
}
