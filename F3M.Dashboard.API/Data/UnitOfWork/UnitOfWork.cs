using F3M.Dashboard.API.Data.Context;
using F3M.Dashboard.API.Data.Entities.Repositories.Application;
using F3M.Dashboard.API.Data.Entities.Repositories.Application.Interfaces;
using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        private readonly ApplicationDbContext _databaseContext;
        private IApplicationRepository<Entities.Prisma.tbLojas> _storesRepository;

        #region "ctor"
        public UnitOfWork(ApplicationDbContext dbContext)
        {
            _databaseContext = dbContext;
        }
        #endregion

        #region "repositories"
        public IApplicationRepository<Entities.Prisma.tbLojas> StoresRepository
        {
            get { return _storesRepository = _storesRepository ?? new ApplicationRepository<Entities.Prisma.tbLojas>(_databaseContext); }
        }
        #endregion

        public int Commit() => _databaseContext.SaveChanges();
        public void Rollback() => _databaseContext.Dispose();
        public async Task<int> CommitAsync() => await _databaseContext.SaveChangesAsync();
        public async Task RollbackAsync() => await _databaseContext.DisposeAsync();

        public void Dispose()
        {
            _databaseContext?.Dispose();
            GC.SuppressFinalize(this);
        }

        public void DisposeAsync()
        {
            _databaseContext?.DisposeAsync();
            GC.SuppressFinalize(this);
        }

        public async Task<List<T>> ExecQueryListAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class
        {
            return await _databaseContext.ExecQueryListAsync<T>(query, parameters);
        }

        public async Task<T> ExecQuerySingleAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class
        {
            return await _databaseContext.ExecQuerySingleAsync<T>(query, parameters);
        }

        public void ExecQueryNonAsync<T>(T query)
        {
            _databaseContext.ExecQueryNonAsync(query);
        }

        public async Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class
        {
            return await _databaseContext.ExecQueryAsync<T>(query, parameters);
        }
    }
}
