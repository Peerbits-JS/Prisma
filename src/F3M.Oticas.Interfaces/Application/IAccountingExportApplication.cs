using F3M.Oticas.Domain.Entities;
using F3M.Oticas.DTO;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Interfaces.Application
{
    public interface IAccountingExportApplication
    {
        IEnumerable<AccountingExportDocumentsDto> GetDocuments(AccountingExportFilterDto model);
        IEnumerable<AccountingExportDocumentsDetailsDto> GetDocumentsDetails(AccountingExportDto model);
        Task GenerateMovements(AccountingExportDto accountingExportDto);
        byte[] ExportFile(AccountingExportDto model);

        IEnumerable<AccountingConfigurationModulesDto> GetModulesByFilter(AccountingExportFilterDto accountingConfigurationFilter);
        IEnumerable<AccountingConfigurationTypesDto> GetDocumentTypesByFilter(AccountingExportFilterDto accountingConfigurationFilter);
        IEnumerable<object> GetGeneratedList();
        IEnumerable<object> GetExportedList();
        IEnumerable<object> GetEntityTypesList();
        IEnumerable<object> GetFormatsList();
    }
}