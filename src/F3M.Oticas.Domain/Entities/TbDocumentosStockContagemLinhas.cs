using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbDocumentosStockContagemLinhas
    {
        public long Id { get; set; }
        public long IddocumentoStockContagem { get; set; }
        public long Idartigo { get; set; }
        public string CodigoArtigo { get; set; }
        public string DescricaoArtigo { get; set; }
        public long? Idlote { get; set; }
        public string CodigoLote { get; set; }
        public string DescricaoLote { get; set; }
        public double? PvmoedaRef { get; set; }
        public long Idunidade { get; set; }
        public string CodigoUnidade { get; set; }
        public string DescricaoUnidade { get; set; }
        public double QuantidadeEmStock { get; set; }
        public double QuantidadeContada { get; set; }
        public double QuantidadeDiferenca { get; set; }
        public double? PrecoUnitario { get; set; }
        public bool? Alterada { get; set; }
        public int Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime? DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public Product IdartigoNavigation { get; set; }
        public TbDocumentosStockContagem IddocumentoStockContagemNavigation { get; set; }
        public TbArtigosLotes IdloteNavigation { get; set; }
        public TbUnidades IdunidadeNavigation { get; set; }
    }
}
