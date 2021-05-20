using System.Configuration;

namespace F3M.Middleware.Constants
{
    public struct WebConfigKeys
    {
        public struct AppSettings
        {
            public static readonly string ProjetoCliente = ConfigurationManager.AppSettings["ProjetoCliente"];
            public static readonly string Projeto = ConfigurationManager.AppSettings["Projeto"];
            public static readonly string URLProjeto = ConfigurationManager.AppSettings["URLProjeto"];
            public static readonly bool ModoSAAS = !string.IsNullOrEmpty(ConfigurationManager.AppSettings["ModoSAAS"]) && System.Convert.ToBoolean(ConfigurationManager.AppSettings["ModoSAAS"]);
            public static readonly string ServidorSQL = !string.IsNullOrEmpty(ConfigurationManager.AppSettings["ServidorSQL"]) ? ConfigurationManager.AppSettings["ServidorSQL"] : "";
            public static readonly string InstanciaSQL = !string.IsNullOrEmpty(ConfigurationManager.AppSettings["InstanciaSQL"]) ? ConfigurationManager.AppSettings["InstanciaSQL"] : "";
            public static readonly string UtilizadorSQL = !string.IsNullOrEmpty(ConfigurationManager.AppSettings["UtilizadorSQL"]) ? ConfigurationManager.AppSettings["UtilizadorSQL"] : "";
            public static readonly string PasswordSQL = !string.IsNullOrEmpty(ConfigurationManager.AppSettings["PasswordSQL"]) ? ConfigurationManager.AppSettings["PasswordSQL"] : "";
            public static readonly string BDEmpresa = ConfigurationManager.AppSettings["BDEmpresa"];
            public static readonly string BDGeral = ConfigurationManager.AppSettings["BDGeral"];
            public static readonly bool EmDesenv = ConfigurationManager.AppSettings["EmDesenvolvimento"].Equals("true");
        }

        public struct ConnString
        {
            public static readonly string DefaultConnection = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }
    }
}
