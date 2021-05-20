using F3M.Core.Data.Interfaces.Repository;
using F3M.Core.Domain.Entity;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IRepositoryOticasBase<TEntity> : IRepositoryBase<TEntity> where TEntity : EntityBase
    {
        Task<Paged<TEntity>> GetAsync(F3MDataSourceRequest dataSourceRequest);
        decimal GetLastPage(F3MDataSourceRequest f3MKendoDataSource);
        Task<int> CommitAsync();
        int Commit();
        decimal GetPageToRemove(KendoRemoveModel kendoRemoveModel);
        TEntity GetBefore(KendoRemoveModel kendoRemoveModel);
    }
}
