Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class CoresLentes
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

    <DataMember>
    Public Property PrecoVenda As Nullable(Of Double)

    <DataMember>
    Public Property PrecoCusto As Nullable(Of Double)

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

    <DataMember>
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

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposLentes", MapearDescricaoChaveEstrangeira:="DescricaoTipoLente")>
    Public Property IDTipoLente As Long

    <DataMember>
    Public Property DescricaoTipoLente As String

    <DataMember, Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaMateriasLentes", MapearDescricaoChaveEstrangeira:="DescricaoMateriaLente")>
    Public Property IDMateriaLente As Long

    <DataMember>
    Public Property DescricaoMateriaLente As String
End Class