using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposDocumento
    {
        public TbSistemaTiposDocumento()
        {
            TbMapasVistas = new HashSet<TbMapasVistas>();
            TbSistemaTiposDocumentoColunasAutomaticas = new HashSet<TbSistemaTiposDocumentoColunasAutomaticas>();
            TbSistemaTiposDocumentoFiscal = new HashSet<TbSistemaTiposDocumentoFiscal>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
        }

        public long Id { get; set; }
        public string Tipo { get; set; }
        public string Descricao { get; set; }
        public long Idmodulo { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool TipoFiscal { get; set; }
        public bool ActivaPredefTipoDoc { get; set; }

        public TbSistemaModulos IdmoduloNavigation { get; set; }
        public ICollection<TbMapasVistas> TbMapasVistas { get; set; }
        public ICollection<TbSistemaTiposDocumentoColunasAutomaticas> TbSistemaTiposDocumentoColunasAutomaticas { get; set; }
        public ICollection<TbSistemaTiposDocumentoFiscal> TbSistemaTiposDocumentoFiscal { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }
    }
}
