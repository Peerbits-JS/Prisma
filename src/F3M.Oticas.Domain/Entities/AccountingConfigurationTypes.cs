using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities
{
    public class AccountingConfigurationType : EntityBase
    {

        public AccountingConfigurationType()
        {
        }

        public string Code { get; set; }
        public string Description { get; set; }
        public string Table { get; set; }
        public bool ShowGoodsCostPurchase { get; set; }
    }
}
