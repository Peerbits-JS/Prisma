using F3M.Core.Domain.Entity;
using F3M.Oticas.Data.Mapping;
using F3M.Oticas.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Context
{
    public partial class OticasContext : DbContext
    {

        private readonly string _connectionString;
        private readonly string _user;

        public OticasContext(string connectionString, string user)
        {
            _connectionString = connectionString;
            _user = user;
        }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default(CancellationToken))
        {
            SetDefaultPropertirOnEntities();
            return await base.SaveChangesAsync(cancellationToken);
        }

        public override int SaveChanges()
        {
            SetDefaultPropertirOnEntities();
            return base.SaveChanges();
        }

        private void SetDefaultPropertirOnEntities()
        {
            var entries = ChangeTracker.Entries<EntityBase>();

            if (entries != null)
            {
                foreach (var entry in entries)
                {
                    if (entry.State == EntityState.Added)
                    {
                        entry.Entity.UpdatedAt = null;
                        entry.Entity.CreatedAt = DateTime.Now;
                        entry.Entity.CreatedBy = _user;
                    }

                    if (entry.State == EntityState.Modified)
                    {
                        entry.Property(prop => prop.CreatedAt).IsModified = false;
                        entry.Property(prop => prop.CreatedBy).IsModified = false;

                        entry.Entity.UpdatedAt = DateTime.Now;
                        entry.Entity.UpdatedBy = _user;
                    }
                }
            }
        }
        public virtual DbSet<AccountingConfiguration> AccountingConfiguration { get; set; }
        public virtual DbSet<AccountingConfigurationDetail> AccountingConfigurationDetail { get; set; }
        public virtual DbSet<AccountingConfigurationModule> AccountingConfigurationModules { get; set; }
        public virtual DbSet<AccountingConfigurationType> AccountingConfigurationTypes { get; set; }
        public virtual DbSet<AccountingConfigurationDocumentTypeValues> AccountingConfigurationDocumentTypeValues { get; set; }
        public virtual DbSet<Product> Product { get; set; }
        public virtual DbSet<SaleDocument> SalesDocument { get; set; }
        public virtual DbSet<StockDocument> StockDocument { get; set; }
        public virtual DbSet<PurchaseDocument> PurchaseDocument { get; set; }
        public virtual DbSet<TbArmazens> Warehouse { get; set; }
        public virtual DbSet<TbClientes> Customer { get; set; }
        public virtual DbSet<TbEntidades> Entity { get; set; } 
        public virtual DbSet<TbFormasPagamento> PaymentType { get; set; }
        public virtual DbSet<TbFornecedores> Provider { get; set; }
        public virtual DbSet<TbLojas> Store { get; set; }
        public virtual DbSet<Country> Country { get; set; }
        public virtual DbSet<Vat> Vat { get; set; }
        public virtual DbSet<TbTiposArtigos> ProductType { get; set; }
        public virtual DbSet<PurchaseDocumentLine> PurchaseDocumentLine { get; set; }
        public virtual DbSet<StockDocumentLine> StockDocumentLine { get; set; }
        public virtual DbSet<SaleDocumentLine> SalesDocumentLine { get; set; }
        public virtual DbSet<TbUnidades> Unit { get; set; }
        public virtual DbSet<TbArtigosUnidades> UnitProduct { get; set; }
        public virtual DbSet<TbTiposDocumento> DocumentType { get; set; }
        public virtual DbSet<CurrentAccountStockProduct> CurrentAccountStockProduct { get; set; }
        public virtual DbSet<TbCodigosPostais> ZipCode { get; set; }
        public virtual DbSet<ProviderPaymentDocument> ProviderPaymentDocument { get; set; }
        public virtual DbSet<ProviderPaymentDocumentLine> ProviderPaymentDocumentLine { get; set; }
        public virtual DbSet<ProviderPaymentDocumentPaymentType> ProviderPaymentDocumentPaymentType { get; set; }
        public virtual DbSet<TbIvaregioes> VatRegions { get; set; }
        public virtual DbSet<TbMapasVistas> MapView { get; set; }
        public virtual DbSet<TbTiposConsultas> MedicalExamTypes { get ; set; }
        public virtual DbSet<TbUnidadesRelacoes> UnitRelations { get; set; }
        public virtual DbSet<TbArtigosDadosFinanceiros> ProductFinancialData { get; set; }
        public virtual DbSet<TbArtigosDadosFinanceirosPvsUpcperc> ProductFinancialDataPvsUpcperc { get; set; }
        public virtual DbSet<TbArtigosArmazensLocalizacoes> ProductWarehouseLocation { get; set; }
        public virtual DbSet<TbArmazensLocalizacoes> WarehouseLocation { get; set; }
        public virtual DbSet<TbTiposDocumentoSeries> TbTiposDocumentoSeries { get; set; }
        public virtual DbSet<AccountingExport> AccountingExport { get; set; }
        public virtual DbSet<State> States { get; set; }
        public virtual DbSet<SaleDocumentPaymentType> TbDocumentosVendasFormasPagamento { get; set; }
        public virtual DbSet<ReceiptDocument> ReceiptDocuments { get; set; }
        public virtual DbSet<ReceiptDocumentLine> ReceiptDocumentsLine { get; set; }
        public virtual DbSet<ReceiptDocumentPaymentType> ReceiptDocumentPaymentType { get; set; }

        //SYSTEM
        public virtual DbSet<SystemEntityState> SystemEntityState { get; set; }
        public virtual DbSet<SystemEntityType> SystemEntityType { get; set; }
        public virtual DbSet<SystemSex> SystemSex { get; set; }
        public virtual DbSet<SystemStateType> SystemStateType { get; set; }
        

        //public virtual DbSet<TbAgendamento> TbAgendamento { get; set; }

        //public virtual DbSet<TbAros> TbAros { get; set; }
        //public virtual DbSet<TbArtigosAnexos> TbArtigosAnexos { get; set; }

        //public virtual DbSet<TbArtigosEspecificos> TbArtigosEspecificos { get; set; }
        //public virtual DbSet<TbArtigosFornecedores> TbArtigosFornecedores { get; set; }
        //public virtual DbSet<TbArtigosIdiomas> TbArtigosIdiomas { get; set; }
        //public virtual DbSet<TbArtigosImpostoSelo> TbArtigosImpostoSelo { get; set; }
        //public virtual DbSet<TbArtigosLotes> TbArtigosLotes { get; set; }
        //public virtual DbSet<TbArtigosNumerosSeries> TbArtigosNumerosSeries { get; set; }
        //public virtual DbSet<TbArtigosPrecos> TbArtigosPrecos { get; set; }
        //public virtual DbSet<TbArtigosStock> TbArtigosStock { get; set; }

        //public virtual DbSet<TbAtestadoComunicacao> TbAtestadoComunicacao { get; set; }
        //public virtual DbSet<TbAtestadoComunicacaoLinhas> TbAtestadoComunicacaoLinhas { get; set; }
        //public virtual DbSet<TbBancos> TbBancos { get; set; }
        //public virtual DbSet<TbBancosContatos> TbBancosContatos { get; set; }
        //public virtual DbSet<TbBancosMoradas> TbBancosMoradas { get; set; }
        //public virtual DbSet<TbCampanhas> TbCampanhas { get; set; }
        //public virtual DbSet<TbCcentidades> TbCcentidades { get; set; }
        //public virtual DbSet<TbCcfornecedores> TbCcfornecedores { get; set; }


        //public virtual DbSet<TbClientesAnexos> TbClientesAnexos { get; set; }
        //public virtual DbSet<TbClientesContatos> TbClientesContatos { get; set; }
        //public virtual DbSet<TbClientesLojas> TbClientesLojas { get; set; }
        //public virtual DbSet<TbClientesMoradas> TbClientesMoradas { get; set; }
        //public virtual DbSet<TbComposicoes> TbComposicoes { get; set; }
        //public virtual DbSet<TbComposicoesIdiomas> TbComposicoesIdiomas { get; set; }
        //public virtual DbSet<TaxAuthorityComunication> TaxAuthority { get; set; }
        //public virtual DbSet<TaxAuthorityComunicationProduct> TaxAuthorityComunicationProduct { get; set; }
        //public virtual DbSet<TbConcelhos> TbConcelhos { get; set; }
        //public virtual DbSet<TbCondicionantes> TbCondicionantes { get; set; }
        //public virtual DbSet<TbCondicoesPagamento> TbCondicoesPagamento { get; set; }
        //public virtual DbSet<TbCondicoesPagamentoDescontos> TbCondicoesPagamentoDescontos { get; set; }
        //public virtual DbSet<TbCondicoesPagamentoIdiomas> TbCondicoesPagamentoIdiomas { get; set; }
        //public virtual DbSet<TbConsentimentos> TbConsentimentos { get; set; }
        //public virtual DbSet<TbContasBancarias> TbContasBancarias { get; set; }
        //public virtual DbSet<TbContasBancariasContatos> TbContasBancariasContatos { get; set; }
        //public virtual DbSet<TbContasBancariasMoradas> TbContasBancariasMoradas { get; set; }
        //public virtual DbSet<TbCoresLentes> TbCoresLentes { get; set; }
        //public virtual DbSet<TbDistritos> TbDistritos { get; set; }

        //public virtual DbSet<TbDocumentosComprasAnexos> TbDocumentosComprasAnexos { get; set; }
        //public virtual DbSet<TbDocumentosComprasPendentes> TbDocumentosComprasPendentes { get; set; }

        //public virtual DbSet<TbDocumentosStockAnexos> TbDocumentosStockAnexos { get; set; }
        //public virtual DbSet<TbDocumentosStockContagem> TbDocumentosStockContagem { get; set; }
        //public virtual DbSet<TbDocumentosStockContagemAnexos> TbDocumentosStockContagemAnexos { get; set; }
        //public virtual DbSet<TbDocumentosStockContagemLinhas> TbDocumentosStockContagemLinhas { get; set; }

        //
        //public virtual DbSet<TbDocumentosVendasAnexos> TbDocumentosVendasAnexos { get; set; }
        //public virtual DbSet<TbDocumentosVendasFormasPagamento> TbDocumentosVendasFormasPagamento { get; set; }

        //public virtual DbSet<TbDocumentosVendasLinhasGraduacoes> TbDocumentosVendasLinhasGraduacoes { get; set; }
        //public virtual DbSet<TbDocumentosVendasPendentes> TbDocumentosVendasPendentes { get; set; }

        //public virtual DbSet<TbEntidadesAnexos> TbEntidadesAnexos { get; set; }
        //public virtual DbSet<TbEntidadesComparticipacoes> TbEntidadesComparticipacoes { get; set; }
        //public virtual DbSet<TbEntidadesContatos> TbEntidadesContatos { get; set; }
        //public virtual DbSet<TbEntidadesLojas> TbEntidadesLojas { get; set; }
        //public virtual DbSet<TbEntidadesMoradas> TbEntidadesMoradas { get; set; }
        //public virtual DbSet<TbEscaloes> TbEscaloes { get; set; }
        //public virtual DbSet<TbEscaloesEspecificos> TbEscaloesEspecificos { get; set; }
        //public virtual DbSet<TbEscaloesGerais> TbEscaloesGerais { get; set; }
        //public virtual DbSet<TbEscaloesPenalizacoes> TbEscaloesPenalizacoes { get; set; }
        //public virtual DbSet<TbEspecialidades> TbEspecialidades { get; set; }
        //public virtual DbSet<TbEstacoes> TbEstacoes { get; set; }
        //public virtual DbSet<TbEstados> TbEstados { get; set; }
        //public virtual DbSet<TbExames> TbExames { get; set; }
        //public virtual DbSet<TbExamesAnexos> TbExamesAnexos { get; set; }
        //public virtual DbSet<TbExamesProps> TbExamesProps { get; set; }
        //public virtual DbSet<TbExamesPropsFotos> TbExamesPropsFotos { get; set; }
        //public virtual DbSet<TbExamesTemplate> TbExamesTemplate { get; set; }
        //public virtual DbSet<TbF3mrecalculo> TbF3mrecalculo { get; set; }
        //public virtual DbSet<TbFamilias> TbFamilias { get; set; }
        //public virtual DbSet<TbFormasExpedicao> TbFormasExpedicao { get; set; }
        //public virtual DbSet<TbFormasExpedicaoIdiomas> TbFormasExpedicaoIdiomas { get; set; }

        //public virtual DbSet<TbFormasPagamentoIdiomas> TbFormasPagamentoIdiomas { get; set; }

        //public virtual DbSet<TbFornecedoresAnexos> TbFornecedoresAnexos { get; set; }
        //public virtual DbSet<TbFornecedoresContatos> TbFornecedoresContatos { get; set; }
        //public virtual DbSet<TbFornecedoresMoradas> TbFornecedoresMoradas { get; set; }
        //public virtual DbSet<TbFornecedoresTiposFornecimento> TbFornecedoresTiposFornecimento { get; set; }
        //public virtual DbSet<TbGamasLentes> TbGamasLentes { get; set; }
        //public virtual DbSet<TbGruposArtigo> TbGruposArtigo { get; set; }
        //public virtual DbSet<TbIdiomas> TbIdiomas { get; set; }
        //public virtual DbSet<TbImpostoSelo> TbImpostoSelo { get; set; }

        //public virtual DbSet<TbIvadescontos> TbIvadescontos { get; set; }

        //public virtual DbSet<TbLentesContato> TbLentesContato { get; set; }
        //public virtual DbSet<TbLentesOftalmicas> TbLentesOftalmicas { get; set; }
        //public virtual DbSet<TbLentesOftalmicasSuplementos> TbLentesOftalmicasSuplementos { get; set; }

        //public virtual DbSet<TbMapaCaixa> TbMapaCaixa { get; set; }

        //public virtual DbSet<TbMarcas> TbMarcas { get; set; }
        //public virtual DbSet<TbMedicosTecnicos> TbMedicosTecnicos { get; set; }
        //public virtual DbSet<TbMedicosTecnicosAnexos> TbMedicosTecnicosAnexos { get; set; }
        //public virtual DbSet<TbMedicosTecnicosContatos> TbMedicosTecnicosContatos { get; set; }
        //public virtual DbSet<TbMedicosTecnicosEspecialidades> TbMedicosTecnicosEspecialidades { get; set; }
        //public virtual DbSet<TbMedicosTecnicosMoradas> TbMedicosTecnicosMoradas { get; set; }
        //public virtual DbSet<TbModelos> TbModelos { get; set; }
        //public virtual DbSet<TbMoedas> TbMoedas { get; set; }
        //public virtual DbSet<TbOculosSol> TbOculosSol { get; set; }
        //public virtual DbSet<TbPagamentosComprasAnexos> TbPagamentosComprasAnexos { get; set; }
        //public virtual DbSet<TbPagamentosComprasFormasPagamento> TbPagamentosComprasFormasPagamento { get; set; }
        //public virtual DbSet<TbPagamentosComprasLinhas> TbPagamentosComprasLinhas { get; set; }
        //public virtual DbSet<TbPagamentosVendas> TbPagamentosVendas { get; set; }
        //public virtual DbSet<TbPagamentosVendasFormasPagamento> TbPagamentosVendasFormasPagamento { get; set; }
        //public virtual DbSet<TbPagamentosVendasLinhas> TbPagamentosVendasLinhas { get; set; }

        //public virtual DbSet<TbParametrizacaoConsentimentos> TbParametrizacaoConsentimentos { get; set; }
        //public virtual DbSet<TbParametrizacaoConsentimentosCamposEntidade> TbParametrizacaoConsentimentosCamposEntidade { get; set; }
        //public virtual DbSet<TbParametrizacaoConsentimentosPerguntas> TbParametrizacaoConsentimentosPerguntas { get; set; }
        //public virtual DbSet<TbParametrosCamposContexto> TbParametrosCamposContexto { get; set; }
        //public virtual DbSet<TbParametrosContexto> TbParametrosContexto { get; set; }
        //public virtual DbSet<TbParametrosEmpresa> TbParametrosEmpresa { get; set; }
        //public virtual DbSet<TbParametrosEmpresaCae> TbParametrosEmpresaCae { get; set; }
        //public virtual DbSet<TbParametrosLoja> TbParametrosLoja { get; set; }
        //public virtual DbSet<TbParametrosLojaLinhas> TbParametrosLojaLinhas { get; set; }
        //public virtual DbSet<TbParametrosLojaLinhasValores> TbParametrosLojaLinhasValores { get; set; }
        //public virtual DbSet<TbPlaneamento> TbPlaneamento { get; set; }
        //public virtual DbSet<TbPrecosLentes> TbPrecosLentes { get; set; }
        //public virtual DbSet<TbProfissoes> TbProfissoes { get; set; }
        //public virtual DbSet<TbRazoes> TbRazoes { get; set; }
        //public virtual DbSet<TbRecibos> TbRecibos { get; set; }
        //public virtual DbSet<TbRecibosFormasPagamento> TbRecibosFormasPagamento { get; set; }
        //public virtual DbSet<TbRecibosLinhas> TbRecibosLinhas { get; set; }
        //public virtual DbSet<TbRecibosLinhasTaxas> TbRecibosLinhasTaxas { get; set; }
        //public virtual DbSet<TbRespostasConsentimentos> TbRespostasConsentimentos { get; set; }
        //public virtual DbSet<TbSaft> TbSaft { get; set; }
        //public virtual DbSet<TbSegmentosMercado> TbSegmentosMercado { get; set; }
        //public virtual DbSet<TbSegmentosMercadoIdiomas> TbSegmentosMercadoIdiomas { get; set; }
        //public virtual DbSet<TbSemafroGereStock> TbSemafroGereStock { get; set; }
        //public virtual DbSet<TbServicos> TbServicos { get; set; }
        //public virtual DbSet<TbServicosFases> TbServicosFases { get; set; }
        //public virtual DbSet<TbSetoresAtividade> TbSetoresAtividade { get; set; }
        //public virtual DbSet<TbSetoresAtividadeIdiomas> TbSetoresAtividadeIdiomas { get; set; }
        //public virtual DbSet<TbSistemaAcoes> TbSistemaAcoes { get; set; }
        //public virtual DbSet<TbSistemaCamposFormulas> TbSistemaCamposFormulas { get; set; }
        //public virtual DbSet<TbSistemaClassificacoesTiposArtigos> TbSistemaClassificacoesTiposArtigos { get; set; }
        //public virtual DbSet<TbSistemaClassificacoesTiposArtigosGeral> TbSistemaClassificacoesTiposArtigosGeral { get; set; }
        //public virtual DbSet<TbSistemaCodigosIva> TbSistemaCodigosIva { get; set; }
        //public virtual DbSet<TbSistemaCodigosPrecos> TbSistemaCodigosPrecos { get; set; }
        //public virtual DbSet<TbSistemaCompostoTransformacaoMetodoCusto> TbSistemaCompostoTransformacaoMetodoCusto { get; set; }
        //public virtual DbSet<TbSistemaEmissaoFatura> TbSistemaEmissaoFatura { get; set; }
        //public virtual DbSet<TbSistemaEmissaoPackingList> TbSistemaEmissaoPackingList { get; set; }
        //public virtual DbSet<TbSistemaEntidadeComparticipacao> TbSistemaEntidadeComparticipacao { get; set; }
        //public virtual DbSet<TbSistemaEntidadeDescricao> TbSistemaEntidadeDescricao { get; set; }
        //public virtual DbSet<TbSistemaEntidadesEstados> TbSistemaEntidadesEstados { get; set; }
        //public virtual DbSet<TbSistemaEntidadesF3m> TbSistemaEntidadesF3m { get; set; }
        //public virtual DbSet<TbSistemaEntidadesFormulas> TbSistemaEntidadesFormulas { get; set; }
        //public virtual DbSet<TbSistemaEspacoFiscal> TbSistemaEspacoFiscal { get; set; }
        //public virtual DbSet<TbSistemaEstadoCivil> TbSistemaEstadoCivil { get; set; }
        //public virtual DbSet<TbSistemaFormasCalculoComissoes> TbSistemaFormasCalculoComissoes { get; set; }
        //public virtual DbSet<TbSistemaFormatoUnidadeTempo> TbSistemaFormatoUnidadeTempo { get; set; }
        //public virtual DbSet<TbSistemaFuncionalidadesConsentimento> TbSistemaFuncionalidadesConsentimento { get; set; }
        //public virtual DbSet<TbSistemaIdiomas> TbSistemaIdiomas { get; set; }
        //public virtual DbSet<TbSistemaMateriasLentes> TbSistemaMateriasLentes { get; set; }
        //public virtual DbSet<TbSistemaModulos> TbSistemaModulos { get; set; }
        //public virtual DbSet<TbSistemaMoedas> TbSistemaMoedas { get; set; }
        //public virtual DbSet<TbSistemaNaturezas> TbSistemaNaturezas { get; set; }
        //public virtual DbSet<TbSistemaOrdemLotes> TbSistemaOrdemLotes { get; set; }
        //public virtual DbSet<TbSistemaParametrosLoja> TbSistemaParametrosLoja { get; set; }
        //public virtual DbSet<TbSistemaParentesco> TbSistemaParentesco { get; set; }
        //public virtual DbSet<TbSistemaRegimeIva> TbSistemaRegimeIva { get; set; }
        //public virtual DbSet<TbSistemaRegioesIva> TbSistemaRegioesIva { get; set; }
        //public virtual DbSet<TbSistemaRelacaoEspacoFiscalRegimeIva> TbSistemaRelacaoEspacoFiscalRegimeIva { get; set; }
        //public virtual DbSet<TbSistemaSexo> TbSistemaSexo { get; set; }
        //public virtual DbSet<TbSistemaSiglasPaises> TbSistemaSiglasPaises { get; set; }
        //public virtual DbSet<TbSistemaSuperficiesLentes> TbSistemaSuperficiesLentes { get; set; }
        //public virtual DbSet<TbSistemaTipoDistMatPrima> TbSistemaTipoDistMatPrima { get; set; }
        //public virtual DbSet<TbSistemaTipoDistOperacoes> TbSistemaTipoDistOperacoes { get; set; }
        //public virtual DbSet<TbSistemaTipoOp> TbSistemaTipoOp { get; set; }
        //public virtual DbSet<TbSistemaTipoOperacoes> TbSistemaTipoOperacoes { get; set; }
        //public virtual DbSet<TbSistemaTiposAnexos> TbSistemaTiposAnexos { get; set; }
        //public virtual DbSet<TbSistemaTiposComposicoes> TbSistemaTiposComposicoes { get; set; }
        //public virtual DbSet<TbSistemaTiposCondDataVencimento> TbSistemaTiposCondDataVencimento { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumento> TbSistemaTiposDocumento { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoColunasAutomaticas> TbSistemaTiposDocumentoColunasAutomaticas { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoComunicacao> TbSistemaTiposDocumentoComunicacao { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoFiscal> TbSistemaTiposDocumentoFiscal { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoImportacao> TbSistemaTiposDocumentoImportacao { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoMovStock> TbSistemaTiposDocumentoMovStock { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoOrigem> TbSistemaTiposDocumentoOrigem { get; set; }
        //public virtual DbSet<TbSistemaTiposDocumentoPrecoUnitario> TbSistemaTiposDocumentoPrecoUnitario { get; set; }
        //public virtual DbSet<TbSistemaTiposEntidade> TbSistemaTiposEntidade { get; set; }
        //public virtual DbSet<TbSistemaTiposEntidadeModulos> TbSistemaTiposEntidadeModulos { get; set; }
        //public virtual DbSet<TbSistemaTiposEstados> TbSistemaTiposEstados { get; set; }
        //public virtual DbSet<TbSistemaTiposEtiquetas> TbSistemaTiposEtiquetas { get; set; }
        //public virtual DbSet<TbSistemaTiposExtensoesFicheiros> TbSistemaTiposExtensoesFicheiros { get; set; }
        //public virtual DbSet<TbSistemaTiposFormasPagamento> TbSistemaTiposFormasPagamento { get; set; }
        //public virtual DbSet<TbSistemaTiposGraduacoes> TbSistemaTiposGraduacoes { get; set; }
        //public virtual DbSet<TbSistemaTiposIva> TbSistemaTiposIva { get; set; }
        //public virtual DbSet<TbSistemaTiposLentes> TbSistemaTiposLentes { get; set; }
        //public virtual DbSet<TbSistemaTiposLinhasMp> TbSistemaTiposLinhasMp { get; set; }
        //public virtual DbSet<TbSistemaTiposLiquidacao> TbSistemaTiposLiquidacao { get; set; }
        //public virtual DbSet<TbSistemaTiposMaquinas> TbSistemaTiposMaquinas { get; set; }
        //public virtual DbSet<TbSistemaTiposOlhos> TbSistemaTiposOlhos { get; set; }
        //public virtual DbSet<TbSistemaTiposPessoa> TbSistemaTiposPessoa { get; set; }
        //public virtual DbSet<TbSistemaTiposPrecos> TbSistemaTiposPrecos { get; set; }
        //public virtual DbSet<TbSistemaTiposServicos> TbSistemaTiposServicos { get; set; }
        //public virtual DbSet<TbSistemaTiposTextoBase> TbSistemaTiposTextoBase { get; set; }
        //public virtual DbSet<TbSistemaVerbasIs> TbSistemaVerbasIs { get; set; }
        //public virtual DbSet<TbStockArtigos> TbStockArtigos { get; set; }
        //public virtual DbSet<TbStockArtigosNecessidades> TbStockArtigosNecessidades { get; set; }
        //public virtual DbSet<TbSubFamilias> TbSubFamilias { get; set; }
        //public virtual DbSet<TbSuplementosLentes> TbSuplementosLentes { get; set; }
        //public virtual DbSet<TbTemplates> TbTemplates { get; set; }
        //public virtual DbSet<TbTextosBase> TbTextosBase { get; set; }

        //public virtual DbSet<TbTiposContatos> TbTiposContatos { get; set; }
        //public virtual DbSet<TbTiposDados> TbTiposDados { get; set; }

        //public virtual DbSet<DocumentTypes> DocumentTypes { get; set; }        
        //public virtual DbSet<TbTiposDocumentoIdioma> TbTiposDocumentoIdioma { get; set; }

        //public virtual DbSet<TbTiposDocumentoSeriesPermissoes> TbTiposDocumentoSeriesPermissoes { get; set; }
        //public virtual DbSet<TbTiposDocumentoTipEntPermDoc> TbTiposDocumentoTipEntPermDoc { get; set; }
        //public virtual DbSet<TbTiposFases> TbTiposFases { get; set; }
        //public virtual DbSet<TbTiposFornecimentos> TbTiposFornecimentos { get; set; }
        //public virtual DbSet<TbTiposRelacao> TbTiposRelacao { get; set; }
        //public virtual DbSet<TbTiposRetencao> TbTiposRetencao { get; set; }
        //public virtual DbSet<TbTratamentosLentes> TbTratamentosLentes { get; set; }
        //public virtual DbSet<TbUnidadesTempo> TbUnidadesTempo { get; set; }
        //public virtual DbSet<TbVersao> TbVersao { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(_connectionString);
                optionsBuilder.ConfigureWarnings(warnings => warnings.Ignore());
            }

            optionsBuilder.EnableSensitiveDataLogging(true);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new ProductMap());
            modelBuilder.ApplyConfiguration(new TaxAuthorityMap());
            modelBuilder.ApplyConfiguration(new TaxAuthorityProductMap());
            modelBuilder.ApplyConfiguration(new AccountingConfigurationMap());
            modelBuilder.ApplyConfiguration(new AccountingConfigurationDetailMap());
            modelBuilder.ApplyConfiguration(new AccountingConfigurationModulesMap());
            modelBuilder.ApplyConfiguration(new AccountingConfigurationTypesMap());
            modelBuilder.ApplyConfiguration(new AccountingConfigurationDocumentTypeValuesMap());
            modelBuilder.ApplyConfiguration(new PurchaseDocumentMap());
            modelBuilder.ApplyConfiguration(new SaleDocumentMap());
            modelBuilder.ApplyConfiguration(new StockDocumentMap());
            modelBuilder.ApplyConfiguration(new WarehouseMap());
            modelBuilder.ApplyConfiguration(new CustomerMap());
            modelBuilder.ApplyConfiguration(new EntityMap());
            modelBuilder.ApplyConfiguration(new PaymentTypeMap());
            modelBuilder.ApplyConfiguration(new ProviderMap());
            modelBuilder.ApplyConfiguration(new StoreMap());
            modelBuilder.ApplyConfiguration(new CountryMap());
            modelBuilder.ApplyConfiguration(new VatMap());
            modelBuilder.ApplyConfiguration(new ProductTypeMap());
            modelBuilder.ApplyConfiguration(new PurchaseDocumentLineMap());
            modelBuilder.ApplyConfiguration(new SaleDocumentLineMap());
            modelBuilder.ApplyConfiguration(new StockDocumentLineMap());
            modelBuilder.ApplyConfiguration(new UnitMap());
            modelBuilder.ApplyConfiguration(new UnitProductMap());
            modelBuilder.ApplyConfiguration(new DocumentTypeMap());
            modelBuilder.ApplyConfiguration(new CurrentAccountStockProductMap());
            modelBuilder.ApplyConfiguration(new ZipCodeMap());
            modelBuilder.ApplyConfiguration(new ProviderPaymentDocumentMap());
            modelBuilder.ApplyConfiguration(new ProviderPaymentDocumentLineMap());
            modelBuilder.ApplyConfiguration(new ProviderPaymentDocumentPaymentTypeMap());
            modelBuilder.ApplyConfiguration(new VatRegionsMap());
            modelBuilder.ApplyConfiguration(new MapViewMap());
            modelBuilder.ApplyConfiguration(new MedicalExamTypesMap());
            modelBuilder.ApplyConfiguration(new UnitRelationsMap());
            modelBuilder.ApplyConfiguration(new ProductFinancialDataMap());
            modelBuilder.ApplyConfiguration(new ProductFinancialDataPvsUpcpercMap());
            modelBuilder.ApplyConfiguration(new ProductWarehouseLocationMap());
            modelBuilder.ApplyConfiguration(new WarehouseLocationMap());
            modelBuilder.ApplyConfiguration(new DocumentTypeSeriesMap());
            modelBuilder.ApplyConfiguration(new AccountingExportMap());
            modelBuilder.ApplyConfiguration(new StatesMap());
            modelBuilder.ApplyConfiguration(new SaleDocumentPaymentTypeMap());
            modelBuilder.ApplyConfiguration(new ReceiptDocumentMap());
            modelBuilder.ApplyConfiguration(new ReceiptDocumentLineMap());
            modelBuilder.ApplyConfiguration(new ReceiptDocumentPaymentTypeMap());
            
            //SYSTEM
            modelBuilder.ApplyConfiguration(new SystemEntityStateMap());
            modelBuilder.ApplyConfiguration(new SystemEntityTypeMap());
            modelBuilder.ApplyConfiguration(new SystemStateTypesMap());
            modelBuilder.ApplyConfiguration(new SystemSexMap());
            //modelBuilder.Entity<TbAgendamento>(entity =>
            //{
            //    entity.ToTable("tbAgendamento");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contacto).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.End).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.Idespecialidade).HasColumnName("IDEspecialidade");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.Nome).HasMaxLength(256);

            //    entity.Property(e => e.Observacoes).HasMaxLength(256);

            //    entity.Property(e => e.Start).HasColumnType("datetime");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbAgendamento)
            //        .HasForeignKey(d => d.Idcliente)
            //        .HasConstraintName("FK_tbAgendamento_tbClientes");

            //    entity.HasOne(d => d.IdespecialidadeNavigation)
            //        .WithMany(p => p.TbAgendamento)
            //        .HasForeignKey(d => d.Idespecialidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbAgendamento_tbEspecialidades");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbAgendamento)
            //        .HasForeignKey(d => d.Idloja)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbAgendamento_tbLojas");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbAgendamento)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbAgendamento_tbMedicosTecnicos");
            //});



            //modelBuilder.Entity<TbAros>(entity =>
            //{
            //    entity.ToTable("tbAros");

            //    entity.HasIndex(e => new { e.Idmodelo, e.CodigoCor, e.Tamanho, e.Hastes })
            //        .HasName("IX_tbAros")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoCor).HasMaxLength(50);

            //    entity.Property(e => e.CorGenerica).HasMaxLength(50);

            //    entity.Property(e => e.CorLente).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Hastes).HasMaxLength(50);

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.Tamanho).HasMaxLength(50);

            //    entity.Property(e => e.TipoLente).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Frames)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbAros_tbArtigos");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbAros)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbAros_IDModelo");
            //});

            //modelBuilder.Entity<TbArtigosAnexos>(entity =>
            //{
            //    entity.ToTable("tbArtigosAnexos");

            //    entity.HasIndex(e => new { e.Idartigo, e.Ficheiro })
            //        .HasName("IX_tbArtigosAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Attachments)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosAnexos_tbArtigos");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbArtigosAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbArtigosAnexos_tbSistemaTiposAnexos");
            //});







            //modelBuilder.Entity<TbArtigosEspecificos>(entity =>
            //{
            //    entity.ToTable("tbArtigosEspecificos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Dtex).HasColumnName("DTEX");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idestacao).HasColumnName("IDEstacao");

            //    entity.Property(e => e.Ne).HasColumnName("NE");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdestacaoNavigation)
            //        .WithMany(p => p.TbArtigosEspecificos)
            //        .HasForeignKey(d => d.Idestacao)
            //        .HasConstraintName("FK_tbArtigosEspecificos_tbEstacoes");
            //});

            //modelBuilder.Entity<TbArtigosFornecedores>(entity =>
            //{
            //    entity.ToTable("tbArtigosFornecedores");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoBarras).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idfornecedor).HasColumnName("IDFornecedor");

            //    entity.Property(e => e.Referencia).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Providers)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosFornecedores_tbArtigos");

            //    entity.HasOne(d => d.IdfornecedorNavigation)
            //        .WithMany(p => p.TbArtigosFornecedores)
            //        .HasForeignKey(d => d.Idfornecedor)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosFornecedores_tbFornecedores");
            //});

            //modelBuilder.Entity<TbArtigosIdiomas>(entity =>
            //{
            //    entity.ToTable("tbArtigosIdiomas");

            //    entity.HasIndex(e => new { e.Idartigo, e.Ididioma })
            //        .HasName("IX_tbArtigosIdiomas")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(100);

            //    entity.Property(e => e.DescricaoAbreviada).HasMaxLength(20);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Languages)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosIdiomas_tbArtigos");

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbArtigosIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosIdiomas_tbIdiomas");
            //});

            //modelBuilder.Entity<TbArtigosImpostoSelo>(entity =>
            //{
            //    entity.ToTable("tbArtigosImpostoSelo");

            //    entity.Property(e => e.Id).HasColumnName("ID");
            //});

            //modelBuilder.Entity<TbArtigosLotes>(entity =>
            //{
            //    entity.ToTable("tbArtigosLotes");

            //    entity.HasIndex(e => new { e.Idartigo, e.Codigo })
            //        .HasName("IX_tbArtigosLotes")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.DataFabrico).HasColumnType("datetime");

            //    entity.Property(e => e.DataValidade).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Lots)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosLotes_tbArtigos");
            //});

            //modelBuilder.Entity<TbArtigosNumerosSeries>(entity =>
            //{
            //    entity.ToTable("tbArtigosNumerosSeries");

            //    entity.HasIndex(e => new { e.Idartigo, e.NumeroSerie })
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.NumeroSerie)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.SerialNumbers)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosNumerosSeries_IDArtigo");
            //});

            //modelBuilder.Entity<TbArtigosPrecos>(entity =>
            //{
            //    entity.ToTable("tbArtigosPrecos");

            //    entity.HasIndex(e => new { e.IdcodigoPreco, e.Idunidade, e.Idartigo, e.Idloja })
            //        .HasName("IX_tbArtigosPrecos")
            //        .IsUnique();

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedOnAdd();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdcodigoPreco).HasColumnName("IDCodigoPreco");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            //    entity.Property(e => e.Upcpercentagem).HasColumnName("UPCPercentagem");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.HasOne(d => d.IdNavigation)
            //        .WithOne(p => p.InverseIdNavigation)
            //        .HasForeignKey<TbArtigosPrecos>(d => d.Id)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosPrecos_tbArtigosPrecos");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Prices)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosPrecos_tbArtigos");

            //    entity.HasOne(d => d.IdcodigoPrecoNavigation)
            //        .WithMany(p => p.TbArtigosPrecos)
            //        .HasForeignKey(d => d.IdcodigoPreco)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbArtigosPrecos_tbSistemaCodigosPrecos");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbArtigosPrecos)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbArtigosPrecos_tbLojas");

            //    entity.HasOne(d => d.IdunidadeNavigation)
            //        .WithMany(p => p.TbArtigosPrecos)
            //        .HasForeignKey(d => d.Idunidade)
            //        .HasConstraintName("FK_tbArtigosPrecos_tbUnidades");
            //});

            //modelBuilder.Entity<TbArtigosStock>(entity =>
            //{
            //    entity.ToTable("tbArtigosStock");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.PrimeiraEntrada).HasColumnType("datetime");

            //    entity.Property(e => e.PrimeiraSaida).HasColumnType("datetime");

            //    entity.Property(e => e.UltimaEntrada).HasColumnType("datetime");

            //    entity.Property(e => e.UltimaSaida).HasColumnType("datetime");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.ProductStocks)
            //        .HasForeignKey(d => d.Idartigo)
            //        .HasConstraintName("FK_tbArtigosStock_tbArtigos");
            //});



            //modelBuilder.Entity<TbAtestadoComunicacao>(entity =>
            //{
            //    entity.ToTable("tbATEstadoComunicacao");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Acao).HasMaxLength(1);

            //    entity.Property(e => e.AtdocCodeId)
            //        .HasColumnName("ATDocCodeID")
            //        .HasMaxLength(255);

            //    entity.Property(e => e.CodigoEntidade).HasMaxLength(25);

            //    entity.Property(e => e.CodigoLoja).HasMaxLength(10);

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataHoraCarga).HasColumnType("datetime");

            //    entity.Property(e => e.DataHoraPedido).HasColumnType("datetime");

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idserie).HasColumnName("IDSerie");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.NomeEntidade).HasMaxLength(200);

            //    entity.Property(e => e.NomeLoja).HasMaxLength(50);

            //    entity.Property(e => e.ReturnMessage).HasMaxLength(255);

            //    entity.Property(e => e.Selecionado).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.Serie).HasMaxLength(50);

            //    entity.Property(e => e.StrTabela)
            //        .HasColumnName("strTabela")
            //        .HasMaxLength(255);

            //    entity.Property(e => e.TipoDocumento).HasMaxLength(50);

            //    entity.Property(e => e.TipoDocumentoDescricao).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorCriacao).HasMaxLength(256);

            //    entity.Property(e => e.XmlpedidoAt)
            //        .HasColumnName("XMLPedidoAT")
            //        .HasColumnType("ntext");

            //    entity.Property(e => e.Xmlresposta)
            //        .HasColumnName("XMLResposta")
            //        .HasColumnType("ntext");

            //    entity.Property(e => e.XmlrespostaAt)
            //        .HasColumnName("XMLRespostaAT")
            //        .HasColumnType("ntext");

            //    entity.HasOne(d => d.IdserieNavigation)
            //        .WithMany(p => p.TbAtestadoComunicacao)
            //        .HasForeignKey(d => d.Idserie)
            //        .HasConstraintName("FK_tbATEstadoComunicacao_tbTiposDocumentoSeries");

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbAtestadoComunicacao)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .HasConstraintName("FK_tbATEstadoComunicacao_tbTiposDocumento");
            //});

            //modelBuilder.Entity<TbAtestadoComunicacaoLinhas>(entity =>
            //{
            //    entity.ToTable("tbATEstadoComunicacaoLinhas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Acao).HasMaxLength(1);

            //    entity.Property(e => e.AtdocCodeId)
            //        .HasColumnName("ATDocCodeID")
            //        .HasMaxLength(255);

            //    entity.Property(e => e.DataHoraPedido).HasColumnType("datetime");

            //    entity.Property(e => e.IdatestadoComunicacao).HasColumnName("IDATEstadoComunicacao");

            //    entity.Property(e => e.ReturnMessage).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //    entity.Property(e => e.XmlpedidoAt)
            //        .HasColumnName("XMLPedidoAT")
            //        .HasColumnType("ntext");

            //    entity.Property(e => e.Xmlresposta)
            //        .HasColumnName("XMLResposta")
            //        .HasColumnType("ntext");

            //    entity.Property(e => e.XmlrespostaAt)
            //        .HasColumnName("XMLRespostaAT")
            //        .HasColumnType("ntext");

            //    entity.HasOne(d => d.IdatestadoComunicacaoNavigation)
            //        .WithMany(p => p.TbAtestadoComunicacaoLinhas)
            //        .HasForeignKey(d => d.IdatestadoComunicacao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbATEstadoComunicacaoLinhas_tbATEstadoComunicacao");
            //});

            //modelBuilder.Entity<TbBancos>(entity =>
            //{
            //    entity.ToTable("tbBancos");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.BicSwift).HasMaxLength(15);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.CodigoBp)
            //        .HasColumnName("CodigoBP")
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.NomeFichSepa).HasMaxLength(50);

            //    entity.Property(e => e.PaisIban).HasMaxLength(4);

            //    entity.Property(e => e.Sigla)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbBancos)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbBancos_tbLojas");
            //});

            //modelBuilder.Entity<TbBancosContatos>(entity =>
            //{
            //    entity.ToTable("tbBancosContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.Idbanco).HasColumnName("IDBanco");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdbancoNavigation)
            //        .WithMany(p => p.TbBancosContatos)
            //        .HasForeignKey(d => d.Idbanco)
            //        .HasConstraintName("FK_tbBancosContatos_tbBancos");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbBancosContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbBancosContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbBancosMoradas>(entity =>
            //{
            //    entity.ToTable("tbBancosMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.Idbanco).HasColumnName("IDBanco");

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdbancoNavigation)
            //        .WithMany(p => p.TbBancosMoradas)
            //        .HasForeignKey(d => d.Idbanco)
            //        .HasConstraintName("FK_tbBancosMoradas_tbBancos");

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbBancosMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbBancosMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbBancosMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbBancosMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbBancosMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbBancosMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbBancosMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbBancosMoradas_tbPaises");
            //});

            //modelBuilder.Entity<TbCampanhas>(entity =>
            //{
            //    entity.ToTable("tbCampanhas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbCcentidades>(entity =>
            //{
            //    entity.ToTable("tbCCEntidades");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoDocumentoSeries).HasColumnName("IDTipoDocumentoSeries");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.Natureza).HasMaxLength(2);

            //    entity.Property(e => e.NomeFiscal).HasMaxLength(255);

            //    entity.Property(e => e.NumeroDocumento).HasMaxLength(100);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbCcfornecedores>(entity =>
            //{
            //    entity.ToTable("tbCCFornecedores");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoDocumentoSeries).HasColumnName("IDTipoDocumentoSeries");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.Natureza).HasMaxLength(2);

            //    entity.Property(e => e.NomeFiscal).HasMaxLength(255);

            //    entity.Property(e => e.NumeroDocumento).HasMaxLength(100);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});


            //modelBuilder.Entity<TbClientesAnexos>(entity =>
            //{
            //    entity.ToTable("tbClientesAnexos");

            //    entity.HasIndex(e => new { e.Idcliente, e.Ficheiro })
            //        .HasName("IX_tbClientesAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbClientesAnexos)
            //        .HasForeignKey(d => d.Idcliente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbClientesAnexos_tbClientes");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbClientesAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbClientesAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbClientesContatos>(entity =>
            //{
            //    entity.ToTable("tbClientesContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbClientesContatos)
            //        .HasForeignKey(d => d.Idcliente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbClientesContatos_tbClientes");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbClientesContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbClientesContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbClientesLojas>(entity =>
            //{
            //    entity.ToTable("tbClientesLojas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbClientesLojas)
            //        .HasForeignKey(d => d.Idcliente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbClientesLojas_tbClientes");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbClientesLojas)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbClientesLojas_tbLojas");
            //});

            //modelBuilder.Entity<TbClientesMoradas>(entity =>
            //{
            //    entity.ToTable("tbClientesMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbClientesMoradas)
            //        .HasForeignKey(d => d.Idcliente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbClientesMoradas_tbClientes");

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbClientesMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbClientesMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbClientesMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbClientesMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbClientesMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbClientesMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbClientesMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbClientesMoradas_tbPaises");
            //});



            //modelBuilder.Entity<TbComposicoes>(entity =>
            //{
            //    entity.ToTable("tbComposicoes");

            //    entity.HasIndex(e => e.Ativo)
            //        .HasName("IX_tbComposicoesAtivo");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbComposicoesCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbComposicoesIdiomas>(entity =>
            //{
            //    entity.ToTable("tbComposicoesIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idcomposicao).HasColumnName("IDComposicao");

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdcomposicaoNavigation)
            //        .WithMany(p => p.TbComposicoesIdiomas)
            //        .HasForeignKey(d => d.Idcomposicao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbComposicoesIdiomas_tbComposicoes");

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbComposicoesIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbComposicoesIdiomas_tbIdiomas");
            //});

            //modelBuilder.Entity<TbConcelhos>(entity =>
            //{
            //    entity.ToTable("tbConcelhos");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbConcelhos)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbConcelhos_tbDistritos");
            //});

            //modelBuilder.Entity<TbCondicionantes>(entity =>
            //{
            //    entity.ToTable("tbCondicionantes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.CampoCondicionante).HasMaxLength(100);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdparametroCamposContexto).HasColumnName("IDParametroCamposContexto");

            //    entity.Property(e => e.TipoValorPorDefeito).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.ValorCondicionante).HasMaxLength(100);

            //    entity.Property(e => e.ValorPorDefeito).HasMaxLength(255);

            //    entity.HasOne(d => d.IdparametroCamposContextoNavigation)
            //        .WithMany(p => p.TbCondicionantes)
            //        .HasForeignKey(d => d.IdparametroCamposContexto)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCondicionantes_IDParametroCamposContexto");
            //});

            //modelBuilder.Entity<TbCondicoesPagamento>(entity =>
            //{
            //    entity.ToTable("tbCondicoesPagamento");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdtipoCondDataVencimento).HasColumnName("IDTipoCondDataVencimento");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdtipoCondDataVencimentoNavigation)
            //        .WithMany(p => p.TbCondicoesPagamento)
            //        .HasForeignKey(d => d.IdtipoCondDataVencimento)
            //        .HasConstraintName("FK_tbCondicoesPagamento_tbSistemaTiposCondDataVencimento");
            //});

            //modelBuilder.Entity<TbCondicoesPagamentoDescontos>(entity =>
            //{
            //    entity.ToTable("tbCondicoesPagamentoDescontos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.AteXdiasAposEmissao).HasColumnName("AteXDiasAposEmissao");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdcondicaoPagamento).HasColumnName("IDCondicaoPagamento");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
            //        .WithMany(p => p.TbCondicoesPagamentoDescontos)
            //        .HasForeignKey(d => d.IdcondicaoPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCondicoesPagamentoDescontos_tbCondicoesPagamento");

            //    entity.HasOne(d => d.IdtipoEntidadeNavigation)
            //        .WithMany(p => p.TbCondicoesPagamentoDescontos)
            //        .HasForeignKey(d => d.IdtipoEntidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCondicoesPagamentoDescontos_tbSistemaTiposEntidade");
            //});

            //modelBuilder.Entity<TbCondicoesPagamentoIdiomas>(entity =>
            //{
            //    entity.ToTable("tbCondicoesPagamentoIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdcondicaoPagamento).HasColumnName("IDCondicaoPagamento");

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
            //        .WithMany(p => p.TbCondicoesPagamentoIdiomas)
            //        .HasForeignKey(d => d.IdcondicaoPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCondicoesPagamentoIdiomas_tbCondicoesPagamento");

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbCondicoesPagamentoIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCondicoesPagamentoIdiomas_tbIdiomas");
            //});

            //modelBuilder.Entity<TbConsentimentos>(entity =>
            //{
            //    entity.ToTable("tbConsentimentos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoEntidade).IsRequired();

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataConsentimento).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DescricaoEntidade).IsRequired();

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro).HasMaxLength(255);

            //    entity.Property(e => e.IdcodigoEntidade)
            //        .IsRequired()
            //        .HasColumnName("IDCodigoEntidade");

            //    entity.Property(e => e.IdparametrizacaoConsentimentos).HasColumnName("IDParametrizacaoConsentimentos");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdparametrizacaoConsentimentosNavigation)
            //        .WithMany(p => p.TbConsentimentos)
            //        .HasForeignKey(d => d.IdparametrizacaoConsentimentos)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbConsentimentos_tbParametrizacaoConsentimentos");
            //});

            //modelBuilder.Entity<TbContasBancarias>(entity =>
            //{
            //    entity.ToTable("tbContasBancarias");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idbanco).HasColumnName("IDBanco");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.Nib)
            //        .HasColumnName("NIB")
            //        .HasMaxLength(30);

            //    entity.Property(e => e.PaisIban).HasMaxLength(4);

            //    entity.Property(e => e.SepaPrv).HasMaxLength(35);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);

            //    entity.HasOne(d => d.IdbancoNavigation)
            //        .WithMany(p => p.TbContasBancarias)
            //        .HasForeignKey(d => d.Idbanco)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbContasBancarias_tbBancos");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbContasBancarias)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbContasBancarias_tbLojas");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbContasBancarias)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbContasBancarias_tbMoedas");
            //});

            //modelBuilder.Entity<TbContasBancariasContatos>(entity =>
            //{
            //    entity.ToTable("tbContasBancariasContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.IdcontaBancaria).HasColumnName("IDContaBancaria");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcontaBancariaNavigation)
            //        .WithMany(p => p.TbContasBancariasContatos)
            //        .HasForeignKey(d => d.IdcontaBancaria)
            //        .HasConstraintName("FK_tbContasBancariasContatos_tbContasBancarias");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbContasBancariasContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbContasBancariasContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbContasBancariasMoradas>(entity =>
            //{
            //    entity.ToTable("tbContasBancariasMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.IdcontaBancaria).HasColumnName("IDContaBancaria");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbContasBancariasMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbContasBancariasMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbContasBancariasMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbContasBancariasMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IdcontaBancariaNavigation)
            //        .WithMany(p => p.TbContasBancariasMoradas)
            //        .HasForeignKey(d => d.IdcontaBancaria)
            //        .HasConstraintName("FK_tbContasBancariasMoradas_tbContasBancarias");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbContasBancariasMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbContasBancariasMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbContasBancariasMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbContasBancariasMoradas_tbPaises");
            //});

            //modelBuilder.Entity<TbCoresLentes>(entity =>
            //{
            //    entity.ToTable("tbCoresLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodForn).HasMaxLength(100);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Cor).HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmarca).HasColumnName("IDMarca");

            //    entity.Property(e => e.IdmateriaLente).HasColumnName("IDMateriaLente");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.IdtipoLente).HasColumnName("IDTipoLente");

            //    entity.Property(e => e.ModeloForn).HasMaxLength(50);

            //    entity.Property(e => e.Observacoes).HasMaxLength(4000);

            //    entity.Property(e => e.PrecoCusto).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.PrecoVenda).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.Referencia).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmarcaNavigation)
            //        .WithMany(p => p.TbCoresLentes)
            //        .HasForeignKey(d => d.Idmarca)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCoresLentes_tbMarcas");

            //    entity.HasOne(d => d.IdmateriaLenteNavigation)
            //        .WithMany(p => p.TbCoresLentes)
            //        .HasForeignKey(d => d.IdmateriaLente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCoresLentes_tbSistemaMateriasLentes");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbCoresLentes)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbCoresLentes_tbModelos");

            //    entity.HasOne(d => d.IdtipoLenteNavigation)
            //        .WithMany(p => p.TbCoresLentes)
            //        .HasForeignKey(d => d.IdtipoLente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbCoresLentes_tbSistemaTiposLentes");
            //});

            //modelBuilder.Entity<TbDistritos>(entity =>
            //{
            //    entity.ToTable("tbDistritos");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            ////modelBuilder.Entity<TbDocumentosCompras>(entity =>
            ////{
            ////    entity.ToTable("tbDocumentosCompras");

            ////    entity.Property(e => e.Id).HasColumnName("ID");

            ////    entity.Property(e => e.Signature).HasMaxLength(255);

            ////    entity.Property(e => e.Ativo)
            ////        .IsRequired()
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.ATCode)
            ////        .HasColumnName("CodigoAT")
            ////        .HasMaxLength(200);

            ////    entity.Property(e => e.ATInternalCode)
            ////        .HasColumnName("CodigoATInterno")
            ////        .HasMaxLength(200);

            ////    entity.Property(e => e.DocumentOriginCode).HasMaxLength(255);

            ////    entity.Property(e => e.EntityCode).HasMaxLength(20);

            ////    entity.Property(e => e.CurrencyCode).HasMaxLength(20);

            ////    entity.Property(e => e.PrintLoadZipCode).HasMaxLength(20);

            ////    entity.Property(e => e.DownloadZipCode).HasMaxLength(20);

            ////    entity.Property(e => e.PrintFiscalZipCode).HasMaxLength(10);

            ////    entity.Property(e => e.SystemUnitPricesTypeCode)
            ////        .HasColumnName("CodigoSisTiposDocPU")
            ////        .HasMaxLength(6);

            ////    entity.Property(e => e.TypeStateCode).HasMaxLength(20);

            ////    entity.Property(e => e.PrintLoadCounty).HasMaxLength(255);

            ////    entity.Property(e => e.PrintDownloadCounty).HasMaxLength(255);

            ////    entity.Property(e => e.FiscalTaxPayer).HasMaxLength(25);

            ////    entity.Property(e => e.DataAlteracao)
            ////        .HasColumnType("datetime")
            ////        .HasDefaultValueSql("(getdate())");

            ////    entity.Property(e => e.SignatureDate).HasColumnType("datetime");

            ////    entity.Property(e => e.LoadDate).HasColumnType("datetime");

            ////    entity.Property(e => e.InternalControlDate).HasColumnType("datetime");

            ////    entity.Property(e => e.DataCriacao)
            ////        .HasColumnType("datetime")
            ////        .HasDefaultValueSql("(getdate())");

            ////    entity.Property(e => e.DownloadDate).HasColumnType("datetime");

            ////    entity.Property(e => e.DocumentDate).HasColumnType("datetime");

            ////    entity.Property(e => e.DeliveryDate).HasColumnType("datetime");

            ////    entity.Property(e => e.StateTime).HasColumnType("datetime");

            ////    entity.Property(e => e.LastPrintDate).HasColumnType("datetime");

            ////    entity.Property(e => e.DueDate).HasColumnType("datetime");

            ////    entity.Property(e => e.FiscalZipCodeDescription).HasMaxLength(50);

            ////    entity.Property(e => e.FiscalCountyDescription).HasMaxLength(50);

            ////    entity.Property(e => e.FiscalCountyDescription).HasMaxLength(50);

            ////    entity.Property(e => e.PrintLoadDistrict).HasMaxLength(255);

            ////    entity.Property(e => e.PrintDownloadDistrict).HasMaxLength(255);

            ////    entity.Property(e => e.Document).HasMaxLength(255);

            ////    entity.Property(e => e.PrintFiscalSpaceCharges).HasMaxLength(50);

            ////    entity.Property(e => e.F3mmarcador)
            ////        .HasColumnName("F3MMarcador")
            ////        .IsRowVersion();

            ////    entity.Property(e => e.LoadTime).HasColumnType("datetime");

            ////    entity.Property(e => e.DownloadTime).HasColumnType("datetime");

            ////    entity.Property(e => e.IdLoadZipCode).HasColumnName("IDCodigoPostalCarga");

            ////    entity.Property(e => e.IdDownloadZipCode).HasColumnName("IDCodigoPostalDescarga");

            ////    entity.Property(e => e.IdReceiverZipCode).HasColumnName("IDCodigoPostalDestinatario");

            ////    entity.Property(e => e.IdFiscalZipCode).HasColumnName("IDCodigoPostalFiscal");

            ////    entity.Property(e => e.IdLoadCounty).HasColumnName("IDConcelhoCarga");

            ////    entity.Property(e => e.IdDownloadCounty).HasColumnName("IDConcelhoDescarga");

            ////    entity.Property(e => e.IdReceiverCounty).HasColumnName("IDConcelhoDestinatario");

            ////    entity.Property(e => e.IdFiscalCounty).HasColumnName("IDConcelhoFiscal");

            ////    entity.Property(e => e.IdPaymentType)
            ////        .HasColumnName("IDCondicaoPagamento")
            ////        .HasDefaultValueSql("((13))");

            ////    entity.Property(e => e.IdLoadDistrict).HasColumnName("IDDistritoCarga");

            ////    entity.Property(e => e.IdDownloadDistrict).HasColumnName("IDDistritoDescarga");

            ////    entity.Property(e => e.IdReceiverDistrict).HasColumnName("IDDistritoDestinatario");

            ////    entity.Property(e => e.IdFiscalDistrict).HasColumnName("IDDistritoFiscal");

            ////    entity.Property(e => e.IddocReserva).HasColumnName("IDDocReserva");

            ////    entity.Property(e => e.IdProvider)
            ////        .HasColumnName("IDEntidade")
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.IdFiscalSpace).HasColumnName("IDEspacoFiscal");

            ////    entity.Property(e => e.IdFiscalSpaceCharges).HasColumnName("IDEspacoFiscalPortes");

            ////    entity.Property(e => e.IdState).HasColumnName("IDEstado");

            ////    entity.Property(e => e.IdShippingWay).HasColumnName("IDFormaExpedicao");

            ////    entity.Property(e => e.IdOperationCode)
            ////        .HasColumnName("IDLocalOperacao")
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.IdStore).HasColumnName("IDLoja");

            ////    entity.Property(e => e.IdStoreLastPrint).HasColumnName("IDLojaUltimaImpressao");

            ////    entity.Property(e => e.IdCurrency).HasColumnName("IDMoeda");

            ////    entity.Property(e => e.IdLoadCountry).HasColumnName("IDPaisCarga");

            ////    entity.Property(e => e.IdDownloadCountry).HasColumnName("IDPaisDescarga");

            ////    entity.Property(e => e.IdFiscalCountry).HasColumnName("IDPaisFiscal");

            ////    entity.Property(e => e.IdVatScheme).HasColumnName("IDRegimeIva");

            ////    entity.Property(e => e.IdVatSchemeCharges).HasColumnName("IDRegimeIvaPortes");

            ////    entity.Property(e => e.IdSystemUnitPricesType).HasColumnName("IDSisTiposDocPU");

            ////    entity.Property(e => e.IdVatRateCharges).HasColumnName("IDTaxaIvaPortes");

            ////    entity.Property(e => e.IdDocumentType).HasColumnName("IDTipoDocumento");

            ////    entity.Property(e => e.IdEntityType)
            ////        .HasColumnName("IDTipoEntidade")
            ////        .HasDefaultValueSql("((3))");

            ////    entity.Property(e => e.IdDocumentTypeSeries).HasColumnName("IDTiposDocumentoSeries");

            ////    entity.Property(e => e.LoadPlace).HasMaxLength(50);

            ////    entity.Property(e => e.DownloadPlace).HasMaxLength(50);

            ////    entity.Property(e => e.Registry).HasMaxLength(50);

            ////    entity.Property(e => e.ATDocumentMessage)
            ////        .HasColumnName("MensagemDocAT")
            ////        .HasMaxLength(1000);

            ////    entity.Property(e => e.LoadAddress).HasMaxLength(100);

            ////    entity.Property(e => e.DownloadAdrress).HasMaxLength(100);

            ////    entity.Property(e => e.ReceiverAddress).HasMaxLength(100);

            ////    entity.Property(e => e.FiscalAddress).HasMaxLength(100);

            ////    entity.Property(e => e.ReasonForExemptionFromVat).HasMaxLength(255);

            ////    entity.Property(e => e.ReasonForExemptionFromCharges).HasMaxLength(255);

            ////    entity.Property(e => e.ReceiverName).HasMaxLength(100);

            ////    entity.Property(e => e.FiscalName).HasMaxLength(200);

            ////    entity.Property(e => e.ManualDocumentNumber).HasMaxLength(10);

            ////    entity.Property(e => e.Station).HasMaxLength(512);

            ////    entity.Property(e => e.StateReason).HasMaxLength(50);

            ////    entity.Property(e => e.PrintVatSchemeCharges).HasMaxLength(50);

            ////    entity.Property(e => e.ManualDocumentSerie).HasMaxLength(6);

            ////    entity.Property(e => e.LoadCountryAcronym).HasMaxLength(6);

            ////    entity.Property(e => e.DownloadCountryAcronym).HasMaxLength(6);

            ////    entity.Property(e => e.CountryFiscalAcronym).HasMaxLength(15);

            ////    entity.Property(e => e.FiscalType).HasMaxLength(20);

            ////    entity.Property(e => e.VatTotal).HasColumnName("TotalIVA");

            ////    entity.Property(e => e.UtilizadorAlteracao)
            ////        .HasMaxLength(20)
            ////        .HasDefaultValueSql("('')");

            ////    entity.Property(e => e.UtilizadorCriacao)
            ////        .IsRequired()
            ////        .HasMaxLength(20)
            ////        .HasDefaultValueSql("('')");

            ////    entity.Property(e => e.StateUser).HasMaxLength(20);

            ////    entity.Property(e => e.ThirdDocumentNumber).HasMaxLength(256);

            ////    entity.HasOne(d => d.LoadZipCode)
            ////        .WithMany(p => p.TbDocumentosComprasIdcodigoPostalCargaNavigation)
            ////        .HasForeignKey(d => d.IdLoadZipCode)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Carga");

            ////    entity.HasOne(d => d.DowloadZipCode)
            ////        .WithMany(p => p.TbDocumentosComprasIdcodigoPostalDescargaNavigation)
            ////        .HasForeignKey(d => d.IdDownloadZipCode)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Descarga");

            ////    entity.HasOne(d => d.ReceiverZipCode)
            ////        .WithMany(p => p.TbDocumentosComprasIdcodigoPostalDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IdReceiverZipCode)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Destinatario");

            ////    entity.HasOne(d => d.FiscalZipCode)
            ////        .WithMany(p => p.TbDocumentosComprasIdcodigoPostalFiscalNavigation)
            ////        .HasForeignKey(d => d.IdFiscalZipCode)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbCodigosPostais_Fiscal");

            ////    entity.HasOne(d => d.LoadCounty)
            ////        .WithMany(p => p.TbDocumentosComprasIdconcelhoCargaNavigation)
            ////        .HasForeignKey(d => d.IdLoadCounty)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Carga");

            ////    entity.HasOne(d => d.DownloadCounty)
            ////        .WithMany(p => p.TbDocumentosComprasIdconcelhoDescargaNavigation)
            ////        .HasForeignKey(d => d.IdDownloadCounty)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Descarga");

            ////    entity.HasOne(d => d.ReceiverCounty)
            ////        .WithMany(p => p.TbDocumentosComprasIdconcelhoDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IdReceiverCounty)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Destinatario");

            ////    entity.HasOne(d => d.FiscalCounty)
            ////        .WithMany(p => p.TbDocumentosComprasIdconcelhoFiscalNavigation)
            ////        .HasForeignKey(d => d.IdFiscalCounty)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbConcelhos_Fiscal");

            ////    entity.HasOne(d => d.PaymentType)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdPaymentType)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbCondicoesPagamento");

            ////    entity.HasOne(d => d.LoadDistrict)
            ////        .WithMany(p => p.TbDocumentosComprasIddistritoCargaNavigation)
            ////        .HasForeignKey(d => d.IdLoadDistrict)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Carga");

            ////    entity.HasOne(d => d.DownloadDistrict)
            ////        .WithMany(p => p.TbDocumentosComprasIddistritoDescargaNavigation)
            ////        .HasForeignKey(d => d.IdDownloadDistrict)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Descarga");

            ////    entity.HasOne(d => d.ReceiverDistrict)
            ////        .WithMany(p => p.TbDocumentosComprasIddistritoDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IdReceiverDistrict)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Destinatario");

            ////    entity.HasOne(d => d.FiscalDistrict)
            ////        .WithMany(p => p.TbDocumentosComprasIddistritoFiscalNavigation)
            ////        .HasForeignKey(d => d.IdFiscalDistrict)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbDistritos_Fiscal");

            ////    entity.HasOne(d => d.IddocReservaNavigation)
            ////        .WithMany(p => p.PurchaseDocuments)
            ////        .HasForeignKey(d => d.IddocReserva)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbDocumentosStockReserva");

            ////    entity.HasOne(d => d.Provider)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdProvider)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbFornecedores");

            ////    entity.HasOne(d => d.FiscalSpace)
            ////        .WithMany(p => p.TbDocumentosComprasIdespacoFiscalNavigation)
            ////        .HasForeignKey(d => d.IdFiscalSpace)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaEspacoFiscal1");

            ////    entity.HasOne(d => d.FiscalSpaceCharges)
            ////        .WithMany(p => p.TbDocumentosComprasIdespacoFiscalPortesNavigation)
            ////        .HasForeignKey(d => d.IdFiscalSpaceCharges)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaEspacoFiscal");

            ////    entity.HasOne(d => d.State)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdState)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbEstados");

            ////    entity.HasOne(d => d.ShippingWay)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdShippingWay)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbFormasExpedicao");

            ////    entity.HasOne(d => d.OperationCode)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdOperationCode)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegioesIVA");

            ////    entity.HasOne(d => d.Store)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdStore)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbLojas");

            ////    entity.HasOne(d => d.Currency)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdCurrency)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbMoedas");

            ////    entity.HasOne(d => d.LoadCountry)
            ////        .WithMany(p => p.TbDocumentosComprasIdpaisCargaNavigation)
            ////        .HasForeignKey(d => d.IdLoadCountry)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbPaises");

            ////    entity.HasOne(d => d.DownloadCountry)
            ////        .WithMany(p => p.TbDocumentosComprasIdpaisDescargaNavigation)
            ////        .HasForeignKey(d => d.IdDownloadCountry)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbPaises_Descarga");

            ////    entity.HasOne(d => d.FiscalCountry)
            ////        .WithMany(p => p.TbDocumentosComprasIdpaisFiscalNavigation)
            ////        .HasForeignKey(d => d.IdFiscalCountry)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbPaises_Fiscal");

            ////    entity.HasOne(d => d.VatScheme)
            ////        .WithMany(p => p.TbDocumentosComprasIdregimeIvaNavigation)
            ////        .HasForeignKey(d => d.IdVatScheme)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegimeIVA1");

            ////    entity.HasOne(d => d.VatSchemeCharges)
            ////        .WithMany(p => p.TbDocumentosComprasIdregimeIvaPortesNavigation)
            ////        .HasForeignKey(d => d.IdVatSchemeCharges)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaRegimeIVA");

            ////    entity.HasOne(d => d.SystemUnitPricesType)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdSystemUnitPricesType)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaTiposDocumentoPrecoUnitario");

            ////    entity.HasOne(d => d.VatRateCharges)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdVatRateCharges)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbIVA_Portes");

            ////    entity.HasOne(d => d.DocumentType)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdDocumentType)
            ////        .OnDelete(DeleteBehavior.ClientSetNull)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbTiposDocumento");

            ////    entity.HasOne(d => d.EntityType)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdEntityType)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbSistemaTiposEntidade");

            ////    entity.HasOne(d => d.DocumentTypeSeries)
            ////        .WithMany(p => p.TbDocumentosCompras)
            ////        .HasForeignKey(d => d.IdDocumentTypeSeries)
            ////        .OnDelete(DeleteBehavior.ClientSetNull)
            ////        .HasConstraintName("FK_tbDocumentosCompras_tbTiposDocumentoSeries");
            ////});

            //modelBuilder.Entity<TbDocumentosComprasAnexos>(entity =>
            //{
            //    entity.ToTable("tbDocumentosComprasAnexos");

            //    entity.HasIndex(e => new { e.IddocumentoCompra, e.Ficheiro })
            //        .HasName("IX_tbDocumentosComprasAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IddocumentoCompra).HasColumnName("IDDocumentoCompra");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IddocumentoCompraNavigation)
            //        .WithMany(p => p.Attachments)
            //        .HasForeignKey(d => d.IddocumentoCompra)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosComprasAnexos_tbDocumentosCompras");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbDocumentosComprasAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbDocumentosComprasAnexos_tbSistemaTiposAnexos");
            //});



            //modelBuilder.Entity<TbDocumentosComprasPendentes>(entity =>
            //{
            //    entity.ToTable("tbDocumentosComprasPendentes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoEntidade).HasMaxLength(200);

            //    entity.Property(e => e.Documento).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IddocumentoCompra).HasColumnName("IDDocumentoCompra");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdsistemaNaturezas).HasColumnName("IDSistemaNaturezas");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.Pago).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IddocumentoCompraNavigation)
            //        .WithMany(p => p.PendingPurchaseDocuments)
            //        .HasForeignKey(d => d.IddocumentoCompra)
            //        .HasConstraintName("FK_tbDocumentosComprasPendentes_tbDocumentosCompras");

            //    entity.HasOne(d => d.IdsistemaNaturezasNavigation)
            //        .WithMany(p => p.TbDocumentosComprasPendentes)
            //        .HasForeignKey(d => d.IdsistemaNaturezas)
            //        .HasConstraintName("FK_tbDocumentosComprasPendentes_tbSistemaNaturezas");
            //});

            ////modelBuilder.Entity<TbDocumentosStock>(entity =>
            ////{
            ////    entity.ToTable("tbDocumentosStock");

            ////    entity.Property(e => e.Id).HasColumnName("ID");

            ////    entity.Property(e => e.Assinatura).HasMaxLength(255);

            ////    entity.Property(e => e.Ativo)
            ////        .IsRequired()
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.CodigoAt)
            ////        .HasColumnName("CodigoAT")
            ////        .HasMaxLength(200);

            ////    entity.Property(e => e.CodigoAtinterno)
            ////        .HasColumnName("CodigoATInterno")
            ////        .HasMaxLength(200);

            ////    entity.Property(e => e.CodigoDocOrigem).HasMaxLength(255);

            ////    entity.Property(e => e.CodigoEntidade).HasMaxLength(20);

            ////    entity.Property(e => e.CodigoMoeda).HasMaxLength(20);

            ////    entity.Property(e => e.CodigoPostalCarga).HasMaxLength(20);

            ////    entity.Property(e => e.CodigoPostalDescarga).HasMaxLength(20);

            ////    entity.Property(e => e.CodigoPostalFiscal).HasMaxLength(10);

            ////    entity.Property(e => e.CodigoSisTiposDocPu)
            ////        .HasColumnName("CodigoSisTiposDocPU")
            ////        .HasMaxLength(6);

            ////    entity.Property(e => e.CodigoTipoEstado).HasMaxLength(20);

            ////    entity.Property(e => e.ConcelhoCarga).HasMaxLength(255);

            ////    entity.Property(e => e.ConcelhoDescarga).HasMaxLength(255);

            ////    entity.Property(e => e.ContribuinteFiscal).HasMaxLength(25);

            ////    entity.Property(e => e.DataAlteracao)
            ////        .HasColumnType("datetime")
            ////        .HasDefaultValueSql("(getdate())");

            ////    entity.Property(e => e.DataAssinatura).HasColumnType("datetime");

            ////    entity.Property(e => e.DataCarga).HasColumnType("datetime");

            ////    entity.Property(e => e.DataControloInterno).HasColumnType("datetime");

            ////    entity.Property(e => e.DataCriacao)
            ////        .HasColumnType("datetime")
            ////        .HasDefaultValueSql("(getdate())");

            ////    entity.Property(e => e.DataDescarga).HasColumnType("datetime");

            ////    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            ////    entity.Property(e => e.DataEntrega).HasColumnType("datetime");

            ////    entity.Property(e => e.DataHoraEstado).HasColumnType("datetime");

            ////    entity.Property(e => e.DataUltimaImpressao).HasColumnType("datetime");

            ////    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            ////    entity.Property(e => e.DescricaoCodigoPostalFiscal).HasMaxLength(50);

            ////    entity.Property(e => e.DescricaoConcelhoFiscal).HasMaxLength(50);

            ////    entity.Property(e => e.DescricaoDistritoFiscal).HasMaxLength(50);

            ////    entity.Property(e => e.DistritoCarga).HasMaxLength(255);

            ////    entity.Property(e => e.DistritoDescarga).HasMaxLength(255);

            ////    entity.Property(e => e.Documento).HasMaxLength(255);

            ////    entity.Property(e => e.EspacoFiscalPortes).HasMaxLength(50);

            ////    entity.Property(e => e.F3mmarcador)
            ////        .HasColumnName("F3MMarcador")
            ////        .IsRowVersion();

            ////    entity.Property(e => e.HoraCarga).HasColumnType("datetime");

            ////    entity.Property(e => e.HoraDescarga).HasColumnType("datetime");

            ////    entity.Property(e => e.IdcodigoPostalCarga).HasColumnName("IDCodigoPostalCarga");

            ////    entity.Property(e => e.IdcodigoPostalDescarga).HasColumnName("IDCodigoPostalDescarga");

            ////    entity.Property(e => e.IdcodigoPostalDestinatario).HasColumnName("IDCodigoPostalDestinatario");

            ////    entity.Property(e => e.IdcodigoPostalFiscal).HasColumnName("IDCodigoPostalFiscal");

            ////    entity.Property(e => e.IdconcelhoCarga).HasColumnName("IDConcelhoCarga");

            ////    entity.Property(e => e.IdconcelhoDescarga).HasColumnName("IDConcelhoDescarga");

            ////    entity.Property(e => e.IdconcelhoDestinatario).HasColumnName("IDConcelhoDestinatario");

            ////    entity.Property(e => e.IdconcelhoFiscal).HasColumnName("IDConcelhoFiscal");

            ////    entity.Property(e => e.IdcondicaoPagamento)
            ////        .HasColumnName("IDCondicaoPagamento")
            ////        .HasDefaultValueSql("((13))");

            ////    entity.Property(e => e.IddistritoCarga).HasColumnName("IDDistritoCarga");

            ////    entity.Property(e => e.IddistritoDescarga).HasColumnName("IDDistritoDescarga");

            ////    entity.Property(e => e.IddistritoDestinatario).HasColumnName("IDDistritoDestinatario");

            ////    entity.Property(e => e.IddistritoFiscal).HasColumnName("IDDistritoFiscal");

            ////    entity.Property(e => e.IddocReserva).HasColumnName("IDDocReserva");

            ////    entity.Property(e => e.Identidade)
            ////        .HasColumnName("IDEntidade")
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            ////    entity.Property(e => e.IdespacoFiscalPortes).HasColumnName("IDEspacoFiscalPortes");

            ////    entity.Property(e => e.Idestado).HasColumnName("IDEstado");

            ////    entity.Property(e => e.IdformaExpedicao).HasColumnName("IDFormaExpedicao");

            ////    entity.Property(e => e.IdlocalOperacao)
            ////        .HasColumnName("IDLocalOperacao")
            ////        .HasDefaultValueSql("((1))");

            ////    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            ////    entity.Property(e => e.IdlojaUltimaImpressao).HasColumnName("IDLojaUltimaImpressao");

            ////    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            ////    entity.Property(e => e.IdpaisCarga).HasColumnName("IDPaisCarga");

            ////    entity.Property(e => e.IdpaisDescarga).HasColumnName("IDPaisDescarga");

            ////    entity.Property(e => e.IdpaisFiscal).HasColumnName("IDPaisFiscal");

            ////    entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            ////    entity.Property(e => e.IdregimeIvaPortes).HasColumnName("IDRegimeIvaPortes");

            ////    entity.Property(e => e.IdsisTiposDocPu).HasColumnName("IDSisTiposDocPU");

            ////    entity.Property(e => e.IdtaxaIvaPortes).HasColumnName("IDTaxaIvaPortes");

            ////    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            ////    entity.Property(e => e.IdtipoEntidade)
            ////        .HasColumnName("IDTipoEntidade")
            ////        .HasDefaultValueSql("((3))");

            ////    entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            ////    entity.Property(e => e.LocalCarga).HasMaxLength(50);

            ////    entity.Property(e => e.LocalDescarga).HasMaxLength(50);

            ////    entity.Property(e => e.Matricula).HasMaxLength(50);

            ////    entity.Property(e => e.MensagemDocAt)
            ////        .HasColumnName("MensagemDocAT")
            ////        .HasMaxLength(1000);

            ////    entity.Property(e => e.MoradaCarga).HasMaxLength(100);

            ////    entity.Property(e => e.MoradaDescarga).HasMaxLength(100);

            ////    entity.Property(e => e.MoradaDestinatario).HasMaxLength(100);

            ////    entity.Property(e => e.MoradaFiscal).HasMaxLength(100);

            ////    entity.Property(e => e.MotivoIsencaoIva).HasMaxLength(255);

            ////    entity.Property(e => e.MotivoIsencaoPortes).HasMaxLength(255);

            ////    entity.Property(e => e.NomeDestinatario).HasMaxLength(100);

            ////    entity.Property(e => e.NomeFiscal).HasMaxLength(200);

            ////    entity.Property(e => e.NumeroDocManual).HasMaxLength(10);

            ////    entity.Property(e => e.Posto).HasMaxLength(512);

            ////    entity.Property(e => e.RazaoEstado).HasMaxLength(50);

            ////    entity.Property(e => e.RegimeIvaPortes).HasMaxLength(50);

            ////    entity.Property(e => e.SerieDocManual).HasMaxLength(6);

            ////    entity.Property(e => e.SiglaPaisCarga).HasMaxLength(6);

            ////    entity.Property(e => e.SiglaPaisDescarga).HasMaxLength(6);

            ////    entity.Property(e => e.SiglaPaisFiscal).HasMaxLength(15);

            ////    entity.Property(e => e.TipoFiscal).HasMaxLength(20);

            ////    entity.Property(e => e.TotalIva).HasColumnName("TotalIVA");

            ////    entity.Property(e => e.UtilizadorAlteracao)
            ////        .HasMaxLength(20)
            ////        .HasDefaultValueSql("('')");

            ////    entity.Property(e => e.UtilizadorCriacao)
            ////        .IsRequired()
            ////        .HasMaxLength(20)
            ////        .HasDefaultValueSql("('')");

            ////    entity.Property(e => e.UtilizadorEstado).HasMaxLength(20);

            ////    entity.Property(e => e.VossoNumeroDocumento).HasMaxLength(256);

            ////    entity.HasOne(d => d.IdcodigoPostalCargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdcodigoPostalCargaNavigation)
            ////        .HasForeignKey(d => d.IdcodigoPostalCarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Carga");

            ////    entity.HasOne(d => d.IdcodigoPostalDescargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdcodigoPostalDescargaNavigation)
            ////        .HasForeignKey(d => d.IdcodigoPostalDescarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Descarga");

            ////    entity.HasOne(d => d.IdcodigoPostalDestinatarioNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdcodigoPostalDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IdcodigoPostalDestinatario)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Destinatario");

            ////    entity.HasOne(d => d.IdcodigoPostalFiscalNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdcodigoPostalFiscalNavigation)
            ////        .HasForeignKey(d => d.IdcodigoPostalFiscal)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbCodigosPostais_Fiscal");

            ////    entity.HasOne(d => d.IdconcelhoCargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdconcelhoCargaNavigation)
            ////        .HasForeignKey(d => d.IdconcelhoCarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Carga");

            ////    entity.HasOne(d => d.IdconcelhoDescargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdconcelhoDescargaNavigation)
            ////        .HasForeignKey(d => d.IdconcelhoDescarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Descarga");

            ////    entity.HasOne(d => d.IdconcelhoDestinatarioNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdconcelhoDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IdconcelhoDestinatario)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Destinatario");

            ////    entity.HasOne(d => d.IdconcelhoFiscalNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdconcelhoFiscalNavigation)
            ////        .HasForeignKey(d => d.IdconcelhoFiscal)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbConcelhos_Fiscal");

            ////    entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdcondicaoPagamento)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbCondicoesPagamento");

            ////    entity.HasOne(d => d.IddistritoCargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIddistritoCargaNavigation)
            ////        .HasForeignKey(d => d.IddistritoCarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Carga");

            ////    entity.HasOne(d => d.IddistritoDescargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIddistritoDescargaNavigation)
            ////        .HasForeignKey(d => d.IddistritoDescarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Descarga");

            ////    entity.HasOne(d => d.IddistritoDestinatarioNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIddistritoDestinatarioNavigation)
            ////        .HasForeignKey(d => d.IddistritoDestinatario)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Destinatario");

            ////    entity.HasOne(d => d.IddistritoFiscalNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIddistritoFiscalNavigation)
            ////        .HasForeignKey(d => d.IddistritoFiscal)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbDistritos_Fiscal");

            ////    entity.HasOne(d => d.IddocReservaNavigation)
            ////        .WithMany(p => p.InverseIddocReservaNavigation)
            ////        .HasForeignKey(d => d.IddocReserva)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbDocumentosStockReserva");

            ////    entity.HasOne(d => d.IdentidadeNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.Identidade)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbClientes");

            ////    entity.HasOne(d => d.IdespacoFiscalNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdespacoFiscalNavigation)
            ////        .HasForeignKey(d => d.IdespacoFiscal)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaEspacoFiscal1");

            ////    entity.HasOne(d => d.IdespacoFiscalPortesNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdespacoFiscalPortesNavigation)
            ////        .HasForeignKey(d => d.IdespacoFiscalPortes)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaEspacoFiscal");

            ////    entity.HasOne(d => d.IdestadoNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.Idestado)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbEstados");

            ////    entity.HasOne(d => d.IdformaExpedicaoNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdformaExpedicao)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbFormasExpedicao");

            ////    entity.HasOne(d => d.IdlocalOperacaoNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdlocalOperacao)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegioesIVA");

            ////    entity.HasOne(d => d.IdlojaNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.Idloja)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbLojas");

            ////    entity.HasOne(d => d.IdmoedaNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.Idmoeda)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbMoedas");

            ////    entity.HasOne(d => d.IdpaisCargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdpaisCargaNavigation)
            ////        .HasForeignKey(d => d.IdpaisCarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbPaises");

            ////    entity.HasOne(d => d.IdpaisDescargaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdpaisDescargaNavigation)
            ////        .HasForeignKey(d => d.IdpaisDescarga)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbPaises_Descarga");

            ////    entity.HasOne(d => d.IdpaisFiscalNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdpaisFiscalNavigation)
            ////        .HasForeignKey(d => d.IdpaisFiscal)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbPaises_Fiscal");

            ////    entity.HasOne(d => d.IdregimeIvaNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdregimeIvaNavigation)
            ////        .HasForeignKey(d => d.IdregimeIva)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegimeIVA1");

            ////    entity.HasOne(d => d.IdregimeIvaPortesNavigation)
            ////        .WithMany(p => p.TbDocumentosStockIdregimeIvaPortesNavigation)
            ////        .HasForeignKey(d => d.IdregimeIvaPortes)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaRegimeIVA");

            ////    entity.HasOne(d => d.IdsisTiposDocPuNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdsisTiposDocPu)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaTiposDocumentoPrecoUnitario");

            ////    entity.HasOne(d => d.IdtaxaIvaPortesNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdtaxaIvaPortes)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbIVA_Portes");

            ////    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdtipoDocumento)
            ////        .OnDelete(DeleteBehavior.ClientSetNull)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbTiposDocumento");

            ////    entity.HasOne(d => d.IdtipoEntidadeNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdtipoEntidade)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbSistemaTiposEntidade");

            ////    entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            ////        .WithMany(p => p.TbDocumentosStock)
            ////        .HasForeignKey(d => d.IdtiposDocumentoSeries)
            ////        .OnDelete(DeleteBehavior.ClientSetNull)
            ////        .HasConstraintName("FK_tbDocumentosStock_tbTiposDocumentoSeries");
            ////});

            //modelBuilder.Entity<TbDocumentosStockAnexos>(entity =>
            //{
            //    entity.ToTable("tbDocumentosStockAnexos");

            //    entity.HasIndex(e => new { e.IddocumentoStock, e.Ficheiro })
            //        .HasName("IX_tbDocumentosStockAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IddocumentoStock).HasColumnName("IDDocumentoStock");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IddocumentoStockNavigation)
            //        .WithMany(p => p.Attachments)
            //        .HasForeignKey(d => d.IddocumentoStock)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockAnexos_tbDocumentosStock");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbDocumentosStockAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbDocumentosStockAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbDocumentosStockContagem>(entity =>
            //{
            //    entity.ToTable("tbDocumentosStockContagem");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataControloInterno).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("date");

            //    entity.Property(e => e.Documento).HasMaxLength(20);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Filtro)
            //        .IsRequired()
            //        .HasColumnType("text");

            //    entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            //    entity.Property(e => e.Idestado).HasColumnName("IDEstado");

            //    entity.Property(e => e.Idlocalizacao).HasColumnName("IDLocalizacao");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //    entity.Property(e => e.Observacoes).HasColumnType("text");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdarmazemNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.Idarmazem)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbArmazens");

            //    entity.HasOne(d => d.IdestadoNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.Idestado)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbEstado");

            //    entity.HasOne(d => d.IdlocalizacaoNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.Idlocalizacao)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbArmazensLocalizacoes");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbSistemaMoedas");

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbTipoDocumento");

            //    entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagem)
            //        .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //        .HasConstraintName("FK_tbDocumentosStockContagem_tbTiposDocumentoSeries");
            //});

            //modelBuilder.Entity<TbDocumentosStockContagemAnexos>(entity =>
            //{
            //    entity.ToTable("tbDocumentosStockContagemAnexos");

            //    entity.HasIndex(e => new { e.IddocumentoStockContagem, e.Ficheiro })
            //        .HasName("IX_tbDocumentosStockContagemAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IddocumentoStockContagem).HasColumnName("IDDocumentoStockContagem");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IddocumentoStockContagemNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagemAnexos)
            //        .HasForeignKey(d => d.IddocumentoStockContagem)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagemAnexos_tbDocumentosStockContagem");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagemAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbDocumentosStockContagemAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbDocumentosStockContagemLinhas>(entity =>
            //{
            //    entity.ToTable("tbDocumentosStockContagemLinhas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoArtigo)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.CodigoLote).HasMaxLength(255);

            //    entity.Property(e => e.CodigoUnidade)
            //        .IsRequired()
            //        .HasMaxLength(255)
            //        .IsUnicode(false);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoArtigo)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.DescricaoLote).HasMaxLength(255);

            //    entity.Property(e => e.DescricaoUnidade)
            //        .IsRequired()
            //        .HasMaxLength(255)
            //        .IsUnicode(false);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IddocumentoStockContagem).HasColumnName("IDDocumentoStockContagem");

            //    entity.Property(e => e.Idlote).HasColumnName("IDLote");

            //    entity.Property(e => e.Idunidade).HasColumnName("IDUnidade");

            //    entity.Property(e => e.PvmoedaRef).HasColumnName("PVMoedaRef");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao).HasMaxLength(20);

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.StocksCountProducts)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagemLinhas_tb");

            //    entity.HasOne(d => d.IddocumentoStockContagemNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagemLinhas)
            //        .HasForeignKey(d => d.IddocumentoStockContagem)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagemLinhas_tbDocumentosStockContagem");

            //    entity.HasOne(d => d.IdloteNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagemLinhas)
            //        .HasForeignKey(d => d.Idlote)
            //        .HasConstraintName("FK_tbDocumentosStockContagemLinhas_tbLote");

            //    entity.HasOne(d => d.IdunidadeNavigation)
            //        .WithMany(p => p.TbDocumentosStockContagemLinhas)
            //        .HasForeignKey(d => d.Idunidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosStockContagemLinhas_tbUnidade");
            //});



            //modelBuilder.Entity<TbDocumentosVendas>(entity =>
            //{
            //    entity.ToTable("tbDocumentosVendas");

            //    entity.HasIndex(e => new { e.IdtipoDocumento, e.IdtiposDocumentoSeries, e.NumeroDocumento, e.NumeroInterno })
            //        .HasName("IX_tbDocumentosVendas_Chave")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Assinatura).HasMaxLength(255);

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CapitalSocialLoja).HasMaxLength(255);

            //    entity.Property(e => e.CodigoAt)
            //        .HasColumnName("CodigoAT")
            //        .HasMaxLength(200);

            //    entity.Property(e => e.CodigoAtinterno)
            //        .HasColumnName("CodigoATInterno")
            //        .HasMaxLength(200);

            //    entity.Property(e => e.CodigoDocOrigem).HasMaxLength(255);

            //    entity.Property(e => e.CodigoEntidade).HasMaxLength(20);

            //    entity.Property(e => e.CodigoMoeda).HasMaxLength(20);

            //    entity.Property(e => e.CodigoPostalCarga).HasMaxLength(20);

            //    entity.Property(e => e.CodigoPostalDescarga).HasMaxLength(20);

            //    entity.Property(e => e.CodigoPostalFiscal).HasMaxLength(10);

            //    entity.Property(e => e.CodigoPostalLoja).HasMaxLength(8);

            //    entity.Property(e => e.CodigoSisTiposDocPu)
            //        .HasColumnName("CodigoSisTiposDocPU")
            //        .HasMaxLength(6);

            //    entity.Property(e => e.CodigoTipoEstado).HasMaxLength(20);

            //    entity.Property(e => e.ConcelhoCarga).HasMaxLength(255);

            //    entity.Property(e => e.ConcelhoDescarga).HasMaxLength(255);

            //    entity.Property(e => e.ConservatoriaRegistoComerciaLoja).HasMaxLength(255);

            //    entity.Property(e => e.ContribuinteFiscal).HasMaxLength(25);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataAssinatura).HasColumnType("datetime");

            //    entity.Property(e => e.DataCarga).HasColumnType("datetime");

            //    entity.Property(e => e.DataControloInterno).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDescarga).HasColumnType("datetime");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataEntrega).HasColumnType("datetime");

            //    entity.Property(e => e.DataHoraEstado).HasColumnType("datetime");

            //    entity.Property(e => e.DataNascimento).HasColumnType("datetime");

            //    entity.Property(e => e.DataUltimaImpressao).HasColumnType("datetime");

            //    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoCodigoPostalFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoConcelhoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoDistritoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DesignacaoComercialLoja).HasMaxLength(160);

            //    entity.Property(e => e.DistritoCarga).HasMaxLength(255);

            //    entity.Property(e => e.DistritoDescarga).HasMaxLength(255);

            //    entity.Property(e => e.Documento).HasMaxLength(50);

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.EmailLoja).HasMaxLength(255);

            //    entity.Property(e => e.EspacoFiscalPortes).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.FaxLoja).HasMaxLength(50);

            //    entity.Property(e => e.HoraCarga).HasColumnType("datetime");

            //    entity.Property(e => e.HoraDescarga).HasColumnType("datetime");

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.IdcodigoPostalCarga).HasColumnName("IDCodigoPostalCarga");

            //    entity.Property(e => e.IdcodigoPostalDescarga).HasColumnName("IDCodigoPostalDescarga");

            //    entity.Property(e => e.IdcodigoPostalDestinatario).HasColumnName("IDCodigoPostalDestinatario");

            //    entity.Property(e => e.IdcodigoPostalFiscal).HasColumnName("IDCodigoPostalFiscal");

            //    entity.Property(e => e.IdconcelhoCarga).HasColumnName("IDConcelhoCarga");

            //    entity.Property(e => e.IdconcelhoDescarga).HasColumnName("IDConcelhoDescarga");

            //    entity.Property(e => e.IdconcelhoDestinatario).HasColumnName("IDConcelhoDestinatario");

            //    entity.Property(e => e.IdconcelhoFiscal).HasColumnName("IDConcelhoFiscal");

            //    entity.Property(e => e.IdcondicaoPagamento).HasColumnName("IDCondicaoPagamento");

            //    entity.Property(e => e.IddistritoCarga).HasColumnName("IDDistritoCarga");

            //    entity.Property(e => e.IddistritoDescarga).HasColumnName("IDDistritoDescarga");

            //    entity.Property(e => e.IddistritoDestinatario).HasColumnName("IDDistritoDestinatario");

            //    entity.Property(e => e.IddistritoFiscal).HasColumnName("IDDistritoFiscal");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Identidade1).HasColumnName("IDEntidade1");

            //    entity.Property(e => e.Identidade2).HasColumnName("IDEntidade2");

            //    entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            //    entity.Property(e => e.IdespacoFiscalPortes).HasColumnName("IDEspacoFiscalPortes");

            //    entity.Property(e => e.Idestado).HasColumnName("IDEstado");

            //    entity.Property(e => e.IdformaExpedicao).HasColumnName("IDFormaExpedicao");

            //    entity.Property(e => e.IdlocalOperacao).HasColumnName("IDLocalOperacao");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdlojaUltimaImpressao).HasColumnName("IDLojaUltimaImpressao");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdpaisCarga).HasColumnName("IDPaisCarga");

            //    entity.Property(e => e.IdpaisDescarga).HasColumnName("IDPaisDescarga");

            //    entity.Property(e => e.IdpaisFiscal).HasColumnName("IDPaisFiscal");

            //    entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            //    entity.Property(e => e.IdregimeIvaPortes).HasColumnName("IDRegimeIvaPortes");

            //    entity.Property(e => e.IdsisTiposDocPu).HasColumnName("IDSisTiposDocPU");

            //    entity.Property(e => e.IdtaxaIvaPortes).HasColumnName("IDTaxaIvaPortes");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //    entity.Property(e => e.LocalCarga).HasMaxLength(50);

            //    entity.Property(e => e.LocalDescarga).HasMaxLength(50);

            //    entity.Property(e => e.LocalidadeLoja).HasMaxLength(50);

            //    entity.Property(e => e.Matricula).HasMaxLength(255);

            //    entity.Property(e => e.MensagemDocAt)
            //        .HasColumnName("MensagemDocAT")
            //        .HasMaxLength(1000);

            //    entity.Property(e => e.MoradaCarga).HasMaxLength(100);

            //    entity.Property(e => e.MoradaDescarga).HasMaxLength(100);

            //    entity.Property(e => e.MoradaDestinatario).HasMaxLength(100);

            //    entity.Property(e => e.MoradaFiscal).HasMaxLength(100);

            //    entity.Property(e => e.MoradaLoja).HasMaxLength(100);

            //    entity.Property(e => e.MotivoIsencaoIva).HasMaxLength(255);

            //    entity.Property(e => e.MotivoIsencaoPortes).HasMaxLength(255);

            //    entity.Property(e => e.Nifloja)
            //        .HasColumnName("NIFLoja")
            //        .HasMaxLength(9);

            //    entity.Property(e => e.NomeDestinatario).HasMaxLength(100);

            //    entity.Property(e => e.NomeFiscal).HasMaxLength(200);

            //    entity.Property(e => e.NumeroBeneficiario1).HasMaxLength(50);

            //    entity.Property(e => e.NumeroBeneficiario2).HasMaxLength(50);

            //    entity.Property(e => e.NumeroDocManual).HasMaxLength(50);

            //    entity.Property(e => e.NumeroManual).HasMaxLength(50);

            //    entity.Property(e => e.NumeroRegistoComercialLoja).HasMaxLength(255);

            //    entity.Property(e => e.Parentesco1).HasMaxLength(50);

            //    entity.Property(e => e.Parentesco2).HasMaxLength(50);

            //    entity.Property(e => e.Posto).HasMaxLength(512);

            //    entity.Property(e => e.RazaoEstado).HasMaxLength(50);

            //    entity.Property(e => e.RegimeIvaPortes).HasMaxLength(50);

            //    entity.Property(e => e.SerieDocManual).HasMaxLength(50);

            //    entity.Property(e => e.SerieManual).HasMaxLength(50);

            //    entity.Property(e => e.SiglaLoja).HasMaxLength(3);

            //    entity.Property(e => e.SiglaPaisCarga).HasMaxLength(6);

            //    entity.Property(e => e.SiglaPaisDescarga).HasMaxLength(6);

            //    entity.Property(e => e.SiglaPaisFiscal).HasMaxLength(15);

            //    entity.Property(e => e.TelefoneLoja).HasMaxLength(50);

            //    entity.Property(e => e.TipoFiscal).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorEstado).HasMaxLength(20);

            //    entity.Property(e => e.VossoNumeroDocumento).HasMaxLength(256);

            //    entity.HasOne(d => d.IdcodigoPostalCargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdcodigoPostalCargaNavigation)
            //        .HasForeignKey(d => d.IdcodigoPostalCarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Carga");

            //    entity.HasOne(d => d.IdcodigoPostalDescargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdcodigoPostalDescargaNavigation)
            //        .HasForeignKey(d => d.IdcodigoPostalDescarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Descarga");

            //    entity.HasOne(d => d.IdcodigoPostalDestinatarioNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdcodigoPostalDestinatarioNavigation)
            //        .HasForeignKey(d => d.IdcodigoPostalDestinatario)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Destinatario");

            //    entity.HasOne(d => d.IdcodigoPostalFiscalNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdcodigoPostalFiscalNavigation)
            //        .HasForeignKey(d => d.IdcodigoPostalFiscal)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbCodigosPostais_Fiscal");

            //    entity.HasOne(d => d.IdconcelhoCargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdconcelhoCargaNavigation)
            //        .HasForeignKey(d => d.IdconcelhoCarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Carga");

            //    entity.HasOne(d => d.IdconcelhoDescargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdconcelhoDescargaNavigation)
            //        .HasForeignKey(d => d.IdconcelhoDescarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Descarga");

            //    entity.HasOne(d => d.IdconcelhoDestinatarioNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdconcelhoDestinatarioNavigation)
            //        .HasForeignKey(d => d.IdconcelhoDestinatario)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Destinatario");

            //    entity.HasOne(d => d.IdconcelhoFiscalNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdconcelhoFiscalNavigation)
            //        .HasForeignKey(d => d.IdconcelhoFiscal)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbConcelhos_Fiscal");

            //    entity.HasOne(d => d.IdcondicaoPagamentoNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdcondicaoPagamento)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbCondicoesPagamento");

            //    entity.HasOne(d => d.IddistritoCargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIddistritoCargaNavigation)
            //        .HasForeignKey(d => d.IddistritoCarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Carga");

            //    entity.HasOne(d => d.IddistritoDescargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIddistritoDescargaNavigation)
            //        .HasForeignKey(d => d.IddistritoDescarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Descarga");

            //    entity.HasOne(d => d.IddistritoDestinatarioNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIddistritoDestinatarioNavigation)
            //        .HasForeignKey(d => d.IddistritoDestinatario)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Destinatario");

            //    entity.HasOne(d => d.IddistritoFiscalNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIddistritoFiscalNavigation)
            //        .HasForeignKey(d => d.IddistritoFiscal)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbDistritos_Fiscal");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.Identidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbClientes");

            //    entity.HasOne(d => d.Identidade1Navigation)
            //        .WithMany(p => p.TbDocumentosVendasIdentidade1Navigation)
            //        .HasForeignKey(d => d.Identidade1)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbEntidades1");

            //    entity.HasOne(d => d.Identidade2Navigation)
            //        .WithMany(p => p.TbDocumentosVendasIdentidade2Navigation)
            //        .HasForeignKey(d => d.Identidade2)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbEntidades2");

            //    entity.HasOne(d => d.IdespacoFiscalNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdespacoFiscalNavigation)
            //        .HasForeignKey(d => d.IdespacoFiscal)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaEspacoFiscal1");

            //    entity.HasOne(d => d.IdespacoFiscalPortesNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdespacoFiscalPortesNavigation)
            //        .HasForeignKey(d => d.IdespacoFiscalPortes)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaEspacoFiscal");

            //    entity.HasOne(d => d.IdestadoNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.Idestado)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbEstados");

            //    entity.HasOne(d => d.IdformaExpedicaoNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdformaExpedicao)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbFormasExpedicao");

            //    entity.HasOne(d => d.IdlocalOperacaoNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdlocalOperacao)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegioesIVA");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbLojas");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbMoedas");

            //    entity.HasOne(d => d.IdpaisCargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdpaisCargaNavigation)
            //        .HasForeignKey(d => d.IdpaisCarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbPaises1");

            //    entity.HasOne(d => d.IdpaisDescargaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdpaisDescargaNavigation)
            //        .HasForeignKey(d => d.IdpaisDescarga)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbPaises2");

            //    entity.HasOne(d => d.IdpaisFiscalNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdpaisFiscalNavigation)
            //        .HasForeignKey(d => d.IdpaisFiscal)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbPaises_Fiscal");

            //    entity.HasOne(d => d.IdregimeIvaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdregimeIvaNavigation)
            //        .HasForeignKey(d => d.IdregimeIva)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegimeIVA1");

            //    entity.HasOne(d => d.IdregimeIvaPortesNavigation)
            //        .WithMany(p => p.TbDocumentosVendasIdregimeIvaPortesNavigation)
            //        .HasForeignKey(d => d.IdregimeIvaPortes)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaRegimeIVA");

            //    entity.HasOne(d => d.IdsisTiposDocPuNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdsisTiposDocPu)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaTiposDocumentoPrecoUnitario");

            //    entity.HasOne(d => d.IdtaxaIvaPortesNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdtaxaIvaPortes)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbIVA_Portes");

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbTiposDocumento");

            //    entity.HasOne(d => d.IdtipoEntidadeNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdtipoEntidade)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbSistemaTiposEntidade");

            //    entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //        .WithMany(p => p.TbDocumentosVendas)
            //        .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendas_tbTiposDocumentoSeries");
            //});

            //modelBuilder.Entity<TbDocumentosVendasAnexos>(entity =>
            //{
            //    entity.ToTable("tbDocumentosVendasAnexos");

            //    entity.HasIndex(e => new { e.IddocumentoVenda, e.Ficheiro })
            //        .HasName("IX_tbDocumentosVendasAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IddocumentoVendaNavigation)
            //        .WithMany(p => p.Attachments)
            //        .HasForeignKey(d => d.IddocumentoVenda)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendasAnexos_tbDocumentosVendas");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbDocumentosVendasAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbDocumentosVendasAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbDocumentosVendasFormasPagamento>(entity =>
            //{
            //    entity.ToTable("tbDocumentosVendasFormasPagamento");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoFormaPagamento).HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //    entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IddocumentoVendaNavigation)
            //        .WithMany(p => p.PaymentsTypes)
            //        .HasForeignKey(d => d.IddocumentoVenda)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbDocumentosVendas");

            //    entity.HasOne(d => d.IdformaPagamentoNavigation)
            //        .WithMany(p => p.TbDocumentosVendasFormasPagamento)
            //        .HasForeignKey(d => d.IdformaPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbFormasPagamento");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbDocumentosVendasFormasPagamento)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbDocumentosVendasFormasPagamento_tbLojas");
            //});



            //modelBuilder.Entity<TbDocumentosVendasLinhasGraduacoes>(entity =>
            //{
            //    entity.ToTable("tbDocumentosVendasLinhasGraduacoes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.AcuidadeVisual).HasMaxLength(10);

            //    entity.Property(e => e.AnguloPantoscopico).HasMaxLength(10);

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.BasePrismatica).HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DetalheRaio).HasMaxLength(10);

            //    entity.Property(e => e.DistanciaVertex).HasMaxLength(10);

            //    entity.Property(e => e.Dnp).HasColumnName("DNP");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idservico).HasColumnName("IDServico");

            //    entity.Property(e => e.IdtipoGraduacao).HasColumnName("IDTipoGraduacao");

            //    entity.Property(e => e.IdtipoOlho).HasColumnName("IDTipoOlho");

            //    entity.Property(e => e.RaioCurvatura).HasMaxLength(10);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdservicoNavigation)
            //        .WithMany(p => p.TbDocumentosVendasLinhasGraduacoes)
            //        .HasForeignKey(d => d.Idservico)
            //        .HasConstraintName("FK_tbDocumentosVendasLinhasGraduacoes_tbServicos");

            //    entity.HasOne(d => d.IdtipoGraduacaoNavigation)
            //        .WithMany(p => p.TbDocumentosVendasLinhasGraduacoes)
            //        .HasForeignKey(d => d.IdtipoGraduacao)
            //        .HasConstraintName("FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposGraduacoes");

            //    entity.HasOne(d => d.IdtipoOlhoNavigation)
            //        .WithMany(p => p.TbDocumentosVendasLinhasGraduacoes)
            //        .HasForeignKey(d => d.IdtipoOlho)
            //        .HasConstraintName("FK_tbDocumentosVendasLinhasGraduacoes_tbSistemaTiposOlhos");
            //});

            //modelBuilder.Entity<TbDocumentosVendasPendentes>(entity =>
            //{
            //    entity.ToTable("tbDocumentosVendasPendentes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoEntidade).HasMaxLength(200);

            //    entity.Property(e => e.Documento).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdsistemaNaturezas).HasColumnName("IDSistemaNaturezas");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.Pago).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IddocumentoVendaNavigation)
            //        .WithMany(p => p.PendingSalesDocuments)
            //        .HasForeignKey(d => d.IddocumentoVenda)
            //        .HasConstraintName("FK_tbDocumentosVendasPendentes_tbDocumentosVendas");

            //    entity.HasOne(d => d.IdsistemaNaturezasNavigation)
            //        .WithMany(p => p.TbDocumentosVendasPendentes)
            //        .HasForeignKey(d => d.IdsistemaNaturezas)
            //        .HasConstraintName("FK_tbDocumentosVendasPendentes_tbSistemaNaturezas");
            //});



            //modelBuilder.Entity<TbEntidadesAnexos>(entity =>
            //{
            //    entity.ToTable("tbEntidadesAnexos");

            //    entity.HasIndex(e => new { e.Identidade, e.Ficheiro })
            //        .HasName("IX_tbEntidadesAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbEntidadesAnexos)
            //        .HasForeignKey(d => d.Identidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEntidadesAnexos_tbEntidades");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbEntidadesAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbEntidadesAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbEntidadesComparticipacoes>(entity =>
            //{
            //    entity.ToTable("tbEntidadesComparticipacoes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.IdtipoArtigo).HasColumnName("IDTipoArtigo");

            //    entity.Property(e => e.IdtipoLente).HasColumnName("IDTipoLente");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbEntidadesComparticipacoes)
            //        .HasForeignKey(d => d.Identidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEntidadesComparticipacoes_tbEntidades");

            //    entity.HasOne(d => d.IdtipoArtigoNavigation)
            //        .WithMany(p => p.TbEntidadesComparticipacoes)
            //        .HasForeignKey(d => d.IdtipoArtigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEntidadesComparticipacoes_tbTiposArtigos");

            //    entity.HasOne(d => d.IdtipoLenteNavigation)
            //        .WithMany(p => p.TbEntidadesComparticipacoes)
            //        .HasForeignKey(d => d.IdtipoLente)
            //        .HasConstraintName("FK_tbEntidadesComparticipacoes_tbSistemaTiposLentes");
            //});

            //modelBuilder.Entity<TbEntidadesContatos>(entity =>
            //{
            //    entity.ToTable("tbEntidadesContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbEntidadesContatos)
            //        .HasForeignKey(d => d.Identidade)
            //        .HasConstraintName("FK_tbEntidadesContatos_tbEntidades");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbEntidadesContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbEntidadesContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbEntidadesLojas>(entity =>
            //{
            //    entity.ToTable("tbEntidadesLojas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.NumAssociado).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbEntidadesLojas)
            //        .HasForeignKey(d => d.Identidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEntidadesLojas_tbEntidades");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbEntidadesLojas)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbEntidadesLojas_tbLojas");
            //});

            //modelBuilder.Entity<TbEntidadesMoradas>(entity =>
            //{
            //    entity.ToTable("tbEntidadesMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbEntidadesMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbEntidadesMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbEntidadesMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbEntidadesMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbEntidadesMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbEntidadesMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbEntidadesMoradas)
            //        .HasForeignKey(d => d.Identidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEntidadesMoradas_tbEntidades");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbEntidadesMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbEntidadesMoradas_tbPaises");
            //});

            //modelBuilder.Entity<TbEscaloes>(entity =>
            //{
            //    entity.ToTable("tbEscaloes");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbEscaloesCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbEscaloesEspecificos>(entity =>
            //{
            //    entity.ToTable("tbEscaloesEspecificos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idescalao).HasColumnName("IDEscalao");

            //    entity.Property(e => e.Idfamilia).HasColumnName("IDFamilia");

            //    entity.Property(e => e.IdgruposArtigo).HasColumnName("IDGruposArtigo");

            //    entity.Property(e => e.IdsubFamilia).HasColumnName("IDSubFamilia");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdescalaoNavigation)
            //        .WithMany(p => p.TbEscaloesEspecificos)
            //        .HasForeignKey(d => d.Idescalao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEscaloesEspecificos_tbEscaloes");

            //    entity.HasOne(d => d.IdfamiliaNavigation)
            //        .WithMany(p => p.TbEscaloesEspecificos)
            //        .HasForeignKey(d => d.Idfamilia)
            //        .HasConstraintName("FK_tbEscaloesEspecificos_tbFamilias");

            //    entity.HasOne(d => d.IdgruposArtigoNavigation)
            //        .WithMany(p => p.TbEscaloesEspecificos)
            //        .HasForeignKey(d => d.IdgruposArtigo)
            //        .HasConstraintName("FK_tbEscaloesEspecificos_tbGruposArtigo");

            //    entity.HasOne(d => d.IdsubFamiliaNavigation)
            //        .WithMany(p => p.TbEscaloesEspecificos)
            //        .HasForeignKey(d => d.IdsubFamilia)
            //        .HasConstraintName("FK_tbEscaloesEspecificos_tbSubFamilias");
            //});

            //modelBuilder.Entity<TbEscaloesGerais>(entity =>
            //{
            //    entity.ToTable("tbEscaloesGerais");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idescalao).HasColumnName("IDEscalao");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdescalaoNavigation)
            //        .WithMany(p => p.TbEscaloesGerais)
            //        .HasForeignKey(d => d.Idescalao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEscaloesGerais_tbEscaloes");
            //});

            //modelBuilder.Entity<TbEscaloesPenalizacoes>(entity =>
            //{
            //    entity.ToTable("tbEscaloesPenalizacoes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idescalao).HasColumnName("IDEscalao");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdescalaoNavigation)
            //        .WithMany(p => p.TbEscaloesPenalizacoes)
            //        .HasForeignKey(d => d.Idescalao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEscaloesPenalizacoes_tbEscaloes");
            //});

            //modelBuilder.Entity<TbEspecialidades>(entity =>
            //{
            //    entity.ToTable("tbEspecialidades");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Cor).HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbEstacoes>(entity =>
            //{
            //    entity.ToTable("tbEstacoes");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbEstacoes")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbEstados>(entity =>
            //{
            //    entity.ToTable("tbEstados");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdentidadeEstado).HasColumnName("IDEntidadeEstado");

            //    entity.Property(e => e.IdtipoEstado).HasColumnName("IDTipoEstado");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdentidadeEstadoNavigation)
            //        .WithMany(p => p.TbEstados)
            //        .HasForeignKey(d => d.IdentidadeEstado)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEstados_tbSistemaEntidadesEstados");

            //    entity.HasOne(d => d.IdtipoEstadoNavigation)
            //        .WithMany(p => p.TbEstados)
            //        .HasForeignKey(d => d.IdtipoEstado)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbEstados_tbSistemaTiposEstados");
            //});

            //modelBuilder.Entity<TbExames>(entity =>
            //{
            //    entity.ToTable("tbExames");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.DataExame).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idagendamento).HasColumnName("IDAgendamento");

            //    entity.Property(e => e.Idcliente).HasColumnName("IDCliente");

            //    entity.Property(e => e.Idespecialidade).HasColumnName("IDEspecialidade");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.Idtemplate)
            //        .HasColumnName("IDTemplate")
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.IdtipoConsulta).HasColumnName("IDTipoConsulta");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdagendamentoNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.Idagendamento)
            //        .HasConstraintName("FK_tbExames_tbAgendamento");

            //    entity.HasOne(d => d.IdclienteNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.Idcliente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExames_tbClientes");

            //    entity.HasOne(d => d.IdespecialidadeNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.Idespecialidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExames_tbEspecialidades");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.Idloja)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExames_tbLojas");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExames_tbMedicosTecnicos");

            //    entity.HasOne(d => d.IdtemplateNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.Idtemplate)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExames_tbTemplates");

            //    entity.HasOne(d => d.IdtipoConsultaNavigation)
            //        .WithMany(p => p.TbExames)
            //        .HasForeignKey(d => d.IdtipoConsulta)
            //        .HasConstraintName("FK_tbExames_tbTiposConsultas");
            //});

            //modelBuilder.Entity<TbExamesAnexos>(entity =>
            //{
            //    entity.ToTable("tbExamesAnexos");

            //    entity.HasIndex(e => new { e.Idexame, e.Ficheiro })
            //        .HasName("IX_tbExamesAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.Idexame).HasColumnName("IDExame");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdexameNavigation)
            //        .WithMany(p => p.TbExamesAnexos)
            //        .HasForeignKey(d => d.Idexame)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExamesAnexos_tbExames");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbExamesAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbExamesAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbExamesProps>(entity =>
            //{
            //    entity.ToTable("tbExamesProps");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.AtributosHtml).HasMaxLength(100);

            //    entity.Property(e => e.CampoTexto).HasMaxLength(255);

            //    entity.Property(e => e.ComponentTag).IsUnicode(false);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Ecabecalho).HasColumnName("ECabecalho");

            //    entity.Property(e => e.Eeditavel).HasColumnName("EEditavel");

            //    entity.Property(e => e.EeditavelEdicao).HasColumnName("EEditavelEdicao");

            //    entity.Property(e => e.Eobrigatorio).HasColumnName("EObrigatorio");

            //    entity.Property(e => e.Evisivel).HasColumnName("EVisivel");

            //    entity.Property(e => e.F3mmarcador)
            //        .IsRequired()
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.FuncaoJschange).HasColumnName("FuncaoJSChange");

            //    entity.Property(e => e.FuncaoJsenviaParametros).HasColumnName("FuncaoJSEnviaParametros");

            //    entity.Property(e => e.FuncaoJsonClick).HasColumnName("FuncaoJSOnClick");

            //    entity.Property(e => e.Idelemento).HasColumnName("IDElemento");

            //    entity.Property(e => e.Idexame).HasColumnName("IDExame");

            //    entity.Property(e => e.Idpai).HasColumnName("IDPai");

            //    entity.Property(e => e.Label).HasMaxLength(250);

            //    entity.Property(e => e.ModelPropertyName).HasMaxLength(100);

            //    entity.Property(e => e.ModelPropertyType).HasMaxLength(100);

            //    entity.Property(e => e.TabelaBd).HasColumnName("TabelaBD");

            //    entity.Property(e => e.TipoComponente).HasMaxLength(250);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.ValorId).HasColumnName("ValorID");

            //    entity.Property(e => e.ViewClassesCss).HasColumnName("ViewClassesCSS");

            //    entity.HasOne(d => d.IdexameNavigation)
            //        .WithMany(p => p.TbExamesProps)
            //        .HasForeignKey(d => d.Idexame)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExamesProps_tbExames");

            //    entity.HasOne(d => d.IdpaiNavigation)
            //        .WithMany(p => p.InverseIdpaiNavigation)
            //        .HasForeignKey(d => d.Idpai)
            //        .HasConstraintName("FK_tbExamesProps_tbExamesProps");
            //});

            //modelBuilder.Entity<TbExamesPropsFotos>(entity =>
            //{
            //    entity.ToTable("tbExamesPropsFotos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Foto)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FotoCaminho).IsRequired();

            //    entity.Property(e => e.Idexame).HasColumnName("IDExame");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdexameNavigation)
            //        .WithMany(p => p.TbExamesPropsFotos)
            //        .HasForeignKey(d => d.Idexame)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExamesPropsFotos_tbExames");
            //});

            //modelBuilder.Entity<TbExamesTemplate>(entity =>
            //{
            //    entity.ToTable("tbExamesTemplate");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.AtributosHtml).HasMaxLength(100);

            //    entity.Property(e => e.CampoTexto).HasMaxLength(255);

            //    entity.Property(e => e.ComponentTag).IsUnicode(false);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Ecabecalho).HasColumnName("ECabecalho");

            //    entity.Property(e => e.Eeditavel).HasColumnName("EEditavel");

            //    entity.Property(e => e.EeditavelEdicao).HasColumnName("EEditavelEdicao");

            //    entity.Property(e => e.Eobrigatorio).HasColumnName("EObrigatorio");

            //    entity.Property(e => e.Evisivel).HasColumnName("EVisivel");

            //    entity.Property(e => e.F3mmarcador)
            //        .IsRequired()
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.FuncaoJschange).HasColumnName("FuncaoJSChange");

            //    entity.Property(e => e.FuncaoJsenviaParametros).HasColumnName("FuncaoJSEnviaParametros");

            //    entity.Property(e => e.FuncaoJsonClick)
            //        .HasColumnName("FuncaoJSOnClick")
            //        .IsUnicode(false);

            //    entity.Property(e => e.Idelemento)
            //        .HasColumnName("IDElemento")
            //        .IsUnicode(false);

            //    entity.Property(e => e.Idpai).HasColumnName("IDPai");

            //    entity.Property(e => e.Idtemplate)
            //        .HasColumnName("IDTemplate")
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Label).HasMaxLength(250);

            //    entity.Property(e => e.ModelPropertyName).HasMaxLength(100);

            //    entity.Property(e => e.ModelPropertyType).HasMaxLength(100);

            //    entity.Property(e => e.TabelaBd).HasColumnName("TabelaBD");

            //    entity.Property(e => e.TipoComponente).HasMaxLength(250);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.ViewClassesCss).HasColumnName("ViewClassesCSS");

            //    entity.HasOne(d => d.IdpaiNavigation)
            //        .WithMany(p => p.InverseIdpaiNavigation)
            //        .HasForeignKey(d => d.Idpai)
            //        .HasConstraintName("FK_tbExamesTemplate_tbExamesTemplate");

            //    entity.HasOne(d => d.IdtemplateNavigation)
            //        .WithMany(p => p.TbExamesTemplate)
            //        .HasForeignKey(d => d.Idtemplate)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbExamesTemplate_tbTemplates");
            //});

            //modelBuilder.Entity<TbF3mrecalculo>(entity =>
            //{
            //    entity.ToTable("tbF3MRecalculo");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdartigoDimensao).HasColumnName("IDArtigoDimensao");

            //    entity.Property(e => e.Idrecalculo).HasColumnName("IDRecalculo");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbFamilias>(entity =>
            //{
            //    entity.ToTable("tbFamilias");

            //    entity.HasIndex(e => e.Ativo)
            //        .HasName("IX_tbFamiliasAtivo");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbFamiliasCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbFormasExpedicao>(entity =>
            //{
            //    entity.ToTable("tbFormasExpedicao");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbFormasExpedicaoIdiomas>(entity =>
            //{
            //    entity.ToTable("tbFormasExpedicaoIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdformaExpedicao).HasColumnName("IDFormaExpedicao");

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdformaExpedicaoNavigation)
            //        .WithMany(p => p.TbFormasExpedicaoIdiomas)
            //        .HasForeignKey(d => d.IdformaExpedicao)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFormasExpedicaoIdiomas_tbFormasExpedicao");

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbFormasExpedicaoIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFormasExpedicaoIdiomas_tbIdiomas");
            //});



            //modelBuilder.Entity<TbFormasPagamentoIdiomas>(entity =>
            //{
            //    entity.ToTable("tbFormasPagamentoIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdformaPagamentoNavigation)
            //        .WithMany(p => p.TbFormasPagamentoIdiomas)
            //        .HasForeignKey(d => d.IdformaPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFormasPagamentoIdiomas_tbFormasPagamento");

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbFormasPagamentoIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFormasPagamentoIdiomas_tbIdiomas");
            //});



            //modelBuilder.Entity<TbFornecedoresAnexos>(entity =>
            //{
            //    entity.ToTable("tbFornecedoresAnexos");

            //    entity.HasIndex(e => new { e.Idfornecedor, e.Ficheiro })
            //        .HasName("IX_tbFornecedoresAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.Idfornecedor).HasColumnName("IDFornecedor");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdfornecedorNavigation)
            //        .WithMany(p => p.TbFornecedoresAnexos)
            //        .HasForeignKey(d => d.Idfornecedor)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFornecedoresAnexos_tbFornecedores");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbFornecedoresAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbFornecedoresAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbFornecedoresContatos>(entity =>
            //{
            //    entity.ToTable("tbFornecedoresContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.Idfornecedor).HasColumnName("IDFornecedor");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdfornecedorNavigation)
            //        .WithMany(p => p.TbFornecedoresContatos)
            //        .HasForeignKey(d => d.Idfornecedor)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFornecedoresContatos_tbFornecedores");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbFornecedoresContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbFornecedoresContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbFornecedoresMoradas>(entity =>
            //{
            //    entity.ToTable("tbFornecedoresMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.Idfornecedor).HasColumnName("IDFornecedor");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbFornecedoresMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbFornecedoresMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbFornecedoresMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbFornecedoresMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbFornecedoresMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbFornecedoresMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdfornecedorNavigation)
            //        .WithMany(p => p.TbFornecedoresMoradas)
            //        .HasForeignKey(d => d.Idfornecedor)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFornecedoresMoradas_tbFornecedores");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbFornecedoresMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbFornecedoresMoradas_tbPaises");
            //});

            //modelBuilder.Entity<TbFornecedoresTiposFornecimento>(entity =>
            //{
            //    entity.ToTable("tbFornecedoresTiposFornecimento");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idfornecedor).HasColumnName("IDFornecedor");

            //    entity.Property(e => e.IdtipoFornecimento).HasColumnName("IDTipoFornecimento");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdfornecedorNavigation)
            //        .WithMany(p => p.TbFornecedoresTiposFornecimento)
            //        .HasForeignKey(d => d.Idfornecedor)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFornecedoresTiposFornecimento_tbFornecedores");

            //    entity.HasOne(d => d.IdtipoFornecimentoNavigation)
            //        .WithMany(p => p.TbFornecedoresTiposFornecimento)
            //        .HasForeignKey(d => d.IdtipoFornecimento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbFornecedoresTiposFornecimento_tbTiposFornecimentos");
            //});

            //modelBuilder.Entity<TbGamasLentes>(entity =>
            //{
            //    entity.ToTable("tbGamasLentes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DiamAte).HasMaxLength(10);

            //    entity.Property(e => e.DiamDe).HasMaxLength(10);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.IdtratamentoLente).HasColumnName("IDTratamentoLente");

            //    entity.Property(e => e.Raio).HasMaxLength(5);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbGamasLentes)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbGamasLentes_tbModelos");

            //    entity.HasOne(d => d.IdtratamentoLenteNavigation)
            //        .WithMany(p => p.TbGamasLentes)
            //        .HasForeignKey(d => d.IdtratamentoLente)
            //        .HasConstraintName("FK_tbGamasLentes_tbTratamentosLentes");
            //});

            //modelBuilder.Entity<TbGruposArtigo>(entity =>
            //{
            //    entity.ToTable("tbGruposArtigo");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbGruposCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbIdiomas>(entity =>
            //{
            //    entity.ToTable("tbIdiomas");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(40);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idcultura).HasColumnName("IDCultura");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdculturaNavigation)
            //        .WithMany(p => p.TbIdiomas)
            //        .HasForeignKey(d => d.Idcultura)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbIdiomas_tbSistemaIdiomas");
            //});

            //modelBuilder.Entity<TbImpostoSelo>(entity =>
            //{
            //    entity.ToTable("tbImpostoSelo");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbImpostoSeloCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdverbaIs).HasColumnName("IDVerbaIS");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdverbaIsNavigation)
            //        .WithMany(p => p.TbImpostoSelo)
            //        .HasForeignKey(d => d.IdverbaIs)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbImpostoSelo_tbSistemaVerbasIS");
            //});



            //modelBuilder.Entity<TbIvadescontos>(entity =>
            //{
            //    entity.ToTable("tbIVADescontos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idiva).HasColumnName("IDIva");

            //    entity.Property(e => e.Pcm).HasColumnName("PCM");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdivaNavigation)
            //        .WithMany(p => p.TbIvadescontos)
            //        .HasForeignKey(d => d.Idiva)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbIVADescontos_tbIVA");
            //});

            //modelBuilder.Entity<TbLentesContato>(entity =>
            //{
            //    entity.ToTable("tbLentesContato");

            //    entity.HasIndex(e => new { e.Idmodelo, e.Raio, e.Diametro, e.PotenciaEsferica, e.PotenciaCilindrica, e.Eixo, e.Adicao })
            //        .HasName("IX_tbLentesContato")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Diametro).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.Raio).HasMaxLength(50);

            //    entity.Property(e => e.Raio2).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.ContactLenses)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbLentesContato_tbArtigos");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbLentesContato)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbLentesContato_tbModelos");
            //});

            //modelBuilder.Entity<TbLentesOftalmicas>(entity =>
            //{
            //    entity.ToTable("tbLentesOftalmicas");

            //    entity.HasIndex(e => new { e.Idmodelo, e.IdtratamentoLente, e.IdcorLente, e.Diametro, e.PotenciaEsferica, e.PotenciaCilindrica, e.PotenciaPrismatica, e.Adicao, e.CodigosSuplementos })
            //        .HasName("IX_tbLentesOftalmicas")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigosSuplementos).HasMaxLength(360);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Diametro).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdcorLente).HasColumnName("IDCorLente");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.IdtratamentoLente).HasColumnName("IDTratamentoLente");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.OphthalmicLenses)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbLentesOftalmicas_tbArtigos");

            //    entity.HasOne(d => d.IdcorLenteNavigation)
            //        .WithMany(p => p.TbLentesOftalmicas)
            //        .HasForeignKey(d => d.IdcorLente)
            //        .HasConstraintName("FK_tbLentesOftalmicas_tbCoresLentes");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbLentesOftalmicas)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbLentesOftalmicas_tbModelos");

            //    entity.HasOne(d => d.IdtratamentoLenteNavigation)
            //        .WithMany(p => p.TbLentesOftalmicas)
            //        .HasForeignKey(d => d.IdtratamentoLente)
            //        .HasConstraintName("FK_tbLentesOftalmicas_tbTratamentosLentes");
            //});

            //modelBuilder.Entity<TbLentesOftalmicasSuplementos>(entity =>
            //{
            //    entity.ToTable("tbLentesOftalmicasSuplementos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdlenteOftalmica).HasColumnName("IDLenteOftalmica");

            //    entity.Property(e => e.IdsuplementoLente).HasColumnName("IDSuplementoLente");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdlenteOftalmicaNavigation)
            //        .WithMany(p => p.TbLentesOftalmicasSuplementos)
            //        .HasForeignKey(d => d.IdlenteOftalmica)
            //        .HasConstraintName("FK_tbLentesOftalmicasSuplementos_tbLentesOftalmicas");

            //    entity.HasOne(d => d.IdsuplementoLenteNavigation)
            //        .WithMany(p => p.TbLentesOftalmicasSuplementos)
            //        .HasForeignKey(d => d.IdsuplementoLente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbLentesOftalmicasSuplementos_tbSuplementosLentes");
            //});



            //modelBuilder.Entity<TbMapaCaixa>(entity =>
            //{
            //    entity.ToTable("tbMapaCaixa");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.DescricaoFormaPagamento).HasMaxLength(255);

            //    entity.Property(e => e.Estado).HasMaxLength(10);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoDocumentoSeries).HasColumnName("IDTipoDocumentoSeries");

            //    entity.Property(e => e.Natureza).HasMaxLength(2);

            //    entity.Property(e => e.NumeroDocumento).HasMaxLength(100);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});



            //modelBuilder.Entity<TbMarcas>(entity =>
            //{
            //    entity.ToTable("tbMarcas");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbMedicosTecnicos>(entity =>
            //{
            //    entity.ToTable("tbMedicosTecnicos");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Abreviatura).HasMaxLength(50);

            //    entity.Property(e => e.Apelido).HasMaxLength(50);

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Cabecalho).HasMaxLength(4000);

            //    entity.Property(e => e.CartaoCidadao).HasMaxLength(25);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Cor).HasMaxLength(10);

            //    entity.Property(e => e.CorFundo).HasDefaultValueSql("((8410939))");

            //    entity.Property(e => e.CorFundo1).HasDefaultValueSql("((13741460))");

            //    entity.Property(e => e.CorTexto).HasDefaultValueSql("((16777196))");

            //    entity.Property(e => e.CorTexto1).HasDefaultValueSql("((16777196))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataNascimento).HasColumnType("datetime");

            //    entity.Property(e => e.DataValidade).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Foto).HasMaxLength(255);

            //    entity.Property(e => e.FotoCaminho).HasMaxLength(4000);

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Idsexo).HasColumnName("IDSexo");

            //    entity.Property(e => e.IdsistemaAcoes).HasColumnName("IDSistemaAcoes");

            //    entity.Property(e => e.Idtemplate).HasColumnName("IDTemplate");

            //    entity.Property(e => e.IdtipoConsulta).HasColumnName("IDTipoConsulta");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.Idutilizador).HasColumnName("IDUtilizador");

            //    entity.Property(e => e.Ncedula)
            //        .HasColumnName("NCedula")
            //        .HasMaxLength(25);

            //    entity.Property(e => e.Ncontribuinte)
            //        .HasColumnName("NContribuinte")
            //        .HasMaxLength(25);

            //    entity.Property(e => e.Nome)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.Observacoes).HasMaxLength(4000);

            //    entity.Property(e => e.TemAgenda)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Tempoconsulta).HasDefaultValueSql("((30))");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbLojas");

            //    entity.HasOne(d => d.IdsexoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.Idsexo)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbSistemaSexo");

            //    entity.HasOne(d => d.IdsistemaAcoesNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.IdsistemaAcoes)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbSistemaAcoes");

            //    entity.HasOne(d => d.IdtemplateNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.Idtemplate)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbTemplates");

            //    entity.HasOne(d => d.IdtipoConsultaNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.IdtipoConsulta)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbTiposConsultas");

            //    entity.HasOne(d => d.IdtipoEntidadeNavigation)
            //        .WithMany(p => p.TbMedicosTecnicos)
            //        .HasForeignKey(d => d.IdtipoEntidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMedicosTecnicos_tbSistemaTiposEntidade");
            //});

            //modelBuilder.Entity<TbMedicosTecnicosAnexos>(entity =>
            //{
            //    entity.ToTable("tbMedicosTecnicosAnexos");

            //    entity.HasIndex(e => new { e.IdmedicoTecnico, e.Ficheiro })
            //        .HasName("IX_tbMedicosTecnicosAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosAnexos)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMedicosTecnicosAnexos_tbMedicosTecnicos");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbMedicosTecnicosAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbMedicosTecnicosContatos>(entity =>
            //{
            //    entity.ToTable("tbMedicosTecnicosContatos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Contato).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.Email).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Fax).HasMaxLength(25);

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.Idtipo).HasColumnName("IDTipo");

            //    entity.Property(e => e.Mailing)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.PagRedeSocial).HasMaxLength(255);

            //    entity.Property(e => e.PagWeb).HasMaxLength(255);

            //    entity.Property(e => e.Telefone).HasMaxLength(25);

            //    entity.Property(e => e.Telemovel).HasMaxLength(25);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosContatos)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .HasConstraintName("FK_tbMedicosTecnicosContatos_tbMedicostecnicos");

            //    entity.HasOne(d => d.IdtipoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosContatos)
            //        .HasForeignKey(d => d.Idtipo)
            //        .HasConstraintName("FK_tbMedicosTecnicosContatos_tbTiposContatos");
            //});

            //modelBuilder.Entity<TbMedicosTecnicosEspecialidades>(entity =>
            //{
            //    entity.ToTable("tbMedicosTecnicosEspecialidades");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idespecialidade).HasColumnName("IDEspecialidade");

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdespecialidadeNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosEspecialidades)
            //        .HasForeignKey(d => d.Idespecialidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMedicosTecnicosEspecialidades_tbEspecialidades");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosEspecialidades)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMedicosTecnicosEspecialidades_tbMedicosTecnicos");
            //});

            //modelBuilder.Entity<TbMedicosTecnicosMoradas>(entity =>
            //{
            //    entity.ToTable("tbMedicosTecnicosMoradas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Gps)
            //        .HasColumnName("GPS")
            //        .HasMaxLength(100);

            //    entity.Property(e => e.IdcodigoPostal).HasColumnName("IDCodigoPostal");

            //    entity.Property(e => e.Idconcelho).HasColumnName("IDConcelho");

            //    entity.Property(e => e.Iddistrito).HasColumnName("IDDistrito");

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //    entity.Property(e => e.Morada)
            //        .HasMaxLength(100)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Rota).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcodigoPostalNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosMoradas)
            //        .HasForeignKey(d => d.IdcodigoPostal)
            //        .HasConstraintName("FK_tbMedicosTecnicosMoradas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosMoradas)
            //        .HasForeignKey(d => d.Idconcelho)
            //        .HasConstraintName("FK_tbMedicosTecnicosMoradas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosMoradas)
            //        .HasForeignKey(d => d.Iddistrito)
            //        .HasConstraintName("FK_tbMedicosTecnicosMoradas_tbDistritos");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosMoradas)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMedicosTecnicosMoradas_tbMedicosTecnicos");

            //    entity.HasOne(d => d.IdpaisNavigation)
            //        .WithMany(p => p.TbMedicosTecnicosMoradas)
            //        .HasForeignKey(d => d.Idpais)
            //        .HasConstraintName("FK_tbMedicosTecnicosMoradas_tbPaises");
            //});

            //modelBuilder.Entity<TbModelos>(entity =>
            //{
            //    entity.ToTable("tbModelos");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodCor).HasMaxLength(50);

            //    entity.Property(e => e.CodForn).HasMaxLength(100);

            //    entity.Property(e => e.CodInstrucao).HasMaxLength(50);

            //    entity.Property(e => e.CodTratamento).HasMaxLength(50);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmarca).HasColumnName("IDMarca");

            //    entity.Property(e => e.IdmateriaLente).HasColumnName("IDMateriaLente");

            //    entity.Property(e => e.IdsuperficieLente).HasColumnName("IDSuperficieLente");

            //    entity.Property(e => e.IdtipoArtigo).HasColumnName("IDTipoArtigo");

            //    entity.Property(e => e.IdtipoLente).HasColumnName("IDTipoLente");

            //    entity.Property(e => e.Infravermelhos).HasMaxLength(15);

            //    entity.Property(e => e.Material).HasMaxLength(15);

            //    entity.Property(e => e.ModeloForn).HasMaxLength(50);

            //    entity.Property(e => e.NrAbbe)
            //        .HasColumnName("NrABBE")
            //        .HasMaxLength(15);

            //    entity.Property(e => e.Observacoes).HasMaxLength(4000);

            //    entity.Property(e => e.Referencia).HasMaxLength(50);

            //    entity.Property(e => e.TransmissaoLuz).HasMaxLength(15);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Uva)
            //        .HasColumnName("UVA")
            //        .HasMaxLength(15);

            //    entity.Property(e => e.Uvb)
            //        .HasColumnName("UVB")
            //        .HasMaxLength(15);

            //    entity.HasOne(d => d.IdmarcaNavigation)
            //        .WithMany(p => p.TbModelos)
            //        .HasForeignKey(d => d.Idmarca)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbModelos_tbMarcas");

            //    entity.HasOne(d => d.IdmateriaLenteNavigation)
            //        .WithMany(p => p.TbModelos)
            //        .HasForeignKey(d => d.IdmateriaLente)
            //        .HasConstraintName("FK_tbModelos_tbSistemaMateriasLentes");

            //    entity.HasOne(d => d.IdsuperficieLenteNavigation)
            //        .WithMany(p => p.TbModelos)
            //        .HasForeignKey(d => d.IdsuperficieLente)
            //        .HasConstraintName("FK_tbModelos_tbSistemaSuperficiesLentes");

            //    entity.HasOne(d => d.IdtipoArtigoNavigation)
            //        .WithMany(p => p.TbModelos)
            //        .HasForeignKey(d => d.IdtipoArtigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbModelos_tbTiposArtigos");

            //    entity.HasOne(d => d.IdtipoLenteNavigation)
            //        .WithMany(p => p.TbModelos)
            //        .HasForeignKey(d => d.IdtipoLente)
            //        .HasConstraintName("FK_tbModelos_tbSistemaTiposLentes");
            //});

            //modelBuilder.Entity<TbMoedas>(entity =>
            //{
            //    entity.ToTable("tbMoedas");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.DescricaoDecimal)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.DescricaoInteira)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdsistemaMoeda).HasColumnName("IDSistemaMoeda");

            //    entity.Property(e => e.Simbolo).HasMaxLength(3);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdsistemaMoedaNavigation)
            //        .WithMany(p => p.TbMoedas)
            //        .HasForeignKey(d => d.IdsistemaMoeda)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbMoedas_tbSistemaMoedas");
            //});

            //modelBuilder.Entity<TbOculosSol>(entity =>
            //{
            //    entity.ToTable("tbOculosSol");

            //    entity.HasIndex(e => new { e.Idmodelo, e.CodigoCor, e.Tamanho, e.Hastes })
            //        .HasName("IX_tbOculosSol")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoCor).HasMaxLength(50);

            //    entity.Property(e => e.CorGenerica).HasMaxLength(50);

            //    entity.Property(e => e.CorLente).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Hastes).HasMaxLength(50);

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.Tamanho).HasMaxLength(50);

            //    entity.Property(e => e.TipoLente).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.Sunglasses)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbOculosSol_tbArtigos");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbOculosSol)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbOculosSol_IDModelo");
            //});



            //modelBuilder.Entity<TbPagamentosComprasAnexos>(entity =>
            //{
            //    entity.ToTable("tbPagamentosComprasAnexos");

            //    entity.HasIndex(e => new { e.IdpagamentoCompra, e.Ficheiro })
            //        .HasName("IX_tbPagamentosComprasAnexos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.FicheiroOriginal).HasMaxLength(255);

            //    entity.Property(e => e.FicheiroThumbnail).HasMaxLength(300);

            //    entity.Property(e => e.IdpagamentoCompra).HasColumnName("IDPagamentoCompra");

            //    entity.Property(e => e.IdtipoAnexo).HasColumnName("IDTipoAnexo");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdpagamentoCompraNavigation)
            //        .WithMany(p => p.TbPagamentosComprasAnexos)
            //        .HasForeignKey(d => d.IdpagamentoCompra)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbPagamentosComprasAnexos_tbPagamentosCompras");

            //    entity.HasOne(d => d.IdtipoAnexoNavigation)
            //        .WithMany(p => p.TbPagamentosComprasAnexos)
            //        .HasForeignKey(d => d.IdtipoAnexo)
            //        .HasConstraintName("FK_tbPagamentosComprasAnexos_tbSistemaTiposAnexos");
            //});

            //modelBuilder.Entity<TbPagamentosComprasFormasPagamento>(entity =>
            //{
            //    entity.ToTable("tbPagamentosComprasFormasPagamento");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoFormaPagamento).HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdpagamentoCompra).HasColumnName("IDPagamentoCompra");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdformaPagamentoNavigation)
            //        .WithMany(p => p.TbPagamentosComprasFormasPagamento)
            //        .HasForeignKey(d => d.IdformaPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbPagamentosComprasFormasPagamento_tbFormasPagamento");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbPagamentosComprasFormasPagamento)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbPagamentosComprasFormasPagamento_tbMoedas");

            //    entity.HasOne(d => d.IdpagamentoCompraNavigation)
            //        .WithMany(p => p.TbPagamentosComprasFormasPagamento)
            //        .HasForeignKey(d => d.IdpagamentoCompra)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbPagamentosComprasFormasPagamento_tbPagamentosCompras");
            //});

            //            modelBuilder.Entity<TbPagamentosComprasLinhas>(entity =>
            //            {
            //                entity.ToTable("tbPagamentosComprasLinhas");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //                entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //                entity.Property(e => e.DescricaoEntidade).HasMaxLength(200);

            //                entity.Property(e => e.Documento).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IddocumentoCompra).HasColumnName("IDDocumentoCompra");

            //                entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //                entity.Property(e => e.IdpagamentoCompra).HasColumnName("IDPagamentoCompra");

            //                entity.Property(e => e.IdsistemaNaturezas).HasColumnName("IDSistemaNaturezas");

            //                entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //                entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //                entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IddocumentoCompraNavigation)
            //                    .WithMany(p => p.PurchasePayments)
            //                    .HasForeignKey(d => d.IddocumentoCompra)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbDocumentosCompras");

            //                entity.HasOne(d => d.IdentidadeNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.Identidade)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbClientes");

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbLojas");

            //                entity.HasOne(d => d.IdmoedaNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.Idmoeda)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbMoedas");

            //                entity.HasOne(d => d.IdpagamentoCompraNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.IdpagamentoCompra)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbPagamentosCompras");

            //                entity.HasOne(d => d.IdsistemaNaturezasNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.IdsistemaNaturezas)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbSistemaNaturezas");

            //                entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.IdtipoDocumento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbTiposDocumento");

            //                entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //                    .WithMany(p => p.TbPagamentosComprasLinhas)
            //                    .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosComprasLinhas_tbTiposDocumentoSeries");
            //            });

            //            modelBuilder.Entity<TbPagamentosVendas>(entity =>
            //            {
            //                entity.ToTable("tbPagamentosVendas");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.CodigoTipoEstado).HasMaxLength(6);

            //                entity.Property(e => e.Data).HasColumnType("datetime");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.Descricao).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendas)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbPagamentosVendas_tbLojas");

            //                entity.HasOne(d => d.IdmoedaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendas)
            //                    .HasForeignKey(d => d.Idmoeda)
            //                    .HasConstraintName("FK_tbPagamentosVendas_tbMoedas");
            //            });

            //            modelBuilder.Entity<TbPagamentosVendasFormasPagamento>(entity =>
            //            {
            //                entity.ToTable("tbPagamentosVendasFormasPagamento");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //                entity.Property(e => e.IdpagamentoVenda).HasColumnName("IDPagamentoVenda");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IdformaPagamentoNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasFormasPagamento)
            //                    .HasForeignKey(d => d.IdformaPagamento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasFormasPagamento_tbFormasPagamento");

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasFormasPagamento)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbPagamentosVendasFormasPagamento_tbLojas");

            //                entity.HasOne(d => d.IdpagamentoVendaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasFormasPagamento)
            //                    .HasForeignKey(d => d.IdpagamentoVenda)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasFormasPagamento_tbPagamentosVendas");
            //            });

            //            modelBuilder.Entity<TbPagamentosVendasLinhas>(entity =>
            //            {
            //                entity.ToTable("tbPagamentosVendasLinhas");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //                entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //                entity.Property(e => e.Documento).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //                entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //                entity.Property(e => e.IdpagamentoVenda).HasColumnName("IDPagamentoVenda");

            //                entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //                entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IddocumentoVendaNavigation)
            //                    .WithMany(p => p.SalesPayments)
            //                    .HasForeignKey(d => d.IddocumentoVenda)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbDocumentosVendas");

            //                entity.HasOne(d => d.IdentidadeNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.Identidade)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbClientes");

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbLojas");

            //                entity.HasOne(d => d.IdmoedaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.Idmoeda)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbMoedas");

            //                entity.HasOne(d => d.IdpagamentoVendaNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.IdpagamentoVenda)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbPagamentosVendas");

            //                entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.IdtipoDocumento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbTiposDocumento");

            //                entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //                    .WithMany(p => p.TbPagamentosVendasLinhas)
            //                    .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPagamentosVendasLinhas_tbTiposDocumentoSeries");
            //            });



            //            modelBuilder.Entity<TbParametrizacaoConsentimentos>(entity =>
            //            {
            //                entity.ToTable("tbParametrizacaoConsentimentos");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.Codigo)
            //                    .IsRequired()
            //                    .HasMaxLength(30);

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.Descricao).HasMaxLength(256);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdfuncionalidadeConsentimento).HasColumnName("IDFuncionalidadeConsentimento");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IdfuncionalidadeConsentimentoNavigation)
            //                    .WithMany(p => p.TbParametrizacaoConsentimentos)
            //                    .HasForeignKey(d => d.IdfuncionalidadeConsentimento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrizacaoConsentimentos_tbSistemaFuncionalidadesConsentimento");
            //            });

            //            modelBuilder.Entity<TbParametrizacaoConsentimentosCamposEntidade>(entity =>
            //            {
            //                entity.ToTable("tbParametrizacaoConsentimentosCamposEntidade");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.AliasLeftJoin).HasMaxLength(100);

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DescricaoCampo)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdparametrizacaoConsentimento).HasColumnName("IDParametrizacaoConsentimento");

            //                entity.Property(e => e.IdsistemaFuncionalidadesConsentimento).HasColumnName("IDSistemaFuncionalidadesConsentimento");

            //                entity.Property(e => e.NomeCampo)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.NomeCampoChave)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.Tabela)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.TamanhoMaximoCampo).HasMaxLength(256);

            //                entity.Property(e => e.TipoCampo)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IdparametrizacaoConsentimentoNavigation)
            //                    .WithMany(p => p.TbParametrizacaoConsentimentosCamposEntidade)
            //                    .HasForeignKey(d => d.IdparametrizacaoConsentimento)
            //                    .HasConstraintName("FK_tbParametrizacaoConsentimentosCamposEntidade_tbParametrizacaoConsentimentos");

            //                entity.HasOne(d => d.IdsistemaFuncionalidadesConsentimentoNavigation)
            //                    .WithMany(p => p.TbParametrizacaoConsentimentosCamposEntidade)
            //                    .HasForeignKey(d => d.IdsistemaFuncionalidadesConsentimento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrizacaoConsentimentosCamposEntidade_tbSistemaFuncionalidadesConsentimento");
            //            });

            //            modelBuilder.Entity<TbParametrizacaoConsentimentosPerguntas>(entity =>
            //            {
            //                entity.ToTable("tbParametrizacaoConsentimentosPerguntas");

            //                entity.HasIndex(e => new { e.Codigo, e.IdparametrizacaoConsentimento })
            //                    .HasName("IX_tbParametrizacaoConsentimentosPerguntas_Codigo_IDPa")
            //                    .IsUnique();

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.DataAlteracao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.Descricao).IsRequired();

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdparametrizacaoConsentimento).HasColumnName("IDParametrizacaoConsentimento");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql("('')");

            //                entity.HasOne(d => d.IdparametrizacaoConsentimentoNavigation)
            //                    .WithMany(p => p.TbParametrizacaoConsentimentosPerguntas)
            //                    .HasForeignKey(d => d.IdparametrizacaoConsentimento)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrizacaoConsentimentosPerguntas_tbParametrizacaoConsentimentos");
            //            });

            //            modelBuilder.Entity<TbParametrosCamposContexto>(entity =>
            //            {
            //                entity.ToTable("tbParametrosCamposContexto");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Accao).HasMaxLength(255);

            //                entity.Property(e => e.AccaoExtra).HasMaxLength(255);

            //                entity.Property(e => e.CodigoCampo)
            //                    .IsRequired()
            //                    .HasMaxLength(20);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.DescricaoCampo)
            //                    .IsRequired()
            //                    .HasMaxLength(100);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Filtro).HasMaxLength(255);

            //                entity.Property(e => e.IdparametroContexto).HasColumnName("IDParametroContexto");

            //                entity.Property(e => e.IdtipoDados).HasColumnName("IDTipoDados");

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(255);

            //                entity.Property(e => e.ValorCampo).HasMaxLength(255);

            //                entity.Property(e => e.ValorMax).HasMaxLength(100);

            //                entity.Property(e => e.ValorMin).HasMaxLength(100);

            //                entity.HasOne(d => d.IdparametroContextoNavigation)
            //                    .WithMany(p => p.TbParametrosCamposContexto)
            //                    .HasForeignKey(d => d.IdparametroContexto)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrosCamposContexto_tbParametrosContexto");

            //                entity.HasOne(d => d.IdtipoDadosNavigation)
            //                    .WithMany(p => p.TbParametrosCamposContexto)
            //                    .HasForeignKey(d => d.IdtipoDados)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrosCamposContexto_tbTiposDados");
            //            });

            //            modelBuilder.Entity<TbParametrosContexto>(entity =>
            //            {
            //                entity.ToTable("tbParametrosContexto");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Accao).HasMaxLength(255);

            //                entity.Property(e => e.Codigo)
            //                    .IsRequired()
            //                    .HasMaxLength(20);

            //                entity.Property(e => e.CodigoPai).HasMaxLength(20);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.Descricao)
            //                    .IsRequired()
            //                    .HasMaxLength(100);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.Idpai).HasColumnName("IDPai");

            //                entity.Property(e => e.IdparametrosEmpresa).HasColumnName("IDParametrosEmpresa");

            //                entity.Property(e => e.MostraConteudo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(255);

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbParametrosContexto)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbParametrosContexto_tbLojas");

            //                entity.HasOne(d => d.IdpaiNavigation)
            //                    .WithMany(p => p.InverseIdpaiNavigation)
            //                    .HasForeignKey(d => d.Idpai)
            //                    .HasConstraintName("FK_tbParametrosContexto_tbParametrosContexto");

            //                entity.HasOne(d => d.IdparametrosEmpresaNavigation)
            //                    .WithMany(p => p.TbParametrosContexto)
            //                    .HasForeignKey(d => d.IdparametrosEmpresa)
            //                    .HasConstraintName("FK_tbParametrosContexto_tbParametrosEmpresa");
            //            });

            //            modelBuilder.Entity<TbParametrosEmpresa>(entity =>
            //            {
            //                entity.ToTable("tbParametrosEmpresa");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.CapitalSocial).HasMaxLength(255);

            //                entity.Property(e => e.CodigoPostal).HasMaxLength(8);

            //                entity.Property(e => e.Concelho).HasMaxLength(50);

            //                entity.Property(e => e.ConservatoriaRegistoComercial).HasMaxLength(35);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.DesignacaoComercial).HasMaxLength(160);

            //                entity.Property(e => e.Distrito).HasMaxLength(50);

            //                entity.Property(e => e.Email).HasMaxLength(60);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Fax).HasMaxLength(20);

            //                entity.Property(e => e.Foto).HasMaxLength(255);

            //                entity.Property(e => e.Idempresa).HasColumnName("IDEmpresa");

            //                entity.Property(e => e.IdidiomaBase).HasColumnName("IDIdiomaBase");

            //                entity.Property(e => e.IdmoedaDefeito).HasColumnName("IDMoedaDefeito");

            //                entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //                entity.Property(e => e.IdpaisesDesc).HasColumnName("IDPaisesDesc");

            //                entity.Property(e => e.Localidade).HasMaxLength(50);

            //                entity.Property(e => e.Morada).HasMaxLength(100);

            //                entity.Property(e => e.Nif)
            //                    .HasColumnName("NIF")
            //                    .HasMaxLength(9);

            //                entity.Property(e => e.NumeroRegistoComercial).HasMaxLength(15);

            //                entity.Property(e => e.Telefone).HasMaxLength(20);

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(255);

            //                entity.Property(e => e.WebSite).HasMaxLength(60);

            //                entity.HasOne(d => d.IdidiomaBaseNavigation)
            //                    .WithMany(p => p.TbParametrosEmpresa)
            //                    .HasForeignKey(d => d.IdidiomaBase)
            //                    .HasConstraintName("FK_tbParametrosEmpresa_tbSistemaIdiomas");

            //                entity.HasOne(d => d.IdmoedaDefeitoNavigation)
            //                    .WithMany(p => p.TbParametrosEmpresa)
            //                    .HasForeignKey(d => d.IdmoedaDefeito)
            //                    .HasConstraintName("FK_tbParametrosEmpresa_tbMoedas");

            //                entity.HasOne(d => d.IdpaisNavigation)
            //                    .WithMany(p => p.TbParametrosEmpresa)
            //                    .HasForeignKey(d => d.Idpais)
            //                    .HasConstraintName("FK_tbParametrosEmpresa_tbSistemaSiglasPaises");

            //                entity.HasOne(d => d.IdpaisesDescNavigation)
            //                    .WithMany(p => p.TbParametrosEmpresa)
            //                    .HasForeignKey(d => d.IdpaisesDesc)
            //                    .HasConstraintName("FK_tbParametrosEmpresa_tbPaises");
            //            });

            //            modelBuilder.Entity<TbParametrosEmpresaCae>(entity =>
            //            {
            //                entity.ToTable("tbParametrosEmpresaCAE");

            //                entity.HasIndex(e => e.Codigo)
            //                    .HasName("IX_tbParametrosEmpresaCAE")
            //                    .IsUnique();

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Codigo).HasMaxLength(5);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.Descricao).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdparametrosEmpresa).HasColumnName("IDParametrosEmpresa");

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.HasOne(d => d.IdparametrosEmpresaNavigation)
            //                    .WithMany(p => p.TbParametrosEmpresaCae)
            //                    .HasForeignKey(d => d.IdparametrosEmpresa)
            //                    .HasConstraintName("FK_tbParametrosEmpresaCAE_tbParametrosEmpresa");
            //            });

            //            modelBuilder.Entity<TbParametrosLoja>(entity =>
            //            {
            //                entity.ToTable("tbParametrosLoja");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.CapitalSocial).HasMaxLength(255);

            //                entity.Property(e => e.CodigoPostal).HasMaxLength(8);

            //                entity.Property(e => e.Concelho).HasMaxLength(50);

            //                entity.Property(e => e.ConservatoriaRegistoComercial).HasMaxLength(35);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.DesignacaoComercial).HasMaxLength(160);

            //                entity.Property(e => e.Distrito).HasMaxLength(50);

            //                entity.Property(e => e.Email).HasMaxLength(60);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Fax).HasMaxLength(20);

            //                entity.Property(e => e.Foto).HasMaxLength(255);

            //                entity.Property(e => e.IdidiomaBase).HasColumnName("IDIdiomaBase");

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.IdmoedaDefeito).HasColumnName("IDMoedaDefeito");

            //                entity.Property(e => e.Idpais).HasColumnName("IDPais");

            //                entity.Property(e => e.Localidade).HasMaxLength(50);

            //                entity.Property(e => e.Morada).HasMaxLength(100);

            //                entity.Property(e => e.Nif)
            //                    .HasColumnName("NIF")
            //                    .HasMaxLength(9);

            //                entity.Property(e => e.NumeroRegistoComercial).HasMaxLength(15);

            //                entity.Property(e => e.Telefone).HasMaxLength(20);

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(255);

            //                entity.Property(e => e.WebSite).HasMaxLength(60);

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbParametrosLoja)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .HasConstraintName("FK_tbParametrosLoja_IDLoja");

            //                entity.HasOne(d => d.IdmoedaDefeitoNavigation)
            //                    .WithMany(p => p.TbParametrosLoja)
            //                    .HasForeignKey(d => d.IdmoedaDefeito)
            //                    .HasConstraintName("FK_tbParametrosLoja_tbMoedas");

            //                entity.HasOne(d => d.IdpaisNavigation)
            //                    .WithMany(p => p.TbParametrosLoja)
            //                    .HasForeignKey(d => d.Idpais)
            //                    .HasConstraintName("FK_tbParametrosLoja_tbSistemaSiglasPaises");
            //            });

            //            modelBuilder.Entity<TbParametrosLojaLinhas>(entity =>
            //            {
            //                entity.ToTable("tbParametrosLojaLinhas");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Codigo).HasMaxLength(50);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.Descricao).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.TipoDados).HasMaxLength(255);

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.Property(e => e.Valor).HasMaxLength(255);

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbParametrosLojaLinhas)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrosLojaLinhas_tbLojas");
            //            });

            //            modelBuilder.Entity<TbParametrosLojaLinhasValores>(entity =>
            //            {
            //                entity.ToTable("tbParametrosLojaLinhasValores");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Codigo)
            //                    .HasMaxLength(50)
            //                    .IsUnicode(false);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //                entity.Property(e => e.Descricao).HasMaxLength(255);

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.IdparametroLojaLinha).HasColumnName("IDParametroLojaLinha");

            //                entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.HasOne(d => d.IdparametroLojaLinhaNavigation)
            //                    .WithMany(p => p.TbParametrosLojaLinhasValores)
            //                    .HasForeignKey(d => d.IdparametroLojaLinha)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbParametrosLojaLinhasValores_tbParametrosLojaLinhas");
            //            });

            //            modelBuilder.Entity<TbPlaneamento>(entity =>
            //            {
            //                entity.ToTable("tbPlaneamento");

            //                entity.Property(e => e.Id).HasColumnName("ID");

            //                entity.Property(e => e.Ativo)
            //                    .IsRequired()
            //                    .HasDefaultValueSql("((1))");

            //                entity.Property(e => e.Contacto).HasMaxLength(50);

            //                entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //                entity.Property(e => e.DataCriacao)
            //                    .HasColumnType("datetime")
            //                    .HasDefaultValueSql("(getdate())");

            //                entity.Property(e => e.End).HasColumnType("datetime");

            //                entity.Property(e => e.F3mmarcador)
            //                    .HasColumnName("F3MMarcador")
            //                    .IsRowVersion();

            //                entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //                entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //                entity.Property(e => e.Nome).HasMaxLength(256);

            //                entity.Property(e => e.Observacoes).HasMaxLength(256);

            //                entity.Property(e => e.Start).HasColumnType("datetime");

            //                entity.Property(e => e.UtilizadorAlteracao)
            //                    .HasMaxLength(256)
            //                    .HasDefaultValueSql(@"(') FOR [UtilizadorCriacao]
            //ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_DataAlteracao]  DEFAULT (getdate()) FOR [DataAlteracao]
            //ALTER TABLE [dbo].[tbPlaneamento] ADD  CONSTRAINT [DF_tbPlaneamento_UtilizadorAlteracao]  DEFAULT (')");

            //                entity.Property(e => e.UtilizadorCriacao)
            //                    .IsRequired()
            //                    .HasMaxLength(256);

            //                entity.HasOne(d => d.IdlojaNavigation)
            //                    .WithMany(p => p.TbPlaneamento)
            //                    .HasForeignKey(d => d.Idloja)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPlaneamento_tbLojas");

            //                entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //                    .WithMany(p => p.TbPlaneamento)
            //                    .HasForeignKey(d => d.IdmedicoTecnico)
            //                    .OnDelete(DeleteBehavior.ClientSetNull)
            //                    .HasConstraintName("FK_tbPlaneamento_tbMedicosTecnicos");
            //            });

            //modelBuilder.Entity<TbPrecosLentes>(entity =>
            //{
            //    entity.ToTable("tbPrecosLentes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DiamAte).HasMaxLength(10);

            //    entity.Property(e => e.DiamDe).HasMaxLength(10);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.IdtratamentoLente).HasColumnName("IDTratamentoLente");

            //    entity.Property(e => e.Raio).HasMaxLength(5);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbPrecosLentes)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbPrecosLentes_tbModelos");

            //    entity.HasOne(d => d.IdtratamentoLenteNavigation)
            //        .WithMany(p => p.TbPrecosLentes)
            //        .HasForeignKey(d => d.IdtratamentoLente)
            //        .HasConstraintName("FK_tbPrecosLentes_tbTratamentosLentes");
            //});

            //modelBuilder.Entity<TbProfissoes>(entity =>
            //{
            //    entity.ToTable("tbProfissoes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbRazoes>(entity =>
            //{
            //    entity.ToTable("tbRazoes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Data).HasColumnType("datetime");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.Opcao).HasMaxLength(255);

            //    entity.Property(e => e.Razao).HasMaxLength(4000);

            //    entity.Property(e => e.RegistoId).HasColumnName("RegistoID");

            //    entity.Property(e => e.TabelaBd)
            //        .IsRequired()
            //        .HasColumnName("TabelaBD")
            //        .HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbRazoes)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbRazoes_tbLojas");
            //});

            //modelBuilder.Entity<TbRecibos>(entity =>
            //{
            //    entity.ToTable("tbRecibos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CapitalSocialLoja).HasMaxLength(255);

            //    entity.Property(e => e.CodigoDocOrigem).HasMaxLength(255);

            //    entity.Property(e => e.CodigoEntidade).HasMaxLength(20);

            //    entity.Property(e => e.CodigoMoeda).HasMaxLength(20);

            //    entity.Property(e => e.CodigoPostalFiscal).HasMaxLength(50);

            //    entity.Property(e => e.CodigoPostalLoja).HasMaxLength(8);

            //    entity.Property(e => e.CodigoTipoEstado).HasMaxLength(20);

            //    entity.Property(e => e.ConservatoriaRegistoComerciaLoja).HasMaxLength(255);

            //    entity.Property(e => e.ContribuinteFiscal).HasMaxLength(25);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataAssinatura).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataHoraEstado).HasColumnType("datetime");

            //    entity.Property(e => e.DataUltimaImpressao).HasColumnType("datetime");

            //    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoCodigoPostalFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoConcelhoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoDistritoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DesignacaoComercialLoja).HasMaxLength(160);

            //    entity.Property(e => e.Documento).HasMaxLength(255);

            //    entity.Property(e => e.EmailLoja).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.FaxLoja).HasMaxLength(50);

            //    entity.Property(e => e.IdcodigoPostalFiscal).HasColumnName("IDCodigoPostalFiscal");

            //    entity.Property(e => e.IdconcelhoFiscal).HasColumnName("IDConcelhoFiscal");

            //    entity.Property(e => e.IddistritoFiscal).HasColumnName("IDDistritoFiscal");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idestado).HasColumnName("IDEstado");

            //    entity.Property(e => e.IdlocalOperacao).HasColumnName("IDLocalOperacao");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdlojaUltimaImpressao).HasColumnName("IDLojaUltimaImpressao");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.IdpagamentoVenda).HasColumnName("IDPagamentoVenda");

            //    entity.Property(e => e.IdpaisFiscal).HasColumnName("IDPaisFiscal");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtipoEntidade).HasColumnName("IDTipoEntidade");

            //    entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //    entity.Property(e => e.LocalidadeLoja).HasMaxLength(50);

            //    entity.Property(e => e.MensagemDocAt)
            //        .HasColumnName("MensagemDocAT")
            //        .HasMaxLength(1000);

            //    entity.Property(e => e.MoradaFiscal).HasMaxLength(100);

            //    entity.Property(e => e.MoradaLoja).HasMaxLength(100);

            //    entity.Property(e => e.Nifloja)
            //        .HasColumnName("NIFLoja")
            //        .HasMaxLength(9);

            //    entity.Property(e => e.NomeFiscal).HasMaxLength(200);

            //    entity.Property(e => e.NumeroRegistoComercialLoja).HasMaxLength(255);

            //    entity.Property(e => e.SiglaLoja).HasMaxLength(3);

            //    entity.Property(e => e.SiglaPaisFiscal).HasMaxLength(15);

            //    entity.Property(e => e.TelefoneLoja).HasMaxLength(50);

            //    entity.Property(e => e.TipoFiscal).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorEstado).HasMaxLength(20);

            //    entity.Property(e => e.ValorExtenso).HasMaxLength(4000);

            //    entity.HasOne(d => d.IdcodigoPostalFiscalNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdcodigoPostalFiscal)
            //        .HasConstraintName("FK_tbRecibos_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoFiscalNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdconcelhoFiscal)
            //        .HasConstraintName("FK_tbRecibos_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoFiscalNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IddistritoFiscal)
            //        .HasConstraintName("FK_tbRecibos_tbDistritos");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.Identidade)
            //        .HasConstraintName("FK_tbRecibos_tbClientes");

            //    entity.HasOne(d => d.IdestadoNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.Idestado)
            //        .HasConstraintName("FK_tbRecibos_tbEstados");

            //    entity.HasOne(d => d.IdlocalOperacaoNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdlocalOperacao)
            //        .HasConstraintName("FK_tbRecibos_tbSistemaRegioesIVA");

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbRecibos_tbLojas");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbRecibos_tbMoedas");

            //    entity.HasOne(d => d.IdpagamentoVendaNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdpagamentoVenda)
            //        .HasConstraintName("FK_tbRecibos_tbPagamentosVendas");

            //    entity.HasOne(d => d.IdpaisFiscalNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdpaisFiscal)
            //        .HasConstraintName("FK_tbRecibos_tbPaises");

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibos_tbTiposDocumento");

            //    entity.HasOne(d => d.IdtipoEntidadeNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdtipoEntidade)
            //        .HasConstraintName("FK_tbrecibos_tbSistemaTiposEntidade");

            //    entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //        .WithMany(p => p.TbRecibos)
            //        .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibos_tbTiposDocumentoSeries");
            //});

            //modelBuilder.Entity<TbRecibosFormasPagamento>(entity =>
            //{
            //    entity.ToTable("tbRecibosFormasPagamento");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoFormaPagamento).HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdformaPagamento).HasColumnName("IDFormaPagamento");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.Idrecibo).HasColumnName("IDRecibo");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdformaPagamentoNavigation)
            //        .WithMany(p => p.TbRecibosFormasPagamento)
            //        .HasForeignKey(d => d.IdformaPagamento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosFormasPagamento_tbFormasPagamento");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbRecibosFormasPagamento)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbRecibosFormasPagamento_tbMoedas");

            //    entity.HasOne(d => d.IdreciboNavigation)
            //        .WithMany(p => p.TbRecibosFormasPagamento)
            //        .HasForeignKey(d => d.Idrecibo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosFormasPagamento_tbRecibos");
            //});

            //modelBuilder.Entity<TbRecibosLinhas>(entity =>
            //{
            //    entity.ToTable("tbRecibosLinhas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoPostalFiscal).HasMaxLength(50);

            //    entity.Property(e => e.ContribuinteFiscal).HasMaxLength(25);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataDocOrigem).HasColumnType("datetime");

            //    entity.Property(e => e.DataDocumento).HasColumnType("datetime");

            //    entity.Property(e => e.DataVencimento).HasColumnType("datetime");

            //    entity.Property(e => e.DescricaoCodigoPostalFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoConcelhoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoDistritoFiscal).HasMaxLength(50);

            //    entity.Property(e => e.Documento).HasMaxLength(255);

            //    entity.Property(e => e.DocumentoOrigem).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdcodigoPostalFiscal).HasColumnName("IDCodigoPostalFiscal");

            //    entity.Property(e => e.IdconcelhoFiscal).HasColumnName("IDConcelhoFiscal");

            //    entity.Property(e => e.IddistritoFiscal).HasColumnName("IDDistritoFiscal");

            //    entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //    entity.Property(e => e.Identidade).HasColumnName("IDEntidade");

            //    entity.Property(e => e.Idmoeda).HasColumnName("IDMoeda");

            //    entity.Property(e => e.Idrecibo).HasColumnName("IDRecibo");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.IdtiposDocumentoSeries).HasColumnName("IDTiposDocumentoSeries");

            //    entity.Property(e => e.MoradaFiscal).HasMaxLength(100);

            //    entity.Property(e => e.NomeFiscal).HasMaxLength(200);

            //    entity.Property(e => e.SiglaPaisFiscal).HasMaxLength(15);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdcodigoPostalFiscalNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.IdcodigoPostalFiscal)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbCodigosPostais");

            //    entity.HasOne(d => d.IdconcelhoFiscalNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.IdconcelhoFiscal)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbConcelhos");

            //    entity.HasOne(d => d.IddistritoFiscalNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.IddistritoFiscal)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbDistritos");

            //    entity.HasOne(d => d.IddocumentoVendaNavigation)
            //        .WithMany(p => p.Receipts)
            //        .HasForeignKey(d => d.IddocumentoVenda)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbDocumentosVendas");

            //    entity.HasOne(d => d.IdentidadeNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.Identidade)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbClientes");

            //    entity.HasOne(d => d.IdmoedaNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.Idmoeda)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbMoedas");

            //    entity.HasOne(d => d.IdreciboNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.Idrecibo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbRecibos");

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbTiposDocumento");

            //    entity.HasOne(d => d.IdtiposDocumentoSeriesNavigation)
            //        .WithMany(p => p.TbRecibosLinhas)
            //        .HasForeignKey(d => d.IdtiposDocumentoSeries)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosLinhas_tbTiposDocumentoSeries");
            //});

            //modelBuilder.Entity<TbRecibosLinhasTaxas>(entity =>
            //{
            //    entity.ToTable("tbRecibosLinhasTaxas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoMotivoIsencaoIva).HasMaxLength(6);

            //    entity.Property(e => e.CodigoRegiaoIva).HasMaxLength(20);

            //    entity.Property(e => e.CodigoTaxaIva).HasMaxLength(255);

            //    entity.Property(e => e.CodigoTipoIva).HasMaxLength(20);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdreciboLinha).HasColumnName("IDReciboLinha");

            //    entity.Property(e => e.MotivoIsencaoIva).HasMaxLength(255);

            //    entity.Property(e => e.TipoTaxa).HasMaxLength(3);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdreciboLinhaNavigation)
            //        .WithMany(p => p.TbRecibosLinhasTaxas)
            //        .HasForeignKey(d => d.IdreciboLinha)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRecibosLinhasTaxas_tbRecibosLinhas");
            //});

            //modelBuilder.Entity<TbRespostasConsentimentos>(entity =>
            //{
            //    entity.ToTable("tbRespostasConsentimentos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao).IsRequired();

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idconsentimento).HasColumnName("IDConsentimento");

            //    entity.Property(e => e.IdparametrizacaoConsentimentoPerguntas).HasColumnName("IDParametrizacaoConsentimentoPerguntas");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdconsentimentoNavigation)
            //        .WithMany(p => p.TbRespostasConsentimentos)
            //        .HasForeignKey(d => d.Idconsentimento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRespostasConsentimentos_tbConsentimentos");

            //    entity.HasOne(d => d.IdparametrizacaoConsentimentoPerguntasNavigation)
            //        .WithMany(p => p.TbRespostasConsentimentos)
            //        .HasForeignKey(d => d.IdparametrizacaoConsentimentoPerguntas)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbRespostasConsentimentos_tbParametrizacaoConsentimentosPerguntas");
            //});

            //modelBuilder.Entity<TbSaft>(entity =>
            //{
            //    entity.ToTable("tbSAFT");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Caminho).IsRequired();

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataFim).HasColumnType("datetime");

            //    entity.Property(e => e.DataInicio).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ficheiro)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.TipoSaft).HasColumnName("TipoSAFT");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.Versao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbSaft)
            //        .HasForeignKey(d => d.Idloja)
            //        .HasConstraintName("FK_tbSAFT_tbLojas");
            //});

            //modelBuilder.Entity<TbSegmentosMercado>(entity =>
            //{
            //    entity.ToTable("tbSegmentosMercado");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbSegmentosMercadoCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSegmentosMercadoIdiomas>(entity =>
            //{
            //    entity.ToTable("tbSegmentosMercadoIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.IdsegmentoMercado).HasColumnName("IDSegmentoMercado");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbSegmentosMercadoIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSegmentosMercadoIdiomas_tbIdiomas");

            //    entity.HasOne(d => d.IdsegmentoMercadoNavigation)
            //        .WithMany(p => p.TbSegmentosMercadoIdiomas)
            //        .HasForeignKey(d => d.IdsegmentoMercado)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSegmentosMercadoIdiomas_tbSegmentosMercado");
            //});

            //modelBuilder.Entity<TbSemafroGereStock>(entity =>
            //{
            //    entity.ToTable("tbSemafroGereStock");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.CampoRelTabelaLinhasCab).HasMaxLength(100);

            //    entity.Property(e => e.CampoRelTabelaLinhasDistLinhas).HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.TabelaCabecalho).HasMaxLength(250);

            //    entity.Property(e => e.TabelaLinhas).HasMaxLength(250);

            //    entity.Property(e => e.TabelaLinhasDist).HasMaxLength(250);

            //    entity.Property(e => e.Utilizador).HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbServicos>(entity =>
            //{
            //    entity.ToTable("tbServicos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.BoxLonge).HasMaxLength(50);

            //    entity.Property(e => e.BoxPerto).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataEntregaLonge).HasColumnType("datetime");

            //    entity.Property(e => e.DataEntregaPerto).HasColumnType("datetime");

            //    entity.Property(e => e.DataReceita).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IddocumentoVenda).HasColumnName("IDDocumentoVenda");

            //    entity.Property(e => e.IdmedicoTecnico).HasColumnName("IDMedicoTecnico");

            //    entity.Property(e => e.IdtipoServico).HasColumnName("IDTipoServico");

            //    entity.Property(e => e.IdtipoServicoOlho).HasColumnName("IDTipoServicoOlho");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.VerPrismas).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.VisaoIntermedia).HasDefaultValueSql("((0))");

            //    entity.HasOne(d => d.IddocumentoVendaNavigation)
            //        .WithMany(p => p.Services)
            //        .HasForeignKey(d => d.IddocumentoVenda)
            //        .HasConstraintName("FK_tbServicos_tbDocumentosVendas");

            //    entity.HasOne(d => d.IdmedicoTecnicoNavigation)
            //        .WithMany(p => p.TbServicos)
            //        .HasForeignKey(d => d.IdmedicoTecnico)
            //        .HasConstraintName("FK_tbServicos_tbMedicosTecnicos");

            //    entity.HasOne(d => d.IdtipoServicoNavigation)
            //        .WithMany(p => p.TbServicos)
            //        .HasForeignKey(d => d.IdtipoServico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbServicos_tbSistemaTiposServicos");
            //});

            //modelBuilder.Entity<TbServicosFases>(entity =>
            //{
            //    entity.ToTable("tbServicosFases");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Data).HasColumnType("datetime");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idservico).HasColumnName("IDServico");

            //    entity.Property(e => e.IdtipoFase).HasColumnName("IDTipoFase");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdservicoNavigation)
            //        .WithMany(p => p.TbServicosFases)
            //        .HasForeignKey(d => d.Idservico)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbServicosFases_tbServicos");

            //    entity.HasOne(d => d.IdtipoFaseNavigation)
            //        .WithMany(p => p.TbServicosFases)
            //        .HasForeignKey(d => d.IdtipoFase)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbServicosFases_tbTiposFases");
            //});

            //modelBuilder.Entity<TbSetoresAtividade>(entity =>
            //{
            //    entity.ToTable("tbSetoresAtividade");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbSetoresAtividadeCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSetoresAtividadeIdiomas>(entity =>
            //{
            //    entity.ToTable("tbSetoresAtividadeIdiomas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.IdsetorAtividade).HasColumnName("IDSetorAtividade");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbSetoresAtividadeIdiomas)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSetoresAtividadeIdiomas_tbIdiomas");

            //    entity.HasOne(d => d.IdsetorAtividadeNavigation)
            //        .WithMany(p => p.TbSetoresAtividadeIdiomas)
            //        .HasForeignKey(d => d.IdsetorAtividade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSetoresAtividadeIdiomas_tbSetoresAtividade");
            //});

            //modelBuilder.Entity<TbSistemaAcoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaAcoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaCamposFormulas>(entity =>
            //{
            //    entity.ToTable("tbSistemaCamposFormulas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdentidadesFormulas).HasColumnName("IDEntidadesFormulas");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaClassificacoesTiposArtigos>(entity =>
            //{
            //    entity.ToTable("tbSistemaClassificacoesTiposArtigos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Sistema)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaClassificacoesTiposArtigosGeral>(entity =>
            //{
            //    entity.ToTable("tbSistemaClassificacoesTiposArtigosGeral");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodigoAt)
            //        .HasColumnName("CodigoAT")
            //        .HasMaxLength(3);

            //    entity.Property(e => e.CodigoSaft)
            //        .HasColumnName("CodigoSAFT")
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Sistema)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaCodigosIva>(entity =>
            //{
            //    entity.ToTable("tbSistemaCodigosIVA");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaCodigosPrecos>(entity =>
            //{
            //    entity.ToTable("tbSistemaCodigosPrecos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaCompostoTransformacaoMetodoCusto>(entity =>
            //{
            //    entity.ToTable("tbSistemaCompostoTransformacaoMetodoCusto");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEmissaoFatura>(entity =>
            //{
            //    entity.ToTable("tbSistemaEmissaoFatura");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEmissaoPackingList>(entity =>
            //{
            //    entity.ToTable("tbSistemaEmissaoPackingList");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEntidadeComparticipacao>(entity =>
            //{
            //    entity.ToTable("tbSistemaEntidadeComparticipacao");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEntidadeDescricao>(entity =>
            //{
            //    entity.ToTable("tbSistemaEntidadeDescricao");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEntidadesEstados>(entity =>
            //{
            //    entity.ToTable("tbSistemaEntidadesEstados");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEntidadesF3m>(entity =>
            //{
            //    entity.ToTable("tbSistemaEntidadesF3M");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEntidadesFormulas>(entity =>
            //{
            //    entity.ToTable("tbSistemaEntidadesFormulas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEspacoFiscal>(entity =>
            //{
            //    entity.ToTable("tbSistemaEspacoFiscal");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaEstadoCivil>(entity =>
            //{
            //    entity.ToTable("tbSistemaEstadoCivil");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbSistemaEstadoCivil");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaFormasCalculoComissoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaFormasCalculoComissoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(25);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaFormatoUnidadeTempo>(entity =>
            //{
            //    entity.ToTable("tbSistemaFormatoUnidadeTempo");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaFuncionalidadesConsentimento>(entity =>
            //{
            //    entity.ToTable("tbSistemaFuncionalidadesConsentimento");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Funcionalidade)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.QueryPesquisa).IsRequired();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaIdiomas>(entity =>
            //{
            //    entity.ToTable("tbSistemaIdiomas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo).HasMaxLength(20);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaMateriasLentes>(entity =>
            //{
            //    entity.ToTable("tbSistemaMateriasLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaModulos>(entity =>
            //{
            //    entity.ToTable("tbSistemaModulos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaMoedas>(entity =>
            //{
            //    entity.ToTable("tbSistemaMoedas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaNaturezas>(entity =>
            //{
            //    entity.ToTable("tbSistemaNaturezas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Modulo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.TipoDoc).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaOrdemLotes>(entity =>
            //{
            //    entity.ToTable("tbSistemaOrdemLotes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Sistema)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaParametrosLoja>(entity =>
            //{
            //    entity.ToTable("tbSistemaParametrosLoja");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.TipoDados).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.Valor).HasMaxLength(255);
            //});

            //modelBuilder.Entity<TbSistemaParentesco>(entity =>
            //{
            //    entity.ToTable("tbSistemaParentesco");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaRegimeIva>(entity =>
            //{
            //    entity.ToTable("tbSistemaRegimeIVA");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaRegioesIva>(entity =>
            //{
            //    entity.ToTable("tbSistemaRegioesIVA");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(1);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaRelacaoEspacoFiscalRegimeIva>(entity =>
            //{
            //    entity.ToTable("tbSistemaRelacaoEspacoFiscalRegimeIva");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdespacoFiscal).HasColumnName("IDEspacoFiscal");

            //    entity.Property(e => e.IdregimeIva).HasColumnName("IDRegimeIva");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdespacoFiscalNavigation)
            //        .WithMany(p => p.TbSistemaRelacaoEspacoFiscalRegimeIva)
            //        .HasForeignKey(d => d.IdespacoFiscal)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaEspacoFiscal");

            //    entity.HasOne(d => d.IdregimeIvaNavigation)
            //        .WithMany(p => p.TbSistemaRelacaoEspacoFiscalRegimeIva)
            //        .HasForeignKey(d => d.IdregimeIva)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaRelacaoEspacoFiscalRegimeIva_tbSistemaRegimeIVA");
            //});

            //modelBuilder.Entity<TbSistemaSexo>(entity =>
            //{
            //    entity.ToTable("tbSistemaSexo");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaSiglasPaises>(entity =>
            //{
            //    entity.ToTable("tbSistemaSiglasPaises");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(50);

            //    entity.Property(e => e.DescricaoPais)
            //        .IsRequired()
            //        .HasMaxLength(50)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Sigla)
            //        .IsRequired()
            //        .HasMaxLength(15);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaSuperficiesLentes>(entity =>
            //{
            //    entity.ToTable("tbSistemaSuperficiesLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaTipoDistMatPrima>(entity =>
            //{
            //    entity.ToTable("tbSistemaTipoDistMatPrima");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTipoDistOperacoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaTipoDistOperacoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTipoOp>(entity =>
            //{
            //    entity.ToTable("tbSistemaTipoOp");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTipoOperacoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaTipoOperacoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposAnexos>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposAnexos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdentidadeF3m).HasColumnName("IDEntidadeF3M");

            //    entity.Property(e => e.IdtipoExtensaoFicheiro).HasColumnName("IDTipoExtensaoFicheiro");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdentidadeF3mNavigation)
            //        .WithMany(p => p.TbSistemaTiposAnexos)
            //        .HasForeignKey(d => d.IdentidadeF3m)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposAnexos_tbSistemaEntidadesF3M");

            //    entity.HasOne(d => d.IdtipoExtensaoFicheiroNavigation)
            //        .WithMany(p => p.TbSistemaTiposAnexos)
            //        .HasForeignKey(d => d.IdtipoExtensaoFicheiro)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposAnexos_tbSistemaTiposExtensoesFicheiros");
            //});

            //modelBuilder.Entity<TbSistemaTiposComposicoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposComposicoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(1);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Sistema)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposCondDataVencimento>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposCondDataVencimento");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumento>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumento");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmodulo).HasColumnName("IDModulo");

            //    entity.Property(e => e.Tipo).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdmoduloNavigation)
            //        .WithMany(p => p.TbSistemaTiposDocumento)
            //        .HasForeignKey(d => d.Idmodulo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposDocumento_tbSistemaModulos");
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoColunasAutomaticas>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoColunasAutomaticas");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.CampoTexto).HasMaxLength(50);

            //    entity.Property(e => e.ChaveColunaTraducao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.Coluna)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.Controlador).HasMaxLength(255);

            //    entity.Property(e => e.ControladorExtra).HasMaxLength(255);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.EnviaParametros).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idpai).HasColumnName("IDPai");

            //    entity.Property(e => e.IdsistemaTipoDocumento).HasColumnName("IDSistemaTipoDocumento");

            //    entity.Property(e => e.IdtipoEditor).HasColumnName("IDTipoEditor");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.Property(e => e.Validador).HasMaxLength(255);

            //    entity.HasOne(d => d.IdpaiNavigation)
            //        .WithMany(p => p.InverseIdpaiNavigation)
            //        .HasForeignKey(d => d.Idpai)
            //        .HasConstraintName("FK_tbSistemaTiposDocumentoColunasAutomaticas_tbSistemaTiposDocumentoColunasAutomaticas");

            //    entity.HasOne(d => d.IdsistemaTipoDocumentoNavigation)
            //        .WithMany(p => p.TbSistemaTiposDocumentoColunasAutomaticas)
            //        .HasForeignKey(d => d.IdsistemaTipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposDocumentoColunasAutomaticas_tbSistemaTiposDocumento");

            //    entity.HasOne(d => d.IdtipoEditorNavigation)
            //        .WithMany(p => p.TbSistemaTiposDocumentoColunasAutomaticas)
            //        .HasForeignKey(d => d.IdtipoEditor)
            //        .HasConstraintName("FK_tbSistemaTiposDocumentoColunasAutomaticas_tbTiposDados");
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoComunicacao>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoComunicacao");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoFiscal>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoFiscal");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.Tipo).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdtipoDocumentoNavigation)
            //        .WithMany(p => p.TbSistemaTiposDocumentoFiscal)
            //        .HasForeignKey(d => d.IdtipoDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposDocumentoFiscal_tbSistemaTiposDocumento");
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoImportacao>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoImportacao");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Natureza).HasMaxLength(50);

            //    entity.Property(e => e.NaturezaOrigem).HasMaxLength(50);

            //    entity.Property(e => e.TipoDocSist)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.TipoDocSistOrigem)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.TipoFiscal)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.TipoFiscalOrigem).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoMovStock>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoMovStock");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoOrigem>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoOrigem");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposDocumentoPrecoUnitario>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposDocumentoPrecoUnitario");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .IsRequired()
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposEntidade>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposEntidade");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(25);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Entidade)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Tipo)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.TipoAux).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposEntidadeModulos>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposEntidadeModulos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdsistemaModulos).HasColumnName("IDSistemaModulos");

            //    entity.Property(e => e.IdsistemaTiposEntidade).HasColumnName("IDSistemaTiposEntidade");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdsistemaModulosNavigation)
            //        .WithMany(p => p.TbSistemaTiposEntidadeModulos)
            //        .HasForeignKey(d => d.IdsistemaModulos)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposEntidadeModulos_tbSistemaModulos");

            //    entity.HasOne(d => d.IdsistemaTiposEntidadeNavigation)
            //        .WithMany(p => p.TbSistemaTiposEntidadeModulos)
            //        .HasForeignKey(d => d.IdsistemaTiposEntidade)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposEntidadeModulos_tbSistemaTiposEntidade");
            //});

            //modelBuilder.Entity<TbSistemaTiposEstados>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposEstados");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.Cor).HasMaxLength(50);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdentidadeEstado).HasColumnName("IDEntidadeEstado");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdentidadeEstadoNavigation)
            //        .WithMany(p => p.TbSistemaTiposEstados)
            //        .HasForeignKey(d => d.IdentidadeEstado)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSistemaTiposEstados_tbSistemaEntidadesEstados");
            //});

            //modelBuilder.Entity<TbSistemaTiposEtiquetas>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposEtiquetas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaTiposExtensoesFicheiros>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposExtensoesFicheiros");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.ExtensoesPermitidas).HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposFormasPagamento>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposFormasPagamento");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposGraduacoes>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposGraduacoes");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaTiposIva>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposIVA");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposLentes>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdsistemaClassificacao).HasColumnName("IDSistemaClassificacao");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdsistemaClassificacaoNavigation)
            //        .WithMany(p => p.TbSistemaTiposLentes)
            //        .HasForeignKey(d => d.IdsistemaClassificacao)
            //        .HasConstraintName("FK_tbSistemaTiposLentes_tbSistemaClassificacoesTiposArtigos");
            //});

            //modelBuilder.Entity<TbSistemaTiposLinhasMp>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposLinhasMP");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposLiquidacao>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposLiquidacao");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbSistemaTiposMaquinas>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposMaquinas");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(80);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposOlhos>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposOlhos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaTiposPessoa>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposPessoa");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(3);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposPrecos>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposPrecos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .IsRequired()
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaTiposServicos>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposServicos");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbSistemaTiposTextoBase>(entity =>
            //{
            //    entity.ToTable("tbSistemaTiposTextoBase");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbSistemaVerbasIs>(entity =>
            //{
            //    entity.ToTable("tbSistemaVerbasIS");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(900);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbStockArtigos>(entity =>
            //{
            //    entity.ToTable("tbStockArtigos");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            //    entity.Property(e => e.IdarmazemLocalizacao).HasColumnName("IDArmazemLocalizacao");

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdartigoDimensao).HasColumnName("IDArtigoDimensao");

            //    entity.Property(e => e.IdartigoLote).HasColumnName("IDArtigoLote");

            //    entity.Property(e => e.IdartigoNumeroSerie).HasColumnName("IDArtigoNumeroSerie");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdarmazemNavigation)
            //        .WithMany(p => p.TbStockArtigos)
            //        .HasForeignKey(d => d.Idarmazem)
            //        .HasConstraintName("FK_tbStockArtigos_IDArmazem");

            //    entity.HasOne(d => d.IdarmazemLocalizacaoNavigation)
            //        .WithMany(p => p.TbStockArtigos)
            //        .HasForeignKey(d => d.IdarmazemLocalizacao)
            //        .HasConstraintName("FK_tbStockArtigos_IDArmazemLocalizacao");

            //    entity.HasOne(d => d.IdartigoNavigation)
            //        .WithMany(p => p.StockProducts)
            //        .HasForeignKey(d => d.Idartigo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbStockArtigos_IDArtigo");

            //    entity.HasOne(d => d.IdartigoLoteNavigation)
            //        .WithMany(p => p.TbStockArtigos)
            //        .HasForeignKey(d => d.IdartigoLote)
            //        .HasConstraintName("FK_tbStockArtigos_IDArtigoLote");

            //    entity.HasOne(d => d.IdartigoNumeroSerieNavigation)
            //        .WithMany(p => p.TbStockArtigos)
            //        .HasForeignKey(d => d.IdartigoNumeroSerie)
            //        .HasConstraintName("FK_tbStockArtigos_IDArtigoNumeroSerie");
            //});

            //modelBuilder.Entity<TbStockArtigosNecessidades>(entity =>
            //{
            //    entity.ToTable("tbStockArtigosNecessidades");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Documento).HasMaxLength(255);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idarmazem).HasColumnName("IDArmazem");

            //    entity.Property(e => e.IdarmazemLocalizacao).HasColumnName("IDArmazemLocalizacao");

            //    entity.Property(e => e.Idartigo).HasColumnName("IDArtigo");

            //    entity.Property(e => e.IdartigoDimensao).HasColumnName("IDArtigoDimensao");

            //    entity.Property(e => e.IdartigoLote).HasColumnName("IDArtigoLote");

            //    entity.Property(e => e.IdartigoNumeroSerie).HasColumnName("IDArtigoNumeroSerie");

            //    entity.Property(e => e.IdartigoPa).HasColumnName("IDArtigoPA");

            //    entity.Property(e => e.IdartigoPara).HasColumnName("IDArtigoPara");

            //    entity.Property(e => e.Iddimensaolinha1).HasColumnName("IDDimensaolinha1");

            //    entity.Property(e => e.Iddimensaolinha2).HasColumnName("IDDimensaolinha2");

            //    entity.Property(e => e.Iddocumento).HasColumnName("IDDocumento");

            //    entity.Property(e => e.Idencomenda).HasColumnName("IDEncomenda");

            //    entity.Property(e => e.IdlinhaDocumento).HasColumnName("IDLinhaDocumento");

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdordemFabrico).HasColumnName("IDOrdemFabrico");

            //    entity.Property(e => e.IdtipoDocumento).HasColumnName("IDTipoDocumento");

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdarmazemNavigation)
            //        .WithMany(p => p.TbStockArtigosNecessidades)
            //        .HasForeignKey(d => d.Idarmazem)
            //        .HasConstraintName("FK_tbStockArtigosNecessidades_IDArmazem");

            //    entity.HasOne(d => d.IdarmazemLocalizacaoNavigation)
            //        .WithMany(p => p.TbStockArtigosNecessidades)
            //        .HasForeignKey(d => d.IdarmazemLocalizacao)
            //        .HasConstraintName("FK_tbStockArtigosNecessidades_IDArmazemLocalizacao");

            //    entity.HasOne(d => d.IdartigoLoteNavigation)
            //        .WithMany(p => p.TbStockArtigosNecessidades)
            //        .HasForeignKey(d => d.IdartigoLote)
            //        .HasConstraintName("FK_tbStockArtigosNecessidades_IDArtigoLote");

            //    entity.HasOne(d => d.IdartigoNumeroSerieNavigation)
            //        .WithMany(p => p.TbStockArtigosNecessidades)
            //        .HasForeignKey(d => d.IdartigoNumeroSerie)
            //        .HasConstraintName("FK_tbStockArtigosNecessidades_IDArtigoNumeroSerie");
            //});

            //modelBuilder.Entity<TbSubFamilias>(entity =>
            //{
            //    entity.ToTable("tbSubFamilias");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbSubFamiliasCodigo");

            //    entity.HasIndex(e => new { e.Idfamilia, e.Codigo })
            //        .HasName("IX_tbSubFamiliasChaveComposta")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idfamilia).HasColumnName("IDFamilia");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.Property(e => e.VariavelContabilidade).HasMaxLength(20);

            //    entity.HasOne(d => d.IdfamiliaNavigation)
            //        .WithMany(p => p.TbSubFamilias)
            //        .HasForeignKey(d => d.Idfamilia)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSubFamilias_tbFamilias");
            //});

            //modelBuilder.Entity<TbSuplementosLentes>(entity =>
            //{
            //    entity.ToTable("tbSuplementosLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodForn).HasMaxLength(100);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Cor).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmarca).HasColumnName("IDMarca");

            //    entity.Property(e => e.IdmateriaLente).HasColumnName("IDMateriaLente");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.IdtipoLente).HasColumnName("IDTipoLente");

            //    entity.Property(e => e.ModeloForn).HasMaxLength(50);

            //    entity.Property(e => e.Observacoes).HasMaxLength(4000);

            //    entity.Property(e => e.PrecoCusto).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.PrecoVenda).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.Referencia).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmarcaNavigation)
            //        .WithMany(p => p.TbSuplementosLentes)
            //        .HasForeignKey(d => d.Idmarca)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSuplementosLentes_tbMarcas");

            //    entity.HasOne(d => d.IdmateriaLenteNavigation)
            //        .WithMany(p => p.TbSuplementosLentes)
            //        .HasForeignKey(d => d.IdmateriaLente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSuplementosLentes_tbSistemaMateriasLentes");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbSuplementosLentes)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .HasConstraintName("FK_tbSuplementosLentes_tbModelos");

            //    entity.HasOne(d => d.IdtipoLenteNavigation)
            //        .WithMany(p => p.TbSuplementosLentes)
            //        .HasForeignKey(d => d.IdtipoLente)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbSuplementosLentes_tbSistemaTiposLentes");
            //});

            //modelBuilder.Entity<TbTemplates>(entity =>
            //{
            //    entity.ToTable("tbTemplates");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6)
            //        .HasDefaultValueSql("('T')");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasDefaultValueSql("('T1')");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idloja).HasColumnName("IDLoja");

            //    entity.Property(e => e.IdsistemaTipoTemplate).HasColumnName("IDSistemaTipoTemplate");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdlojaNavigation)
            //        .WithMany(p => p.TbTemplates)
            //        .HasForeignKey(d => d.Idloja)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTemplates_tbLojas");
            //});

            //modelBuilder.Entity<TbTextosBase>(entity =>
            //{
            //    entity.ToTable("tbTextosBase");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdtiposTextoBase).HasColumnName("IDTiposTextoBase");

            //    entity.Property(e => e.Texto)
            //        .IsRequired()
            //        .HasMaxLength(4000);

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdtiposTextoBaseNavigation)
            //        .WithMany(p => p.TbTextosBase)
            //        .HasForeignKey(d => d.IdtiposTextoBase)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTextosBase_tbSistemaTiposTextoBase");
            //});





            //modelBuilder.Entity<TbTiposContatos>(entity =>
            //{
            //    entity.ToTable("tbTiposContatos");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbTiposContatosCodigo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbTiposDados>(entity =>
            //{
            //    entity.ToTable("tbTiposDados");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(255);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(255);
            //});



            //modelBuilder.Entity<TbTiposDocumentoIdioma>(entity =>
            //{
            //    entity.ToTable("tbTiposDocumentoIdioma");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Ididioma).HasColumnName("IDIdioma");

            //    entity.Property(e => e.IdtiposDocumento).HasColumnName("IDTiposDocumento");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdidiomaNavigation)
            //        .WithMany(p => p.TbTiposDocumentoIdioma)
            //        .HasForeignKey(d => d.Ididioma)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTiposDocumentoIdioma_tbIdiomas");

            //    entity.HasOne(d => d.IdtiposDocumentoNavigation)
            //        .WithMany(p => p.TbTiposDocumentoIdioma)
            //        .HasForeignKey(d => d.IdtiposDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTiposDocumentoIdioma_tbTiposDocumento");
            //});



            //modelBuilder.Entity<TbTiposDocumentoSeriesPermissoes>(entity =>
            //{
            //    entity.ToTable("tbTiposDocumentoSeriesPermissoes");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idperfil).HasColumnName("IDPerfil");

            //    entity.Property(e => e.Idserie).HasColumnName("IDSerie");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdserieNavigation)
            //        .WithMany(p => p.TbTiposDocumentoSeriesPermissoes)
            //        .HasForeignKey(d => d.Idserie)
            //        .HasConstraintName("FK_tbTiposDocumentoSeriesPermissoes_tbTiposDocumentoSeries");
            //});

            //modelBuilder.Entity<TbTiposDocumentoTipEntPermDoc>(entity =>
            //{
            //    entity.ToTable("tbTiposDocumentoTipEntPermDoc");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.DataAlteracao).HasColumnType("datetime");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.IdsistemaTiposEntidadeModulos).HasColumnName("IDSistemaTiposEntidadeModulos");

            //    entity.Property(e => e.IdtiposDocumento).HasColumnName("IDTiposDocumento");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);

            //    entity.HasOne(d => d.IdsistemaTiposEntidadeModulosNavigation)
            //        .WithMany(p => p.TbTiposDocumentoTipEntPermDoc)
            //        .HasForeignKey(d => d.IdsistemaTiposEntidadeModulos)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTiposDocumentoTipEntPermDoc_tbSistemaTiposEntidadeModulos");

            //    entity.HasOne(d => d.IdtiposDocumentoNavigation)
            //        .WithMany(p => p.TbTiposDocumentoTipEntPermDoc)
            //        .HasForeignKey(d => d.IdtiposDocumento)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTiposDocumentoTipEntPermDoc_tbTiposDocumento");
            //});

            //modelBuilder.Entity<TbTiposFases>(entity =>
            //{
            //    entity.ToTable("tbTiposFases");

            //    entity.Property(e => e.Id)
            //        .HasColumnName("ID")
            //        .ValueGeneratedNever();

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);
            //});

            //modelBuilder.Entity<TbTiposFornecimentos>(entity =>
            //{
            //    entity.ToTable("tbTiposFornecimentos");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbTiposFornecimentos")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(256);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256);
            //});

            //modelBuilder.Entity<TbTiposRelacao>(entity =>
            //{
            //    entity.ToTable("tbTiposRelacao");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbTiposRetencao>(entity =>
            //{
            //    entity.ToTable("tbTiposRetencao");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Contabilidade).HasMaxLength(20);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});

            //modelBuilder.Entity<TbTratamentosLentes>(entity =>
            //{
            //    entity.ToTable("tbTratamentosLentes");

            //    entity.HasIndex(e => e.Codigo)
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.CodForn).HasMaxLength(100);

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(10);

            //    entity.Property(e => e.Cor).HasDefaultValueSql("((0))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(100);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idmarca).HasColumnName("IDMarca");

            //    entity.Property(e => e.Idmodelo).HasColumnName("IDModelo");

            //    entity.Property(e => e.ModeloForn).HasMaxLength(50);

            //    entity.Property(e => e.Observacoes).HasMaxLength(4000);

            //    entity.Property(e => e.Referencia).HasMaxLength(50);

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.HasOne(d => d.IdmarcaNavigation)
            //        .WithMany(p => p.TbTratamentosLentes)
            //        .HasForeignKey(d => d.Idmarca)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTratamentosLentes_tbMarcas");

            //    entity.HasOne(d => d.IdmodeloNavigation)
            //        .WithMany(p => p.TbTratamentosLentes)
            //        .HasForeignKey(d => d.Idmodelo)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbTratamentosLentes_tbModelos");
            //});





            //modelBuilder.Entity<TbUnidadesTempo>(entity =>
            //{
            //    entity.ToTable("tbUnidadesTempo");

            //    entity.HasIndex(e => e.Codigo)
            //        .HasName("IX_tbUnidadesTempo")
            //        .IsUnique();

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.Codigo)
            //        .IsRequired()
            //        .HasMaxLength(6);

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao).HasColumnType("datetime");

            //    entity.Property(e => e.Descricao)
            //        .IsRequired()
            //        .HasMaxLength(50);

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.Idformato).HasColumnName("IDFormato");

            //    entity.Property(e => e.UtilizadorAlteracao).HasMaxLength(20);

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(20);

            //    entity.HasOne(d => d.IdformatoNavigation)
            //        .WithMany(p => p.TbUnidadesTempo)
            //        .HasForeignKey(d => d.Idformato)
            //        .OnDelete(DeleteBehavior.ClientSetNull)
            //        .HasConstraintName("FK_tbUnidadesTempo_tbSistemaFormatoUnidadeTempo");
            //});

            //modelBuilder.Entity<TbVersao>(entity =>
            //{
            //    entity.ToTable("tbVersao");

            //    entity.Property(e => e.Id).HasColumnName("ID");

            //    entity.Property(e => e.Ativo)
            //        .IsRequired()
            //        .HasDefaultValueSql("((1))");

            //    entity.Property(e => e.DataAlteracao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.DataCriacao)
            //        .HasColumnType("datetime")
            //        .HasDefaultValueSql("(getdate())");

            //    entity.Property(e => e.F3mmarcador)
            //        .HasColumnName("F3MMarcador")
            //        .IsRowVersion();

            //    entity.Property(e => e.UtilizadorAlteracao)
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");

            //    entity.Property(e => e.UtilizadorCriacao)
            //        .IsRequired()
            //        .HasMaxLength(256)
            //        .HasDefaultValueSql("('')");
            //});
        }
    }
}
