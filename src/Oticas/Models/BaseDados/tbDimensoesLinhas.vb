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

Partial Public Class tbDimensoesLinhas
    Public Property ID As Long
    Public Property IDDimensao As Long
    Public Property Descricao As String
    Public Property Ordem As Integer
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property Virtual As Boolean

    Public Overridable Property tbArtigosAlternativos As ICollection(Of tbArtigosAlternativos) = New HashSet(Of tbArtigosAlternativos)
    Public Overridable Property tbArtigosAlternativos1 As ICollection(Of tbArtigosAlternativos) = New HashSet(Of tbArtigosAlternativos)
    Public Overridable Property tbArtigosAlternativos2 As ICollection(Of tbArtigosAlternativos) = New HashSet(Of tbArtigosAlternativos)
    Public Overridable Property tbArtigosAlternativos3 As ICollection(Of tbArtigosAlternativos) = New HashSet(Of tbArtigosAlternativos)
    Public Overridable Property tbArtigosAssociados As ICollection(Of tbArtigosAssociados) = New HashSet(Of tbArtigosAssociados)
    Public Overridable Property tbArtigosAssociados1 As ICollection(Of tbArtigosAssociados) = New HashSet(Of tbArtigosAssociados)
    Public Overridable Property tbArtigosAssociados2 As ICollection(Of tbArtigosAssociados) = New HashSet(Of tbArtigosAssociados)
    Public Overridable Property tbArtigosAssociados3 As ICollection(Of tbArtigosAssociados) = New HashSet(Of tbArtigosAssociados)
    Public Overridable Property tbArtigosComponentes As ICollection(Of tbArtigosComponentes) = New HashSet(Of tbArtigosComponentes)
    Public Overridable Property tbArtigosComponentes1 As ICollection(Of tbArtigosComponentes) = New HashSet(Of tbArtigosComponentes)
    Public Overridable Property tbArtigosComponentes2 As ICollection(Of tbArtigosComponentes) = New HashSet(Of tbArtigosComponentes)
    Public Overridable Property tbArtigosComponentes3 As ICollection(Of tbArtigosComponentes) = New HashSet(Of tbArtigosComponentes)
    Public Overridable Property tbArtigosDimensoes As ICollection(Of tbArtigosDimensoes) = New HashSet(Of tbArtigosDimensoes)
    Public Overridable Property tbArtigosDimensoes1 As ICollection(Of tbArtigosDimensoes) = New HashSet(Of tbArtigosDimensoes)
    Public Overridable Property tbDimensoes As tbDimensoes

End Class