namespace F3M.Middleware.Constants
{
    public struct ApplicationConstants
    {
        public const string NomeFicheiroLicencimento = "f3m.lic";
        
        public struct F3MCookie
        {
            public static string F3MCodCliente { get; set; } = string.Concat("F3M", WebConfigKeys.AppSettings.EmDesenv ? string.Empty : WebConfigKeys.AppSettings.ProjetoCliente, "CodCliente");
            public static string F3MLang { get; set; } = string.Concat("F3M", WebConfigKeys.AppSettings.EmDesenv ? string.Empty : WebConfigKeys.AppSettings.ProjetoCliente, "Lang");
            public static string AuthCookieName { get; set; } = string.Concat("F3M", WebConfigKeys.AppSettings.EmDesenv ? string.Empty : WebConfigKeys.AppSettings.ProjetoCliente, "Application");
            public static string SharedAuthCookieName { get; set; } = string.Concat("Shared", "F3M", WebConfigKeys.AppSettings.EmDesenv ? string.Empty : WebConfigKeys.AppSettings.ProjetoCliente, "Application");
        }
        
        const string KeysFolder = @"/Keys/";
        
        public const string NomePastaPrisma = "/src/Oticas";
        
        public static string PathKeysCli { get; set; } = NomePastaPrisma + KeysFolder;

        public const string ImagesFolder = @"/Images/Gerais/";
    }
}
