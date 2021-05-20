Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos

Public Class Marcas
    Inherits F3M.Marcas

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSegmentosMarcas", MapearDescricaoChaveEstrangeira:="DescricaoSegmentoMarca")>
    Public Property IDSegmentoMarca As Nullable(Of Long)

    <DataMember>
    <Display(Name:="SegmentoMarca", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoSegmentoMarca As String
End Class
