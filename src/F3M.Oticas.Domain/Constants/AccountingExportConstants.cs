namespace F3M.Oticas.Domain.Constants
{
    public struct AccountingExportConstants
    {
        public struct Generated {
            public const string All = "001";
            public const string True = "002";
            public const string False = "003";
        }

        public struct Exported
        {
            public const string All = "001";
            public const string True = "002";
            public const string False = "003";
        }

        public struct EntityTypes {
            public const string Customer = "001";
            public const string Provider = "002";
        }

        public struct ExportFormats
        {
            public const string PBSSV9 = "PBSSV9.00";
        }

        public struct ConfigurationType
        {
            public const long Iva = 1;
            public const long MercadoriaSemIva = 2;
            public const long MercadoriaComIva = 3;
            public const long CustoMercadoria = 4;
            public const long CustoMercadoriaCompras = 5;
            public const long Desconto = 6;
            public const long TotalDocumento = 7;
            public const long TotalComparticipacao = 8;
            public const long ValorRecebido = 9;
        }

        public struct Tokens
        {
            public const string Customers = "T";
            public const string Providers = "T";
            public const string Stores = "L";
            public const string Countries = "P";
            public const string Entities = "E";
            public const string ProductTypes = "G";
            public const string Products = "A";
            public const string DestinationWarehouse = "N";
            public const string OriginWarehouse = "M";
            public const string VatRates = "I";
            public const string PaymentType = "F";
        }
    }
}