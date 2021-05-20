using F3M.Core.Domain.Entity;
using F3M.Oticas.Domain.Entities.Base;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SystemStateType : SystemBase
    {
        public SystemStateType()
        {
            States = new HashSet<State>();
        }

        public long EntityStateId { get; set; }
        public string Color { get; set; }
        public bool AtivaPredefNovosDocs { get; set; }

        public SystemEntityState SystemEntityStates { get; set; }
        public ICollection<State> States { get; set; }
    }
}