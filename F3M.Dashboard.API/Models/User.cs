using System.Collections.Generic;

namespace F3M.Dashboard.API.Models
{
    public class User
    {
        //public Int64 Id { get; set; }
        public decimal Id { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
    }

    public class UserSummary
    {
        public UserSummary()
        {
            Users = new();
        }

        public List<User> Users { get; set; }
    }
}
