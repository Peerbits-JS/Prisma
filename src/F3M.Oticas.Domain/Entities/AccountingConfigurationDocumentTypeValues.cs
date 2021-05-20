using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities
{
    public class AccountingConfigurationDocumentTypeValues : EntityBase
    {

        public AccountingConfigurationDocumentTypeValues()
        {
        }

        public string Code { get; set; }
        public string Description { get; set; }
    }
}
