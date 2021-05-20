using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbContasBancarias
    {
        public TbContasBancarias()
        {
            TbContasBancariasContatos = new HashSet<TbContasBancariasContatos>();
            TbContasBancariasMoradas = new HashSet<TbContasBancariasMoradas>();
        }

        public long Id { get; set; }
        public long? Idloja { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public long Idbanco { get; set; }
        public long Idmoeda { get; set; }
        public double? Plafond { get; set; }
        public double? TaxaPlafond { get; set; }
        public string PaisIban { get; set; }
        public string Nib { get; set; }
        public string SepaPrv { get; set; }
        public string VariavelContabilidade { get; set; }
        public bool ContaCaixa { get; set; }
        public double? SaldoTotal { get; set; }
        public double? SaldoReconciliado { get; set; }
        public string Observacoes { get; set; }
        public bool? Ativo { get; set; }
        public bool Sistema { get; set; }
        public DateTime DataCriacao { get; set; }
        public string UtilizadorCriacao { get; set; }
        public DateTime? DataAlteracao { get; set; }
        public string UtilizadorAlteracao { get; set; }
        public byte[] F3mmarcador { get; set; }

        public TbBancos IdbancoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public ICollection<TbContasBancariasContatos> TbContasBancariasContatos { get; set; }
        public ICollection<TbContasBancariasMoradas> TbContasBancariasMoradas { get; set; }
    }
}
