using F3M.Dashboard.API.Data.Entities.Repositories.Application.Interfaces;
using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.UnitOfWork.Interfaces
{
    public interface IUnitOfWork
    {
        #region "repositories"
        IApplicationRepository<Entities.Prisma.tbLojas> StoresRepository {get; }
        #endregion

        int Commit();
        void Rollback();
        Task<int> CommitAsync();
        Task RollbackAsync();
        void Dispose();
        void DisposeAsync();

        Task<T> ExecQuerySingleAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class;

        Task<List<T>> ExecQueryListAsync<T>(string query, Dictionary<string, object> parameters = null) where T : class;

        void ExecQueryNonAsync<T>(T monthSales);

        Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class;
    }
}