using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbFornecedores : EntityDocumentBase
    {
        public TbFornecedores()
        {
            TbArtigosFornecedores = new HashSet<TbArtigosFornecedores>();
            TbDocumentosCompras = new HashSet<PurchaseDocument>();
            TbFornecedoresAnexos = new HashSet<TbFornecedoresAnexos>();
            TbFornecedoresContatos = new HashSet<TbFornecedoresContatos>();
            TbFornecedoresMoradas = new HashSet<TbFornecedoresMoradas>();
            TbFornecedoresTiposFornecimento = new HashSet<TbFornecedoresTiposFornecimento>();
            TbPagamentosCompras = new HashSet<ProviderPaymentDocument>();
            TbPagamentosComprasLinhas = new HashSet<ProviderPaymentDocumentLine>();
        }

        public long? Idloja { get; set; }
        
        public string Nome { get; set; }
        public string Foto { get; set; }
        public string FotoCaminho { get; set; }
        public DateTime? DataValidade { get; set; }
        public DateTime? DataNascimento { get; set; }
        public long IdtipoEntidade { get; set; }
        public string Apelido { get; set; }
        public string Abreviatura { get; set; }
        public string CartaoCidadao { get; set; }
        public string TituloAcademico { get; set; }
        public long? Idprofissao { get; set; }
        public long Idmoeda { get; set; }
        public long IdformaPagamento { get; set; }
        public long IdcondicaoPagamento { get; set; }
        public long? IdtipoPessoa { get; set; }
        public long IdespacoFiscal { get; set; }
        public long IdregimeIva { get; set; }
        public long? IdlocalOperacao { get; set; }
        public long? Idpais { get; set; }
        public long? Ididioma { get; set; }
        public long? Idsexo { get; set; }
        public string Contabilidade { get; set; }
        public string CodIq { get; set; }
        public string Nib { get; set; }
        public long Idfornecimento { get; set; }
        public bool RegimeEspecial { get; set; }
        public bool EfetuaRetencao { get; set; }
        public bool IvaCaixa { get; set; }
        public string Observacoes { get; set; }
        public string Avisos { get; set; }
        public double Desconto1 { get; set; }
        public double Desconto2 { get; set; }
        public string Ncontribuinte { get; set; }
        public double? Saldo { get; set; }
        public bool? Esquecido { get; set; }

        public TbCondicoesPagamento IdcondicaoPagamentoNavigation { get; set; }
        public TbSistemaEspacoFiscal IdespacoFiscalNavigation { get; set; }
        public TbFormasPagamento IdformaPagamentoNavigation { get; set; }
        public TbIdiomas IdidiomaNavigation { get; set; }
        public TbSistemaRegioesIva IdlocalOperacaoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public Country IdpaisNavigation { get; set; }
        public TbProfissoes IdprofissaoNavigation { get; set; }
        public TbSistemaRegimeIva IdregimeIvaNavigation { get; set; }
        public SystemSex IdsexoNavigation { get; set; }
        public SystemEntityType IdtipoEntidadeNavigation { get; set; }
        public TbSistemaTiposPessoa IdtipoPessoaNavigation { get; set; }
        public ICollection<TbArtigosFornecedores> TbArtigosFornecedores { get; set; }
        public ICollection<PurchaseDocument> TbDocumentosCompras { get; set; }
        public ICollection<TbFornecedoresAnexos> TbFornecedoresAnexos { get; set; }
        public ICollection<TbFornecedoresContatos> TbFornecedoresContatos { get; set; }
        public ICollection<TbFornecedoresMoradas> TbFornecedoresMoradas { get; set; }
        public ICollection<TbFornecedoresTiposFornecimento> TbFornecedoresTiposFornecimento { get; set; }
        public ICollection<ProviderPaymentDocument> TbPagamentosCompras { get; set; }
        public ICollection<ProviderPaymentDocumentLine> TbPagamentosComprasLinhas { get; set; }
    }
}
