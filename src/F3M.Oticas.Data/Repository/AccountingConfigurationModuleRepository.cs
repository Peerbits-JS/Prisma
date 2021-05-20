using F3M.Oticas.Component.Models;
using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class AccountingConfigurationModuleRepository : OticasBaseRepository<AccountingConfigurationModule>, IAccountingConfigurationModuleRepository
    {
        public AccountingConfigurationModuleRepository(OticasContext context)
            : base(context)
        {
        }

        public async Task<IEnumerable<AccountingConfigurationModule>> GetAsync()
        {
            return await EntitySet.Where(x => x.IsActive).ToListAsync();
        }

        public IEnumerable<AccountingConfigurationModule> Get(Expression<Func<AccountingConfigurationModule, bool>> expression = null)
        {
            if (expression is null) expression =  x => true;

            return EntitySet.
                Where(x => x.IsActive).
                Where(expression.Compile()).ToList();
        }
    }
}
