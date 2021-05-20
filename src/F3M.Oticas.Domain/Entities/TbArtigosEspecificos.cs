using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosEspecificos
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long? Idestacao { get; set; }
        public double? Ne { get; set; }
        public double? Dtex { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbEstacoes IdestacaoNavigation { get; set; }
    }
}
