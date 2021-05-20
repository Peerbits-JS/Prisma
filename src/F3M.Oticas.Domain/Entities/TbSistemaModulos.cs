using F3M.Oticas.Domain.Constants;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaModulos
    {
        public TbSistemaModulos()
        {
            TbMapasVistas = new HashSet<TbMapasVistas>();
            TbSistemaTiposDocumento = new HashSet<TbSistemaTiposDocumento>();
            TbSistemaTiposEntidadeModulos = new HashSet<TbSistemaTiposEntidadeModulos>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool TiposDocumentos { get; set; }

        public ICollection<TbMapasVistas> TbMapasVistas { get; set; }
        public ICollection<TbSistemaTiposDocumento> TbSistemaTiposDocumento { get; set; }
        public ICollection<TbSistemaTiposEntidadeModulos> TbSistemaTiposEntidadeModulos { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }

        public bool IsCurrentAccount() => Codigo == DocumentTypeConstants.Module.CurrentAccount;
    }
}
