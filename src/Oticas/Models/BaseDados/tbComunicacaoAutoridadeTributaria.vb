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

Partial Public Class tbComunicacaoAutoridadeTributaria
    Public Property ID As Long
    Public Property Filtro As String
    Public Property Observacoes As String
    Public Property FicheiroXML As String
    Public Property CaminhoXML As String
    Public Property FicheiroCSV As String
    Public Property CaminhoCSV As String
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property Sistema As Nullable(Of Boolean)
    Public Property Ativo As Boolean

    Public Overridable Property tbComunicacaoAutoridadeTributariaAnexos As ICollection(Of tbComunicacaoAutoridadeTributariaAnexos) = New HashSet(Of tbComunicacaoAutoridadeTributariaAnexos)

End Class
