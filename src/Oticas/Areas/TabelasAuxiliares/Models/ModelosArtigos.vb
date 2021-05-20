Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Base
Imports F3M.Modelos.Atributos

Public Class ModelosArtigos
    Inherits ClsF3MModelo

    <DataMember, StringLength(10), Required>
    <Display(Name:="Codigo", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Codigo As String

    <DataMember, StringLength(100), Required>
    <Display(Name:="Descricao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Descricao As String

    <DataMember>
    <Display(Name:="Stock", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Stock As Boolean

    <DataMember>
    <Display(Name:="Fotocromatica", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Fotocromatica As Boolean

    <DataMember>
    <Display(Name:="IndiceRefracao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property IndiceRefracao As Double

    Public Property IndiceRefracaoAux As Double

    <DataMember, StringLength(15)>
    <Display(Name:="NrABBE", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property NrABBE As String

    <DataMember, StringLength(15)>
    <Display(Name:="TransmissaoLuz", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property TransmissaoLuz As String

    <DataMember, StringLength(15)>
    <Display(Name:="Material", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Material As String

    <DataMember, StringLength(15)>
    <Display(Name:="UVA", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property UVA As String

    <DataMember, StringLength(15)>
    <Display(Name:="UVB", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property UVB As String

    <DataMember, StringLength(15)>
    <Display(Name:="Infravermelhos", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Infravermelhos As String

    <DataMember, StringLength(100)>
    <Display(Name:="CodForn", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodForn As String

    <DataMember>
    <StringLength(50)>
    <Display(Name:="Referencia", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Referencia As String

    <DataMember>
    <StringLength(50)>
    <Display(Name:="ModeloForn", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property ModeloForn As String

    <DataMember>
    <StringLength(50)>
    <Display(Name:="CodCor", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodCor As String

    <DataMember>
    <StringLength(50)>
    <Display(Name:="CodTratamento", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodTratamento As String

    <DataMember>
    <StringLength(50)>
    <Display(Name:="CodInstrucao", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodInstrucao As String

    <DataMember>
    <StringLength(4000)>
    <Display(Name:="Observacoes", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property Observacoes As String

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbMarcas", MapearDescricaoChaveEstrangeira:="DescricaoMarca")>
    Public Property IDMarca As Nullable(Of Long)

    <DataMember>
    <Display(Name:="Marca", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMarca As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaTiposLentes", MapearDescricaoChaveEstrangeira:="DescricaoTipoLente")>
    Public Property IDTipoLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTipoLente As String

    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaMateriasLentes", MapearDescricaoChaveEstrangeira:="DescricaoMateriaLente")>
    Public Property IDMateriaLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoMateriaLente As String
    <DataMember>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbSistemaSuperficiesLentes", MapearDescricaoChaveEstrangeira:="DescricaoSuperficieLente")>
    Public Property IDSuperficieLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoSuperficieLente As String

    <DataMember>
    <Required>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbTiposArtigos", MapearDescricaoChaveEstrangeira:="DescricaoTipoArtigo")>
    Public Property IDTipoArtigo As Long

    <DataMember>
    Public Property DescricaoTipoArtigo As String
End Class