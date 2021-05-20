using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposDocumentoFiscal
    {
        public TbSistemaTiposDocumentoFiscal()
        {
            TbMapasVistas = new HashSet<TbMapasVistas>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
        }

        public long Id { get; set; }
        public string Tipo { get; set; }
        public string Descricao { get; set; }
        public long IdtipoDocumento { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaTiposDocumento IdtipoDocumentoNavigation { get; set; }
        public ICollection<TbMapasVistas> TbMapasVistas { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }
    }
}
