using F3M.Dashboard.API.Data.UnitOfWork.Interfaces;
using F3M.Dashboard.API.Models;
using F3M.Dashboard.API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Dashboard.API.Services
{
    public class UserService : IUserService
    {
        readonly IUnitOfWorkCore _unitOfWorkCore;

        public UserService(IUnitOfWorkCore unitOfWorkCore)
        {
            _unitOfWorkCore = unitOfWorkCore;
        }

        public async Task<UserSummary> GetUserList()
        {
            UserSummary result = new UserSummary();

            result.Users.AddRange(await _unitOfWorkCore.UsersRepository.
                GetEntityAsNoTracking(entity => entity.Ativo).
                Select(entity => new User
                {
                    Id = entity.Id,
                    FirstName = entity.Nome,
                    UserName = entity.Nome
                }).
                OrderBy(entity => entity.FirstName).
                ToListAsync());

            return result;
        }
    }
}
