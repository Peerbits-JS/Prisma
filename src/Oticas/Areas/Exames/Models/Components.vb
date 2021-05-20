Imports System.Runtime.Serialization
Imports F3M.Modelos.Constantes

Public Class Components
    <DataMember>
    Public Property ID As Long

    <DataMember>
    Public Property AcaoFormulario As Integer

    <DataMember>
    Public Property IDPai As Nullable(Of Long)

    <DataMember>
    Public Property IDTemplate As Long

    <DataMember>
    Public Property TipoComponente As String

    <DataMember>
    Public Property Ordem As Nullable(Of Integer)

    <DataMember>
    Public Property Label As String

    <DataMember>
    Public Property StartRow As Nullable(Of Integer)

    <DataMember>
    Public Property EndRow As Nullable(Of Integer)

    <DataMember>
    Public Property StartCol As Nullable(Of Integer)

    <DataMember>
    Public Property EndCol As Nullable(Of Integer)

    <DataMember>
    Public Property ModelPropertyName As String

    <DataMember>
    Public Property ModelPropertyType As String

    <DataMember>
    Public Property EObrigatorio As Nullable(Of Boolean) = False

    <DataMember>
    Public Property EEditavel As Nullable(Of Boolean) = True

    <DataMember>
    Public Property ValorPorDefeito As String

    Private _AtributosHtml As String
    <DataMember>
    Public Property AtributosHtml() As String
        Get
            Return _AtributosHtml
        End Get
        Set(ByVal value As String)
            _AtributosHtml = IIf(String.IsNullOrEmpty(value), String.Empty, value)
        End Set
    End Property

    Private _ViewClassesCSS As String
    <DataMember>
    Public Property ViewClassesCSS() As String
        Get
            Return _ViewClassesCSS
        End Get
        Set(ByVal value As String)
            _ViewClassesCSS = IIf(String.IsNullOrEmpty(value), "", value)
        End Set
    End Property

    <DataMember>
    Public Property Controlador As String

    <DataMember>
    Public Property ControladorAcaoExtra As String

    <DataMember>
    Public Property CampoTexto As String

    <DataMember>
    Public Property FuncaoJSEnviaParametros As String

    <DataMember>
    Public Property FuncaoJSChange As String

    <DataMember>
    Public Property FuncaoJSOnClick As String

    <DataMember>
    Public Property ValorID As String

    <DataMember>
    Public Property ValorDescricao As String

    <DataMember>
    Public Property ValorMinimo As Nullable(Of Double)

    <DataMember>
    Public Property ValorMaximo As Nullable(Of Double)

    <DataMember>
    Public Property Steps As Nullable(Of Double)

    <DataMember>
    Public Property NumCasasDecimais As Nullable(Of Integer)

    <DataMember>
    Public Property ECustomizacao As Boolean = False

    <DataMember>
    Public Property EElementoGridLinhas As Boolean = False

    <DataMember>
    Public Property IDElemento As String

    <DataMember>
    Public Property DesenhaBotaoLimpar As Nullable(Of Boolean) = True

    <DataMember>
    Public Property ECabecalho As Nullable(Of Boolean) = False

    <DataMember>
    Public Property EEditavelEdicao As Nullable(Of Boolean) = True

    <DataMember>
    Public Property ListOfComponentesFilhos As List(Of Components)

    <DataMember>
    Public Property F3MBDID As Long

    <DataMember>
    Public Property IDExame As Long
End Class