using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbLojas
    {
        public TbLojas()
        {
            TbAgendamento = new HashSet<TbAgendamento>();
            TbArmazens = new HashSet<TbArmazens>();
            TbArtigosPrecos = new HashSet<TbArtigosPrecos>();
            TbBancos = new HashSet<TbBancos>();
            TbClientes = new HashSet<TbClientes>();
            TbClientesLojas = new HashSet<TbClientesLojas>();
            TbContasBancarias = new HashSet<TbContasBancarias>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbDocumentosVendasFormasPagamento = new HashSet<SaleDocumentPaymentType>();
            TbEntidades = new HashSet<TbEntidades>();
            TbEntidadesLojas = new HashSet<TbEntidadesLojas>();
            TbExames = new HashSet<TbExames>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbMapasVistas = new HashSet<TbMapasVistas>();
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
            TbPagamentosVendas = new HashSet<TbPagamentosVendas>();
            TbPagamentosVendasFormasPagamento = new HashSet<TbPagamentosVendasFormasPagamento>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbParametrosContexto = new HashSet<TbParametrosContexto>();
            TbParametrosLoja = new HashSet<TbParametrosLoja>();
            TbParametrosLojaLinhas = new HashSet<TbParametrosLojaLinhas>();
            TbPlaneamento = new HashSet<TbPlaneamento>();
            TbRazoes = new HashSet<TbRazoes>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbSaft = new HashSet<TbSaft>();
            TbTemplates = new HashSet<TbTemplates>();
            TbTiposConsultas = new HashSet<TbTiposConsultas>();
            TbTiposDocumentoSeries = new HashSet<TbTiposDocumentoSeries>();
        }

        public long Id { get; set; }
        public long Idempresa { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long IdlojaSede { get; set; }
        public string DescricaoLojaSede { get; set; }
        public bool SedeGrupo { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public string EnderecoIp { get; set; }
        public string Cor { get; set; }
        public DateTime? Abertura { get; set; }
        public DateTime? Fecho { get; set; }

        public ICollection<TbAgendamento> TbAgendamento { get; set; }
        public ICollection<TbArmazens> TbArmazens { get; set; }
        public ICollection<TbArtigosPrecos> TbArtigosPrecos { get; set; }
        public ICollection<TbBancos> TbBancos { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbClientesLojas> TbClientesLojas { get; set; }
        public ICollection<TbContasBancarias> TbContasBancarias { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<SaleDocumentPaymentType> TbDocumentosVendasFormasPagamento { get; set; }
        public ICollection<TbEntidades> TbEntidades { get; set; }
        public ICollection<TbEntidadesLojas> TbEntidadesLojas { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<TbMapasVistas> TbMapasVistas { get; set; }
        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
        public ICollection<TbPagamentosVendas> TbPagamentosVendas { get; set; }
        public ICollection<TbPagamentosVendasFormasPagamento> TbPagamentosVendasFormasPagamento { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<TbParametrosContexto> TbParametrosContexto { get; set; }
        public ICollection<TbParametrosLoja> TbParametrosLoja { get; set; }
        public ICollection<TbParametrosLojaLinhas> TbParametrosLojaLinhas { get; set; }
        public ICollection<TbPlaneamento> TbPlaneamento { get; set; }
        public ICollection<TbRazoes> TbRazoes { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<TbSaft> TbSaft { get; set; }
        public ICollection<TbTemplates> TbTemplates { get; set; }
        public ICollection<TbTiposConsultas> TbTiposConsultas { get; set; }
        public ICollection<TbTiposDocumentoSeries> TbTiposDocumentoSeries { get; set; }
    }
}
