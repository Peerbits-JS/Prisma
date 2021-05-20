namespace F3M.Oticas.Component.Kendo.Models
{
    public class KendoRemoveModel
    {
        public KendoRemoveModel(long id, F3MDataSourceRequest f3MKendoDataSource)
        {
            Id = id;
            F3MKendoDataSource = f3MKendoDataSource;
        }

        public F3MDataSourceRequest F3MKendoDataSource { get; private set; }

        public long Id { get; set; }

        public static KendoRemoveModel Create(long id, F3MDataSourceRequest f3MKendoDataSource)
            => new KendoRemoveModel(id, f3MKendoDataSource);

    }
}
