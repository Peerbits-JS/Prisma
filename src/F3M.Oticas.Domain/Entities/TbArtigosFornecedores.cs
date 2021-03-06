using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbArtigosFornecedores
    {
        public long Id { get; set; }
        public long Idartigo { get; set; }
        public long Idfornecedor { get; set; }
        public string Referencia { get; set; }
        public string CodigoBarras { get; set; }
        public int Ordem { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbFornecedores IdfornecedorNavigation { get; set; }
    }
}
