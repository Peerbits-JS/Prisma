Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base

Public Class Seriesnumeracao
    Inherits ClsF3MModelo

    <DataMember>
    <Required>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(10)>
    Public Property Codigo As String

    <DataMember>
    <Required>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property Descricao As String

    <DataMember>
    Public Property Fechada As Boolean
End Class
