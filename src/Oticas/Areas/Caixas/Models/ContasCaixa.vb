Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Base


Public Class ContasCaixa
    Inherits ClsF3MModelo

    <DataMember, Required>
    <Display(Name:="Loja", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Long?

    <DataMember>
    <Display(Name:="Loja", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String

    <DataMember, Required, StringLength(10)>
    Public Property Codigo As String

    <DataMember, Required, StringLength(50)>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String

    <DataMember>
    Public Property PorDefeito As Boolean

End Class