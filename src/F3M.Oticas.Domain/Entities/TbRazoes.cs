using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbRazoes
    {
        public long Id { get; set; }
        public long? Idloja { get; set; }
        public DateTime Data { get; set; }
        public string TabelaBd { get; set; }
        public long RegistoId { get; set; }
        public string Opcao { get; set; }
        public string Razao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
    }
}
