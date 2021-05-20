Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class MedicosTecnicos
    Inherits F3M.MedicosTecnicos


    <DataMember>
    Public Property CodigoTemplate As String

    ' GRELHAS LINHAS
    <DataMember>
    Public Overridable Property MedicosTecnicosEspecialidades As List(Of MedicosTecnicosEspecialidades)

    <DataMember>
    Public Overridable Property MedicosTecnicosContatos As List(Of MedicosTecnicosContatos)

    <DataMember>
    Public Overridable Property MedicosTecnicosMoradas As List(Of MedicosTecnicosMoradas)
End Class
