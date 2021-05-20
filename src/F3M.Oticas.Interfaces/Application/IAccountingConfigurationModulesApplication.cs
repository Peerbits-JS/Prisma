using F3M.Core.Domain.Entity;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Models;
using F3M.Oticas.DTO;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Application
{
    public interface IAccountingConfigurationModulesApplication
    {
        Task<List<AccountingConfigurationModulesDto>> ReadAsync();
        Task<List<AccountingConfigurationModulesDto>> GetModules();
    }
}
