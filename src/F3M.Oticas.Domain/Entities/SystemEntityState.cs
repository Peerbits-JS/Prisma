using F3M.Oticas.Domain.Entities.Base;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SystemEntityState : SystemBase
    {
        public SystemEntityState()
        {
            State = new HashSet<State>();
            SystemStateType = new HashSet<SystemStateType>();
        }

        public ICollection<State> State { get; set; }
        public ICollection<SystemStateType> SystemStateType { get; set; }
    }
}
