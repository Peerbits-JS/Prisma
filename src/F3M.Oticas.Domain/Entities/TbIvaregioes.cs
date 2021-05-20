using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbIvaregioes
    {
        public long Id { get; set; }
        public long Idiva { get; set; }
        public long Idregiao { get; set; }
        public long? IdivaRegiao { get; set; }
        public bool Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Vat IdivaNavigation { get; set; }
        public Vat IdivaRegiaoNavigation { get; set; }
        public TbSistemaRegioesIva IdregiaoNavigation { get; set; }
    }
}
