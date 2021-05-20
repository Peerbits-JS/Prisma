using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposServicos
    {
        public TbSistemaTiposServicos()
        {
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbServicos = new HashSet<TbServicos>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public bool PorDefeito { get; set; }

        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<TbServicos> TbServicos { get; set; }
    }
}
