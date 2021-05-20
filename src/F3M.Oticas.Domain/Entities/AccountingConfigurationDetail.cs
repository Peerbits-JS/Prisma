using System;
using F3M.Core.Domain.Entity;
using static F3M.Oticas.Domain.Constants.AccountingExportConstants;

namespace F3M.Oticas.Domain.Entities
{
    public partial class AccountingConfigurationDetail : EntityBase
    {
        public string Account { get; set; }

        public AccountingConfiguration AccountingConfiguration { get; set; }

        public long AccountingConfigurationId { get; set; }

        public string AccountingVariable { get; set; }

        public string CostCenter { get; set; }

        public string EntityCode { get; set; }

        public string EntityDescription { get; set; }

        public long EntityId { get; set; }

        public bool? GoodsCostInPurchase { get; set; }

        public string IVAClass { get; set; }

        public string NatureDescription { get; set; }

        public string ValueDescription { get; set; }

        public long ValueId { get; set; }

        public bool HasGoodsCostInPurchase() => GoodsCostInPurchase == true;

        public bool HasNoAccount() => Account is null;

        public bool HasNoGoodsCostInPurchase() => GoodsCostInPurchase != true;

        public bool HasNoNatureDescription() => NatureDescription is null;

        public bool HasNoValueDescription() => ValueDescription is null;

        public bool IsCredit() => NatureDescription == "C";

        public bool IsDebit() => NatureDescription == "D";

        public bool IsDiscount() => ValueId == ConfigurationType.Desconto;

        public bool IsGoodsCost() => ValueId == ConfigurationType.CustoMercadoria;

        public bool IsIvaConfiguration() => ValueId == ConfigurationType.Iva;

        public bool IsMerchandiseWithoutVAT() => ValueId == ConfigurationType.MercadoriaSemIva;

        public bool IsMerchandiseWithVAT() => ValueId == ConfigurationType.MercadoriaComIva;

        public bool IsPurcharGoodsCost() => ValueId == ConfigurationType.CustoMercadoriaCompras;

        public bool IsReceivedValue() => ValueId == ConfigurationType.ValorRecebido;

        public bool IsTotalOfDocument() => ValueId == ConfigurationType.TotalDocumento;

        public bool IsTotalReimbursement() => ValueId == ConfigurationType.TotalComparticipacao;

        public bool HasCostCenter() => string.IsNullOrEmpty(CostCenter) is false;
    }
}
