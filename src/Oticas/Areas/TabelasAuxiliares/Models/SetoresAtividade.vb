Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Public Class SetoresAtividade
    Inherits F3M.SetoresAtividade

    <DataMember>
    Public Overridable Property SetoresAtividadeIdiomas As List(Of SetoresAtividadeIdiomas)
End Class
