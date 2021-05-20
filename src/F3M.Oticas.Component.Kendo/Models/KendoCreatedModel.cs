namespace F3M.Oticas.Component.Kendo.Models
{
    public class KendoCreatedModel<TSource> where TSource : class
    {

        public KendoCreatedModel(TSource data, F3MDataSourceRequest f3MKendoDataSource)
        {
            Data = data;
            F3MKendoDataSource = f3MKendoDataSource;
        }

        public TSource Data { get; set; }

        public F3MDataSourceRequest F3MKendoDataSource { get; private set; }

        public static KendoCreatedModel<TSource> Create(TSource data, F3MDataSourceRequest f3MKendoDataSource)
            => new KendoCreatedModel<TSource>(data, f3MKendoDataSource);

    }
}
