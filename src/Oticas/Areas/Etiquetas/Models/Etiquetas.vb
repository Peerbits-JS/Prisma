Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Namespace Areas.Etiquetas.Models
    Public Class Etiquetas
        Inherits ClsF3MModelo

        <DataMember>
        Public Property Entidade As String

        <DataMember>
        Public Property Linha As Integer = 1

        <DataMember>
        Public Property Coluna As Integer = 1

        <DataMember>
        Public Property EtiquetasArtigos As New List(Of EtiquetasArtigos)
    End Class
End Namespace