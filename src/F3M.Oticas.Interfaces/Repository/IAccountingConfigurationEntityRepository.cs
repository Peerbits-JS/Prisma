using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using System.Collections.Generic;

namespace F3M.Oticas.Interfaces.Repository
{
    public interface IAccountingConfigurationEntityRepository
    {
        IEnumerable<AccountingConfigurationEntityDto> GetToAccountingConfigurationAsync(AccountingConfigurationTypesDto filter);
        IEnumerable<AccountingConfigurationEntityDto> GetToAccountingConfigurationByTableName(string tableName);
        IEnumerable<AccountingConfigurationDetail> GetAccountingConfigurationEntities(AccountingExportFilterDto filter);
    }
}