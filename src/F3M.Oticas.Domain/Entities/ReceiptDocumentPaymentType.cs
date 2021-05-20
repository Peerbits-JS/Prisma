using F3M.Oticas.Domain.Entities.Base;

namespace F3M.Oticas.Domain.Entities
{
    public partial class ReceiptDocumentPaymentType : DocumentPaymentTypeBase
    {
        public long ReceiptId { get; set; }

        public ReceiptDocument ReceiptDocument { get; set; }

        public override DocumentBase GetDocumentBase() => ReceiptDocument;

        public override double GetPaymentTypeValue() => Value ?? 0;
    }
}