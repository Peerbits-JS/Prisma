Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios

Public Class TiposConsultas
    Inherits ClsF3MModelo

    <DataMember, StringLength(6), Required, Display(Name:=CamposGenericos.Codigo, ResourceType:=GetType(Traducao.EstruturaClientes))>
    Public Property Codigo As String

    <DataMember, Required, Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaClientes))>
    Public Property Descricao As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Nullable(Of Long)

    <DataMember, Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String

    <DataMember, Required, AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTemplates", MapearDescricaoChaveEstrangeira:="DescricaoTemplate")>
    Public Property IDTemplate As Nullable(Of Long)

    <DataMember, Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoTemplate As String

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMapasvistas", MapearDescricaoChaveEstrangeira:="DescricaoMapaVista1")>
    Public Property IDMapaVista1 As Nullable(Of Long)

    Private Property _DescricaoMapaVista1 As String
    <DataMember, Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMapaVista1 As String
        Get
            Return _DescricaoMapaVista1
        End Get
        Set(value As String)
            _DescricaoMapaVista1 = ClsTexto.Traduz(Traducao.EstruturaImpressao.ResourceManager, value)
        End Set
    End Property

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMapasvistas", MapearDescricaoChaveEstrangeira:="DescricaoMapaVista2")>
    Public Property IDMapaVista2 As Nullable(Of Long)

    Private Property _DescricaoMapaVista2 As String
    <DataMember, Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMapaVista2 As String
        Get
            Return _DescricaoMapaVista2
        End Get
        Set(value As String)
            _DescricaoMapaVista2 = ClsTexto.Traduz(Traducao.EstruturaImpressao.ResourceManager, value)
        End Set
    End Property

    <DataMember>
    Public Property CodigoTemplate As String
End Class