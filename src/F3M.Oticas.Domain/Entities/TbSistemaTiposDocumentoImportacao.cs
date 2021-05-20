using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposDocumentoImportacao
    {
        public long Id { get; set; }
        public string TipoFiscal { get; set; }
        public string TipoDocSist { get; set; }
        public string Natureza { get; set; }
        public string TipoFiscalOrigem { get; set; }
        public string TipoDocSistOrigem { get; set; }
        public string NaturezaOrigem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
    }
}
