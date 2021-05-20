using Kendo.Mvc;
using Kendo.Mvc.UI;
using System.Collections.Generic;

namespace F3M.Oticas.Component.Kendo
{
    public class F3MDataSourceRequest
        : DataSourceRequest
    {
        public F3MDataSourceRequest(IList<AggregateDescriptor> aggregates, IList<GroupDescriptor> groups, int page,
            int pageSize, IList<SortDescriptor> sorts, IList<IFilterDescriptor> filters)
        {
            Aggregates = aggregates;
            Groups = groups;
            Page = page;
            PageSize = pageSize;
            Sorts = sorts;
            Filters = filters;
        }

        public static F3MDataSourceRequest Create(DataSourceRequest request)
            => new F3MDataSourceRequest(request.Aggregates, request.Groups, request.Page, request.PageSize, request.Sorts, request.Filters);
    }
}
