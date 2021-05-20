using F3M.Dashboard.API.Models;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services.Interfaces
{
    public interface IUserService
    {
        //Task<List<User>> GetUsers();
        Task<UserSummary> GetUserList();
    }
}
