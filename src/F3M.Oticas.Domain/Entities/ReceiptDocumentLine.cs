using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class ReceiptDocumentLine : DocumentLineBase
    {
        public ReceiptDocumentLine()
        {
            TbRecibosLinhasTaxas = new HashSet<TbRecibosLinhasTaxas>();
        }

        public long ReceiptDocumentId { get; set; }
        public long DocumentTypeId { get; set; }
        public long DocumentTypeSeriesId { get; set; }
        public long SaleDocumentId { get; set; }
        public long? DocumentNumber { get; set; }
        public DateTime DocumentDate { get; set; }
        public DateTime? DueDate { get; set; }
        public string Document { get; set; }
        public long? EntityId { get; set; }
        public string FiscalName { get; set; }
        public string FiscalAddress { get; set; }
        public long? FiscalZipCodeId { get; set; }
        public long? FiscalCountyId { get; set; }
        public long? FiscalDistrictId { get; set; }
        public string PrintFiscalZipCode { get; set; }
        public string FiscalZipCodeDescription { get; set; }
        public string FiscalCountyDescription { get; set; }
        public string FiscalDistrictDescription { get; set; }
        public string FiscalTaxPayer { get; set; }
        public string CountryFiscalAcronym { get; set; }
        public double? TotalCurrencyDocument { get; set; }
        public long? CurrencyId { get; set; }
        public double? ConversionRate { get; set; }
        public double? TotalReferenceCurrency { get; set; }
        public double? AmmountPaid { get; set; }
        public double? IncidenceValue { get; set; }
        public double? VatValue { get; set; }
        public string OriginDocument { get; set; }
        public DateTime? OriginDocumentDate { get; set; }
        public bool? IsDownPayment { get; set; }
        public int? Order { get; set; }

        public TbCodigosPostais IdcodigoPostalFiscalNavigation { get; set; }
        public TbConcelhos IdconcelhoFiscalNavigation { get; set; }
        public TbDistritos IddistritoFiscalNavigation { get; set; }
        public SaleDocument SaleDocument { get; set; }
        public TbClientes IdentidadeNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public ReceiptDocument ReceiptDocument { get; set; }
        public TbTiposDocumento IdtipoDocumentoNavigation { get; set; }
        public TbTiposDocumentoSeries IdtiposDocumentoSeriesNavigation { get; set; }
        public ICollection<TbRecibosLinhasTaxas> TbRecibosLinhasTaxas { get; set; }

        public override DocumentBase GetDocumentBase() => ReceiptDocument;
    }
}
