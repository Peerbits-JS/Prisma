Imports F3M.Modelos.Base
Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos

Public Class ArtigosFornecedores
    Inherits ClsF3MModeloLinhas

    <DataMember>
    <Required>
    Public Property IDArtigo As Long
    <DataMember>
    Public Property DescricaoArtigo As String

    <DataMember>
    <Required>
    <Display(Name:="Fornecedor", ResourceType:=GetType(Traducao.EstruturaArtigos))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbFornecedores", MapearDescricaoChaveEstrangeira:="DescricaoFornecedor")>
    Public Property IDFornecedor As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Fornecedor", ResourceType:=GetType(Traducao.EstruturaArtigos))>
    Public Property DescricaoFornecedor As String

    <DataMember>
    <Display(Name:="Referencia", ResourceType:=GetType(Traducao.EstruturaArtigos))>
    Public Property Referencia As String

    <DataMember>
    <Display(Name:="CodigoBarras", ResourceType:=GetType(Traducao.EstruturaArtigos))>
    Public Property CodigoBarras As String
End Class