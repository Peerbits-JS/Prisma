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

Partial Public Class tbBancos
    Public Property ID As Long
    Public Property IDLoja As Nullable(Of Long)
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property Sigla As String
    Public Property CodigoBP As String
    Public Property PaisIban As String
    Public Property BicSwift As String
    Public Property NomeFichSepa As String
    Public Property Observacoes As String
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbBancosContatos As ICollection(Of tbBancosContatos) = New HashSet(Of tbBancosContatos)
    Public Overridable Property tbBancosMoradas As ICollection(Of tbBancosMoradas) = New HashSet(Of tbBancosMoradas)
    Public Overridable Property tbContasBancarias As ICollection(Of tbContasBancarias) = New HashSet(Of tbContasBancarias)

End Class
