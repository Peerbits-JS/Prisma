using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Models;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingConfigurationRepository : IRepositoryOticasBase<AccountingConfiguration>
    {
        Task<List<KeyValueModel>> GetYears();
        string GetAlternative(AccountingConfiguration model);
        bool AlreadyExists(AccountingConfiguration model);
        Task<List<AccountingConfiguration>> GetToPresetAlternativeAsync(AccountingConfiguration model);
        List< AccountingConfiguration> GetConfigurations(AccountingExportFilterDto filter);
    }
}