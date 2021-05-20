Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class Especialidades
    Inherits F3M.Especialidades

    <DataMember>
    <Display(Name:="Contactologia")>
    Public Property EContactologia As Boolean
End Class
