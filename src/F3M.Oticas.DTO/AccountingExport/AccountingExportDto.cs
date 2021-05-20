using System;

namespace F3M.Oticas.DTO
{
    public class AccountingExportDto
    {
        public AccountingExportDto()
        {
            Filter = new AccountingExportFilterDto();
        }
        public AccountingExportFilterDto Filter { get; set; }
        public AccountingExportDocumentsDto []Documents {get; set;}
    }
}