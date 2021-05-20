using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbAtestadoComunicacao
    {
        public TbAtestadoComunicacao()
        {
            TbAtestadoComunicacaoLinhas = new HashSet<TbAtestadoComunicacaoLinhas>();
        }

        public long Id { get; set; }
        public long? Iddocumento { get; set; }
        public long? IdtipoDocumento { get; set; }
        public string TipoDocumento { get; set; }
        public long? Idserie { get; set; }
        public string Serie { get; set; }
        public long? Ano { get; set; }
        public long? Numero { get; set; }
        public DateTime? DataDocumento { get; set; }
        public long? TipoEntidade { get; set; }
        public string CodigoEntidade { get; set; }
        public string NomeEntidade { get; set; }
        public long? ReturnCode { get; set; }
        public string ReturnMessage { get; set; }
        public string AtdocCodeId { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataHoraPedido { get; set; }
        public string TipoDocumentoDescricao { get; set; }
        public bool? Selecionado { get; set; }
        public long? Idloja { get; set; }
        public string CodigoLoja { get; set; }
        public string NomeLoja { get; set; }
        public string Acao { get; set; }
        public string Xmlresposta { get; set; }
        public DateTime? DataHoraCarga { get; set; }
        public bool Manual { get; set; }
        public string XmlpedidoAt { get; set; }
        public string XmlrespostaAt { get; set; }
        public string StrTabela { get; set; }

        public TbTiposDocumentoSeries IdserieNavigation { get; set; }
        public TbTiposDocumento IdtipoDocumentoNavigation { get; set; }
        public ICollection<TbAtestadoComunicacaoLinhas> TbAtestadoComunicacaoLinhas { get; set; }
    }
}
