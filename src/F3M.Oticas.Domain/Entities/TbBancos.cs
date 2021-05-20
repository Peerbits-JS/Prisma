using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbBancos
    {
        public TbBancos()
        {
            TbBancosContatos = new HashSet<TbBancosContatos>();
            TbBancosMoradas = new HashSet<TbBancosMoradas>();
            TbContasBancarias = new HashSet<TbContasBancarias>();
        }

        public long Id { get; set; }
        public long? Idloja { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public string Sigla { get; set; }
        public string CodigoBp { get; set; }
        public string PaisIban { get; set; }
        public string BicSwift { get; set; }
        public string NomeFichSepa { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbLojas IdlojaNavigation { get; set; }
        public ICollection<TbBancosContatos> TbBancosContatos { get; set; }
        public ICollection<TbBancosMoradas> TbBancosMoradas { get; set; }
        public ICollection<TbContasBancarias> TbContasBancarias { get; set; }
    }
}
