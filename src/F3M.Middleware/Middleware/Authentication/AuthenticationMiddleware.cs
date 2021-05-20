using F3M.Middleware.Extensions;
using Microsoft.AspNetCore.Builder;

namespace F3M.Middleware.Middleware.Authentication
{
    public class AuthenticationMiddleware
    {
        public void Configure(IApplicationBuilder app)
        {
            app.UseF3MAuthenticationMiddleware();
        }
    }
}
