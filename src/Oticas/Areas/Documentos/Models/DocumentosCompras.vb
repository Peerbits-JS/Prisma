Imports System.Runtime.Serialization

Public Class DocumentosCompras
    Inherits F3M.DocumentosCompras

    <DataMember>
    Public Property DocumentosComprasLinhas As New List(Of DocumentosComprasLinhas)

    <DataMember>
    Public Overridable Property DocLinhasIncidencias As List(Of Oticas.DocumentosComprasLinhas)

    Public Property IDLojaSede As Long?

    <DataMember>
    Public Property LocalidadeSede As String

    <DataMember>
    Public Property CodigoPostalSede As String

    <DataMember>
    Public Property MoradaSede As String

    <DataMember>
    Public Property TelefoneSede As String
End Class
