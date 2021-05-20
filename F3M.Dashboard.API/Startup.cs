using F3M.Dashboard.API.Data.Context;
using F3M.Dashboard.API.Data.UnitOfWork;
using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Services;
using F3M.Dashboard.API.Services.Interfaces;
using F3M.Middleware.Constants;
using F3M.Middleware.Middleware.Authentication;
using F3M.Middleware.Middleware.Errors;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using System.IO;

namespace F3M.Dashboard.API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddAuthentication();
            services.AddScoped<IClsDadosAcesso, ClsDadosAcesso>();




            var cs = "Data Source=prisma-lab-vm.westeurope.cloudapp.azure.com,1433;Initial Catalog=10000F3MO;user id=F3MO;Password=;Integrated Security=True;Trusted_Connection=false;";
            services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(cs));


            //services.AddDbContext<ApplicationDbContext>();

            var cs_geral = "Data Source=prisma-lab-vm.westeurope.cloudapp.azure.com,1433;Initial Catalog=10000F3MOGeral;user id=F3MO;Password=;Integrated Security=True;Trusted_Connection=false;";
            services.AddDbContext<ApplicationDbContextCore>(options => options.UseSqlServer(cs_geral));

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();

            //ClsPaths.ContentRootPathPIU = Directory.GetCurrentDirectory();
            //ClsPaths.ContentRootPathEsocial = ClsPaths.ContentRootPathPIU.Substring(0, ClsPaths.ContentRootPathPIU.LastIndexOf("\\"));
            //ClsPaths.ContentRootPath = ClsPaths.ContentRootPathEsocial.Substring(0, ClsPaths.ContentRootPathEsocial.LastIndexOf("\\"));
            //
            //services.AddDataProtection()
            //    .PersistKeysToFileSystem(new System.IO.DirectoryInfo(ClsPaths.ContentRootPathEsocial + ApplicationConstants.PathKeysCli))
            //    .SetApplicationName(ApplicationConstants.F3MCookie.SharedAuthCookieName);


            //For CORS            
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader());
            });
            //For CORS

            services.AddControllers();

            /* COM AUTENTICAÇÂO*/
            //services.AddControllers(options =>
            //{
            ////    services.AddScoped<IClsDadosAcesso, ClsDadosAcesso>();
            //    //Aplica o Middleware de autenticação a todos os controllers
            //    options.Filters.Add(new MiddlewareFilterAttribute(typeof(AuthenticationMiddleware)));
            //    options.Filters.Add(typeof(ExceptionFilter));
            //});

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "F3M.Dashboard.API", Version = "v1" });
            });


            services.AddScoped<IBillingSummaryService, BillingSummaryService>();
            services.AddScoped<IPerformanceSummaryService, PerformanceSummaryService>();
            services.AddScoped<ISalesSummaryService, SalesSummaryService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IShopService, ShopService>();
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<IUnitOfWorkCore, UnitOfWorkCore>();
            services.AddScoped<IHeaderService, HeaderService>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            //if (env.IsDevelopment())
            //{
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "F3M.Dashboard.API v1"));
            //}

            app.UseHttpsRedirection();

            app.UseRouting();

            //For CORS
            app.UseCors("CorsPolicy");
            //For CORS

            //app.UseAuthentication();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
