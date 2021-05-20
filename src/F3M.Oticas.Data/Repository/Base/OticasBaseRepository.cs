using F3M.Core.Data.Repository;
using F3M.Core.Domain.Entity;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Data.Context;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public abstract class OticasBaseRepository<TEntity> : RepositoryBase<TEntity>, IRepositoryOticasBase<TEntity> where TEntity : EntityBase
    {
        public static OticasContext _dbContext;

        protected OticasBaseRepository(OticasContext context)
            : base(context)
        {
            _dbContext = context;
        }

        public int Commit() => _dbContext.SaveChanges();

        public async Task<int> CommitAsync() => await _dbContext.SaveChangesAsync();

        public Task<Paged<TEntity>> GetAsync(F3MDataSourceRequest dataSourceRequest)
        {
            var query = EntitySet.Sort(dataSourceRequest).Where(dataSourceRequest).AsNoTracking();
            var items = query.Skip((dataSourceRequest.Page - 1) * dataSourceRequest.PageSize).Take(dataSourceRequest.PageSize).ToList();
            var totalOfItems = query.Count();
            var paged = Paged<TEntity>.Create(items, totalOfItems);
            return Task.FromResult(paged);
        }

        public decimal GetLastPage(F3MDataSourceRequest f3MKendoDataSource)
        {
            var quantityOfItems = EntitySet.Where(f3MKendoDataSource).AsNoTracking().Count();
            decimal page = (quantityOfItems / f3MKendoDataSource.PageSize) + 1;
            return Math.Floor(page);
        }

        public decimal GetPageToRemove(KendoRemoveModel kendoRemoveModel)
        {
            var query = EntitySet.Sort(kendoRemoveModel.F3MKendoDataSource).Where(kendoRemoveModel.F3MKendoDataSource).AsNoTracking();
            var items = query.Skip((kendoRemoveModel.F3MKendoDataSource.Page - 1) * kendoRemoveModel.F3MKendoDataSource.PageSize).Take(kendoRemoveModel.F3MKendoDataSource.PageSize).ToList();
            var index = items.FindIndex(x => x.Id == kendoRemoveModel.Id);

            return index is 0
                ? Math.Floor((decimal)kendoRemoveModel.F3MKendoDataSource.Page - 1)
                : kendoRemoveModel.F3MKendoDataSource.Page;
        }

        public TEntity GetBefore(KendoRemoveModel kendoRemoveModel)
        {
            var query = EntitySet.Sort(kendoRemoveModel.F3MKendoDataSource).Where(kendoRemoveModel.F3MKendoDataSource).AsNoTracking();
            var items = query.Skip((kendoRemoveModel.F3MKendoDataSource.Page - 1) * kendoRemoveModel.F3MKendoDataSource.PageSize).Take(kendoRemoveModel.F3MKendoDataSource.PageSize).ToList();
            var index = items.FindIndex(x => x.Id == kendoRemoveModel.Id);
            var entity = index is 0 ? default(TEntity) : items[index - 1];

            if (index is 0)
            {
                items = query.Skip((kendoRemoveModel.F3MKendoDataSource.Page - 2) * kendoRemoveModel.F3MKendoDataSource.PageSize)
                    .Take(kendoRemoveModel.F3MKendoDataSource.PageSize)
                    .OrderByDescending(x => x.Id).ToList();
                entity = items.FirstOrDefault();
            }

            return items.Any() ? entity : null;
        }
    }
}