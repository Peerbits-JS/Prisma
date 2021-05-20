using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaFuncionalidadesConsentimento
    {
        public TbSistemaFuncionalidadesConsentimento()
        {
            TbParametrizacaoConsentimentos = new HashSet<TbParametrizacaoConsentimentos>();
            TbParametrizacaoConsentimentosCamposEntidade = new HashSet<TbParametrizacaoConsentimentosCamposEntidade>();
        }

        public int Id { get; set; }
        public string Funcionalidade { get; set; }
        public string QueryPesquisa { get; set; }
        public string OutraDenominacao { get; set; }
        public string QueryDefineEscondeFuncionalidade { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbParametrizacaoConsentimentos> TbParametrizacaoConsentimentos { get; set; }
        public ICollection<TbParametrizacaoConsentimentosCamposEntidade> TbParametrizacaoConsentimentosCamposEntidade { get; set; }
    }
}
