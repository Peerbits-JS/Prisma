using F3M.Core.Domain.Entity;
using System;

namespace F3M.Oticas.Domain.Entities.Base
{
    public class DocumentPaymentTypeBase : EntityBase
    {
        public long PaymentTypeId { get; set; }
        public double? TotalCurrency { get; set; }
        public long? CurrencyId { get; set; }
        public double? ConversionRate { get; set; }
        public double? TotalReferenceCurrency { get; set; }
        public double? Value { get; set; }
        public double? ValueDelivered { get; set; }
        public double? Troco { get; set; }
        public string PaymentTypeCode { get; set; }
        public int? Order { get; set; }

        public TbFormasPagamento PaymentType { get; set; }
        public TbMoedas Currency { get; set; }

        public virtual DocumentBase GetDocumentBase() => throw new NotImplementedException();

        public virtual double GetPaymentTypeValue() => throw new NotImplementedException();
    }
}