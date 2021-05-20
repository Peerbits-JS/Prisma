using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbAros
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long? Idmodelo { get; set; }
        public string CodigoCor { get; set; }
        public string Tamanho { get; set; }
        public string Hastes { get; set; }
        public string CorGenerica { get; set; }
        public string CorLente { get; set; }
        public string TipoLente { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbModelos IdmodeloNavigation { get; set; }
    }
}
