using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbIdiomas
    {
        public TbIdiomas()
        {
            TbArtigosIdiomas = new HashSet<TbArtigosIdiomas>();
            TbClientes = new HashSet<TbClientes>();
            TbComposicoesIdiomas = new HashSet<TbComposicoesIdiomas>();
            TbCondicoesPagamentoIdiomas = new HashSet<TbCondicoesPagamentoIdiomas>();
            TbFormasExpedicaoIdiomas = new HashSet<TbFormasExpedicaoIdiomas>();
            TbFormasPagamentoIdiomas = new HashSet<TbFormasPagamentoIdiomas>();
            TbFornecedores = new HashSet<TbFornecedores>();
            TbSegmentosMercadoIdiomas = new HashSet<TbSegmentosMercadoIdiomas>();
            TbSetoresAtividadeIdiomas = new HashSet<TbSetoresAtividadeIdiomas>();
            TbTiposDocumentoIdioma = new HashSet<TbTiposDocumentoIdioma>();
        }

        public long Id { get; set; }
        public string Codigo { get; set; }
        public long Idcultura { get; set; }
        public string Descricao { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbSistemaIdiomas IdculturaNavigation { get; set; }
        public ICollection<TbArtigosIdiomas> TbArtigosIdiomas { get; set; }
        public ICollection<TbClientes> TbClientes { get; set; }
        public ICollection<TbComposicoesIdiomas> TbComposicoesIdiomas { get; set; }
        public ICollection<TbCondicoesPagamentoIdiomas> TbCondicoesPagamentoIdiomas { get; set; }
        public ICollection<TbFormasExpedicaoIdiomas> TbFormasExpedicaoIdiomas { get; set; }
        public ICollection<TbFormasPagamentoIdiomas> TbFormasPagamentoIdiomas { get; set; }
        public ICollection<TbFornecedores> TbFornecedores { get; set; }
        public ICollection<TbSegmentosMercadoIdiomas> TbSegmentosMercadoIdiomas { get; set; }
        public ICollection<TbSetoresAtividadeIdiomas> TbSetoresAtividadeIdiomas { get; set; }
        public ICollection<TbTiposDocumentoIdioma> TbTiposDocumentoIdioma { get; set; }
    }
}
