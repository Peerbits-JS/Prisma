using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;

namespace F3M.Oticas.Data.Repository
{
    public class SystemStateTypeRepository : OticasBaseRepository<SystemStateType>, ISystemStateTypeRepository
    {
        public SystemStateTypeRepository(OticasContext context)
            : base(context)
        {
        }
    }
}