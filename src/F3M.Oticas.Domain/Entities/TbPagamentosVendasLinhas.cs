using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbPagamentosVendasLinhas
    {
        public long Id { get; set; }
        public long IdpagamentoVenda { get; set; }
        public long IdtipoDocumento { get; set; }
        public long IdtiposDocumentoSeries { get; set; }
        public long IddocumentoVenda { get; set; }
        public long Identidade { get; set; }
        public long? NumeroDocumento { get; set; }
        public DateTime DataDocumento { get; set; }
        public DateTime DataVencimento { get; set; }
        public string Documento { get; set; }
        public double? TotalMoedaDocumento { get; set; }
        public double? ValorPendente { get; set; }
        public double? TotalMoeda { get; set; }
        public long? Idmoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public double? TotalMoedaReferencia { get; set; }
        public double? ValorPago { get; set; }
        public int? Ordem { get; set; }
        public long? Idloja { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public SaleDocument IddocumentoVendaNavigation { get; set; }
        public TbClientes IdentidadeNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public TbPagamentosVendas IdpagamentoVendaNavigation { get; set; }
        public TbTiposDocumento IdtipoDocumentoNavigation { get; set; }
        public TbTiposDocumentoSeries IdtiposDocumentoSeriesNavigation { get; set; }
    }
}
