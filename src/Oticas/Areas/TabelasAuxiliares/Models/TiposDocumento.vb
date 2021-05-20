Imports System.Runtime.Serialization

Public Class TiposDocumento
    Inherits F3M.TiposDocumento

    <DataMember>
    Public Overridable Property TiposDocumentoTipEntPermDoc As List(Of TiposDocumentoTipEntPermDoc)

    <DataMember>
    Public Overridable Property TiposDocumentoIdiomas As List(Of TiposDocumentoIdiomas)

    <DataMember>
    Public Overridable Property TiposDocumentoSeries As List(Of TiposDocumentoSeries)

    <DataMember>
    Public Property Series As List(Of TiposDocumentoSeries)
End Class
