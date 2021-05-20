Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Autenticacao

Public Class LogicaModulos
    Inherits ClsF3MModeloLinhas

    <DataMember>
    <Required>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(6)>
    Public Property Codigo As String

    <DataMember>
    Private _Descricao As String
    <DataMember>
    <Required>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property Descricao() As String
        Get
            Return _Descricao
        End Get
        Set(ByVal value As String)
            _Descricao = Traducao.Traducao.ClsTraducao.Traduz(Traducao.Traducao.ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma)
        End Set
    End Property

End Class
