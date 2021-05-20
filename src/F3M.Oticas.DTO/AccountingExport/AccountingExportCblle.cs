using F3M.Oticas.DTO.Attributes;
using System;
using System.Globalization;

namespace F3M.Oticas.DTO
{
    public class AccountingExportCblle
    {
        public AccountingExportCblle(AccountingExportFile accountingExport)
        {
            ReflectsVATClasses = accountingExport.ReflectsVATClasses ? 'S' : 'N';
            ReflectsAnalytics = accountingExport.ReflectsAnalytics ? 'S' : 'N';
            ReflectsCostCenters = accountingExport.ReflectsCostCenters ? 'S' : 'N';
            LineType = (char)accountingExport.LineType;
            Module = (char)accountingExport.Module;
            Date = accountingExport.Date?.ToString("ddMM");
            AccountToMove = accountingExport.AccountToMove;
            Daily = accountingExport.Daily;
            DailyNumber = accountingExport.DailyNumber;
            Document = accountingExport.Document;
            DocumentNumber = accountingExport.DocumentNumber;
            Description = accountingExport.Description;
            SourceValue = accountingExport.SourceValue.Value.ToString("#.00").Replace(",", ".");
            Nature = (char)accountingExport.Nature;
            Entity = accountingExport.Entity;
            EntityType = (char?)accountingExport.EntityType;
            VatClass = accountingExport.VatClass;
            SourceAccount = accountingExport.SourceAccount;
            Batch = accountingExport.Batch;
            ClassSeal = accountingExport.ClassSeal;
            SealQuantity = accountingExport.SealQuantity;
            ReflectsStampClasses = accountingExport.ReflectsStampClasses.HasValue ? (accountingExport.ReflectsStampClasses.Value ? 'S' : 'N') : (char?)null;
            Third = accountingExport.Third;
            ThirdType = (char?)accountingExport.ThirdType;
            MonthCollection = accountingExport.MonthCollection?.ToString("MM");
            IntraCommunityTransactionsOperationType = (int?)accountingExport.IntraCommunityTransactionsOperationType;
            Year = accountingExport.Year;
            CurrencyOrigin = accountingExport.CurrencyOrigin;
            CurrencyExchangeOrigin = accountingExport.CurrencyExchangeOrigin;
            BaseCurrency = accountingExport.BaseCurrency;
            AlternativeExchange = accountingExport.AlternativeExchange;
            AffectionType = (int?)accountingExport.AffectionType;
            ReflectsFlows = accountingExport.ReflectsFlows.HasValue ? (accountingExport.ReflectsFlows.Value ? 'S' : 'N') : (char?)null;
            VatClassSelfAssessment = (char?)accountingExport.VatClassSelfAssessment;
            NonDeductiblePercentage = accountingExport.NonDeductiblePercentage;
            ReleaseType = accountingExport.ReleaseType;
            DocumentDate = accountingExport.DocumentDate?.ToString("ddMMyyyy");
            ExternalDocumentNumber = accountingExport.ExternalDocumentNumber;
            Observations = accountingExport.Observations;
            TreasuryItem = accountingExport.TreasuryItem;
            ReflecteCOPE = accountingExport.ReflecteCOPE.HasValue ? (accountingExport.ReflecteCOPE.Value ? 'S' : 'N') : (char?)null;
            ReflectsFunctionalPlan = accountingExport.ReflectsFunctionalPlan.HasValue ? (accountingExport.ReflectsFunctionalPlan.Value ? 'S' : 'N') : (char?)null;
            COPEStatisticalClassification = accountingExport.COPEStatisticalClassification;
            COPEAccountType = (char?)accountingExport.COPEAccountType;
            COPECountryEntityCounterparty = accountingExport.COPECountryEntityCounterparty;
            COPECountryFinancialInstitution = accountingExport.COPECountryFinancialInstitution;
            COPENPCSecondIntervener = accountingExport.COPENPCSecondIntervener;
            COPEAssetEntity = accountingExport.COPEAssetEntity;
            COPEAmount = accountingExport.COPEAmount;
            LineDesignCode = accountingExport.LineDesignCode;
            LinePEPElement = accountingExport.LinePEPElement;
            DocumentSeries = accountingExport.DocumentSeries;
            PendingDocumentDescription = accountingExport.PendingDocumentDescription;
            PendingDocumentBranch = accountingExport.PendingDocumentBranch;
            PendingDocumentDeliveryNumber = accountingExport.PendingDocumentDeliveryNumber;
            PendingDocumentValue = accountingExport.PendingDocumentValue;
            PendingAmountDocumentBaseCurrency = accountingExport.PendingAmountDocumentBaseCurrency;
            PendingAmountDocumentAlternativeCurrency = accountingExport.PendingAmountDocumentAlternativeCurrency;
            PendingDocumentCurrency = accountingExport.PendingDocumentCurrency;
            PendingDocumentModule = accountingExport.PendingDocumentModule;
            OperationDate = accountingExport.OperationDate?.ToString("ddMMyyyy");
            ShippingDate = accountingExport.ShippingDate?.ToString("ddMMyyyy");
            ReceiptDate = accountingExport.ReceiptDate?.ToString("ddMMyyyy");
            NIF = accountingExport.NIF;
            FiscalDesignation = accountingExport.FiscalDesignation;
            Country = accountingExport.Country;
            RectifiedDocument = accountingExport.RectifiedDocument;
            VatRate = accountingExport.VatRate;
            PaymentType = accountingExport.PaymentType;
            IncidenceBasis = accountingExport.IncidenceBasis;
            VATNotDeductible = accountingExport.VATNotDeductible;
            OperationType = accountingExport.OperationType;
            EntityNIF = accountingExport.EntityNIF;
            EntityFiscalName = accountingExport.EntityFiscalName;
            EntityCountry = accountingExport.EntityCountry;
            ThirdNIF = accountingExport.ThirdNIF;
            ThirdFiscalName = accountingExport.ThirdFiscalName;
            ThirdCountry = accountingExport.ThirdCountry;
            CollectionType = (int?)accountingExport.CollectionType;
            SourceDocument = accountingExport.SourceDocument;
        }

        [FixedTextFile(1, 1)]
        public char ReflectsVATClasses { get; set; }

        [FixedTextFile(2, 1)]
        public char ReflectsAnalytics { get; set; }

        [FixedTextFile(3, 1)]
        public char ReflectsCostCenters { get; set; }

        [FixedTextFile(4, 1)]
        public char LineType { get; set; }

        [FixedTextFile(5, 1)]
        public char Module { get; set; }

        [FixedTextFile(6, 4)]
        public string Date { get; set; }

        [FixedTextFile(10, 20)]
        public string AccountToMove { get; set; }

        [FixedTextFile(30, 5)]
        public string Daily { get; set; }

        [FixedTextFile(35, 10)]
        public string DailyNumber { get; set; }

        [FixedTextFile(45, 5)]
        public string Document { get; set; }

        [FixedTextFile(50, 10)]
        public string DocumentNumber { get; set; }

        [FixedTextFile(60, 50)]
        public string Description { get; set; }

        [FixedTextFile(110, 18)]
        public string SourceValue { get; set; }

        [FixedTextFile(128, 1)]
        public char Nature { get; set; }

        [FixedTextFile(129, 12)]
        public string Entity { get; set; }

        [FixedTextFile(141, 1)]
        public char? EntityType { get; set; }

        [FixedTextFile(142, 10)]
        public string VatClass { get; set; }

        [FixedTextFile(152, 20)]
        public string SourceAccount { get; set; }

        [FixedTextFile(172, 5)]
        public int? Batch { get; set; }

        [FixedTextFile(177, 15)]
        public string ClassSeal { get; set; }

        [FixedTextFile(192, 9)]
        public long? SealQuantity { get; set; }

        [FixedTextFile(201, 1)]
        public char? ReflectsStampClasses { get; set; }

        [FixedTextFile(202, 1)]
        public char? ReflectsFunctionalPlan { get; set; }

        [FixedTextFile(203, 15)]
        public string Third { get; set; }

        [FixedTextFile(218, 1)]
        public char? ThirdType { get; set; }

        [FixedTextFile(219, 2)]
        public string MonthCollection { get; set; }

        [FixedTextFile(221, 1)]
        public int? IntraCommunityTransactionsOperationType { get; set; }

        [FixedTextFile(222, 4)]
        public string Year { get; set; }

        [FixedTextFile(226, 3)]
        public string CurrencyOrigin { get; set; }

        [FixedTextFile(229, 18)]
        public string CurrencyExchangeOrigin { get; set; }

        [FixedTextFile(247, 18)]
        public string BaseCurrency { get; set; }

        [FixedTextFile(265, 18)]
        public string AlternativeExchange { get; set; }

        [FixedTextFile(283, 1)]
        public int? AffectionType { get; set; }

        [FixedTextFile(284, 1)]
        public char? ReflectsFlows { get; set; }

        [FixedTextFile(285, 10)]
        public char? VatClassSelfAssessment { get; set; }

        [FixedTextFile(295, 7)]
        public decimal? NonDeductiblePercentage { get; set; }

        [FixedTextFile(302, 3)]
        public string ReleaseType { get; set; }

        [FixedTextFile(305, 8)]
        public string DocumentDate { get; set; }

        [FixedTextFile(313, 20)]
        public string ExternalDocumentNumber { get; set; }

        [FixedTextFile(333, 50)]
        public string Observations { get; set; }

        [FixedTextFile(383, 35)]
        public string TreasuryItem { get; set; }

        [FixedTextFile(418, 1)]
        public char? ReflecteCOPE { get; set; }

        [FixedTextFile(419, 5)]
        public string COPEStatisticalClassification { get; set; }

        [FixedTextFile(424, 1)]
        public char? COPEAccountType { get; set; }

        [FixedTextFile(425, 5)]
        public string COPEAccountBank { get; set; }

        [FixedTextFile(430, 2)]
        public string COPECountryEntityCounterparty { get; set; }

        [FixedTextFile(432, 2)]
        public string COPECountryFinancialInstitution { get; set; }

        [FixedTextFile(434, 20)]
        public string COPENPCSecondIntervener { get; set; }

        [FixedTextFile(454, 15)]
        public string COPEAssetEntity { get; set; }

        [FixedTextFile(469, 18)]
        public string COPEAmount { get; set; }

        [FixedTextFile(487, 40)]
        public string LineDesignCode { get; set; }

        [FixedTextFile(527, 100)]
        public string LinePEPElement { get; set; }

        [FixedTextFile(627, 5)]
        public string DocumentSeries { get; set; }

        [FixedTextFile(632, 30)]
        public string PendingDocumentDescription { get; set; }

        [FixedTextFile(662, 3)]
        public string PendingDocumentBranch { get; set; }

        [FixedTextFile(665, 5)]
        public string PendingDocumentDeliveryNumber { get; set; }

        [FixedTextFile(670, 18)]
        public string PendingDocumentValue { get; set; }

        [FixedTextFile(688, 18)]
        public string PendingAmountDocumentBaseCurrency { get; set; }

        [FixedTextFile(706, 18)]
        public string PendingAmountDocumentAlternativeCurrency { get; set; }

        [FixedTextFile(724, 3)]
        public string PendingDocumentCurrency { get; set; }

        [FixedTextFile(727, 1)]
        public string PendingDocumentModule { get; set; }

        [FixedTextFile(728, 8)]
        public string OperationDate { get; set; }

        [FixedTextFile(736, 8)]
        public string ShippingDate { get; set; }

        [FixedTextFile(744, 8)]
        public string ReceiptDate { get; set; }

        [FixedTextFile(752, 20)]
        public string NIF { get; set; }

        [FixedTextFile(772, 50)]
        public string FiscalDesignation { get; set; }

        [FixedTextFile(822, 2)]
        public string Country { get; set; }

        [FixedTextFile(824, 60)]
        public string RectifiedDocument { get; set; }

        [FixedTextFile(884, 6)]
        public string VatRate { get; set; }

        [FixedTextFile(890, 5)]
        public string PaymentType { get; set; }

        [FixedTextFile(895, 11)]
        public string IncidenceBasis { get; set; }

        [FixedTextFile(906, 11)]
        public string VATNotDeductible { get; set; }

        [FixedTextFile(917, 2)]
        public string OperationType { get; set; }

        [FixedTextFile(919, 20)]
        public string EntityNIF { get; set; }

        [FixedTextFile(939, 50)]
        public string EntityFiscalName { get; set; }

        [FixedTextFile(989, 2)]
        public string EntityCountry { get; set; }

        [FixedTextFile(991, 20)]
        public string ThirdNIF { get; set; }

        [FixedTextFile(1011, 50)]
        public string ThirdFiscalName { get; set; }

        [FixedTextFile(1061, 2)]
        public string ThirdCountry { get; set; }

        [FixedTextFile(1063, 1)]
        public int? CollectionType { get; set; }

        [FixedTextFile(1064, 16)]
        public string SourceDocument { get; set; }
    }
}
