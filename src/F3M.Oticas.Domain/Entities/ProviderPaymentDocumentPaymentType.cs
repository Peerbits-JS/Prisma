using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;

namespace F3M.Oticas.Domain.Entities
{
    public partial class ProviderPaymentDocumentPaymentType : DocumentPaymentTypeBase
    {
        public long ProviderPaymentDocumentId { get; set; }

        public ProviderPaymentDocument ProviderPaymentDocument { get; set; }
        
        public override DocumentBase GetDocumentBase() => ProviderPaymentDocument;

        public override double GetPaymentTypeValue()
        {
            if (PaymentType.IdtipoFormaPagamentoNavigation.Codigo == PaymentTypeConstants.Cash) {
                return GetPaymentTypeValueCash();
            } 
            return Value ?? 0;
        }

        private double GetPaymentTypeValueCash() {
            double valueAux = Value ?? 0;
            double trocoAux = ProviderPaymentDocument.Troco ?? 0;
            double paymentTypeValue = valueAux - trocoAux;
            return paymentTypeValue < 0 ? 0 : paymentTypeValue;
        }
    }
}