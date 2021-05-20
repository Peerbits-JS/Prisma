using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposEntidadeModulos
    {
        public TbSistemaTiposEntidadeModulos()
        {
            TbTiposDocumentoTipEntPermDoc = new HashSet<TbTiposDocumentoTipEntPermDoc>();
        }

        public long Id { get; set; }
        public long IdsistemaTiposEntidade { get; set; }
        public long IdsistemaModulos { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaModulos IdsistemaModulosNavigation { get; set; }
        public SystemEntityType IdsistemaTiposEntidadeNavigation { get; set; }
        public ICollection<TbTiposDocumentoTipEntPermDoc> TbTiposDocumentoTipEntPermDoc { get; set; }
    }
}
