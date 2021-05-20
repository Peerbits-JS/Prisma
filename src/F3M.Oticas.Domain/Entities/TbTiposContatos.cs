using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposContatos
    {
        public TbTiposContatos()
        {
            TbBancosContatos = new HashSet<TbBancosContatos>();
            TbClientesContatos = new HashSet<TbClientesContatos>();
            TbContasBancariasContatos = new HashSet<TbContasBancariasContatos>();
            TbEntidadesContatos = new HashSet<TbEntidadesContatos>();
            TbFornecedoresContatos = new HashSet<TbFornecedoresContatos>();
            TbMedicosTecnicosContatos = new HashSet<TbMedicosTecnicosContatos>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbBancosContatos> TbBancosContatos { get; set; }
        public ICollection<TbClientesContatos> TbClientesContatos { get; set; }
        public ICollection<TbContasBancariasContatos> TbContasBancariasContatos { get; set; }
        public ICollection<TbEntidadesContatos> TbEntidadesContatos { get; set; }
        public ICollection<TbFornecedoresContatos> TbFornecedoresContatos { get; set; }
        public ICollection<TbMedicosTecnicosContatos> TbMedicosTecnicosContatos { get; set; }
    }
}
