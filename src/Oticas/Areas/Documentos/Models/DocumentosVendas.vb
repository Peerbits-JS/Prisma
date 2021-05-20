Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Constantes

Public Class DocumentosVendas
    Inherits F3M.DocumentosVendas

    <DataMember>
    Public Property ContatoPreferencial As String

    <DataMember>
    Public Property DocumentosVendasLinhas As New List(Of DocumentosVendasLinhas)

    <DataMember>
    Public Property SimboloMoedaRef As String

    <DataMember>
    Public Property DescricaoTipoEstado As String

    <DataMember>
    Public Property ValidaEstado As Integer

    <DataMember>
    Public Property NotaCredito As DocumentosVendas

    <DataMember>
    Public Property CodigoPostalLoja As String

    <DataMember>
    Public Property LocalidadeLoja As String

    <DataMember>
    Public Property SiglaLoja As String

    <DataMember>
    Public Property NIFLoja As String

    <DataMember>
    Public Property DesignacaoComercialLoja As String

    <DataMember>
    Public Property MoradaLoja As String

    <DataMember>
    Public Property PagamentosVendas As PagamentosVendas

    <DataMember>
    Public Property IDDocumentoVendaPendente As Nullable(Of Long)

    <DataMember>
    Public Property UtilizaConfigDescontos As Boolean = False

    <DataMember>
    Public Property IDLojaSede As Long?

    <DataMember>
    Public Property LocalidadeSede As String

    <DataMember>
    Public Property CodigoPostalSede As String

    <DataMember>
    Public Property MoradaSede As String

    <DataMember>
    Public Property TelefoneSede As String

    <DataMember>
    Public Property IDDocumentoVendaServico As Long = 0

    <DataMember>
    Public Property F3MMarcadorDocOrigem As Byte()

    <DataMember>
    Public Property IdDocOrigem As Long?

    <DataMember>
    Public Property NCDA_CLI_DIFF As DocumentosVendas

    <DataMember>
    Public Property OrigemEntidade2 As Boolean?
End Class
