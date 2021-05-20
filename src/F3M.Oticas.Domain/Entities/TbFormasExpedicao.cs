using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbFormasExpedicao
    {
        public TbFormasExpedicao()
        {
            TbClientes = new HashSet<TbClientes>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbFormasExpedicaoIdiomas = new HashSet<TbFormasExpedicaoIdiomas>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<TbFormasExpedicaoIdiomas> TbFormasExpedicaoIdiomas { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
    }
}
