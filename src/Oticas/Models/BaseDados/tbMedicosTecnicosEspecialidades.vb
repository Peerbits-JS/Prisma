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

Partial Public Class tbMedicosTecnicosEspecialidades
    Public Property ID As Long
    Public Property IDMedicoTecnico As Long
    Public Property IDEspecialidade As Long
    Public Property Selecionado As Boolean
    Public Property Principal As Boolean
    Public Property Ativo As Boolean
    Public Property Sistema As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()

    Public Overridable Property tbEspecialidades As tbEspecialidades
    Public Overridable Property tbMedicosTecnicos As tbMedicosTecnicos

End Class
