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

Partial Public Class tbExames
    Public Property ID As Long
    Public Property Numero As Long
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDCliente As Long
    Public Property IDMedicoTecnico As Long
    Public Property IDEspecialidade As Long
    Public Property IDLoja As Long
    Public Property DataExame As Date
    Public Property IDTemplate As Long
    Public Property IDAgendamento As Nullable(Of Long)
    Public Property IDTipoConsulta As Nullable(Of Long)

    Public Overridable Property tbAgendamento As tbAgendamento
    Public Overridable Property tbClientes As tbClientes
    Public Overridable Property tbEspecialidades As tbEspecialidades
    Public Overridable Property tbLojas As tbLojas
    Public Overridable Property tbMedicosTecnicos As tbMedicosTecnicos
    Public Overridable Property tbTemplates As tbTemplates
    Public Overridable Property tbTiposConsultas As tbTiposConsultas
    Public Overridable Property tbExamesAnexos As ICollection(Of tbExamesAnexos) = New HashSet(Of tbExamesAnexos)
    Public Overridable Property tbExamesProps As ICollection(Of tbExamesProps) = New HashSet(Of tbExamesProps)
    Public Overridable Property tbExamesPropsFotos As ICollection(Of tbExamesPropsFotos) = New HashSet(Of tbExamesPropsFotos)

End Class
