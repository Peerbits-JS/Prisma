using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities
{
    public class AccountingConfigurationModule : EntityBase
    {
        public AccountingConfigurationModule()
        {
        }

        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsDocumentType() => !Code.Equals("008");
        public bool HasNoModuleSelected() => string.IsNullOrEmpty(Code);
    }
}
