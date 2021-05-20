using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMoedas
    {
        public TbMoedas()
        {
            TbCcstockArtigos = new HashSet<CurrentAccountStockProduct>();
            TbClientes = new HashSet<TbClientes>();
            TbContasBancarias = new HashSet<TbContasBancarias>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasFormasPagamento = new HashSet<ProviderPaymentDocumentPaymentType>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
            TbPagamentosVendas = new HashSet<TbPagamentosVendas>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbParametrosEmpresa = new HashSet<TbParametrosEmpresa>();
            TbParametrosLoja = new HashSet<TbParametrosLoja>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosFormasPagamento = new HashSet<ReceiptDocumentPaymentType>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public double TaxaConversao { get; set; }
        public string DescricaoDecimal { get; set; }
        public string DescricaoInteira { get; set; }
        public byte? CasasDecimaisTotais { get; set; }
        public byte? CasasDecimaisIva { get; set; }
        public byte? CasasDecimaisPrecosUnitarios { get; set; }
        public long IdsistemaMoeda { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string Simbolo { get; set; }

        public TbSistemaMoedas IdsistemaMoedaNavigation { get; set; }
        public ICollection<CurrentAccountStockProduct> TbCcstockArtigos { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbContasBancarias> TbContasBancarias { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ProviderPaymentDocumentPaymentType> TbPagamentosComprasFormasPagamento { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
        public ICollection<TbPagamentosVendas> TbPagamentosVendas { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<TbParametrosEmpresa> TbParametrosEmpresa { get; set; }
        public ICollection<TbParametrosLoja> TbParametrosLoja { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentPaymentType> TbRecibosFormasPagamento { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
    }
}
