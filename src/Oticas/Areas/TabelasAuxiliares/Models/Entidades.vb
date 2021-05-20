Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class Entidades
    Inherits F3M.Entidades

    <DataMember>
    Public Overridable Property EntidadesLojas As List(Of EntidadesLojas)

    <DataMember>
    Public Overridable Property EntidadesContatos As List(Of EntidadesContatos)

    <DataMember>
    Public Overridable Property EntidadesMoradas As List(Of EntidadesMoradas)

    <DataMember>
    Public Overridable Property EntidadesComparticipacoes As List(Of EntidadesComparticipacoes)
End Class
