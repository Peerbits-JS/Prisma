using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbPagamentosVendasFormasPagamento
    {
        public long Id { get; set; }
        public long IdpagamentoVenda { get; set; }
        public long IdformaPagamento { get; set; }
        public double? TotalMoeda { get; set; }
        public long? Idmoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public double? TotalMoedaReferencia { get; set; }
        public double? Valor { get; set; }
        public int? Ordem { get; set; }
        public long? Idloja { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbFormasPagamento IdformaPagamentoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbPagamentosVendas IdpagamentoVendaNavigation { get; set; }
    }
}
