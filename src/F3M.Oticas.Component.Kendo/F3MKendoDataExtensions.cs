using F3M.Oticas.Component.Kendo;
using Kendo.Mvc;
using System;
using System.ComponentModel;
using System.Linq;

namespace F3M.Oticas.Component.Kendo
{
    public static class F3MKendoDataExtensions
    {

        public static IQueryable<T> Sort<T>(this IQueryable<T> entity, F3MDataSourceRequest request) where T : class
        {
            if (request.Sorts != null && request.Sorts.Any())
            {
                foreach (var item in request.Sorts)
                {
                    switch (item.SortDirection)
                    {
                        case ListSortDirection.Ascending:
                            entity = entity.OrderBy(x => x.GetType().GetProperty(item.Member).GetValue(x));
                            break;
                        case ListSortDirection.Descending:
                            entity = entity.OrderByDescending(x => x.GetType().GetProperty(item.Member).GetValue(x));
                            break;
                        default:
                            throw new Exception("Unexpected Case");
                    }
                }
            }
            return entity;
        }
        public static IQueryable<T> Where<T>(this IQueryable<T> entity, F3MDataSourceRequest dataSourceRequest) where T : class
            => entity.Where(ExpressionBuilder.Expression<T>(dataSourceRequest.Filters, false).Compile()).AsQueryable();
    }
}
