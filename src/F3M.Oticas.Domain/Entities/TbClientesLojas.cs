using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbClientesLojas
    {
        public long Id { get; set; }
        public long? Idloja { get; set; }
        public long Idcliente { get; set; }
        public double TotalVendas { get; set; }
        public double Saldo { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public int? Ordem { get; set; }

        public TbClientes IdclienteNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
    }
}
