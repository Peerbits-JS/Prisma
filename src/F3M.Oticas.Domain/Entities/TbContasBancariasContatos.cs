using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbContasBancariasContatos
    {
        public long Id { get; set; }
        public long? IdcontaBancaria { get; set; }
        public long? Idtipo { get; set; }
        public string Descricao { get; set; }
        public string Contato { get; set; }
        public string Telefone { get; set; }
        public string Telemovel { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public bool? Mailing { get; set; }
        public string PagWeb { get; set; }
        public string PagRedeSocial { get; set; }
        public int Ordem { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbContasBancarias IdcontaBancariaNavigation { get; set; }
        public TbTiposContatos IdtipoNavigation { get; set; }
    }
}
