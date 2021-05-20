using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposLentes
    {
        public TbSistemaTiposLentes()
        {
            TbCoresLentes = new HashSet<TbCoresLentes>();
            TbEntidadesComparticipacoes = new HashSet<TbEntidadesComparticipacoes>();
            TbModelos = new HashSet<TbModelos>();
            TbSuplementosLentes = new HashSet<TbSuplementosLentes>();
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
        public long? IdsistemaClassificacao { get; set; }

        public TbSistemaClassificacoesTiposArtigos IdsistemaClassificacaoNavigation { get; set; }
        public ICollection<TbCoresLentes> TbCoresLentes { get; set; }
        public ICollection<TbEntidadesComparticipacoes> TbEntidadesComparticipacoes { get; set; }
        public ICollection<TbModelos> TbModelos { get; set; }
        public ICollection<TbSuplementosLentes> TbSuplementosLentes { get; set; }
    }
}
