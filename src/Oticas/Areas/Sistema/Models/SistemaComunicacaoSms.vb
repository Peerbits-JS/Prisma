Imports System.ComponentModel.DataAnnotations
Imports System.Runtime.Serialization
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes
Imports Traducao.Traducao

Public Class SistemaComunicacaoSms
    Inherits ClsF3MModelo

    <DataMember, Required, StringLength(5)>
    <Display(Name:=CamposGenericos.Codigo, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Codigo As String

    <DataMember>
    Private _Descricao As String
    <DataMember, Required, StringLength(50)>
    <Display(Name:=CamposGenericos.Descricao, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String
        Get
            Return _Descricao
        End Get
        Set(ByVal value As String)
            _Descricao = ClsTraducao.Traduz(ClsTipos.TipoTraducao.Sistema, value, ClsF3MSessao.Idioma)
        End Set
    End Property

    <DataMember>
    Public Property APIURL As String
End Class