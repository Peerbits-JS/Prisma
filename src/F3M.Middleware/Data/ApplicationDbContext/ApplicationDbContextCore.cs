using F3M.Middleware.Constants;
using F3M.Middleware.Data.Entities;
using F3M.Middleware.Data.Utils;
using Microsoft.EntityFrameworkCore;

namespace F3M.Middleware.Data.ApplicationDbContext
{
    public class ApplicationDbContextCore :  DbContext
    {
        private readonly IClsDadosAcesso _clsDadosAcesso;

        public ApplicationDbContextCore(IClsDadosAcesso clsDadosAcesso)
        {
            _clsDadosAcesso = clsDadosAcesso;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);


            DatabaseUtils db= new(_clsDadosAcesso);
            var connString = db.GetConexaoBD(true);
            optionsBuilder.UseSqlServer(connString);
            //optionsBuilder.UseLazyLoadingProxies(false);
        }


        #region "entities"
        public virtual DbSet<Data.Entities.AspNetUsers> AspNetUsers { get; set; }
        public virtual DbSet<TbEmpresas> TbEmpresas { get; set; }
        public virtual DbSet<TbMenus> TbMenus { get; set; }
        public virtual DbSet<TbMenusAreasEmpresa> TbMenusAreasEmpresa { get; set; }
        public virtual DbSet<TbMenusFavoritos> TbMenusFavoritos { get; set; }
        public virtual DbSet<TbPerfis> TbPerfis { get; set; }
        public virtual DbSet<TbPerfisAcessos> TbPerfisAcessos { get; set; }
        public virtual DbSet<TbPerfisAcessosAreas> TbPerfisAcessosAreas { get; set; }
        public virtual DbSet<TbPerfisAcessosAreasEmpresa> TbPerfisAcessosAreasEmpresa { get; set; }
        public virtual DbSet<TbUtilEmprEstado> TbUtilEmprEstado { get; set; }
        public virtual DbSet<TbUtilizadores> TbUtilizadores { get; set; }
        public virtual DbSet<TbUtilizadoresEmpresa> TbUtilizadoresEmpresa { get; set; }
        #endregion
    }
}
