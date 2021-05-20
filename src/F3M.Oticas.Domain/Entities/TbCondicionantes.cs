using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbCondicionantes
    {
        public long Id { get; set; }
        public long IdparametroCamposContexto { get; set; }
        public string CampoCondicionante { get; set; }
        public string ValorCondicionante { get; set; }
        public string ValorPorDefeito { get; set; }
        public string TipoValorPorDefeito { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbParametrosCamposContexto IdparametroCamposContextoNavigation { get; set; }
    }
}
