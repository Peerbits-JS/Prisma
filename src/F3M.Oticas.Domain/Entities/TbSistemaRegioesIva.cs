using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaRegioesIva
    {
        public TbSistemaRegioesIva()
        {
            TbClientes = new HashSet<TbClientes>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbIvaregioes = new HashSet<TbIvaregioes>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbRecibos = new HashSet<ReceiptDocument>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<TbIvaregioes> TbIvaregioes { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
    }
}
