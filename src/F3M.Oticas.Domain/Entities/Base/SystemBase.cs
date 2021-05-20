using F3M.Core.Domain.Entity;

namespace F3M.Oticas.Domain.Entities.Base
{
    public class SystemBase : EntityBase
    {
        public virtual string Code { get; set; }
        public virtual string Description { get; set; }
    }        
}