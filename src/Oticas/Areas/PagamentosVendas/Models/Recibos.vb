Imports F3M.Modelos.Base
Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos

Public Class Recibos
    Inherits ClsF3MModelo

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposDocumento", MapearDescricaoChaveEstrangeira:="DescricaoTipoDocumento")>
    Public Property IDTipoDocumento As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTipoDocumento As String

    <DataMember>
    Public Property CodigoTipoDocumento As String

    <DataMember>
    <Required>
    Public Property Documento As String

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposDocumentoSeries", MapearDescricaoChaveEstrangeira:="DescricaoTiposDocumentoSeries")>
    Public Property IDTiposDocumentoSeries As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTiposDocumentoSeries As String

    <DataMember>
    Public Property CodigoTipoDocumentoSerie As String

    <DataMember>
    <Required>
    Public Property NumeroDocumento As Nullable(Of Long)

    <DataMember>
    Public Property NumeroInterno As Nullable(Of Long)

    <DataMember>
    <Required>
    Public Property DataDocumento As Nullable(Of Date)

    <DataMember>
    <Required>
    Public Property DataVencimento As Nullable(Of Date)

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbClientes", MapearDescricaoChaveEstrangeira:="DescricaoEntidade")>
    Public Property IDEntidade As Nullable(Of Long)

    <DataMember>
    Public Property NomeFiscal As String

    <DataMember>
    Public Property MoradaFiscal As String

    <DataMember>
    Public Property ContribuinteFiscal As String

    <DataMember>
    Public Property SiglaPaisFiscal As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbCodigosPostais", MapearDescricaoChaveEstrangeira:="DescricaoCodigoPostal")>
    Public Property IDCodigoPostalFiscal As Nullable(Of Long)

    <DataMember>
    Public Property CodigoPostalFiscal As String

    <DataMember>
    Public Property DescricaoCodigoPostalFiscal As String

    <DataMember>
    Public Property IDConcelhoFiscal As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoConcelhoFiscal As String

    <DataMember>
    Public Property IDDistritoFiscal As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoDistritoFiscal As String

    <DataMember>
    Public Property TotalMoeda As Nullable(Of Double)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMoedas", MapearDescricaoChaveEstrangeira:="DescricaoMoeda")>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoMoeda As String

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property Observacoes As String

    <DataMember>
    Public Property CodigoTipoEstado As String 'EFT || ANL

    <DataMember>
    Public Property RecibosLinhas As List(Of RecibosLinhas)

    <DataMember>
    Public Property RecibosFormasPagamento As List(Of RecibosFormasPagamento)

    'HERE CERTIFICACAO!
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
End Class