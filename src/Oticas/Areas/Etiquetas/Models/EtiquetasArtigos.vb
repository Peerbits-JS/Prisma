Imports System.Runtime.Serialization
Imports F3M.Modelos.Base

Namespace Areas.Etiquetas.Models
    Public Class EtiquetasArtigos
        Inherits ClsF3MModeloLinhas

        <DataMember>
        Public Property Selecionar As Boolean

        <DataMember>
        Public Property IDArtigo As Long

        <DataMember>
        Public Property CodigoArtigo As String

        <DataMember>
        Public Property DescricaoArtigo As String

        <DataMember>
        Public Property Quantidade As Double?

        <DataMember>
        Public Property ValorComIva As Double?

        <DataMember>
        Public Property TipoDoc As String

        <DataMember>
        Public Property IDDocumento As Nullable(Of Long)

        <DataMember>
        Public Property CodigoBarras As String

        <DataMember>
        Public Property CodigoBarrasFornecedor As String

        <DataMember>
        Public Property ReferenciaFornecedor As String

        <DataMember>
        Public Property CodigoFornecedor As String

        <DataMember>
        Public Property DescricaoMarca As String

        <DataMember>
        Public Property ValorComIva2 As Double?
    End Class
End Namespace