using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposDocumentoTipEntPermDoc
    {
        public long Id { get; set; }
        public long IdtiposDocumento { get; set; }
        public long IdsistemaTiposEntidadeModulos { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Ordem { get; set; }
        public long ContadorDoc { get; set; }

        public TbSistemaTiposEntidadeModulos IdsistemaTiposEntidadeModulosNavigation { get; set; }
        public TbTiposDocumento IdtiposDocumentoNavigation { get; set; }
    }
}
