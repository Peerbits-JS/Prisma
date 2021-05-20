using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbServicos
    {
        public TbServicos()
        {
            TbDocumentosVendasLinhas = new HashSet<SaleDocumentLine>();
            TbDocumentosVendasLinhasGraduacoes = new HashSet<TbDocumentosVendasLinhasGraduacoes>();
            TbServicosFases = new HashSet<TbServicosFases>();
        }

        public long Id { get; set; }
        public int Ordem { get; set; }
        public long IdtipoServico { get; set; }
        public long? IdmedicoTecnico { get; set; }
        public DateTime? DataReceita { get; set; }
        public DateTime? DataEntregaLonge { get; set; }
        public DateTime? DataEntregaPerto { get; set; }
        public bool? VerPrismas { get; set; }
        public bool? VisaoIntermedia { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long IdtipoServicoOlho { get; set; }
        public bool? CombinacaoDefeito { get; set; }
        public string BoxLonge { get; set; }
        public string BoxPerto { get; set; }
        public long? IddocumentoVenda { get; set; }

        public SaleDocument IddocumentoVendaNavigation { get; set; }
        public TbMedicosTecnicos IdmedicoTecnicoNavigation { get; set; }
        public TbSistemaTiposServicos IdtipoServicoNavigation { get; set; }
        public ICollection<SaleDocumentLine> TbDocumentosVendasLinhas { get; set; }
        public ICollection<TbDocumentosVendasLinhasGraduacoes> TbDocumentosVendasLinhasGraduacoes { get; set; }
        public ICollection<TbServicosFases> TbServicosFases { get; set; }
    }
}
