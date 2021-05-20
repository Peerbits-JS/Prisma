Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations

Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao
Imports F3M.Modelos.Autenticacao

Public Class DocumentosVendasPendentes
    Inherits ClsF3MModelo

    <DataMember>
    Public Property Documento As String

    <DataMember>
    Public Property Descricao As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposDocumento", MapearDescricaoChaveEstrangeira:="DescricaoTipoDocumento")>
    Public Property IDTipoDocumento As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTipoDocumento As String

    <DataMember>
    Public Property NumeroDocumento As Nullable(Of Long)

    <DataMember>
    Public Property DataDocumento As Nullable(Of Date)

    <DataMember>
    Public Property DataVencimento As Nullable(Of Date)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMoedas", MapearDescricaoChaveEstrangeira:="DescricaoMoeda")>
    Public Property IDMoeda As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoMoeda As String

    <DataMember>
    Public Property TaxaConversao As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaDocumento As Nullable(Of Double)

    <DataMember>
    Public Property TotalMoedaReferencia As Nullable(Of Double)

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbClientes", MapearDescricaoChaveEstrangeira:="DescricaoEntidade")>
    Public Property IDEntidade As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoEntidade As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposEntidade", MapearDescricaoChaveEstrangeira:="DescricaoTipoEntidade")>
    Public Property IDTipoEntidade As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTipoEntidade As String

    <DataMember>
    Public Property ValorPendente As Double

    <DataMember>
    Public Property ValorPendenteAux As Double

    <DataMember>
    Public Property ValorPago As Double

    <DataMember>
    Public Property LinhaSelecionada As Boolean

    <DataMember>
    Public Property GereContaCorrente As Boolean

    <DataMember>
    Public Property GereCaixasBancos As Boolean

    <DataMember>
    Public Property GeraPendente As Boolean

    <DataMember>
    Public Property IDDocumentoVenda As Long

    <DataMember>
    Public Property IDTiposDocumentoSeries As Long

    <DataMember>
    Public Property ValorEmFaltaAux As Double


    '// here
    <DataMember>
    Public Property NomeFiscal As String

    <DataMember>
    Public Property MoradaFiscal As String

    <DataMember>
    Public Property IDCodigoPostalFiscal As Nullable(Of Long)

    <DataMember>
    Public Property IDConcelhoFiscal As Nullable(Of Long)

    <DataMember>
    Public Property IDDistritoFiscal As Nullable(Of Long)

    <DataMember>
    Public Property CodigoPostalFiscal As String

    <DataMember>
    Public Property DescricaoCodigoPostalFiscal As String

    <DataMember>
    Public Property DescricaoConcelhoFiscal As String

    <DataMember>
    Public Property DescricaoDistritoFiscal As String

    <DataMember>
    Public Property ContribuinteFiscal As String

    <DataMember>
    Public Property SiglaPaisFiscal As String

    <DataMember>
    Public Property MotivoIsencao As String

    <DataMember>
    Public Property IDSistemaNaturezas As Long

    <DataMember>
    Public Property DescricaoSistemaNaturezas As String

    <DataMember>
    Public Property CodigoSistemaNaturezas As String

    <DataMember>
    Public Property TotalClienteMoedaReferencia As Nullable(Of Double)

    <DataMember>
    Public Property TotalClienteMoedaDocumento As Nullable(Of Double)
End Class
