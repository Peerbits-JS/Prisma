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

Partial Public Class tbArtigosUnidades
    Public Property ID As Long
    Public Property IDArtigo As Long
    Public Property IDUnidade As Long
    Public Property IDUnidadeConversao As Long
    Public Property FatorConversao As Double
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property Ordem As Integer

    Public Overridable Property tbArtigos As tbArtigos
    Public Overridable Property tbUnidades As tbUnidades
    Public Overridable Property tbUnidades1 As tbUnidades

End Class
