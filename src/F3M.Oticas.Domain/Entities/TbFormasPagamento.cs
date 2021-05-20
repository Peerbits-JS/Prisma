using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbFormasPagamento
    {
        public TbFormasPagamento()
        {
            TbClientes = new HashSet<TbClientes>();
            TbDocumentosVendasFormasPagamento = new HashSet<SaleDocumentPaymentType>();
            TbFormasPagamentoIdiomas = new HashSet<TbFormasPagamentoIdiomas>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbPagamentosComprasFormasPagamento = new HashSet<ProviderPaymentDocumentPaymentType>();
            TbPagamentosVendasFormasPagamento = new HashSet<TbPagamentosVendasFormasPagamento>();
            TbRecibosFormasPagamento = new HashSet<ReceiptDocumentPaymentType>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long IdtipoFormaPagamento { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaTiposFormasPagamento IdtipoFormaPagamentoNavigation { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<SaleDocumentPaymentType> TbDocumentosVendasFormasPagamento { get; set; }
        public ICollection<TbFormasPagamentoIdiomas> TbFormasPagamentoIdiomas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<ProviderPaymentDocumentPaymentType> TbPagamentosComprasFormasPagamento { get; set; }
        public ICollection<TbPagamentosVendasFormasPagamento> TbPagamentosVendasFormasPagamento { get; set; }
        public ICollection<ReceiptDocumentPaymentType> TbRecibosFormasPagamento { get; set; }
    }
}
