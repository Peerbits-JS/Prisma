using Dapper;
using F3M.Dashboard.API.Data.Entities.Base;
using F3M.Dashboard.API.Models;
using F3M.Middleware.Constants;
using F3M.Middleware.Data.Utils;
using F3M.Modelos.Autenticacao;
using F3M.Modelos.BaseDados;
using F3M.Modelos.Constantes;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.Context
{
    public class ApplicationDbContext : DbContext
    {
        private readonly string _user;
        public readonly string _connectionString;

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        { }

        #region "onconfiguring"
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            //var connString = DatabaseUtils.GetConexaoBD(false);
            //optionsBuilder.UseSqlServer(connString);
        }
        #endregion

        public DbSet<Entities.Prisma.tbLojas> tbLojas { get; set; }
        public DbSet<MonthSalesNew> MonthSalesNew { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<MonthSalesNew>().HasKey("Id");
            modelBuilder.Entity<MonthSalesNew>()
            .Property(f => f.Id)
            .ValueGeneratedOnAdd();
        }


        #region "save changes"
        public override int SaveChanges()
        {
            SetDefaultPropertiesOnEntities();
            return base.SaveChanges();
        }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            SetDefaultPropertiesOnEntities();
            return await base.SaveChangesAsync(cancellationToken);
        }

        private void SetDefaultPropertiesOnEntities()
        {
            var entries = ChangeTracker.Entries<EntityBase>();

            if (entries != null)
            {
                foreach (var entry in entries)
                {
                    if (entry.State == EntityState.Added)
                    {
                        entry.Property(prop => prop.F3MMarcador).IsModified = false;

                        entry.Entity.DataAlteracao = null;
                        entry.Entity.DataCriacao = DateTime.Now;
                        entry.Entity.UtilizadorCriacao = ""; //ClsDadosAcesso.CodigoUtilizador;
                    }

                    if (entry.State == EntityState.Modified)
                    {
                        entry.Property(prop => prop.DataCriacao).IsModified = false;
                        entry.Property(prop => prop.UtilizadorCriacao).IsModified = false;
                        entry.Property(prop => prop.F3MMarcador).IsModified = false;

                        entry.Entity.DataAlteracao = DateTime.Now;
                        entry.Entity.UtilizadorAlteracao = ""; //ClsDadosAcesso.CodigoUtilizador;
                    }
                }
            }
        }
        #endregion
        public async Task<List<T>> ExecQueryListAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class
        {
            using SqlConnection conexao = new(base.Database.GetConnectionString());
            var result = await conexao.QueryAsync<T>(query, parameters);
            return result.ToList();
        }

        public async Task<T> ExecQuerySingleAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class
        {
            using SqlConnection conexao = new(base.Database.GetConnectionString());
            var result = await  conexao.QueryAsync<T>(query, parameters);
            return result.FirstOrDefault();
        }

        public void ExecQueryNonAsync<T>(T query)
        {
            Add(query);
        }

        public async Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class
        {
            using SqlConnection connection = new(base.Database.GetConnectionString());
            return await connection.QueryAsync<T>(query, parameters);
        }
    }
}