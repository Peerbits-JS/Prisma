'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class tbExamesTemplate
    Public Property ID As Long
    Public Property IDPai As Nullable(Of Long)
    Public Property TipoComponente As String
    Public Property Ordem As Nullable(Of Integer)
    Public Property Label As String
    Public Property StartRow As Nullable(Of Integer)
    Public Property EndRow As Nullable(Of Integer)
    Public Property StartCol As Nullable(Of Integer)
    Public Property EndCol As Nullable(Of Integer)
    Public Property AtributosHtml As String
    Public Property ModelPropertyName As String
    Public Property ModelPropertyType As String
    Public Property EObrigatorio As Nullable(Of Boolean)
    Public Property EEditavel As Nullable(Of Boolean)
    Public Property ValorPorDefeito As String
    Public Property Controlador As String
    Public Property ControladorAcaoExtra As String
    Public Property TabelaBD As String
    Public Property CampoTexto As String
    Public Property FuncaoJSEnviaParametros As String
    Public Property FuncaoJSChange As String
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property ValorMinimo As Nullable(Of Double)
    Public Property ValorMaximo As Nullable(Of Double)
    Public Property Steps As Nullable(Of Double)
    Public Property IDTemplate As Long
    Public Property ViewClassesCSS As String
    Public Property NumCasasDecimais As Nullable(Of Integer)
    Public Property IDElemento As String
    Public Property FuncaoJSOnClick As String
    Public Property EEditavelEdicao As Nullable(Of Boolean)
    Public Property DesenhaBotaoLimpar As Nullable(Of Boolean)
    Public Property ECabecalho As Nullable(Of Boolean)
    Public Property EVisivel As Nullable(Of Boolean)
    Public Property ComponentTag As String

    Public Overridable Property tbExamesTemplate1 As ICollection(Of tbExamesTemplate) = New HashSet(Of tbExamesTemplate)
    Public Overridable Property tbExamesTemplate2 As tbExamesTemplate
    Public Overridable Property tbTemplates As tbTemplates

End Class