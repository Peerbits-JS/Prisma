using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSemafroGereStock
    {
        public long Id { get; set; }
        public long? Iddocumento { get; set; }
        public long? IdtipoDocumento { get; set; }
        public int? Accao { get; set; }
        public string TabelaCabecalho { get; set; }
        public string TabelaLinhas { get; set; }
        public string TabelaLinhasDist { get; set; }
        public string CampoRelTabelaLinhasCab { get; set; }
        public string CampoRelTabelaLinhasDistLinhas { get; set; }
        public string Utilizador { get; set; }
        public byte[] F3mmarcador { get; set; }
    }
}
