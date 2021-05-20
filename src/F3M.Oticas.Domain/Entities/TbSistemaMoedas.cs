using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaMoedas
    {
        public TbSistemaMoedas()
        {
            TbDocumentosStockContagem = new HashSet<TbDocumentosStockContagem>();
            TbMoedas = new HashSet<TbMoedas>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public byte? CasasDecimaisTotais { get; set; }
        public byte? CasasDecimaisIva { get; set; }
        public byte? CasasDecimaisPrecosUnitarios { get; set; }

        public ICollection<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        public ICollection<TbMoedas> TbMoedas { get; set; }
    }
}
