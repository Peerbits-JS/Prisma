namespace F3M.Middleware.Constants
{
    public class ClsDadosAcesso : IClsDadosAcesso
    {
        public ClsDadosAcesso()
        {

        }

        public long IDPerfil { get; set; }

        public string CodigoSAAS { get; set; }

        public  string Linguagem { get; set; }

        #region EMPRESA
        public string NomeEmpresa { get; set; }
        public  string CodigoEmpresa { get; set; }
        public  long IDEmpresa { get; set; }
        #endregion

        #region UTILIZADOR
        public  string EmailUtilizador { get; set; }
        public  string NomeUtilizador { get; set; }
        public  string CodigoUtilizador { get; set; }
        public  long IDUtilizador { get; set; }
        #endregion


    }
}
