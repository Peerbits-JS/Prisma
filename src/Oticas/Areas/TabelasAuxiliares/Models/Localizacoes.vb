Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class Localizacoes
    Inherits ClsF3MModelo

    <DataMember>
    <Required>
    <Display(Name:="Armazem", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
        MapearTabelaChaveEstrangeira:="tbArmazens", MapearDescricaoChaveEstrangeira:="DescricaoArmazem")>
    Public Property IDArmazem As Nullable(Of Long)
    <DataMember>
    <Display(Name:="Armazem", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoArmazem As String

    <DataMember>
    <Required>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property Codigo As String

    <DataMember>
    <Required>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(100)>
    Public Property Descricao As String

    <DataMember>
    <Display(Name:="CodigoBarras", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(125)>
    Public Property CodigoBarras As String

    <DataMember>
    Public Property Ordem As Nullable(Of Integer)
End Class
