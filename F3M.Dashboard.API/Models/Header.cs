namespace F3M.Dashboard.API.Models
{
    public partial class MenusDTO
    {
        public long Id { get; set; }
        public string Description { get; set; }
        public string Icon { get; set; }
        public string Action { get; set; }
    }
    public partial class FavouriteMenuDTO
    {
        public long IdMenu { get; set; }
    }

    public partial class HomepageMenuDTO
    {
        public long IDHomePage { get; set; }
    }
}
