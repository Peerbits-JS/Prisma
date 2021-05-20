using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposArtigos
    {
        public TbTiposArtigos()
        {
            TbArtigos = new HashSet<Product>();
            TbEntidadesComparticipacoes = new HashSet<TbEntidadesComparticipacoes>();
            TbModelos = new HashSet<TbModelos>();
        }

        public long Id { get; set; }
        public long IdsistemaClassificacao { get; set; }
        public long IdsistemaClassificacaoGeral { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string VariavelContabilidade { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool StkUnidade1 { get; set; }
        public bool StkUnidade2 { get; set; }

        public TbSistemaClassificacoesTiposArtigosGeral IdsistemaClassificacaoGeralNavigation { get; set; }
        public TbSistemaClassificacoesTiposArtigos IdsistemaClassificacaoNavigation { get; set; }
        public ICollection<Product> TbArtigos { get; set; }
        public ICollection<TbEntidadesComparticipacoes> TbEntidadesComparticipacoes { get; set; }
        public ICollection<TbModelos> TbModelos { get; set; }
    }
}
