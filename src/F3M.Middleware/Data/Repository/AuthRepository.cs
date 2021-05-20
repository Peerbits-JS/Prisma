using F3M.Middleware.Constants;
using F3M.Middleware.Data.ApplicationDbContext;
using F3M.Middleware.Data.Entities;
using Microsoft.AspNet.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Security.Principal;

namespace F3M.Middleware.Data.Repository
{
    public class AuthRepository : IDisposable
    {
        public ApplicationDbContextCore BDContexto { get; set; }
        private readonly IClsDadosAcesso _clsDadosAcesso;

        public AuthRepository(IClsDadosAcesso clsDadosAcesso)
        {
            BDContexto = new ApplicationDbContextCore(clsDadosAcesso);
            _clsDadosAcesso = clsDadosAcesso;
        }

        public void PreencheDadosAcessoObj(IIdentity inCurrentUser, string CodigoClienteSAAS, string F3MLang)
        {
            string userID = inCurrentUser.GetUserId();
            var aspnetUser = BDContexto.AspNetUsers
                .Where(anu => anu.Id == userID)
                .Include(anu => anu.IdutilizadorNavigation)
                .ThenInclude(uti => uti.IdultimaEmpresaAbertaNavigation)
                .ThenInclude(uti => uti.TbUtilizadoresEmpresa)
                .ThenInclude(utiEmp => utiEmp.IdempresaNavigation)
                .FirstOrDefault();

            if (aspnetUser != null)
            {
                TbUtilizadores utilizador = aspnetUser.IdutilizadorNavigation;
                if (utilizador != null)
                {
                    long? ultEmpresa = utilizador.IdultimaEmpresaAberta ?? 0;
                    long empresaID = 0;
                    string empresaNome = string.Empty;
                    string empresaCodigo = string.Empty;
                    long perfilID = 0;

                    // Verifica ultima Empresa Aberta
                    if (ultEmpresa != 0)
                    {
                        // A empresa aberta pode ter sido retirada da associação ao utilizador, e neste caso não vamos ter empresa para carregar
                        // Como tal vamos chegar ao fim deste método com empresaID = 0, e o utilizador só consegue trabalhar se fizer terminar sessão e entrar outra vez 
                        int numUtilEmp = utilizador.TbUtilizadoresEmpresa.Where(f => f.Idempresa == empresaID).Count();
                        if (numUtilEmp == 0)
                            empresaID = 0;
                        else
                            empresaID = (long)utilizador.IdultimaEmpresaAberta;
                    }

                    if (empresaID == 0)
                    {
                        // 1ª empresa da Lista de Empresas do utilizador
                        TbUtilizadoresEmpresa utiEmpresa = utilizador.TbUtilizadoresEmpresa.OrderByDescending(o => o.Id).FirstOrDefault();
                        if (utiEmpresa != null)
                        {
                            empresaID = utiEmpresa.Idempresa ?? 0;
                        }
                    }

                    // Caso tenha Empresa busca Perfil
                    TbEmpresas empresa = null;
                    if (empresaID != 0)
                        empresa = utilizador.TbUtilizadoresEmpresa
                            .Where(f => f.Idempresa == empresaID)
                            .Select(f => f.IdempresaNavigation).FirstOrDefault();


                    // Define Empresa
                    if (empresa != null)
                    {
                        empresaID = empresa.Id;
                        empresaNome = empresa.Nome;
                        empresaCodigo = empresa.Codigo;

                        long? IDperfil = utilizador.TbUtilizadoresEmpresa.Where(ue => ue.Idempresa == empresaID).FirstOrDefault().Idperfil;
                        perfilID = (long)(IDperfil == null ? 0 : IDperfil);
                    }
                    else
                        empresaID = 0;

                    _clsDadosAcesso.IDUtilizador = utilizador.Id;
                    _clsDadosAcesso.CodigoUtilizador = aspnetUser.UserName;
                    _clsDadosAcesso.NomeUtilizador = utilizador.Nome;
                    _clsDadosAcesso.EmailUtilizador = aspnetUser.Email;
                    _clsDadosAcesso.IDEmpresa = empresaID;
                    _clsDadosAcesso.NomeEmpresa = empresaNome;
                    _clsDadosAcesso.CodigoEmpresa = empresaCodigo;
                    _clsDadosAcesso.IDPerfil = perfilID;
                    _clsDadosAcesso.CodigoSAAS = CodigoClienteSAAS;
                    _clsDadosAcesso.Linguagem = F3MLang;
                }
            }
        }


        public void Dispose()
        {
            //Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}