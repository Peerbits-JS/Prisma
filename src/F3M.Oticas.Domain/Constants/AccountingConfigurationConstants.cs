namespace F3M.Oticas.Domain.Constants
{
    public static class AccountingConfigurationConstants
    {
        public struct DefaultValues {
            public const string DocumentTypesAlternativeCode = "1";
            public const string DocumentTypesAlternativeDescription = "1";
        }

        public struct Value {
            public const long Vat = 1;
            public const long MerchandiseWithoutVat = 2;
            public const long MerchandiseWithVat = 3;
            public const long MerchandiseCost = 4;
            public const long MerchandisePurchaseCost = 5;
            public const long Discount = 6;
            public const long TotalDocument = 7;
            public const long TotalReimbursement = 8;
            public const long ReceiptValue = 9;
        }

        public struct Module
        {
            public const string Stock = "001";
            public const string CashAndBanks = "002";
            public const string Purchase = "003";
            public const string Sales = "004";
            public const string CurrentAccount = "006";
            public const string Entities = "008";
        }
    }
}