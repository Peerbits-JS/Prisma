using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbFormasExpedicaoIdiomas
    {
        public long Id { get; set; }
        public long IdformaExpedicao { get; set; }
        public long Ididioma { get; set; }
        public string Descricao { get; set; }
        public int Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbFormasExpedicao IdformaExpedicaoNavigation { get; set; }
        public TbIdiomas IdidiomaNavigation { get; set; }
    }
}
