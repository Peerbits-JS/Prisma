using System.Collections.Generic;
using F3M.Oticas.DTO;

namespace F3M.Oticas.Interfaces.Application.Services
{
    public interface IAccountingExportService
    {
        byte[] ExportAccountingCblle(IEnumerable<AccountingExportFile> accountingExportFiles);
    }
}