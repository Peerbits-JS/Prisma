Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class RecibosLinhas
    Inherits ClsF3MModelo

    <DataMember>
    Public Property IDRecibo As Nullable(Of Long)

    <DataMember>
    <Required>
    <Display(Name:="TiposDocumento", ResourceType:=GetType(Traducao.EstruturaTiposDocumento))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposDocumento", MapearDescricaoChaveEstrangeira:="DescricaoTipoDocumento")>
    Public Property IDTipoDocumento As Nullable(Of Long)

    <DataMember>
    <Display(Name:="TiposDocumento", ResourceType:=GetType(Traducao.EstruturaTiposDocumento))>
    Public Property DescricaoTipoDocumento As String

    <DataMember>
    Public Property CodigoTipoDocumento As String

    <DataMember>
    <Required>
    <Display(Name:="Documento", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Documento As String

    <DataMember>
    <Required>
    <Display(Name:="TiposDocumento", ResourceType:=GetType(Traducao.EstruturaTiposDocumento))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposDocumentoSeries", MapearDescricaoChaveEstrangeira:="DescricaoTiposDocumentoSeries")>
    Public Property IDTiposDocumentoSeries As Nullable(Of Long)

    <DataMember>
    <Display(Name:="TiposDocumento", ResourceType:=GetType(Traducao.EstruturaTiposDocumento))>
    Public Property DescricaoTiposDocumentoSeries As String

    <DataMember>
    Public Property CodigoTipoDocumentoSerie As String

    <DataMember>
    <Required>
    <Display(Name:="NumeroDocumento", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property NumeroDocumento As Nullable(Of Long)

    <DataMember>
    Public Property NumeroInterno As Nullable(Of Long)

    <DataMember>
    <Required>
    <Display(Name:="DataDocumento", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataDocumento As Nullable(Of Date)

    <DataMember>
    <Required>
    <Display(Name:="DataVencimento", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataVencimento As Nullable(Of Date)

    <DataMember>
    <Required>
    <Display(Name:="Entidade", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
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
    <Display(Name:="Moeda", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMoedas", MapearDescricaoChaveEstrangeira:="DescricaoMoeda")>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Moeda", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DescricaoMoeda As String

    <DataMember>
    <Display(Name:="TaxaConversao", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property Observacoes As String

    <DataMember>
    Public Property RecibosLinhasTaxas As List(Of RecibosLinhasTaxas)
End Class

