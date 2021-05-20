using F3M.Oticas.Domain.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingConfigurationTypeRepository : IRepositoryOticasBase<AccountingConfigurationType>
    {
        Task<List<AccountingConfigurationType>> GetTypesByModule(AccountingConfigurationModule model);
    }
}

