using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbRespostasConsentimentos
    {
        public long Id { get; set; }
        public long IdparametrizacaoConsentimentoPerguntas { get; set; }
        public long Idconsentimento { get; set; }
        public bool? Resposta { get; set; }
        public long Codigo { get; set; }
        public string Descricao { get; set; }
        public long OrdemApresentaPerguntas { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbConsentimentos IdconsentimentoNavigation { get; set; }
        public TbParametrizacaoConsentimentosPerguntas IdparametrizacaoConsentimentoPerguntasNavigation { get; set; }
    }
}
