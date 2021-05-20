Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class RecibosFormasPagamento
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDRecibo As Nullable(Of Long)

    <DataMember>
    Public Property IDFormaPagamento As Long

    <DataMember>
    Public Property DescricaoFormaPagamento As String

    <DataMember>
    Public Property TotalMoeda As Nullable(Of Double)

    <DataMember>
    Public Property IDMoeda As Nullable(Of Double)

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property Valor As Nullable(Of Double)

    <DataMember>
    Public Property Ordem As Long

    <DataMember>
    Public Property CodigoFormaPagamento As String
End Class

