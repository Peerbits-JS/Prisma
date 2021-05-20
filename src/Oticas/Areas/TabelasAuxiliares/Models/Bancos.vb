Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class Bancos
    Inherits F3M.Bancos


    ' GRELHAS LINHAS
    <DataMember>
    Public Overridable Property BancosContatos As List(Of BancosContatos)

    <DataMember>
    Public Overridable Property BancosMoradas As List(Of BancosMoradas)
End Class
