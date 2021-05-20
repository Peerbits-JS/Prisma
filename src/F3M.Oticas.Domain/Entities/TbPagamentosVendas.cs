using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbPagamentosVendas
    {
        public TbPagamentosVendas()
        {
            TbPagamentosVendasFormasPagamento = new HashSet<TbPagamentosVendasFormasPagamento>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbRecibos = new HashSet<ReceiptDocument>();
        }

        public long Id { get; set; }
        public long? Numero { get; set; }
        public DateTime Data { get; set; }
        public string Descricao { get; set; }
        public double? TotalMoeda { get; set; }
        public long? Idmoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public double? TotalMoedaReferencia { get; set; }
        public double? ValorEntregue { get; set; }
        public double? Troco { get; set; }
        public long? Idloja { get; set; }
        public string CodigoTipoEstado { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public ICollection<TbPagamentosVendasFormasPagamento> TbPagamentosVendasFormasPagamento { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
    }
}
