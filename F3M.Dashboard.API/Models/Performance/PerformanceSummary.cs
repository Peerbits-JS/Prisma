namespace F3M.Dashboard.API.Models
{
    public class PerformanceSummary
    {
        public Total Total { get; set; }
        public Aros Aros { get; set; }
        public OpthalmicLenses OpthalmicLenses { get; set; }
        public ContactLenses ContactLenses { get; set; }
        public SunGlasses SunGlasses { get; set; }
        public Several Several { get; set; }
        public Models.Chart Chart { get; set; }
    }
}
