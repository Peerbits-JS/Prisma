using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbProfissoes
    {
        public TbProfissoes()
        {
            TbClientes = new HashSet<TbClientes>();
            TbFornecedores = new HashSet<TbFornecedores>();
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

        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
    }
}
