Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports Traducao.Traducao
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes

Public Class Artigos
    Inherits F3M.Artigos

#Region "Grelhas linhas"
    <DataMember>
    Public Property ArtigosLotes As List(Of ArtigosLotes)

    <DataMember>
    Public Property ArtigosArmazensLocalizacoes As List(Of ArtigosArmazensLocalizacoes)

    <DataMember>
    Public Property ArtigosUnidades As List(Of ArtigosUnidades)

    <DataMember>
    Public Property ArtigosPrecos As List(Of ArtigosPrecos)

    <DataMember>
    Public Property ArtigosIdiomas As List(Of ArtigosIdiomas)

    <DataMember>
    Public Property ArtigosAssociados As List(Of ArtigosAssociados)

    <DataMember>
    Public Property ArtigosAlternativos As List(Of ArtigosAlternativos)

    <DataMember>
    Public Property ArtigosFornecedores As List(Of ArtigosFornecedores)
#End Region

#Region "Campos overrides"
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbFamilias", MapearDescricaoChaveEstrangeira:="DescricaoFamilia")>
    Public Overrides Property IDFamilia As Nullable(Of Long)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSubFamilias", MapearDescricaoChaveEstrangeira:="DescricaoSubFamilia")>
    Public Overrides Property IDSubFamilia As Nullable(Of Long)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbUnidades", MapearDescricaoChaveEstrangeira:="DescricaoUnidadeStock2")>
    Public Overrides Property IDUnidadeStock2 As Nullable(Of Long)

    <DataMember>
    Public Overrides Property IDUnidade As Nullable(Of Long)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMarcas", MapearDescricaoChaveEstrangeira:="DescricaoMarca")>
    <Required>
    Public Overrides Property IDMarca As Nullable(Of Long)

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True,
      MapearTabelaChaveEstrangeira:="tbUnidades", MapearDescricaoChaveEstrangeira:="DescricaoUnidadeStock")>
    Public Overrides Property IDUnidadeStock As Nullable(Of Long)
        Get
            Return IDUnidade
        End Get
        Set(ByVal value As Nullable(Of Long))
            IDUnidade = value
        End Set
    End Property

    <DataMember>
    <Required>
    Public Overrides Property IDUnidadeCompra As Nullable(Of Long)

    <DataMember>
    Public Overrides Property IDTipoPreco As Nullable(Of Long)
#End Region

#Region "Aros"
    <DataMember>
    Public Property ArtigosAros As List(Of ArtigosAros)
#End Region

#Region "Oculos de sol"
    <DataMember>
    Public Property ArtigosOculosSol As List(Of ArtigosOculosSol)
#End Region

#Region "Lentes de contato"
    <DataMember>
    Public Property ArtigosLentesContato As List(Of ArtigosLentesContato)

    <DataMember>
    Public Property Raio As String

    <DataMember>
    Public Property RaioCurvatura As String

    <DataMember>
    Public Property Eixo As Nullable(Of Integer)

    <DataMember>
    Public Property Raio2 As String

    <DataMember>
    Public Property DetalheRaio As String
#End Region

#Region "Lentes oftalmicas"
    <DataMember>
    Public Property ArtigosLentesOftalmicas As List(Of ArtigosLentesOftalmicas)

    <DataMember>
    Public Property IDTratamentoLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTratamentoLente As String

    <DataMember>
    Public Property PotenciaPrismatica As Double

    <DataMember>
    Public Property CodigosSuplementos As String

    <DataMember>
    Public Property IDCorLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoCorLente As String

    <DataMember>
    Public Property ArtigosLentesOftalmicasSuplementos As List(Of ArtigosLentesOftalmicasSuplementos)
#End Region

#Region "Aros / Oculos de sol / Lentes de contato / Lentes oftalmicas"
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbModelos", MapearDescricaoChaveEstrangeira:="DescricaoModelo")>
    Public Property IDModelo As Nullable(Of Long)
    <DataMember>
    Public Property DescricaoModelo As String
#End Region

#Region "Aros / Oculos de sol"
    <DataMember>
    Public Property CodigoCor As String

    <DataMember>
    Public Property Tamanho As String

    <DataMember>
    Public Property Hastes As String

    <DataMember>
    Public Property CorGenerica As String

    <DataMember>
    Public Property CorLente As String

    <DataMember>
    Public Property TipoLente As String
#End Region

#Region "Lentes de contato / Lentes oftalmicas"
    <DataMember>
    Public Property Diametro As String

    <DataMember>
    Public Property Adicao As Double

    <DataMember>
    Public Property PotenciaEsferica As Double

    <DataMember>
    Public Property PotenciaCilindrica As Double

    <DataMember>
    Public Property PotenciaEsfericaTransposta As String

    <DataMember>
    Public Property PotenciaCilindricaTransposta As String
#End Region

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True,
     MapearTabelaChaveEstrangeira:="tbSistemaClassificacoesTiposArtigos", MapearDescricaoChaveEstrangeira:="DescricaoSistemaClassificacao")>
    Public Property IDSistemaClassificacao As Nullable(Of Long)

    <DataMember>
    Private _DescricaoSistemaClassificacao As String

    <Display(Name:="TipoArtigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <DataMember>
    Public Property DescricaoSistemaClassificacao As String
        Get
            Return _DescricaoSistemaClassificacao
        End Get
        Set(ByVal value As String)
            _DescricaoSistemaClassificacao = ClsTraducao.Traduz(ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma)
        End Set
    End Property

    <DataMember>
    Public Property CodigoMotivoIsencaoIva As String

    <DataMember>
    Public Property MotivoIsencaoIva As String

    <DataMember>
    Public Property SiglaPais As String

    <DataMember>
    Public Property EspacoFiscal As String

    <DataMember>
    Public Property CodigoArtigo As String

    <DataMember>
    Public Property CodigoBarrasArtigo As String

    <DataMember>
    Public Property CodigoBarrasFornecedor As String

    <DataMember>
    Public Property CodigoTipoIVA As String

    <DataMember>
    Public Property CodigoSistemaTipoIva As String

    <DataMember>
    Public Property IDTipoLente As Nullable(Of Long)

    <DataMember>
    Public Property IDMateriaLente As Nullable(Of Long)

    <DataMember>
    Public Property IDsSuplementos As List(Of String)

    <DataMember>
    Public Property CodigoIva As String

    <DataMember>
    Public Property CodigoUnidadeCompra As String

    <DataMember>
    Public Property MencaoIva As String

    <DataMember>
    Public Property IDLote As Long

    <DataMember>
    Public Property DescricaoLote As String

    <DataMember>
    Public Property IDDuplica As Nullable(Of Long)

    <DataMember>
    Public Property QuantidadeStock As Double

    <DataMember>
    Public Property Unidade As String

    <DataMember>
    Public Property ValorComIva2 As Double

    <DataMember>
    Public Property CodigoLote As String

    <DataMember>
    Public Property NLotes As Short

    <DataMember>
    Public Property Inventariado As Nullable(Of Boolean)

    <DataMember>
    Public Overridable Property IDTipoPeso As Nullable(Of Long)

    <DataMember>
    Public Property CodigoTipoPeso As String
    <DataMember>
    Public Property DescricaoTipoPeso As String

    <DataMember>
    Public Property PesoKg As Double?

    <DataMember>
    Public Property Volume As Double?

    <DataMember>
    Public Property IDIdioma As Long?

    <DataMember>
    Public Property DescricaoIdioma As String

    <DataMember>
    Public Property IndiceRefracao As Double?

    <DataMember>
    Public Property Fotocromatica As Boolean
End Class
