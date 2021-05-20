﻿using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbMapaCaixa
    {
        public long Id { get; set; }
        public long? Idloja { get; set; }
        public string Natureza { get; set; }
        public long? IdformaPagamento { get; set; }
        public string DescricaoFormaPagamento { get; set; }
        public long? IdtipoDocumento { get; set; }
        public long? IdtipoDocumentoSeries { get; set; }
        public long? Iddocumento { get; set; }
        public string NumeroDocumento { get; set; }
        public DateTime? DataDocumento { get; set; }
        public string Descricao { get; set; }
        public long? Idmoeda { get; set; }
        public double? TotalMoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public double? TotalMoedaReferencia { get; set; }
        public double? Valor { get; set; }
        public double? ValorEntregue { get; set; }
        public double? Troco { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public double? Transporte { get; set; }
        public string Estado { get; set; }
    }
}
