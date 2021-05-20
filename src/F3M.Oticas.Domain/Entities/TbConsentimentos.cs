using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbConsentimentos
    {
        public TbConsentimentos()
        {
            TbRespostasConsentimentos = new HashSet<TbRespostasConsentimentos>();
        }

        public long Id { get; set; }
        public string IdcodigoEntidade { get; set; }
        public string CodigoEntidade { get; set; }
        public string DescricaoEntidade { get; set; }
        public long IdparametrizacaoConsentimentos { get; set; }
        public bool ComAssinatura { get; set; }
        public DateTime DataConsentimento { get; set; }
        public string Titulo { get; set; }
        public string TituloSemFormatacao { get; set; }
        public string Cabecalho { get; set; }
        public string CabecalhoSemFormatacao { get; set; }
        public string Rodape { get; set; }
        public string RodapeSemFormatacao { get; set; }
        public string Ficheiro { get; set; }
        public string Caminho { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbParametrizacaoConsentimentos IdparametrizacaoConsentimentosNavigation { get; set; }
        public ICollection<TbRespostasConsentimentos> TbRespostasConsentimentos { get; set; }
    }
}
