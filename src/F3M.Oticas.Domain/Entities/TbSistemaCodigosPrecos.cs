using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaCodigosPrecos
    {
        public TbSistemaCodigosPrecos()
        {
            TbArtigosPrecos = new HashSet<TbArtigosPrecos>();
            TbClientes = new HashSet<TbClientes>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbArtigosPrecos> TbArtigosPrecos { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
    }
}
