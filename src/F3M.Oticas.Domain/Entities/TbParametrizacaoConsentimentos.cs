using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrizacaoConsentimentos
    {
        public TbParametrizacaoConsentimentos()
        {
            TbConsentimentos = new HashSet<TbConsentimentos>();
            TbParametrizacaoConsentimentosCamposEntidade = new HashSet<TbParametrizacaoConsentimentosCamposEntidade>();
            TbParametrizacaoConsentimentosPerguntas = new HashSet<TbParametrizacaoConsentimentosPerguntas>();
        }

        public long Id { get; set; }
        public int IdfuncionalidadeConsentimento { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string Titulo { get; set; }
        public string TituloSemFormatacao { get; set; }
        public string Cabecalho { get; set; }
        public string CabecalhoSemFormatacao { get; set; }
        public string Rodape { get; set; }
        public string RodapeSemFormatacao { get; set; }
        public bool ApresentadoPorDefeito { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaFuncionalidadesConsentimento IdfuncionalidadeConsentimentoNavigation { get; set; }
        public ICollection<TbConsentimentos> TbConsentimentos { get; set; }
        public ICollection<TbParametrizacaoConsentimentosCamposEntidade> TbParametrizacaoConsentimentosCamposEntidade { get; set; }
        public ICollection<TbParametrizacaoConsentimentosPerguntas> TbParametrizacaoConsentimentosPerguntas { get; set; }
    }
}
