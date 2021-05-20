using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.Domain.Enum;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public partial class PurchaseDocument : DocumentBase
    {
        public PurchaseDocument()
        {
            Attachments = new HashSet<TbDocumentosComprasAnexos>();
            Lines = new HashSet<PurchaseDocumentLine>();
            PendingPurchaseDocuments = new HashSet<TbDocumentosComprasPendentes>();
            PurchasePayments = new HashSet<ProviderPaymentDocumentLine>();
        }

        public double? AmmountPaid { get; set; }

        public long? StockDocumentId { get; set; }

        public long? IDTemp { get; set; }
        public EntryAction? AcaoTemp { get; set; }

        public TbFornecedores Entity { get; set; }

        public ICollection<TbDocumentosComprasAnexos> Attachments { get; set; }

        public ICollection<PurchaseDocumentLine> Lines { get; set; }

        public ICollection<TbDocumentosComprasPendentes> PendingPurchaseDocuments { get; set; }

        public ICollection<ProviderPaymentDocumentLine> PurchasePayments { get; set; }

        public override IEnumerable<DocumentLineBase> GetDocumentLineBase() => Lines.Select(line => line as DocumentLineBase);

        public override EntityDocumentBase GetDocumentBaseEntity() => Entity;
    }
}
