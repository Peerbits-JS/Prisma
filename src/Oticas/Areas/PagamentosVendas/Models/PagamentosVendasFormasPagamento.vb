Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class PagamentosVendasLinhas
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDPagamentoVenda As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoDocumento As Nullable(Of Long)

    <DataMember>
    Public Property IDTiposDocumentoSeries As Nullable(Of Long)

    <DataMember>
    Public Property IDDocumentoVenda As Long

    <DataMember>
    Public Property IDEntidade As Nullable(Of Long)

    <DataMember>
    Public Property NumeroDocumento As Long

    <DataMember>
    Public Property DataDocumento As Date

    <DataMember>
    Public Property DataVencimento As Date

    <DataMember>
    Public Property Documento As String

    <DataMember>
    Public Property TotalMoeda As Double

    <DataMember>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    Public Property TaxaConversao As Double

    <DataMember>
    Public Property TotalMoedaReferencia As Double

    <DataMember>
    Public Property ValorPago As Double

    <DataMember>
    Public Property Ordem As Long

    <DataMember>
    Public Property LinhaSelecionada As Boolean

    <DataMember>
    Public Property ValorPendente As Double

    <DataMember>
    Public Property TotalMoedaDocumento As Double

    '--/ Non db members
    <DataMember>
    Public Property DescricaoEntidade As String
End Class
