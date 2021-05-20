using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbEntidades
    {
        public TbEntidades()
        {
            TbClientesIdentidade1Navigation = new HashSet<TbClientes>();
            TbClientesIdentidade2Navigation = new HashSet<TbClientes>();
            TbDocumentosVendasIdentidade1Navigation = new HashSet<SaleDocument>();
            TbDocumentosVendasIdentidade2Navigation = new HashSet<SaleDocument>();
            TbEntidadesAnexos = new HashSet<TbEntidadesAnexos>();
            TbEntidadesComparticipacoes = new HashSet<TbEntidadesComparticipacoes>();
            TbEntidadesContatos = new HashSet<TbEntidadesContatos>();
            TbEntidadesLojas = new HashSet<TbEntidadesLojas>();
            TbEntidadesMoradas = new HashSet<TbEntidadesMoradas>();
        }

        public long Id { get; set; }
        public long? Idloja { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string Abreviatura { get; set; }
        public string Foto { get; set; }
        public string FotoCaminho { get; set; }
        public string Ncontribuinte { get; set; }
        public string Contabilidade { get; set; }
        public long IdtipoEntidade { get; set; }
        public long IdtipoDescricao { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }
        public long? IdclienteEntidade { get; set; }

        public TbClientes IdclienteEntidadeNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbSistemaEntidadeDescricao IdtipoDescricaoNavigation { get; set; }
        public TbSistemaEntidadeComparticipacao IdtipoEntidadeNavigation { get; set; }
        public ICollection<TbClientes> TbClientesIdentidade1Navigation { get; set; }
        public ICollection<TbClientes> TbClientesIdentidade2Navigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdentidade1Navigation { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendasIdentidade2Navigation { get; set; }
        public ICollection<TbEntidadesAnexos> TbEntidadesAnexos { get; set; }
        public ICollection<TbEntidadesComparticipacoes> TbEntidadesComparticipacoes { get; set; }
        public ICollection<TbEntidadesContatos> TbEntidadesContatos { get; set; }
        public ICollection<TbEntidadesLojas> TbEntidadesLojas { get; set; }
        public ICollection<TbEntidadesMoradas> TbEntidadesMoradas { get; set; }
    }
}
