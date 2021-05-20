using F3M.Middleware.Middleware.Authentication;
using Microsoft.AspNetCore.Builder;

namespace F3M.Middleware.Extensions
{
    public static class AuthenticationMiddlewareExtensions
    {
        public static IApplicationBuilder UseF3MAuthenticationMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<F3MAuthenticationMiddleware>();
        }
    }
}
