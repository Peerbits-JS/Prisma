using F3M.Dashboard.API.Data.Entities.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Data.Entities.Repositories.Application.Interfaces
{
    public interface IApplicationRepository<TEntity> where TEntity : EntityBase
    {
        Task<TEntity> FindAsync(long id);

        Task<TEntity> FindAsync(Expression<Func<TEntity, bool>> where);

        IQueryable<TEntity> GetEntity();

        IQueryable<TEntity> GetEntity(Expression<Func<TEntity, bool>> where);

        IQueryable<TEntity> GetEntityAsNoTracking();

        IQueryable<TEntity> GetEntityAsNoTracking(Expression<Func<TEntity, bool>> where);

        Task<IEnumerable<TEntity>> GetListAsync(Expression<Func<TEntity, bool>> where);

        Task<IEnumerable<TEntity>> GetListAsync<TKey>(Expression<Func<TEntity, bool>> where, Expression<Func<TEntity, TKey>> order, bool ascending = true);

        Task<TEntity> CreateAsync(TEntity entity);

        Task<IEnumerable<TEntity>> CreateAsync(IEnumerable<TEntity> entities);

        Task<TEntity> Edit(TEntity entity);

        Task<IEnumerable<TEntity>> Edit(IEnumerable<TEntity> entity);

        Task<TEntity> Delete(long id);

        Task<TEntity> Delete(TEntity entity);

        Task<IEnumerable<TEntity>> Delete(IEnumerable<TEntity> entity);
    }
}