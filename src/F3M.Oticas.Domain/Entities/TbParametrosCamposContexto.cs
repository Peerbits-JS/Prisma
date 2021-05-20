using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbParametrosCamposContexto
    {
        public TbParametrosCamposContexto()
        {
            TbCondicionantes = new HashSet<TbCondicionantes>();
        }

        public long Id { get; set; }
        public long IdparametroContexto { get; set; }
        public string CodigoCampo { get; set; }
        public string DescricaoCampo { get; set; }
        public byte? TipoCondicionante { get; set; }
        public long IdtipoDados { get; set; }
        public string ConteudoLista { get; set; }
        public string ValorCampo { get; set; }
        public string Accao { get; set; }
        public string AccaoExtra { get; set; }
        public string Filtro { get; set; }
        public string ValorMax { get; set; }
        public string ValorMin { get; set; }
        public bool ValorReadOnly { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbParametrosContexto IdparametroContextoNavigation { get; set; }
        public TbTiposDados IdtipoDadosNavigation { get; set; }
        public ICollection<TbCondicionantes> TbCondicionantes { get; set; }
    }
}
