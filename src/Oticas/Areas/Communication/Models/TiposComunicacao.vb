Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos
Imports Traducao.Traducao
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao

Public Class TiposComunicacao


        <DataMember, Required, StringLength(10)>
    <Display(Name:="ID", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property ID As Long

    <DataMember, Required, StringLength(50)>
        <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
        Public Property Descricao As String

    End Class

