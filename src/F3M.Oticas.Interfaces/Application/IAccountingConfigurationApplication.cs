using F3M.Core.Domain.Entity;
using F3M.Core.Domain.Validators;
using F3M.Oticas.Component.Kendo;
using F3M.Oticas.Component.Kendo.Models;
using F3M.Oticas.Component.Models;
using F3M.Oticas.DTO;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Application
{
    public interface IAccountingConfigurationApplication
    {
        Task<Paged<AccountingConfigurationDto>> GetAsync(F3MDataSourceRequest dataSourceRequest);
        Task<AccountingConfigurationDto> GetAsync(long id);
        Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> CreateWithAccountsAsync(KendoCreatedModel<AccountingConfigurationDto> accountingConfiguration);
        Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> CreateWithDocumentTypesAsync(KendoCreatedModel<AccountingConfigurationDto> accountingConfiguration);
        Task<KendoResultModel<AccountingConfigurationDto>> UpdateWithAccountsAsync(KendoCreatedModel<AccountingConfigurationDto> accountingConfiguration);
        Task<DomainResult<KendoResultModel<AccountingConfigurationDto>>> UpdateWithDocumentTypesAsync(KendoCreatedModel<AccountingConfigurationDto> accountingConfiguration);
        Task<KendoResultModel<AccountingConfigurationDto>> RemoveAsync(KendoRemoveModel kendoRemoveModel);
        Task<List<KeyValueModel>> GetYearsAsync();
        Task<IEnumerable<AccountingConfigurationModulesDto>> GetModulesAsync();
        Task<IEnumerable<AccountingConfigurationTypesDto>> GetTypesAsync(AccountingConfigurationModulesDto model);
        string GetAlternative(AccountingConfigurationDto model);
        IEnumerable<AccountingConfigurationEntityDto> GetEntities(AccountingConfigurationTypesDto model);
    }
}
