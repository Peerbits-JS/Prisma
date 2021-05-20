using F3M.Core.Domain.Entity;
using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SaleDocumentPaymentType : DocumentPaymentTypeBase
    {
        public long SaleDocumentId { get; set; }
        public long? StoreId { get; set; }

        public SaleDocument SalesDocument { get; set; }
        public TbLojas Store { get; set; }
        public override DocumentBase GetDocumentBase() => SalesDocument;

        public override double GetPaymentTypeValue()
        {
            if (PaymentType.IdtipoFormaPagamentoNavigation.Codigo == PaymentTypeConstants.Cash)
            {
                return GetPaymentTypeValueCash();
            }
            return Value ?? 0;
        }

        private double GetPaymentTypeValueCash()
        {
            double valueAux = Value ?? 0;
            double trocoAux = Troco ?? 0;
            double paymentTypeValue = valueAux - trocoAux;
            return paymentTypeValue < 0 ? 0 : paymentTypeValue;
        }
    }
}