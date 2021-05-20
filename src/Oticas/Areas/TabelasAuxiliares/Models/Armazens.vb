Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos

Public Class Armazens
    Inherits F3M.Armazens

    <DataMember>
    <Display(Name:="Pais", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
        MapearTabelaChaveEstrangeira:="tbPaises", MapearDescricaoChaveEstrangeira:="DescricaoPais")>
    Public Property IDPais As Nullable(Of Long)
    <DataMember>
    Public Property DescricaoPais As String

    <DataMember>
    Public Overridable Property ArmazensLocalizacoes As List(Of ArmazensLocalizacoes)
End Class
