using F3M.Core.Domain.Entity;
using System;

namespace F3M.Oticas.Domain.Entities.Base
{
    public class DocumentLineBase : EntityBase
    {
        public virtual DocumentBase GetDocumentBase() => throw new NotImplementedException();

        public virtual double GetVatValue() => 0;

        public virtual double GetIncidenceValue() => 0;

        public virtual double GetTotalPrice() => 0;

        public virtual double GetCostOfGoods() => 0;

        public virtual double GetPurchaseCostOfGoods() => 0;

        public virtual double GetDiscount() => 0;

        public virtual double GetMerchandiseWithVat() => 0;
    }
}