using F3M.Oticas.DTO.Enum;
using System;

namespace F3M.Oticas.DTO
{
    public class AccountingExportFile
    {
        public AccountingExportFile()
        {
            LineType = AccountingExportLineType.Financial;
            Module = AccountingExportModule.Sales;
            DailyNumber = "-1";
            DocumentNumber = "-1";
        }

        /// <summary>
        /// Reflecte Classes de IVA
        /// </summary>
        public bool ReflectsVATClasses { get; set; }

        /// <summary>
        /// Reflecte Analítica
        /// </summary>
        public bool ReflectsAnalytics { get; set; }

        /// <summary>
        /// Reflecte Centros de Custo
        /// </summary>
        public bool ReflectsCostCenters { get; set; }

        /// <summary>
        /// Tipo de Linha -
        /// F - Financeira;
        /// A - Analítico;
        /// O - Centro de Custo;
        /// C - Plano Funcional;
        /// M - Linha de pendente
        /// </summary>
        public AccountingExportLineType LineType { get; set; }

        /// <summary>
        /// Módulo -
        /// V - Vendas;
        /// S - Stocks;
        /// C - Compras;
        /// M - Contas Correntes;
        /// B – Bancos;
        /// P – Recursos Humanos;
        /// I - Imobilizado
        /// L - Contabilidade (Sempre que forem documentos de módulos terceiros)
        /// </summary>
        public AccountingExportModule Module { get; set; }

        /// <summary>
        /// Data
        /// </summary>
        public DateTime? Date { get; set; }

        /// <summary>
        /// Conta a movimentar -
        /// Conta;
        /// Centro de Custo;
        /// Função;
        /// Fluxo;
        /// </summary>
        public string AccountToMove { get; set; }

        /// <summary>
        /// Diário
        /// </summary>
        public string Daily { get; set; }

        /// <summary>
        /// Nº Diário -
        /// Se negativo (-1), é lançado no próximo numerador livre. Se >0, grava com esse numerador (pode sobrepor o lançamento)
        /// As linhas de um documento devem ter todas o mesmo numerador.
        /// </summary>
        public string DailyNumber { get; set; }

        /// <summary>
        /// Documento -
        /// Identificador do documento
        /// </summary>
        public string Document { get; set; }

        /// <summary>
        /// Nº Documento -
        /// Se negativo (-1), é numerado p/ CBL
        /// </summary>
        public string DocumentNumber { get; set; }

        /// <summary>
        /// Descrição -
        /// Descrição associado ao documento
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Valor Origem -
        /// Valor na moeda de lançamento
        /// </summary>
        public double? SourceValue { get; set; }

        /// <summary>
        /// Natureza -
        /// D - Débito;
        /// C - Crédito
        /// </summary>
        public AccountingExportNatureType Nature { get; set; }

        /// <summary>
        /// Código da entidade utilizada para recolha dos dados para recapitulativos e emissão dos mapas recapitulativos:
        /// Anexo O e Anexo P da declaração anual.
        /// </summary>
        public string Entity { get; set; }

        /// <summary>
        /// C - Cliente;
        /// F - Fornecedor;
        /// D – Outro Devedor;
        /// R – Outro Credor;
        /// B – Conta Bancária;
        /// S – Sócio;
        /// E – Entidade Pública;
        /// I – Fornecedor de Imobilizado;
        /// T – Consultor;
        /// A – Subscritor de Capital;
        /// G – Obrigacionista;
        /// L – Credor Subscritores Não Liberadas;
        /// U – Funcionário;
        /// N – Sindicato;
        /// P – Independente;
        /// O - Outros
        /// </summary>
        public AccountingExportEntityType? EntityType { get; set; }

        /// <summary>
        /// Classe de IVA associada à conta.
        /// </summary>
        public string VatClass { get; set; }

        /// <summary>
        /// Conta que originou este lançamento.
        /// Obrigatório nos movimentos de IVA, Centros de Custo, Funções e Analítica e Fluxos.
        /// </summary>
        public string SourceAccount { get; set; }

        /// <summary>
        /// Deverá ser igual ao lote da conta origem.
        /// Obrigatório nos movimentos de IVA, Centros de Custo, Funções e Analítica.
        /// </summary>
        public int? Batch { get; set; }

        /// <summary>
        /// Classe de selo associada à conta.
        /// </summary>
        public string ClassSeal { get; set; }

        /// <summary>
        /// Nº de unidades a usar no cálculo do valor do Imposto de selo.
        /// (Nº de unidades ou 0 se o cálculo for por %).
        /// </summary>
        public long? SealQuantity { get; set; }

        /// <summary>
        /// Se o valor for true a CBL, aquando da importação, fará automaticamente os lançamentos de Selo.
        /// </summary>
        public bool? ReflectsStampClasses { get; set; }

        /// <summary>
        /// Se o valor for true a CBL, aquando da importação, fará automaticamente os lançamentos para Funções.
        /// </summary>
        public bool? ReflectsFunctionalPlan { get; set; }

        /// <summary>
        /// Código da entidade para a recolha para o mapa de TransacçõesIntracomunitárias ou Pedidos de Reembolsos de IVA.
        /// </summary>
        public string Third { get; set; }

        /// <summary>
        /// C - Cliente;
        /// F - Fornecedor;
        /// O - Outros.* Esta propriedade em conjugação com a anterior é que indica qual o código do tipo de entidade em causa.
        /// </summary>
        public AccountingExportThirdType? ThirdType { get; set; }

        /// <summary>
        /// Mes a que se refere a factura de compra para o caso de Pedidos de Reembolso de IVA.*
        /// </summary>
        public DateTime? MonthCollection { get; set; }

        /// <summary>
        /// Tipo de operação para as TransacçõesIntracomunitárias:
        /// 0 - Vendas de meios de transporte,
        /// 1 - Não compreendidas no tipo 4
        /// 4 - Operações triangulares.*
        /// </summary>
        public AccountingExportOperationType? IntraCommunityTransactionsOperationType { get; set; }

        /// <summary>
        /// Ano do exercício contabilístico do documento
        /// </summary>
        public string Year { get; set; }

        /// <summary>
        /// Moeda de lançamento do documento
        /// </summary>
        public string CurrencyOrigin { get; set; }

        /// <summary>
        /// Taxa de câmbio entre a moeda origem e a moeda de referência
        /// </summary>
        public string CurrencyExchangeOrigin { get; set; }

        /// <summary>
        /// Taxa de câmbio para converter o valor origem na moeda base.
        /// </summary>
        public string BaseCurrency { get; set; }

        /// <summary>
        /// Taxa de câmbio para converter o valor origem na moeda base.
        /// </summary>
        public string AlternativeExchange { get; set; }

        /// <summary>
        /// Indica em que moeda, base ou alternativa, os movimentos são considerados.
        /// 0 = Significa que o movimento é efectuado na moeda base e na moeda alternativa;
        /// 1 = O movimento é apenas efectuado na moeda base;
        /// 2 = O movimento é apenas efectuado na moeda alternativa.
        /// </summary>
        public AccountingExportAffectionType? AffectionType { get; set; }

        /// <summary>
        /// Se o valor for true a CBL, aquando da importação, fará automaticamente os lançamentos para Fluxos.
        /// </summary>
        public bool? ReflectsFlows { get; set; }

        /// <summary>
        /// Classe de IVA de auto liquidação (natureza inversa).
        /// </summary>
        public AccountingExportNatureType? VatClassSelfAssessment { get; set; }

        /// <summary>
        /// Percentagem do IVA não dedutível.
        /// </summary>
        public decimal? NonDeductiblePercentage { get; set; }

        /// <summary>
        /// Tipo de Lançamento do documento.
        /// </summary>
        public string ReleaseType { get; set; }

        /// <summary>
        /// A data do documento.
        /// </summary>
        public DateTime? DocumentDate { get; set; }

        /// <summary>
        /// O número do Documento Externo.
        /// </summary>
        public string ExternalDocumentNumber { get; set; }

        /// <summary>
        /// Campo de Observações do cabeçalho do documento.
        /// </summary>
        public string Observations { get; set; }

        /// <summary>
        /// O Item de Tesouraria associado à linha.
        /// </summary>
        public string TreasuryItem { get; set; }

        /// <summary>
        /// Se o valor for true a CBL, aquando da importação, fará automaticamente a recolha de informação para COPE baseado nos campos a seguir definidos.
        /// </summary>
        public bool? ReflecteCOPE { get; set; }

        /// <summary>
        /// COPE - A Classificação Estatística associada.
        /// </summary>
        public string COPEStatisticalClassification { get; set; }

        /// <summary>
        /// COPE - O Tipo da Conta Bancária:
        /// I - Interna;
        /// E - Externa;
        /// O - Outra Conta Externa;
        /// C - Compensação;
        /// X - Sem movimento de conta.
        /// </summary>
        public AccountingExportCOPEAccountType? COPEAccountType { get; set; }

        /// <summary>
        /// COPE - O País da Entidade (Cliente, Fornecedor, Outro) associado.
        /// </summary>
        public string COPECountryEntityCounterparty { get; set; }

        /// <summary>
        /// COPE - País da Entidade do Ativo Financeiro associado.
        /// </summary>
        public string COPECountryFinancialInstitution { get; set; }

        /// <summary>
        /// COPE - NPC do 2º Interveniente associado.
        /// </summary>
        public string COPENPCSecondIntervener { get; set; }

        /// <summary>
        /// COPE - Entidade do Ativo associada.
        /// </summary>
        public string COPEAssetEntity { get; set; }

        /// <summary>
        /// COPE - O Montante reflectido. Não pode superior ao valor da linha.
        /// </summary>
        public string COPEAmount { get; set; }

        /// <summary>
        /// Código do projeto associado à linha.
        /// </summary>
        public string LineDesignCode { get; set; }

        /// <summary>
        /// Código do elemento PEP associado à linha.
        /// </summary>
        public string LinePEPElement { get; set; }

        /// <summary>
        /// Série do documento.
        /// </summary>
        public string DocumentSeries { get; set; }

        /// <summary>
        /// Descrição do documento do pendente correspondente à linha com a estrutura:
        /// Documento Numdocint/Série[Filial]
        /// </summary>
        public string PendingDocumentDescription { get; set; }

        /// <summary>
        /// Filial do pendente correspondente à linha.
        /// </summary>
        public string PendingDocumentBranch { get; set; }

        /// <summary>
        /// Número de prestação do pendente correspondente à linha.
        /// </summary>
        public string PendingDocumentDeliveryNumber { get; set; }

        /// <summary>
        /// Valor total do pendente correspondente à linha na moeda do pendente.
        /// </summary>
        public string PendingDocumentValue { get; set; }

        /// <summary>
        /// Valor total do pendente correspondente à linha na moeda Base.
        /// </summary>
        public string PendingAmountDocumentBaseCurrency { get; set; }

        /// <summary>
        /// Valor total do pendente correspondente à linha na moeda Alternativa.
        /// </summary>
        public string PendingAmountDocumentAlternativeCurrency { get; set; }

        /// <summary>
        /// Moeda do pendente correspondente à linha.
        /// </summary>
        public string PendingDocumentCurrency { get; set; }

        /// <summary>
        /// Módulo do pendente correspondente à linha.
        /// </summary>
        public string PendingDocumentModule { get; set; }

        /// <summary>
        /// Data de Operação. No caso de documentos financeiros deve corresponder à data do documento de logística que o antecede.
        /// </summary>
        public DateTime? OperationDate { get; set; }

        /// <summary>
        /// Data de Expedição. No caso de documentos de compra deve corresponder à data de documento.
        /// </summary>
        public DateTime? ShippingDate { get; set; }

        /// <summary>
        /// Data de Recepção. No caso de documentos de compra deve corresponder à data de introdução.
        /// </summary>
        public DateTime? ReceiptDate { get; set; }

        /// <summary>
        /// Número de Identificação Fiscal da entidade.
        /// </summary>
        public string NIF { get; set; }

        /// <summary>
        /// Designação Fiscal da entidade.
        /// </summary>
        public string FiscalDesignation { get; set; }

        /// <summary>
        /// Código do País da entidade.
        /// </summary>
        public string Country { get; set; }

        /// <summary>
        /// Identificador do Documento estornado no formato [Documento Serie/N.º Documento].
        /// </summary>
        public string RectifiedDocument { get; set; }

        /// <summary>
        /// Valor da Taxa de IVA.
        /// </summary>
        public string VatRate { get; set; }

        /// <summary>
        /// Modo de Pagamento.
        /// </summary>
        public string PaymentType { get; set; }

        /// <summary>
        /// Base de Incidência do IVA.
        /// </summary>
        public string IncidenceBasis { get; set; }

        /// <summary>
        /// Valor de IVA não dedutível.
        /// </summary>
        public string VATNotDeductible { get; set; }

        /// <summary>
        /// Tipo de Operação.
        /// </summary>
        public string OperationType { get; set; }

        /// <summary>
        /// Número de contribuinte para a entidade usada nos recapitulativos.
        /// </summary>
        public string EntityNIF { get; set; }

        /// <summary>
        /// Nome Fiscal da entidade usada nos recapitulativos.
        /// </summary>
        public string EntityFiscalName { get; set; }

        /// <summary>
        /// País da entidade usada nos recapitulativos.
        /// </summary>
        public string EntityCountry { get; set; }

        /// <summary>
        /// Número de contribuinte do terceiro para recolha de dados para o mapa de pedidos de reembolsos de IVA.
        /// </summary>
        public string ThirdNIF { get; set; }

        /// <summary>
        /// Nome Fiscal do terceiro para recolha de dados para o mapa de pedidos de reembolsos de IVA.
        /// </summary>
        public string ThirdFiscalName { get; set; }

        /// <summary>
        /// País do terceiro para recolha de dados para o mapa de pedidos de reembolsos de IVA.
        /// </summary>
        public string ThirdCountry { get; set; }

        /// <summary>
        /// As opções disponíveis são:
        /// 0) Sem recolha
        /// 1) Transacções Intracomunitárias
        /// 2) Pedidos de reembolso de IVA
        /// 3) Reembolso de IVA / Trans.Intracomunitárias
        /// </summary>
        public AccountingExportCollectionType? CollectionType { get; set; }

        /// <summary>
        /// Identificador do documento origem que foi regularizado pelo documento a ser importado, no formato: [Tipo Documento] [Série]/[N.º Documento]. Exemplo: [FA 2017/311].
        /// </summary>
        public string SourceDocument { get; set; }
    }
}
