using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbDocumentosStockContagem
    {
        public TbDocumentosStockContagem()
        {
            TbDocumentosStockContagemAnexos = new HashSet<TbDocumentosStockContagemAnexos>();
            TbDocumentosStockContagemLinhas = new HashSet<TbDocumentosStockContagemLinhas>();
        }

        public long Id { get; set; }
        public string Documento { get; set; }
        public long NumeroDocumento { get; set; }
        public DateTime DataDocumento { get; set; }
        public long IdtipoDocumento { get; set; }
        public long? Idarmazem { get; set; }
        public long Idestado { get; set; }
        public long? Idmoeda { get; set; }
        public double? TaxaConversao { get; set; }
        public long? IdtiposDocumentoSeries { get; set; }
        public long? NumeroInterno { get; set; }
        public long? Idlocalizacao { get; set; }
        public string Filtro { get; set; }
        public string Observacoes { get; set; }
        public double? FaltamContar { get; set; }
        public double? Contados { get; set; }
        public double? Diferencas { get; set; }
        public long? Idloja { get; set; }
        public DateTime? DataControloInterno { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbArmazens IdarmazemNavigation { get; set; }
        public State IdestadoNavigation { get; set; }
        public TbArmazensLocalizacoes IdlocalizacaoNavigation { get; set; }
        public TbSistemaMoedas IdmoedaNavigation { get; set; }
        public TbTiposDocumento IdtipoDocumentoNavigation { get; set; }
        public TbTiposDocumentoSeries IdtiposDocumentoSeriesNavigation { get; set; }
        public ICollection<TbDocumentosStockContagemAnexos> TbDocumentosStockContagemAnexos { get; set; }
        public ICollection<TbDocumentosStockContagemLinhas> TbDocumentosStockContagemLinhas { get; set; }
    }
}
