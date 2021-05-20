Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Base

Public Class ComunicacaoSms
    Inherits ClsF3MModelo

    <DataMember, Required, StringLength(10)>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Codigo As String

    <DataMember, Required, StringLength(50)>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaComunicacao", MapearDescricaoChaveEstrangeira:="DescricaoSistemaComunicacao")>
    <Display(Name:="SistemaEnvio", ResourceType:=GetType(Traducao.EstruturaTabelasAuxiliares))>
    Public Property IDSistemaComunicacao As Nullable(Of Long)

    <DataMember>
    <Display(Name:="SistemaEnvio", ResourceType:=GetType(Traducao.EstruturaTabelasAuxiliares))>
    Public Property DescricaoSistemaComunicacao As String

    <DataMember, Required, StringLength(50)>
    <Display(Name:="Utilizador", ResourceType:=GetType(Traducao.EstruturaTabelasAuxiliares))>
    Public Property Utilizador As String

    <DataMember, Required, StringLength(50)>
    <Display(Name:="Chave", ResourceType:=GetType(Traducao.EstruturaTabelasAuxiliares))>
    Public Property Chave As String

    <DataMember, Required, StringLength(11)>
    <Display(Name:="Remetente", ResourceType:=GetType(Traducao.EstruturaTabelasAuxiliares))>
    Public Property Remetente As String
End Class
