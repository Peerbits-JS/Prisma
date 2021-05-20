using F3M.Middleware.Constants;
using F3M.Modelos.Utilitarios;

namespace F3M.Middleware.Data.Utils
{
    public class DatabaseUtils
    {
        private readonly IClsDadosAcesso _clsDadosAcesso;

        public DatabaseUtils(IClsDadosAcesso clsDadosAcesso)
        {
            _clsDadosAcesso = clsDadosAcesso;
        }


        public string GetConexaoBD(bool inBDGeral, bool inBDLog = false)
        {
            string conexao;


            string servidor = WebConfigKeys.AppSettings.ServidorSQL;
            string instancia = WebConfigKeys.AppSettings.InstanciaSQL;
            string dataSourceBD = servidor + (servidor != "" && instancia != "" ? @"\" : "") + instancia;

            string clientesaas = _clsDadosAcesso.CodigoSAAS;
            string inCodEmp = _clsDadosAcesso.CodigoEmpresa;

            string codEmp = inBDGeral || inCodEmp == "1" ? "" : inCodEmp;
            string nomeBDEmpresa = inBDGeral && !inBDLog ? WebConfigKeys.AppSettings.BDGeral : WebConfigKeys.AppSettings.BDEmpresa;
            string nomeBD = string.Concat(WebConfigKeys.AppSettings.ModoSAAS ? clientesaas : "", inBDLog ? "F3MLog" : "", nomeBDEmpresa, codEmp);

            string passwordLogin = !string.IsNullOrEmpty(WebConfigKeys.AppSettings.PasswordSQL) ? ClsEncriptacao.Desencriptar(WebConfigKeys.AppSettings.PasswordSQL) : "";

            conexao = WebConfigKeys.ConnString.DefaultConnection.Replace("{0}", dataSourceBD).Replace("{1}", nomeBD).Replace("{2}", WebConfigKeys.AppSettings.UtilizadorSQL).Replace("{3}", passwordLogin);


            return conexao;
        }
    }
}
