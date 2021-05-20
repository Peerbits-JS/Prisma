using F3M.Dashboard.API.Data.Entities.Repositories.Application;
using F3M.Dashboard.API.Data.Entities.Repositories.Application.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.UnitOfWork.Interfaces
{
    public interface IUnitOfWorkCore
    {
        #region "repositories"
        IApplicationRepository<Entities.Core.TbUtilizadores> UsersRepository { get; }
        IApplicationRepository<Entities.Core.TbMenus> MenusRepository { get; }
        IApplicationRepository<Entities.Core.TbMenusFavoritos> FavouritesMenusRepository { get; }
        IApplicationRepository<Entities.Core.TbUtilizadoresEmpresa> CompanyUsersRepository { get; }
        #endregion

        int Commit();
        void Rollback();
        Task<int> CommitAsync();
        Task RollbackAsync();
        void Dispose();
        void DisposeAsync();

        Task<IEnumerable<T>> ExecQueryAsync<T>(string query, Dictionary<string, object> parameters) where T : class;
    }
}