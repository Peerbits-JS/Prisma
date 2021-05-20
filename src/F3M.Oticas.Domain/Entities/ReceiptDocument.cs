using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public partial class ReceiptDocument : DocumentBase
    {
        public ReceiptDocument()
        {
            ReceiptDocumentPaymentType = new HashSet<ReceiptDocumentPaymentType>();
            Lines = new HashSet<ReceiptDocumentLine>();
        }
        public long? IdpagamentoVenda { get; set; }
        public string ValorExtenso { get; set; }
        public string StoreZipCode { get; set; }
        public string StoreCounty { get; set; }
        public string StoreAcronym { get; set; }
        public string StoreTaxPayer { get; set; }
        public string StoreBusinessName { get; set; }
        public string StoreAddress { get; set; }
        public string StorePhone { get; set; }
        public string StoreFax { get; set; }
        public string StoreMail { get; set; }
        public string StoreCommercialRegistryOffice { get; set; }
        public string StoreBusinessRegistrationNumber { get; set; }
        public string StoreSocialCapital { get; set; }

        public TbClientes Entity { get; set; }

        public TbPagamentosVendas IdpagamentoVendaNavigation { get; set; }

        public ICollection<ReceiptDocumentPaymentType> ReceiptDocumentPaymentType { get; set; }

        public ICollection<ReceiptDocumentLine> Lines { get; set; }

        public override IEnumerable<DocumentLineBase> GetDocumentLineBase() => Lines.Select(line => line as DocumentLineBase);

        public override EntityDocumentBase GetDocumentBaseEntity() => Entity;

        public override IEnumerable<DocumentPaymentTypeBase> GetPaymentsTypes() => ReceiptDocumentPaymentType;

        #region NOT MAPPED PROPERTIES FROM  DOCUMENTBASE
        [NotMapped]
        public override string ATCode { get; set; }

        [NotMapped]
        public override bool IsPrinted { get; set; }

        [NotMapped]
        public override bool? IsManualDocument { get; set; }

        [NotMapped]
        public override bool? IsSatisfied { get; set; }

        [NotMapped]
        public override double? SubTotal { get; set; }

        [NotMapped]
        public override string ATInternalCode { get; set; }

        [NotMapped]
        public override double? AddicionalCosts { get; set; }

        [NotMapped]
        public override double? ChargesValue { get; set; }

        [NotMapped]
        public override DateTime? DeliveryDate { get; set; }

        [NotMapped]
        public override double? DiscountPercentage { get; set; }

        [NotMapped]
        public override double? DiscountValue { get; set; }

        [NotMapped]
        public override long? DownloadZipCodeId { get; set; }

        [NotMapped]
        public override string DownloadAdrress { get; set; }

        [NotMapped]
        public override string DownloadCountryAcronym { get; set; }

        [NotMapped]
        public override double? VatTotal { get => base.VatTotal; set => base.VatTotal = value; }

        [NotMapped]
        public override long? VatSchemeId { get => base.VatSchemeId; set => base.VatSchemeId = value; }

        [NotMapped]
        public override long? VatSchemeChargesId { get => base.VatSchemeChargesId; set => base.VatSchemeChargesId = value; }

        [NotMapped]
        public override long? VatRateChargesId { get => base.VatRateChargesId; set => base.VatRateChargesId = value; }

        [NotMapped]
        public override long? SystemUnitPricesTypeId { get => base.SystemUnitPricesTypeId; set => base.SystemUnitPricesTypeId = value; }

        [NotMapped]
        public override string SystemUnitPricesTypeCode { get => base.SystemUnitPricesTypeCode; set => base.SystemUnitPricesTypeCode = value; }

        [NotMapped]
        public override string Station { get => base.Station; set => base.Station = value; }

        [NotMapped]
        public override string StateReason { get => base.StateReason; set => base.StateReason = value; }

        [NotMapped]
        public override string Signature { get => base.Signature; set => base.Signature = value; }

        [NotMapped]
        public override long? ShippingWayId { get => base.ShippingWayId; set => base.ShippingWayId = value; }

        [NotMapped]
        public override string Registry { get => base.Registry; set => base.Registry = value; }

        [NotMapped]
        public override long? ReceiverZipCodeId { get => base.ReceiverZipCodeId; set => base.ReceiverZipCodeId = value; }

        [NotMapped]
        public override string ReceiverName { get => base.ReceiverName; set => base.ReceiverName = value; }

        [NotMapped]
        public override long? ReceiverDistrictId { get => base.ReceiverDistrictId; set => base.ReceiverDistrictId = value; }

        [NotMapped]
        public override long? ReceiverCountyId { get => base.ReceiverCountyId; set => base.ReceiverCountyId = value; }

        [NotMapped]
        public override string ReceiverAddress { get => base.ReceiverAddress; set => base.ReceiverAddress = value; }

        [NotMapped]
        public override string ReasonForExemptionFromVat { get => base.ReasonForExemptionFromVat; set => base.ReasonForExemptionFromVat = value; }

        [NotMapped]
        public override string ReasonForExemptionFromCharges { get => base.ReasonForExemptionFromCharges; set => base.ReasonForExemptionFromCharges = value; }

        [NotMapped]
        public override int? PrivateKeyVersion { get => base.PrivateKeyVersion; set => base.PrivateKeyVersion = value; }

        [NotMapped]
        public override string PrintDownloadCounty { get => base.PrintDownloadCounty; set => base.PrintDownloadCounty = value; }

        [NotMapped]
        public override string PrintDownloadDistrict { get => base.PrintDownloadDistrict; set => base.PrintDownloadDistrict = value; }

        [NotMapped]
        public override string PrintFiscalSpaceCharges { get => base.PrintFiscalSpaceCharges; set => base.PrintFiscalSpaceCharges = value; }

        [NotMapped]
        public override string PrintFiscalZipCode { get => base.PrintFiscalZipCode; set => base.PrintFiscalZipCode = value; }

        [NotMapped]
        public override string PrintLoadCounty { get => base.PrintLoadCounty; set => base.PrintLoadCounty = value; }

        [NotMapped]
        public override string PrintLoadDistrict { get => base.PrintLoadDistrict; set => base.PrintLoadDistrict = value; }

        [NotMapped]
        public override string PrintLoadZipCode { get => base.PrintLoadZipCode; set => base.PrintLoadZipCode = value; }

        [NotMapped]
        public override double? PrintVatRateCharges { get => base.PrintVatRateCharges; set => base.PrintVatRateCharges = value; }

        [NotMapped]
        public override string PrintVatSchemeCharges { get => base.PrintVatSchemeCharges; set => base.PrintVatSchemeCharges = value; }

        [NotMapped]
        public override long? PaymentTypeId { get => base.PaymentTypeId; set => base.PaymentTypeId = value; }

        [NotMapped]
        public override long? NumberOfLines { get => base.NumberOfLines; set => base.NumberOfLines = value; }

        [NotMapped]
        public override string ManualDocumentSerie { get => base.ManualDocumentSerie; set => base.ManualDocumentSerie = value; }

        [NotMapped]
        public override TbCodigosPostais DowloadZipCode { get => base.DowloadZipCode; set => base.DowloadZipCode = value; }

        [NotMapped]
        public override Country DownloadCountry { get => base.DownloadCountry; set => base.DownloadCountry = value; }

        [NotMapped]
        public override long? DownloadCountryId { get => base.DownloadCountryId; set => base.DownloadCountryId = value; }

        [NotMapped]
        public override TbConcelhos DownloadCounty { get => base.DownloadCounty; set => base.DownloadCounty = value; }

        [NotMapped]
        public override long? DownloadCountyId { get => base.DownloadCountyId; set => base.DownloadCountyId = value; }

        [NotMapped]
        public override DateTime? DownloadDate { get => base.DownloadDate; set => base.DownloadDate = value; }

        [NotMapped]
        public override TbDistritos DownloadDistrict { get => base.DownloadDistrict; set => base.DownloadDistrict = value; }

        [NotMapped]
        public override long? DownloadDistrictId { get => base.DownloadDistrictId; set => base.DownloadDistrictId = value; }

        [NotMapped]
        public override string DownloadPlace { get => base.DownloadPlace; set => base.DownloadPlace = value; }

        [NotMapped]
        public override DateTime? DownloadTime { get => base.DownloadTime; set => base.DownloadTime = value; }

        [NotMapped]
        public override string DownloadZipCode { get => base.DownloadZipCode; set => base.DownloadZipCode = value; }

        [NotMapped]
        public override long? HeadStoreId { get => base.HeadStoreId; set => base.HeadStoreId = value; }

        [NotMapped]
        public override DateTime? InternalControlDate { get => base.InternalControlDate; set => base.InternalControlDate = value; }

        [NotMapped]
        public override long? InternalNumber { get => base.InternalNumber; set => base.InternalNumber = value; }

        [NotMapped]
        public override bool? IsReplenishmentDocument { get => base.IsReplenishmentDocument; set => base.IsReplenishmentDocument = value; }

        [NotMapped]
        public override double? LinesDiscounts { get => base.LinesDiscounts; set => base.LinesDiscounts = value; }

        [NotMapped]
        public override string LoadAddress { get => base.LoadAddress; set => base.LoadAddress = value; }

        [NotMapped]
        public override Country LoadCountry { get => base.LoadCountry; set => base.LoadCountry = value; }

        [NotMapped]
        public override long? LoadCountryId { get => base.LoadCountryId; set => base.LoadCountryId = value; }

        [NotMapped]
        public override TbConcelhos LoadCounty { get => base.LoadCounty; set => base.LoadCounty = value; }

        [NotMapped]
        public override long? LoadCountyId { get => base.LoadCountyId; set => base.LoadCountyId = value; }

        [NotMapped]
        public override DateTime? LoadDate { get => base.LoadDate; set => base.LoadDate = value; }

        [NotMapped]
        public override TbDistritos LoadDistrict { get => base.LoadDistrict; set => base.LoadDistrict = value; }

        [NotMapped]
        public override long? LoadDistrictId { get => base.LoadDistrictId; set => base.LoadDistrictId = value; }

        [NotMapped]
        public override string LoadPlace { get => base.LoadPlace; set => base.LoadPlace = value; }

        [NotMapped]
        public override DateTime? LoadTime { get => base.LoadTime; set => base.LoadTime = value; }

        [NotMapped]
        public override long? LoadZipCodeId { get => base.LoadZipCodeId; set => base.LoadZipCodeId = value; }

        [NotMapped]
        public override string LoadCountryAcronym { get => base.LoadCountryAcronym; set => base.LoadCountryAcronym = value; }

        [NotMapped]
        public override string ManualDocumentNumber { get => base.ManualDocumentNumber; set => base.ManualDocumentNumber = value; }

        [NotMapped]
        public override string ExternalDocumentNumber { get => base.ExternalDocumentNumber; set => base.ExternalDocumentNumber = value; }

        [NotMapped]
        public override long? FiscalSpaceChargesId { get => base.FiscalSpaceChargesId; set => base.FiscalSpaceChargesId = value; }

        [NotMapped]
        public override long? FiscalSpaceId { get => base.FiscalSpaceId; set => base.FiscalSpaceId = value; }

        [NotMapped]
        public override TbCodigosPostais LoadZipCode { get => base.LoadZipCode; set => base.LoadZipCode = value; }

        [NotMapped]
        public override TbSistemaRegimeIva VatScheme { get => base.VatScheme; set => base.VatScheme = value; }

        [NotMapped]
        public override Vat VatRateCharges { get => base.VatRateCharges; set => base.VatRateCharges = value; }

        [NotMapped]
        public override TbSistemaRegimeIva VatSchemeCharges { get => base.VatSchemeCharges; set => base.VatSchemeCharges = value; }

        [NotMapped]
        public override TbSistemaTiposDocumentoPrecoUnitario SystemUnitPricesType { get => base.SystemUnitPricesType; set => base.SystemUnitPricesType = value; }

        [NotMapped]
        public override TbConcelhos ReceiverCounty { get => base.ReceiverCounty; set => base.ReceiverCounty = value; }

        [NotMapped]
        public override TbDistritos ReceiverDistrict { get => base.ReceiverDistrict; set => base.ReceiverDistrict = value; }

        [NotMapped]
        public override TbCodigosPostais ReceiverZipCode { get => base.ReceiverZipCode; set => base.ReceiverZipCode = value; }

        [NotMapped]
        public override TbFormasExpedicao ShippingWay { get => base.ShippingWay; set => base.ShippingWay = value; }

        [NotMapped]
        public override TbCondicoesPagamento PaymentType { get => base.PaymentType; set => base.PaymentType = value; }

        [NotMapped]
        public override TbSistemaEspacoFiscal FiscalSpace { get => base.FiscalSpace; set => base.FiscalSpace = value; }

        [NotMapped]
        public override TbSistemaEspacoFiscal FiscalSpaceCharges { get => base.FiscalSpaceCharges; set => base.FiscalSpaceCharges = value; }
        #endregion
    }
}