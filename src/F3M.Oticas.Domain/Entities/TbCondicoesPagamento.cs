using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbCondicoesPagamento
    {
        public TbCondicoesPagamento()
        {
            TbClientes = new HashSet<TbClientes>();
            TbCondicoesPagamentoDescontos = new HashSet<TbCondicoesPagamentoDescontos>();
            TbCondicoesPagamentoIdiomas = new HashSet<TbCondicoesPagamentoIdiomas>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
        }

        public long Id { get; set; }
        public long? IdtipoCondDataVencimento { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool DescontosIncluiIva { get; set; }
        public int? ValorCondicao { get; set; }
        public int? Prazo { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool Importado { get; set; }

        public TbSistemaTiposCondDataVencimento IdtipoCondDataVencimentoNavigation { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbCondicoesPagamentoDescontos> TbCondicoesPagamentoDescontos { get; set; }
        public ICollection<TbCondicoesPagamentoIdiomas> TbCondicoesPagamentoIdiomas { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
    }
}
