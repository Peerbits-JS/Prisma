using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaAcoes
    {
        public TbSistemaAcoes()
        {
            TbMedicosTecnicos = new HashSet<TbMedicosTecnicos>();
            TbTiposDocumentoIdsistemaAcoesNavigation = new HashSet<TbTiposDocumento>();
            TbTiposDocumentoIdsistemaAcoesReposicaoStockNavigation = new HashSet<TbTiposDocumento>();
            TbTiposDocumentoIdsistemaAcoesRupturaStockNavigation = new HashSet<TbTiposDocumento>();
            TbTiposDocumentoIdsistemaAcoesStockMaximoNavigation = new HashSet<TbTiposDocumento>();
            TbTiposDocumentoIdsistemaAcoesStockMinimoNavigation = new HashSet<TbTiposDocumento>();
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

        public ICollection<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumentoIdsistemaAcoesNavigation { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumentoIdsistemaAcoesReposicaoStockNavigation { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumentoIdsistemaAcoesRupturaStockNavigation { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumentoIdsistemaAcoesStockMaximoNavigation { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumentoIdsistemaAcoesStockMinimoNavigation { get; set; }
    }
}
