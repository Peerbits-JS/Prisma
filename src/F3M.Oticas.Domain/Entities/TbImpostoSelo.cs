using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbImpostoSelo
    {
        public TbImpostoSelo()
        {
            TbArtigos = new HashSet<Product>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long IdverbaIs { get; set; }
        public double? Percentagem { get; set; }
        public double? Valor { get; set; }
        public double? LimiteMinimo { get; set; }
        public double? LimiteMaximo { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaVerbasIs IdverbaIsNavigation { get; set; }
        public ICollection<Product> TbArtigos { get; set; }
    }
}
