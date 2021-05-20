Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class MapaCaixa
    Inherits ClsF3MModelo

    <DataMember>
    Public Property Natureza As String

    <DataMember>
    Public Property IDFormaPagamento As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoFormaPagamento As String

    <DataMember>
    Public Property IDTipoDocumento As Nullable(Of Long)
    <DataMember>
    Public Property IDTipoDocumentoSeries As Nullable(Of Long)

    <DataMember>
    Public Property IDDocumento As Nullable(Of Long)

    <DataMember>
    Public Property NumeroDocumento As String

    <DataMember>
    Public Property DataDocumento As Nullable(Of Date)

    <DataMember>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(255)>
    Public Property Descricao As String

    <DataMember>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoeda As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property Valor As Nullable(Of Double)
    <DataMember>
    Public Property ValorEntregue As Nullable(Of Double)

    <DataMember>
    Public Property Troco As Nullable(Of Double)

    <DataMember>
    Public Property IDSistemaNaturezas As Nullable(Of Long)
    <DataMember>
    Public Property DescricaoSistemaNaturezas As String

    <DataMember>
    Public Property DescricaoLoja As String
End Class

