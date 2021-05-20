Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos

Public Class MovimentosCaixa
    Inherits MapaCaixa

    <DataMember>
    Public Property VerificaCaixaAberta As Boolean

    <DataMember, Required>
    <Display(Name:="Caixa", ResourceType:=GetType(Traducao.EstruturaLojas))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbContasCaixa", MapearDescricaoChaveEstrangeira:="DescricaoContaCaixa")>
    Public Property IDContaCaixa As Long

    <Display(Name:="Caixa", ResourceType:=GetType(Traducao.EstruturaLojas))>
    Public Property DescricaoContaCaixa As String

    <DataMember>
    Public Property PermiteEditarCaixa As Boolean

End Class