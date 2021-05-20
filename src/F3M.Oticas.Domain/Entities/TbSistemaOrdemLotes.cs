using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaOrdemLotes
    {
        public TbSistemaOrdemLotes()
        {
            TbArtigosIdordemLoteApresentarNavigation = new HashSet<Product>();
            TbArtigosIdordemLoteMovEntradaNavigation = new HashSet<Product>();
            TbArtigosIdordemLoteMovSaidaNavigation = new HashSet<Product>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public bool? Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<Product> TbArtigosIdordemLoteApresentarNavigation { get; set; }
        public ICollection<Product> TbArtigosIdordemLoteMovEntradaNavigation { get; set; }
        public ICollection<Product> TbArtigosIdordemLoteMovSaidaNavigation { get; set; }
    }
}
