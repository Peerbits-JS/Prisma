using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbDocumentosVendasPendentes
    {
        public long Id { get; set; }
        public long? IdtipoDocumento { get; set; }
        public long? NumeroDocumento { get; set; }
        public DateTime? DataDocumento { get; set; }
        public DateTime? DataVencimento { get; set; }
        public string Documento { get; set; }
        public long? IdtipoEntidade { get; set; }
        public long? Identidade { get; set; }
        public string DescricaoEntidade { get; set; }
        public double? TotalMoedaDocumento { get; set; }
        public double? TotalMoedaReferencia { get; set; }
        public double? TotalClienteMoedaDocumento { get; set; }
        public double? TotalClienteMoedaReferencia { get; set; }
        public long? Idmoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public double? ValorPendente { get; set; }
        public long? IdsistemaNaturezas { get; set; }
        public bool? Pago { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long? IddocumentoVenda { get; set; }

        public SaleDocument IddocumentoVendaNavigation { get; set; }
        public TbSistemaNaturezas IdsistemaNaturezasNavigation { get; set; }
    }
}
