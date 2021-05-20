using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbRecibosLinhasTaxas
    {
        public long Id { get; set; }
        public long IdreciboLinha { get; set; }
        public string TipoTaxa { get; set; }
        public double? TaxaIva { get; set; }
        public double? ValorIncidencia { get; set; }
        public double? ValorIva { get; set; }
        public string CodigoMotivoIsencaoIva { get; set; }
        public string MotivoIsencaoIva { get; set; }
        public double? ValorImposto { get; set; }
        public string CodigoTipoIva { get; set; }
        public string CodigoRegiaoIva { get; set; }
        public string CodigoTaxaIva { get; set; }
        public int? Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ReceiptDocumentLine IdreciboLinhaNavigation { get; set; }
    }
}
