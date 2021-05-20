using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbSistemaTiposAnexos
    {
        public TbSistemaTiposAnexos()
        {
            TbArtigosAnexos = new HashSet<TbArtigosAnexos>();
            TbClientesAnexos = new HashSet<TbClientesAnexos>();
            TbDocumentosComprasAnexos = new HashSet<TbDocumentosComprasAnexos>();
            TbDocumentosStockAnexos = new HashSet<TbDocumentosStockAnexos>();
            TbDocumentosStockContagemAnexos = new HashSet<TbDocumentosStockContagemAnexos>();
            TbDocumentosVendasAnexos = new HashSet<TbDocumentosVendasAnexos>();
            TbEntidadesAnexos = new HashSet<TbEntidadesAnexos>();
            TbExamesAnexos = new HashSet<TbExamesAnexos>();
            TbFornecedoresAnexos = new HashSet<TbFornecedoresAnexos>();
            TbMedicosTecnicosAnexos = new HashSet<TbMedicosTecnicosAnexos>();
            TbPagamentosComprasAnexos = new HashSet<TbPagamentosComprasAnexos>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long IdentidadeF3m { get; set; }
        public long IdtipoExtensaoFicheiro { get; set; }
        public int? TamanhoMaximoFicheiro { get; set; }
        public bool Sistema { get; set; }
        public bool? Ativo { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaEntidadesF3m IdentidadeF3mNavigation { get; set; }
        public TbSistemaTiposExtensoesFicheiros IdtipoExtensaoFicheiroNavigation { get; set; }
        public ICollection<TbArtigosAnexos> TbArtigosAnexos { get; set; }
        public ICollection<TbClientesAnexos> TbClientesAnexos { get; set; }
        public ICollection<TbDocumentosComprasAnexos> TbDocumentosComprasAnexos { get; set; }
        public ICollection<TbDocumentosStockAnexos> TbDocumentosStockAnexos { get; set; }
        public ICollection<TbDocumentosStockContagemAnexos> TbDocumentosStockContagemAnexos { get; set; }
        public ICollection<TbDocumentosVendasAnexos> TbDocumentosVendasAnexos { get; set; }
        public ICollection<TbEntidadesAnexos> TbEntidadesAnexos { get; set; }
        public ICollection<TbExamesAnexos> TbExamesAnexos { get; set; }
        public ICollection<TbFornecedoresAnexos> TbFornecedoresAnexos { get; set; }
        public ICollection<TbMedicosTecnicosAnexos> TbMedicosTecnicosAnexos { get; set; }
        public ICollection<TbPagamentosComprasAnexos> TbPagamentosComprasAnexos { get; set; }
    }
}
