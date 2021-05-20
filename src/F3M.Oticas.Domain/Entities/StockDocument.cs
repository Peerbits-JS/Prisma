using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.Domain.Enum;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public partial class StockDocument : DocumentBase
    {
        public StockDocument()
        {
            PurchaseDocuments = new HashSet<PurchaseDocument>();
            Attachments = new HashSet<TbDocumentosStockAnexos>();
            Lines = new HashSet<StockDocumentLine>();
        }

        public TbClientes Entity { get; set; }

        public ICollection<PurchaseDocument> PurchaseDocuments { get; set; }

        public ICollection<TbDocumentosStockAnexos> Attachments { get; set; }

        public ICollection<StockDocumentLine> Lines { get; set; }

        public override IEnumerable<DocumentLineBase> GetDocumentLineBase() => Lines.Select(line => line as DocumentLineBase);

        public override EntityDocumentBase GetDocumentBaseEntity() => Entity;
    }
}