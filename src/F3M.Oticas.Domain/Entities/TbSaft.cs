using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSaft
    {
        public long Id { get; set; }
        public string Ficheiro { get; set; }
        public string Caminho { get; set; }
        public string Versao { get; set; }
        public DateTime? DataInicio { get; set; }
        public DateTime? DataFim { get; set; }
        public bool FacturacaoMensal { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long? TipoSaft { get; set; }
        public long? Idloja { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
    }
}
