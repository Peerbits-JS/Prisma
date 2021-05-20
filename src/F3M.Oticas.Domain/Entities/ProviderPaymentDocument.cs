using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel.DataAnnotations.Schema;


namespace F3M.Oticas.Domain.Entities
{
    public partial class ProviderPaymentDocument : DocumentBase
    {
        public ProviderPaymentDocument()
        {
            TbPagamentosComprasAnexos = new HashSet<TbPagamentosComprasAnexos>();
            ProviderPaymentDocumentPaymentType = new HashSet<ProviderPaymentDocumentPaymentType>();
            Lines = new HashSet<ProviderPaymentDocumentLine>();
        }

        public double? TotalCurrency { get; set; }
        public double? ValorEntregue { get; set; }
        public double? Troco { get; set; }
        public double? ValorPago { get; set; }
        public string StoreZipCode { get; set; }
        public string StoreCounty { get; set; }
        public string StoreAcronym { get; set; }
        public string StoreTaxPayer { get; set; }
        public string StoreBusinessName { get; set; }
        public string StoreAddress { get; set; }
        public double? TotalAllDocuments { get; set; }
        public double? TotalAllDocumentsDiscount { get; set; }

        [NotMapped]
        public override long? HeadStoreId { get => base.HeadStoreId; set => base.HeadStoreId = value; }

        [NotMapped]
        public override bool? IsSatisfied { get => base.IsSatisfied; set => base.IsSatisfied = value; }

         [NotMapped]
        public override DateTime? DeliveryDate { get => base.DeliveryDate; set => base.DeliveryDate = value; }

        [NotMapped]
        public override string StateReason { get => base.StateReason; set => base.StateReason = value; }

        public TbFornecedores Entity { get; set; }

        public ICollection<TbPagamentosComprasAnexos> TbPagamentosComprasAnexos { get; set; }

        public ICollection<ProviderPaymentDocumentPaymentType> ProviderPaymentDocumentPaymentType { get; set; }

        public ICollection<ProviderPaymentDocumentLine> Lines { get; set; }

        public override EntityDocumentBase GetDocumentBaseEntity() => Entity;

        public override IEnumerable<DocumentLineBase> GetDocumentLineBase() => Lines.Select(line => line as DocumentLineBase);

        public override  IEnumerable<DocumentPaymentTypeBase> GetPaymentsTypes() => ProviderPaymentDocumentPaymentType;

        public override double GetTotalCurrencyDocument() => TotalAllDocuments ?? 0;
    }
}
