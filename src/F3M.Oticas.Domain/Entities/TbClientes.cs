using F3M.Oticas.Domain.Entities.Base;
using System;
using System.Collections.Generic;

namespace F3M.Oticas.Domain.Entities
{
    public partial class TbClientes : EntityDocumentBase
    {
        public TbClientes()
        {
            TbAgendamento = new HashSet<TbAgendamento>();
            TbClientesAnexos = new HashSet<TbClientesAnexos>();
            TbClientesContatos = new HashSet<TbClientesContatos>();
            TbClientesLojas = new HashSet<TbClientesLojas>();
            TbClientesMoradas = new HashSet<TbClientesMoradas>();
            TbDocumentosStock = new HashSet<StockDocument>();
            TbDocumentosVendas = new HashSet<SaleDocument>();
            TbEntidades = new HashSet<TbEntidades>();
            TbExames = new HashSet<TbExames>();
            TbPagamentosVendasLinhas = new HashSet<TbPagamentosVendasLinhas>();
            TbRecibos = new HashSet<ReceiptDocument>();
            TbRecibosLinhas = new HashSet<ReceiptDocumentLine>();
            TbTiposDocumento = new HashSet<TbTiposDocumento>();
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
        public long? IdsegmentoMercado { get; set; }
        public long? IdsetorAtividade { get; set; }
        public long IdprecoSugerido { get; set; }
        public long? Idvendedor { get; set; }
        public long? IdformaExpedicao { get; set; }
        public long? IdtipoPessoa { get; set; }
        public long IdespacoFiscal { get; set; }
        public long IdregimeIva { get; set; }
        public long? IdlocalOperacao { get; set; }
        public long Idpais { get; set; }
        public long Ididioma { get; set; }
        public long? Idsexo { get; set; }
        public string Contabilidade { get; set; }
        public long Prioridade { get; set; }
        public long? IdemissaoFatura { get; set; }
        public long? IdemissaoPackingList { get; set; }
        public string Nib { get; set; }
        public bool RegimeEspecial { get; set; }
        public bool EfetuaRetencao { get; set; }
        public bool ControloCredito { get; set; }
        public bool EmitePedidoLiquidacao { get; set; }
        public bool IvaCaixa { get; set; }
        public string Observacoes { get; set; }
        public string Avisos { get; set; }
        public double Desconto1 { get; set; }
        public double Desconto2 { get; set; }
        public double Comissao1 { get; set; }
        public double Comissao2 { get; set; }
        public double? Plafond { get; set; }
        public long? NmaximoDiasAtraso { get; set; }
        public string Ncontribuinte { get; set; }
        public long? Identidade1 { get; set; }
        public string NumeroBeneficiario1 { get; set; }
        public long? Identidade2 { get; set; }
        public string NumeroBeneficiario2 { get; set; }
        public long? IdmedicoTecnico { get; set; }
        public double Saldo { get; set; }
        public double TotalVendas { get; set; }
        public string Parentesco1 { get; set; }
        public string Parentesco2 { get; set; }
        public bool? Esquecido { get; set; }

        public TbClientes IdNavigation { get; set; }
        public TbCondicoesPagamento IdcondicaoPagamentoNavigation { get; set; }
        public TbSistemaEmissaoFatura IdemissaoFaturaNavigation { get; set; }
        public TbSistemaEmissaoPackingList IdemissaoPackingListNavigation { get; set; }
        public TbEntidades Identidade1Navigation { get; set; }
        public TbEntidades Identidade2Navigation { get; set; }
        public TbSistemaEspacoFiscal IdespacoFiscalNavigation { get; set; }
        public TbFormasExpedicao IdformaExpedicaoNavigation { get; set; }
        public TbFormasPagamento IdformaPagamentoNavigation { get; set; }
        public TbIdiomas IdidiomaNavigation { get; set; }
        public TbSistemaRegioesIva IdlocalOperacaoNavigation { get; set; }
        public TbLojas IdlojaNavigation { get; set; }
        public TbMedicosTecnicos IdmedicoTecnicoNavigation { get; set; }
        public TbMoedas IdmoedaNavigation { get; set; }
        public Country IdpaisNavigation { get; set; }
        public TbSistemaCodigosPrecos IdprecoSugeridoNavigation { get; set; }
        public TbProfissoes IdprofissaoNavigation { get; set; }
        public TbSistemaRegimeIva IdregimeIvaNavigation { get; set; }
        public TbSegmentosMercado IdsegmentoMercadoNavigation { get; set; }
        public TbSetoresAtividade IdsetorAtividadeNavigation { get; set; }
        public SystemSex IdsexoNavigation { get; set; }
        public SystemEntityType IdtipoEntidadeNavigation { get; set; }
        public TbSistemaTiposPessoa IdtipoPessoaNavigation { get; set; }
        public TbClientes InverseIdNavigation { get; set; }
        public ICollection<TbAgendamento> TbAgendamento { get; set; }
        public ICollection<TbClientesAnexos> TbClientesAnexos { get; set; }
        public ICollection<TbClientesContatos> TbClientesContatos { get; set; }
        public ICollection<TbClientesLojas> TbClientesLojas { get; set; }
        public ICollection<TbClientesMoradas> TbClientesMoradas { get; set; }
        public ICollection<StockDocument> TbDocumentosStock { get; set; }
        public ICollection<SaleDocument> TbDocumentosVendas { get; set; }
        public ICollection<TbEntidades> TbEntidades { get; set; }
        public ICollection<TbExames> TbExames { get; set; }
        public ICollection<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }
        public ICollection<ReceiptDocument> TbRecibos { get; set; }
        public ICollection<ReceiptDocumentLine> TbRecibosLinhas { get; set; }
        public ICollection<TbTiposDocumento> TbTiposDocumento { get; set; }
    }
}
