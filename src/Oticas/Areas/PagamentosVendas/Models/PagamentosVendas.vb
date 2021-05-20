Imports F3M.Modelos.Base
Imports System.Runtime.Serialization

Public Class PagamentosVendas
    Inherits ClsF3MModelo

    <DataMember>
    Public Property Numero As Long

    <DataMember>
    Public Property Data As Date

    <DataMember>
    Public Property Descricao As String

    <DataMember>
    Public Property TotalPagar As Nullable(Of Double)

    <DataMember>
    Public Property ValorEntregue As Nullable(Of Double)

    <DataMember>
    Public Property Troco As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoeda As Nullable(Of Double)

    <DataMember>
    Public Property IDMoeda As Long

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property Saldo As Nullable(Of Double)

    <DataMember>
    Public Property Observacoes As String

    <DataMember>
    Public Property IDEntidade As Long

    <DataMember>
    Public Property CodigoTipoEstado As String 'EFT || ANL

    <DataMember>
    Public Property ListOfPendentes As List(Of DocumentosVendasPendentes)

    <DataMember>
    Public Property ListOfFormasPagamento As List(Of PagamentosVendasFormasPagamento)

    <DataMember>
    Public Property Recibo As Recibos

    <DataMember>
    Public Property IDRecibo As Nullable(Of Long)

    <DataMember>
    Public Property Adiantamento As DocumentosVendas

    <DataMember>
    Public Property Documento As String

    <DataMember>
    Public Property IDContaCaixa As Long?

    <DataMember>
    Public Property DescricaoContaCaixa As String

    <DataMember>
    Public Property PermiteEditarCaixa As Boolean

End Class
