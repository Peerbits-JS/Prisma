using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposDocumentoSeriesPermissoes
    {
        public long Id { get; set; }
        public long Idserie { get; set; }
        public long Idperfil { get; set; }
        public bool PermissaoConsultar { get; set; }
        public bool PermissaoAlterar { get; set; }
        public bool PermissaoAdicionar { get; set; }
        public bool PermissaoRemover { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbTiposDocumentoSeries IdserieNavigation { get; set; }
    }
}
