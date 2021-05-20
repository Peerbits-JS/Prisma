using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbTiposDados
    {
        public TbTiposDados()
        {
            TbParametrosCamposContexto = new HashSet<TbParametrosCamposContexto>();
            TbSistemaTiposDocumentoColunasAutomaticas = new HashSet<TbSistemaTiposDocumentoColunasAutomaticas>();
        }

        public long Id { get; set; }
        public string Descricao { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbParametrosCamposContexto> TbParametrosCamposContexto { get; set; }
        public ICollection<TbSistemaTiposDocumentoColunasAutomaticas> TbSistemaTiposDocumentoColunasAutomaticas { get; set; }
    }
}
