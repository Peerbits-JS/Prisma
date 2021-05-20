using F3M.Oticas.Component.Models;
using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class AccountingConfigurationTypeRepository : OticasBaseRepository<AccountingConfigurationType>, IAccountingConfigurationTypeRepository
    {
        public AccountingConfigurationTypeRepository(OticasContext context)
            : base(context)
        {
        }

        public async Task<List<AccountingConfigurationType>> GetTypesByModule(AccountingConfigurationModule model)
        {
            return await EntitySet.AsNoTracking().ToListAsync();
        }
    }
}
