using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosDadosFinanceirosPvsUpcperc
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public double? Pv1 { get; set; }
        public double? Pv2 { get; set; }
        public double? Pv3 { get; set; }
        public double? Pv4 { get; set; }
        public double? Pv5 { get; set; }
        public double? Pv6 { get; set; }
        public double? Pv7 { get; set; }
        public double? Pv8 { get; set; }
        public double? Pv9 { get; set; }
        public double? Pv10 { get; set; }
        public double? Pv1iva { get; set; }
        public double? Pv2iva { get; set; }
        public double? Pv3iva { get; set; }
        public double? Pv4iva { get; set; }
        public double? Pv5iva { get; set; }
        public double? Pv6iva { get; set; }
        public double? Pv7iva { get; set; }
        public double? Pv8iva { get; set; }
        public double? Pv9iva { get; set; }
        public double? Pv10iva { get; set; }
        public double? PercUpc1 { get; set; }
        public double? PercUpc2 { get; set; }
        public double? PercUpc3 { get; set; }
        public double? PercUpc4 { get; set; }
        public double? PercUpc5 { get; set; }
        public double? PercUpc6 { get; set; }
        public double? PercUpc7 { get; set; }
        public double? PercUpc8 { get; set; }
        public double? PercUpc9 { get; set; }
        public double? PercUpc10 { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
    }
}
