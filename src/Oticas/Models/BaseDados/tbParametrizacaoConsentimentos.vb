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

Partial Public Class tbParametrizacaoConsentimentos
    Public Property ID As Long
    Public Property IDFuncionalidadeConsentimento As Integer
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Titulo As String
    Public Property TituloSemFormatacao As String
    Public Property Cabecalho As String
    Public Property CabecalhoSemFormatacao As String
    Public Property Rodape As String
    Public Property RodapeSemFormatacao As String
    Public Property ApresentadoPorDefeito As Boolean
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbConsentimentos As ICollection(Of tbConsentimentos) = New HashSet(Of tbConsentimentos)
    Public Overridable Property tbSistemaFuncionalidadesConsentimento As tbSistemaFuncionalidadesConsentimento
    Public Overridable Property tbParametrizacaoConsentimentosCamposEntidade As ICollection(Of tbParametrizacaoConsentimentosCamposEntidade) = New HashSet(Of tbParametrizacaoConsentimentosCamposEntidade)
    Public Overridable Property tbParametrizacaoConsentimentosPerguntas As ICollection(Of tbParametrizacaoConsentimentosPerguntas) = New HashSet(Of tbParametrizacaoConsentimentosPerguntas)

End Class
