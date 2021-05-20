using F3M.Core.Domain.Entity;
using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace F3M.Oticas.Domain.Entities
{
    public partial class ProviderPaymentDocumentLine : DocumentLineBase
    {
        public long ProviderPaymentDocumentId { get; set; }
        public long DocumentTypeId { get; set; }
        public long DocumentTypeSeriesId { get; set; }
        public long PurchaseDocumentId { get; set; }
        public long EntityId { get; set; }
        public long? EntityTypeId { get; set; }
        public string EntityName { get; set; }
        public long? SystemNatureId { get; set; }
        public long? DocumentNumber { get; set; }
        public DateTime DocumentDate { get; set; }
        public DateTime DueDate { get; set; }
        public string Document { get; set; }
        public double? TotalCurrencyDocument { get; set; }
        public double? PendingAmount { get; set; }
        public double? DiscountPercentage { get; set; }
        public double? DiscountValue { get; set; }
        public double? TotalCurrency { get; set; }
        public long? CurrencyId { get; set; }
        public double? ConversionRate { get; set; }
        public double? TotalReferenceCurrency { get; set; }
        public double? PaidAmount { get; set; }
        public int? Order { get; set; }
        public long? StoreId { get; set; }

        public PurchaseDocument PurchaseDocument { get; set; }
        public TbFornecedores Entity { get; set; }
        public TbLojas Store { get; set; }
        public TbMoedas Currency { get; set; }
        public ProviderPaymentDocument ProviderPaymentDocument { get; set; }
        public TbSistemaNaturezas IdsistemaNaturezasNavigation { get; set; }
        public TbTiposDocumento DocumentType { get; set; }
        public TbTiposDocumentoSeries DocumentTypeSeries { get; set; }

        public override DocumentBase GetDocumentBase() => ProviderPaymentDocument;

        public override double GetDiscount() => DiscountValue ?? 0;
    }
}
