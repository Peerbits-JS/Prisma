using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbLentesOftalmicasSuplementos
    {
        public long Id { get; set; }
        public long IdlenteOftalmica { get; set; }
        public long IdsuplementoLente { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLentesOftalmicas IdlenteOftalmicaNavigation { get; set; }
        public TbSuplementosLentes IdsuplementoLenteNavigation { get; set; }
    }
}
