using Dapper;
using F3M.Middleware.Data.Utils;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace F3M.Dashboard.API.Data.Context
{
    public class ApplicationDbContextCore : DbContext
    {
        public ApplicationDbContextCore(DbContextOptions<ApplicationDbContextCore> options) : base(options)
        { }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            //optionsBuilder.UseSqlServer(DatabaseUtils.GetConexaoBD(true));
        }

        #region "entitities"
        public DbSet<Entities.Core.TbUtilizadores> TbUtilizadores { get; set; }
        public DbSet<Entities.Core.TbMenus> TbMenus { get; set; }
        public DbSet<Entities.Core.TbMenusFavoritos> TbMenusFavoritos { get; set; }
        public DbSet<Entities.Core.TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }

        #endregion

        public async System.Threading.Tasks.Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class
        {
            using SqlConnection connection = new(base.Database.GetConnectionString());
            return await connection.QueryAsync<T>(query, parameters);
        }
    }
}
