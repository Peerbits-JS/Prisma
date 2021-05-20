using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbCondicoesPagamentoDescontos
    {
        public long Id { get; set; }
        public long IdcondicaoPagamento { get; set; }
        public long IdtipoEntidade { get; set; }
        public int AteXdiasAposEmissao { get; set; }
        public double Desconto { get; set; }
        public int Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool Importado { get; set; }

        public TbCondicoesPagamento IdcondicaoPagamentoNavigation { get; set; }
        public SystemEntityType IdtipoEntidadeNavigation { get; set; }
    }
}
