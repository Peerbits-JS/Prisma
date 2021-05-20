Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports Traducao.Traducao
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao

Public Class TiposFases
    Inherits ClsF3MModeloLinhas

    <DataMember, Required, StringLength(10)>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Codigo As String

    <DataMember, Required, StringLength(50)>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String

    <DataMember, Required, Display(Name:="Tipo de Serviço")>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaClassificacoesTiposArtigos", MapearDescricaoChaveEstrangeira:="DescricaoSistemaClassificacoesTiposArtigos")>
    Public Property IDSistemaClassificacoesTiposArtigos As Nullable(Of Long)

    <DataMember>
    Private _DescricaoSistemaClassificacoesTiposArtigos As String
    <DataMember, Display(Name:="Tipo de Serviço")>
    Public Property DescricaoSistemaClassificacoesTiposArtigos() As String
        Get
            Return _DescricaoSistemaClassificacoesTiposArtigos
        End Get
        Set(ByVal value As String)
            _DescricaoSistemaClassificacoesTiposArtigos = ClsTexto.Traduz(ClsTraducao.Traduz(ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma))
        End Set
    End Property

    <DataMember, Display(Name:="Tipo de Artigo")>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposOlhos", MapearDescricaoChaveEstrangeira:="DescricaoSistemaTiposOlhos")>
    Public Property IDSistemaTiposOlhos As Nullable(Of Long)

    <DataMember>
    Private _DescricaoSistemaTiposOlhos As String
    <DataMember, Display(Name:="Tipo de Artigo")>
    Public Property DescricaoSistemaTiposOlhos() As String
        Get
            Return _DescricaoSistemaTiposOlhos
        End Get
        Set(ByVal value As String)
            _DescricaoSistemaTiposOlhos = ClsTexto.Traduz(ClsTraducao.Traduz(ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma))
        End Set
    End Property

    <DataMember, Required, Display(Name:="Tipo de Estado")>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposFases", MapearDescricaoChaveEstrangeira:="DescricaoSistemaTiposFases")>
    Public Property IDSistemaTiposFases As Nullable(Of Long)

    <DataMember>
    Private _DescricaoSistemaTiposFases As String
    <DataMember, Display(Name:="Tipo de Estado")>
    Public Property DescricaoSistemaTiposFases() As String
        Get
            Return _DescricaoSistemaTiposFases
        End Get
        Set(ByVal value As String)
            _DescricaoSistemaTiposFases = ClsTexto.Traduz(ClsTraducao.Traduz(ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma))
        End Set
    End Property
End Class