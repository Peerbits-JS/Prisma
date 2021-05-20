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

Partial Public Class tbContabilidadeConfiguracao
    Public Property ID As Long
    Public Property Ano As String
    Public Property CodigoModulo As String
    Public Property DescricaoModulo As String
    Public Property CodigoTipo As String
    Public Property DescricaoTipo As String
    Public Property CodigoAlternativa As String
    Public Property DescricaoAlternativa As String
    Public Property Predefinido As Nullable(Of Boolean)
    Public Property Diario As String
    Public Property CodDocumento As String
    Public Property RefleteClasseIVAContaFinanceira As Nullable(Of Boolean)
    Public Property RefleteCentroCustoContaFinanceira As Nullable(Of Boolean)
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbContabilidadeConfiguracaoLinhas As ICollection(Of tbContabilidadeConfiguracaoLinhas) = New HashSet(Of tbContabilidadeConfiguracaoLinhas)

End Class
