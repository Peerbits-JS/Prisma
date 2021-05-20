using F3M.Core.Domain.Entity;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Enum;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities.Base
{
    public class DocumentBase : EntityBase
    {
        public virtual long DocumentTypeId { get; set; }

        public virtual long? DocumentNumber { get; set; }

        public virtual DateTime DocumentDate { get; set; }

        public virtual string Notes { get; set; }

        public virtual long? CurrencyId { get; set; }

        public virtual double? ConversionRate { get; set; }

        public virtual double? TotalCurrencyDocument { get; set; }

        public virtual double? TotalReferenceCurrency { get; set; }

        public virtual string LoadPlace { get; set; }

        public virtual DateTime? LoadDate { get; set; }

        public virtual DateTime? LoadTime { get; set; }

        public virtual string LoadAddress { get; set; }

        public virtual long? LoadZipCodeId { get; set; }

        public virtual long? LoadCountyId { get; set; }

        public virtual long? LoadDistrictId { get; set; }

        public virtual string DownloadPlace { get; set; }

        public virtual DateTime? DownloadDate { get; set; }

        public virtual DateTime? DownloadTime { get; set; }

        public virtual string DownloadAdrress { get; set; }

        public virtual long? DownloadZipCodeId { get; set; }

        public virtual long? DownloadCountyId { get; set; }

        public virtual long? DownloadDistrictId { get; set; }

        public virtual string ReceiverName { get; set; }

        public virtual string ReceiverAddress { get; set; }

        public virtual long? ReceiverZipCodeId { get; set; }

        public virtual long? ReceiverCountyId { get; set; }

        public virtual long? ReceiverDistrictId { get; set; }

        public virtual string ManualDocumentNumber { get; set; }

        public virtual string ManualDocumentSerie { get; set; }

        public virtual long? NumberOfLines { get; set; }

        public virtual string Station { get; set; }

        public virtual long? StateId { get; set; }

        public virtual string StateUser { get; set; }

        public virtual DateTime? StateTime { get; set; }

        public virtual string Signature { get; set; }

        public virtual int? PrivateKeyVersion { get; set; }

        public virtual string FiscalName { get; set; }

        public virtual string FiscalAddress { get; set; }

        public virtual long? FiscalZipCodeId { get; set; }

        public virtual long? FiscalCountyId { get; set; }

        public virtual long? FiscalDistrictId { get; set; }

        public virtual string FiscalTaxPayer { get; set; }

        public virtual string CountryFiscalAcronym { get; set; }

        public virtual long? StoreId { get; set; }

        public virtual bool IsPrinted { get; set; }

        public virtual double? TaxValue { get; set; }

        public virtual  double? DiscountPercentage { get; set; }

        public virtual double? DiscountValue { get; set; }

        public virtual double? ChargesValue { get; set; }

        public virtual long? VatRateChargesId { get; set; }

        public virtual double? PrintVatRateCharges { get; set; }

        public virtual string ReasonForExemptionFromVat { get; set; }

        public virtual string ReasonForExemptionFromCharges { get; set; }

        public virtual long? FiscalSpaceChargesId { get; set; }

        public virtual string PrintFiscalSpaceCharges { get; set; }

        public virtual long? VatSchemeChargesId { get; set; }

        public virtual string PrintVatSchemeCharges { get; set; }

        public virtual double? AddicionalCosts { get; set; }

        public virtual long? ShippingWayId { get; set; }

        public virtual long DocumentTypeSeriesId { get; set; }

        public virtual long? InternalNumber { get; set; }

        public virtual long? EntityId { get; set; }

        public virtual long? EntityTypeId { get; set; }

        public virtual long? PaymentTypeId { get; set; }

        public virtual long? OperationCodeId { get; set; }

        public virtual string ATCode { get; set; }

        public virtual long? LoadCountryId { get; set; }

        public virtual long? DownloadCountryId { get; set; }

        public virtual string Registry { get; set; }

        public virtual long? FiscalCountryId { get; set; }

        public virtual string PrintFiscalZipCode { get; set; }

        public virtual string FiscalZipCodeDescription { get; set; }

        public virtual string FiscalCountyDescription { get; set; }

        public virtual string FiscalDistrictDescription { get; set; }

        public virtual long? FiscalSpaceId { get; set; }

        public virtual long? VatSchemeId { get; set; }

        public virtual string ATInternalCode { get; set; }

        public virtual string FiscalType { get; set; }

        public virtual string Document { get; set; }

        public virtual string TypeStateCode { get; set; }

        public virtual string DocumentOriginCode { get; set; }

        public virtual string PrintLoadDistrict { get; set; }

        public virtual string PrintLoadCounty { get; set; }

        public virtual string PrintLoadZipCode { get; set; }

        public virtual string LoadCountryAcronym { get; set; }

        public virtual string PrintDownloadDistrict { get; set; }

        public virtual string PrintDownloadCounty { get; set; }

        public virtual string DownloadZipCode { get; set; }

        public virtual string DownloadCountryAcronym { get; set; }

        public virtual string EntityCode { get; set; }

        public virtual string CurrencyCode { get; set; }

        public virtual string ATDocumentMessage { get; set; }

        public virtual long? SystemUnitPricesTypeId { get; set; }

        public virtual string SystemUnitPricesTypeCode { get; set; }

        public virtual bool? IsManualDocument { get; set; }

        public virtual bool? IsReplenishmentDocument { get; set; }

        public virtual DateTime? SignatureDate { get; set; }

        public virtual DateTime? InternalControlDate { get; set; }

        public virtual double? SubTotal { get; set; }

        public virtual double? LinesDiscounts { get; set; }

        public virtual double? VatTotal { get; set; }

        public virtual DateTime? DueDate { get; set; }

        public virtual string ExternalDocumentNumber { get; set; }
        
        public virtual bool? IsSecondDocumentPath { get; set; }

        public virtual DateTime? LastPrintDate { get; set; }

        public virtual int? NumberOfPrints { get; set; }

        public virtual long? StoreLastPrintId { get; set; }

        public virtual long? HeadStoreId { get; set; }

        public virtual bool? IsSatisfied { get; set; }

        public virtual DateTime? DeliveryDate { get; set; }
        
        public virtual string StateReason { get; set; }

        public virtual TbCodigosPostais LoadZipCode { get; set; }

        public virtual TbCodigosPostais DowloadZipCode { get; set; }

        public virtual TbCodigosPostais ReceiverZipCode { get; set; }

        public virtual TbCodigosPostais FiscalZipCode { get; set; }

        public virtual TbConcelhos LoadCounty { get; set; }

        public virtual TbConcelhos DownloadCounty { get; set; }

        public virtual TbConcelhos ReceiverCounty { get; set; }

        public virtual TbConcelhos FiscalCounty { get; set; }

        public virtual TbCondicoesPagamento PaymentType { get; set; }

        public virtual TbDistritos LoadDistrict { get; set; }

        public virtual TbDistritos DownloadDistrict { get; set; }

        public virtual TbDistritos ReceiverDistrict { get; set; }

        public virtual TbDistritos FiscalDistrict { get; set; }

        public virtual TbSistemaEspacoFiscal FiscalSpace { get; set; }

        public virtual TbSistemaEspacoFiscal FiscalSpaceCharges { get; set; }

        public virtual State State { get; set; }

        public virtual TbFormasExpedicao ShippingWay { get; set; }

        public TbSistemaRegioesIva OperationCode { get; set; }

        public virtual TbLojas Store { get; set; }

        public virtual TbMoedas Currency { get; set; }

        public virtual Country LoadCountry { get; set; }

        public virtual Country DownloadCountry { get; set; }

        public virtual Country FiscalCountry { get; set; }

        public virtual TbSistemaRegimeIva VatScheme { get; set; }

        public virtual TbSistemaRegimeIva VatSchemeCharges { get; set; }

        public virtual TbSistemaTiposDocumentoPrecoUnitario SystemUnitPricesType { get; set; }

        public virtual Vat VatRateCharges { get; set; }

        public virtual TbTiposDocumento DocumentType { get; set; }

        public virtual SystemEntityType EntityType { get; set; }

        public virtual TbTiposDocumentoSeries DocumentTypeSeries { get; set; }

        public virtual IEnumerable<DocumentLineBase> GetDocumentLineBase() => throw new NotImplementedException();

        public virtual EntityDocumentBase GetDocumentBaseEntity() => throw new NotImplementedException();

        public AccountingConfiguration GetAccountingConfiguration(List<AccountingConfiguration> configurations)
            => configurations.FirstOrDefault(configuration => configuration.IsPreset == true &&
                    configuration.Year == DocumentDate.Year.ToString() &&
                    configuration.ModuleCode == DocumentType.IdmoduloNavigation.Codigo &&
                    configuration.TypeCode == DocumentType.Codigo);

        public virtual double GetTotalCurrencyDocument() => TotalCurrencyDocument ?? 0;

        public virtual double GetTotalEntityOne() => 0;

        public virtual TbEntidades GetEntityOne() => throw new NotImplementedException();

        public virtual IEnumerable<DocumentPaymentTypeBase> GetPaymentsTypes() => null;

        public bool IsEffective() => State.SystemStateType.Code == StateTypeConstants.Effective;

        public bool IsDraft() => State.SystemEntityState.Code == StateTypeConstants.Draft;

        public bool IsAborted() => State.SystemEntityState.Code == StateTypeConstants.Aborted;

        public DocumentBase GetDocumentBase() => this;
    }
}