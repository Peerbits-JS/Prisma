using F3M.Oticas.Domain.Constants;
using F3M.Oticas.Domain.Entities.Base;
using F3M.Oticas.Domain.Enum;
using System;
using System.Collections.Generic;
using System.Linq;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SaleDocument : DocumentBase
    {
        public SaleDocument()
        {
            Attachments = new HashSet<TbDocumentosVendasAnexos>();
            PaymentsTypes = new HashSet<SaleDocumentPaymentType>();
            Lines = new HashSet<SaleDocumentLine>();
            PendingSalesDocuments = new HashSet<TbDocumentosVendasPendentes>();
            SalesPayments = new HashSet<TbPagamentosVendasLinhas>();
            Receipts = new HashSet<ReceiptDocumentLine>();
            Services = new HashSet<TbServicos>();
        }

        public long? IdCustomer { get; set; }

        public DateTime? BirthdayDate { get; set; }

        public int? Age { get; set; }

        public long? IdEntityOne { get; set; }

        public string NumberOfbeneficiaryOne { get; set; }

        public string KinshipOne { get; set; }

        public long? IdEntityTwo { get; set; }

        public string NumberOfbeneficiaryTwo { get; set; }

        public string KinshipTwo { get; set; }

        public string Mail { get; set; }

        public double? OtherDiscounts { get; set; }

        public double? TotalOfPoints { get; set; }

        public double? TotalOfGiftVouchers { get; set; }

        public double? TotalEntityOne { get; set; }

        public double? TotalEntityTwo { get; set; }

        public bool? IsAutomaticEntityOne { get; set; }

        public double? AmmountPaid { get; set; }

        public bool? IsOriginEntityTwo { get; set; }

        public string ManualSerie { get; set; }

        public string ManualNumber { get; set; }

        public bool? IsDownPayment { get; set; }

        public double? TotalCustomerDocumentCurrency { get; set; }

        public double? TotalCustomerDocumentReferenceCurrency { get; set; }

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
        public long? IDTemp { get; set; }
        public EntryAction? AcaoTemp { get; set; }

        public TbClientes Entity { get; set; }

        public TbEntidades EntityOne { get; set; }

        public TbEntidades EntityTwo { get; set; }

        public ICollection<TbDocumentosVendasAnexos> Attachments { get; set; }

        public ICollection<SaleDocumentPaymentType> PaymentsTypes { get; set; }

        public ICollection<SaleDocumentLine> Lines { get; set; }

        public ICollection<TbDocumentosVendasPendentes> PendingSalesDocuments { get; set; }

        public ICollection<TbPagamentosVendasLinhas> SalesPayments { get; set; }

        public ICollection<ReceiptDocumentLine> Receipts { get; set; }

        public ICollection<TbServicos> Services { get; set; }

        public override IEnumerable<DocumentLineBase> GetDocumentLineBase() => Lines.Select(line => line as DocumentLineBase);

        public override EntityDocumentBase GetDocumentBaseEntity() => Entity;

        public override TbEntidades GetEntityOne() => EntityOne;

        public override double GetTotalEntityOne() => TotalEntityOne ?? 0;

        public override IEnumerable<DocumentPaymentTypeBase> GetPaymentsTypes() => PaymentsTypes;
    }
}