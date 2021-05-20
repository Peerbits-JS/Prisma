Imports F3M.Modelos.Base
Imports System.Runtime.Serialization

Public Class DocumentosVendasFormasPagamento
    Inherits ClsF3MModeloLinhas

    <DataMember>
    Public Property IDDocumentoVenda As Long

    <DataMember>
    Public Property IDFormaPagamento As Long

    <DataMember>
    Public Property TotalMoeda As Double

    <DataMember>
    Public Property IDMoeda As Long

    <DataMember>
    Public Property TaxaConversao As Double

    <DataMember>
    Public Property TotalMoedaReferencia As Double

    <DataMember>
    Public Property Valor As Double

    <DataMember>
    Public Property ValorEntregue As Double

    <DataMember>
    Public Property Troco As Double

    <DataMember>
    Public Property CodigoFormaPagamento As String
End Class
