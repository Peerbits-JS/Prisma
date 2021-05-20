using F3M.Oticas.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingConfigurationModuleRepository : IRepositoryOticasBase<AccountingConfigurationModule>
    {
        IEnumerable<AccountingConfigurationModule> Get(Expression<Func<AccountingConfigurationModule, bool>> expression = null);
        Task<IEnumerable<AccountingConfigurationModule>> GetAsync();
    }
}