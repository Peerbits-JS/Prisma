namespace F3M.Middleware.Constants
{
    public interface IClsDadosAcesso
    {
        long IDPerfil { get; set; }

        string CodigoSAAS { get; set; }

        string Linguagem { get; set; }

        #region EMPRESA
        string NomeEmpresa { get; set; }
        string CodigoEmpresa { get; set; }
        long IDEmpresa { get; set; }
        #endregion

        #region UTILIZADOR
        string EmailUtilizador { get; set; }
        string NomeUtilizador { get; set; }
        string CodigoUtilizador { get; set; }
        long IDUtilizador { get; set; }
        #endregion
    }
}
