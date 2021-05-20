using F3M.Core.Components.WebApi.Extensions;
using F3M.Core.Domain.Validators;
using F3M.Middleware.Constants;
using F3M.Middleware.Data.Repository;
using F3M.Modelos.Constantes;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic;
using System;
using System.Net;
using System.Text.Json;
using System.Threading.Tasks;
using static F3M.Middleware.Constants.ApplicationConstants;

namespace F3M.Middleware.Middleware.Authentication
{
    public class F3MAuthenticationMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IDataProtectionProvider _provider;

        public F3MAuthenticationMiddleware(RequestDelegate next, IDataProtectionProvider provider)
        {   
            _next = next;
            _provider = provider;
        }

        public async Task<bool> Invoke(HttpContext context, IClsDadosAcesso clsDadosAcesso)
        {
            string cookieName = ConstAplicacao.F3MCookie.AuthCookieName;
            string cookieValue = context.Request.Cookies[cookieName];
            ObjectResult resObj;
            var serializeOptions = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };
            
            string message = "SEM_AUTENTICACAO";

            if (!string.IsNullOrEmpty(cookieValue))
            {
                var dataProtector = _provider.CreateProtector("Microsoft.AspNetCore.Authentication.Cookies." +
                    "CookieAuthenticationMiddleware", Microsoft.AspNet.Identity.DefaultAuthenticationTypes.ApplicationCookie, "v2");

                //Get the decrypted cookie as plain text
                System.Text.UTF8Encoding specialUtf8Encoding = new System.Text.UTF8Encoding(encoderShouldEmitUTF8Identifier: false, throwOnInvalidBytes: true);
                byte[] protectedBytes = Base64UrlTextEncoder.Decode(cookieValue);
                byte[] plainBytes = dataProtector.Unprotect(protectedBytes);
                string plainText = specialUtf8Encoding.GetString(plainBytes);

                //Get the decrypted cookie as a Authentication Ticket
                TicketDataFormat ticketDataFormat = new TicketDataFormat(dataProtector);
                AuthenticationTicket ticket = ticketDataFormat.Unprotect(cookieValue);

                if (IsAuthenticate(ticket))
                {
                    if (!CookieExpire(ticket))
                    {
                        using (AuthRepository rep = new AuthRepository(clsDadosAcesso))
                        {
                            string cookieCodClienteSAASValue = context.Request.Cookies[F3MCookie.F3MCodCliente];
                            cookieCodClienteSAASValue = cookieCodClienteSAASValue != "undefined" ? cookieCodClienteSAASValue : string.Empty;
                            string cookieF3MLangValue = context.Request.Cookies[F3MCookie.F3MLang];
                            cookieF3MLangValue = cookieF3MLangValue != "undefined" ? cookieF3MLangValue : string.Empty;
                            clsDadosAcesso.CodigoSAAS = cookieCodClienteSAASValue;
                            rep.PreencheDadosAcessoObj(ticket.Principal.Identity, cookieCodClienteSAASValue, cookieF3MLangValue);

                            //Validar se tem acesso ao menu - I
                            string controllerName = (string)context.Request.RouteValues["controller"];
                            string actionName = (string)context.Request.RouteValues["action"];
                            if (controllerName == "Header" && actionName == "GetMenu")
                            {
                                string idMenu = (string)context.Request.RouteValues["idMenu"];

                                RepositorioPerfisAcessos repAcessos = new RepositorioPerfisAcessos(clsDadosAcesso);
                                var result = await repAcessos.GetTemAcessoAsync(Int64.Parse(idMenu), clsDadosAcesso.IDPerfil);
                                bool temAcessoFuncionalidade = result.Consultar;

                                if (!temAcessoFuncionalidade)
                                {
                                    resObj = (ObjectResult)DomainResult.Failure("SEM_ACESSO_OPCAO", null, HttpStatusCode.Forbidden).ToActionResult();
                                    context.Response.Clear();
                                    context.Response.StatusCode = (int)HttpStatusCode.Forbidden;
                                    await context.Response.WriteAsync(JsonSerializer.Serialize(resObj.Value, serializeOptions));
                                    return false;
                                }

                            }

                            await _next.Invoke(context);
                            return true;
                        }
                    }
                    else
                    {
                        message = "COOKIE_EXPIROU";
                    }
                }
            }

            resObj = (ObjectResult)DomainResult.Failure(message, null, HttpStatusCode.Unauthorized).ToActionResult();
            context.Response.Clear();
            context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
            await context.Response.WriteAsync(JsonSerializer.Serialize(resObj.Value, serializeOptions));
            return false;
        }

        private bool IsAuthenticate(AuthenticationTicket ticket)
        {
            return ticket.Principal.Identity.IsAuthenticated;
        }

        private bool CookieExpire(AuthenticationTicket ticket)
        {
            var dtExpire = ticket.Properties.ExpiresUtc.Value.DateTime;
            return DateAndTime.DateDiff(DateInterval.Second, dtExpire, DateAndTime.Now) > 0;
        }
    }
}