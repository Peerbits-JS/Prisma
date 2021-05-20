namespace F3M.Dashboard.API.Models
{
    public class ChartData
    {
        public Chart Chart { get; set; }
    }

    public class Chart
    {
        public string XAxis { get; set; }
        public string YAxis { get; set; }
    }
}
