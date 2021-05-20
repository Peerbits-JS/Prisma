using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaNaturezas
    {
        public TbSistemaNaturezas()
        {
            TbDocumentosComprasPendentes = new HashSet<TbDocumentosComprasPendentes>();
            TbDocumentosVendasPendentes = new HashSet<TbDocumentosVendasPendentes>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string Modulo { get; set; }
        public string TipoDoc { get; set; }
        public bool Sistema { get; set; }
        public bool Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public ICollection<TbDocumentosComprasPendentes> TbDocumentosComprasPendentes { get; set; }
        public ICollection<TbDocumentosVendasPendentes> TbDocumentosVendasPendentes { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }
    }
}
