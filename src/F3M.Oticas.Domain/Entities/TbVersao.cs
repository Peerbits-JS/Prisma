using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbVersao
    {
        public long Id { get; set; }
        public int Major { get; set; }
        public int Minor { get; set; }
        public int Version { get; set; }
        public int DbVersion { get; set; }
        public int? DbVersionSistema { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool? Anonimo { get; set; }
    }
}
