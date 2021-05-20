using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaRelacaoEspacoFiscalRegimeIva
    {
        public long Id { get; set; }
        public long IdespacoFiscal { get; set; }
        public long IdregimeIva { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaEspacoFiscal IdespacoFiscalNavigation { get; set; }
        public TbSistemaRegimeIva IdregimeIvaNavigation { get; set; }
    }
}
