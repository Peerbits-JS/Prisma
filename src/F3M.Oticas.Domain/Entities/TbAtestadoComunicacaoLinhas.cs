using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbAtestadoComunicacaoLinhas
    {
        public long Id { get; set; }
        public long IdatestadoComunicacao { get; set; }
        public long? ReturnCode { get; set; }
        public string ReturnMessage { get; set; }
        public string AtdocCodeId { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public DateTime? DataHoraPedido { get; set; }
        public string Acao { get; set; }
        public string Xmlresposta { get; set; }
        public string XmlpedidoAt { get; set; }
        public string XmlrespostaAt { get; set; }

        public TbAtestadoComunicacao IdatestadoComunicacaoNavigation { get; set; }
    }
}
