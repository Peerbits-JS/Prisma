using Kendo.Mvc.UI;
using System.Collections.Generic;

namespace F3M.Oticas.Component.Kendo.Models
{
    public class KendoResultModel<TSource> where TSource : class
    {

        public KendoResultModel(TSource data, long newId, decimal lastPage)
        {
            ResultDataSource = new DataSourceResult { Data = new List<TSource> { data }, Total = 1 };
            NovoID = newId;
            PaginaDoUltimoItemManipulado = lastPage;
        }

        public DataSourceResult ResultDataSource { get; private set; }

        public long NovoID { get; set; }

        public decimal PaginaDoUltimoItemManipulado { get; set; }

        public static KendoResultModel<TSource> Create(TSource data, long newId, decimal lastPage)
            => new KendoResultModel<TSource>(data, newId, lastPage);
    }
}
