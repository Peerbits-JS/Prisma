Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class PagamentosVendasFormasPagamento
    Inherits ClsF3MModeloLinhas

    <DataMember>
    Public Property IDPagamentoVenda As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoDocumento As Nullable(Of Long)

    <DataMember>
    Public Property IDTiposDocumentoSeries As Nullable(Of Long)

    <DataMember>
    Public Property IDEntidade As Nullable(Of Long)

    <DataMember>
    Public Property NumeroDocumento As Nullable(Of Long)

    <DataMember>
    Public Property DataDocumento As Nullable(Of Date)

    <DataMember>
    Public Property DataVencimento As Nullable(Of Date)

    <DataMember>
    Public Property Documento As String

    <DataMember>
    Public Property IDDocumentoVenda As Nullable(Of Long)

    <DataMember>
    Public Property Valor As Double

    <DataMember>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoeda As Nullable(Of Double)

    <DataMember>
    Public Property IDFormaPagamento As Long

    <DataMember>
    Public Property DescricaoFormaPagamento As String

    <DataMember>
    Public Property CodigoSistemaTipoFormaPagamento As String
End Class
