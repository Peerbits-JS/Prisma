using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosPrecos
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long IdcodigoPreco { get; set; }
        public double? ValorComIva { get; set; }
        public double? ValorSemIva { get; set; }
        public double? Upcpercentagem { get; set; }
        public long? Idunidade { get; set; }
        public bool Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long Ordem { get; set; }
        public long? Idloja { get; set; }

        //public TbArtigosPrecos IdNavigation { get; set; }
        public Product IdartigoNavigation { get; set; }
        public TbSistemaCodigosPrecos IdcodigoPrecoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbUnidades IdunidadeNavigation { get; set; }
        //public TbArtigosPrecos InverseIdNavigation { get; set; }
    }
}
