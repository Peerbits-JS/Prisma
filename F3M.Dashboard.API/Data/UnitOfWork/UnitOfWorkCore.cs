using F3M.Dashboard.API.Data.Context;
using F3M.Dashboard.API.Data.Entities.Repositories.Application;
using F3M.Dashboard.API.Data.Entities.Repositories.Application.Interfaces;
using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.UnitOfWork
{
    public class UnitOfWorkCore : IUnitOfWorkCore, IDisposable
    {
        private readonly ApplicationDbContextCore _databaseContextCore;
        private IApplicationRepository<Entities.Core.TbUtilizadores> _usersRepository;
        private IApplicationRepository<Entities.Core.TbUtilizadoresEmpresa> _companyUsersRepository;
        private IApplicationRepository<Entities.Core.TbMenus> _menusRepository;
        private IApplicationRepository<Entities.Core.TbMenusFavoritos> _favouritesMenusRepository;


        #region "ctor"
        public UnitOfWorkCore(ApplicationDbContextCore dbContextCore)
        {
            _databaseContextCore = dbContextCore;
        }
        #endregion

        #region "repositories"
        public IApplicationRepository<Entities.Core.TbUtilizadores> UsersRepository
        {
            get { return _usersRepository ??= new ApplicationRepositoryCore<Entities.Core.TbUtilizadores>(_databaseContextCore); }
        }
        public IApplicationRepository<Entities.Core.TbUtilizadoresEmpresa> CompanyUsersRepository
        {
            get { return _companyUsersRepository ??= new ApplicationRepositoryCore<Entities.Core.TbUtilizadoresEmpresa>(_databaseContextCore); }
        }
        public IApplicationRepository<Entities.Core.TbMenus> MenusRepository
        {
            get { return _menusRepository ??= new ApplicationRepositoryCore<Entities.Core.TbMenus>(_databaseContextCore); }
        }
        public IApplicationRepository<Entities.Core.TbMenusFavoritos> FavouritesMenusRepository
        {
            get { return _favouritesMenusRepository ??= new ApplicationRepositoryCore<Entities.Core.TbMenusFavoritos>(_databaseContextCore); }
        }
        #endregion

        public int Commit() => _databaseContextCore.SaveChanges();
        public void Rollback() => _databaseContextCore.Dispose();
        public async Task<int> CommitAsync() => await _databaseContextCore.SaveChangesAsync();
        public async Task RollbackAsync() => await _databaseContextCore.DisposeAsync();


        public void Dispose()
        {
            _databaseContextCore?.Dispose();
            GC.SuppressFinalize(this);
        }

        public void DisposeAsync()
        {
            _databaseContextCore?.DisposeAsync();
            GC.SuppressFinalize(this);
        }

        public async Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class
        {
            return await _databaseContextCore.ExecQueryAsync<T>(query, parameters);
        }
    }
}
