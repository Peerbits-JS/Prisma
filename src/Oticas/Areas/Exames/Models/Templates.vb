Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes

Public Class Templates
    Inherits ClsF3MModelo

    <DataMember>
    <StringLength(6)>
    <Required>
    <Display(Name:=CamposGenericos.Codigo, ResourceType:=GetType(Traducao.EstruturaClientes))>
    Public Property Codigo As String

    <DataMember>
    <Required>
    <Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaClientes))>
    Public Property Descricao As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String
End Class