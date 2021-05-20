using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class SystemSex:SystemBase

    {
        public SystemSex()
        {
            TbClientes = new HashSet<TbClientes>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
        }

        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
    }
}
