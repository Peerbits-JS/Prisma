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

Partial Public Class tbCondicionantes
    Public Property ID As Long
    Public Property IDParametroCamposContexto As Long
    Public Property CampoCondicionante As String
    Public Property ValorCondicionante As String
    Public Property ValorPorDefeito As String
    Public Property TipoValorPorDefeito As String
    Public Property Ordem As Integer
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbParametrosCamposContexto As tbParametrosCamposContexto

End Class