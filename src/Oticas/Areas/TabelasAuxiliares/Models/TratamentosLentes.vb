Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class TratamentosLentes
    Inherits ClsF3MModelo

    <DataMember, StringLength(10), Required>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Codigo As String

    <DataMember, StringLength(100), Required>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String

    <DataMember>
    <Display(Name:="Cor", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Cor As Boolean

    <DataMember, StringLength(100)>
    <Display(Name:="CodForn", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodForn As String

    <DataMember, StringLength(50)>
    <Display(Name:="Referencia", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Referencia As String

    <DataMember, StringLength(50)>
    <Display(Name:="ModeloForn", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property ModeloForn As String

    <DataMember, StringLength(4000)>
    <Display(Name:="Observacoes", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Observacoes As String

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbModelos", MapearDescricaoChaveEstrangeira:="DescricaoModelo")>
    Public Property IDModelo As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Modelo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoModelo As String

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMarcas", MapearDescricaoChaveEstrangeira:="DescricaoMarca")>
    Public Property IDMarca As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Marca", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMarca As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposTratamentosLentes", MapearDescricaoChaveEstrangeira:="DescricaoTipo")>
    Public Property IDTipo As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Tipo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoTipo As String
End Class