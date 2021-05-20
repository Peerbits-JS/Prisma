Imports System.Runtime.Serialization
Imports F3M.Modelos.Constantes

Public Class DocumentosVendasServicosSubstituicao
    Inherits F3M.DocumentosVendas

    <DataMember>
    Public Property CodigoEstado As String

    Public Function EstaEfetivo() As Boolean
        Return CodigoTipoEstado = TiposEstados.Efetivo
    End Function

    Public Function EstaComoRascunho()
        Return CodigoTipoEstado = TiposEstados.Rascunho
    End Function

    <DataMember>
    Public Property IDServico As Long

    <DataMember>
    Public Property DescricaoServico As String

    <DataMember>
    Public Property DescricaoTipoServico As String

    <DataMember>
    Public Property Servico As New Servicos
End Class

Public Class DocumentosVendasServicosSubstituicaoArtigos
    <DataMember>
    Public Property Id As Long

    <DataMember>
    Public Property DiametroOrigem As String

    <DataMember>
    Public Property IdArtigoOrigem As Long

    <DataMember>
    Public Property CodigoArtigoOrigem As String

    <DataMember>
    Public Property DescricaoArtigoOrigem As String

    <DataMember>
    Public Property DiametroDestino As String

    <DataMember>
    Public Property IdArtigoDestino As Long

    <DataMember>
    Public Property CodigoArtigoDestino As String

    <DataMember>
    Public Property CodigoBarrasArtigoDestino As String

    <DataMember>
    Public Property DescricaoArtigoDestino As String

    <DataMember>
    Public Property IDServico As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoOlho As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoGraduacao As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoServico As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoArtigo As Nullable(Of Long)

    <DataMember>
    Public Property IdLinhaDocumentoOrigemInicial As Nullable(Of Long)

    <DataMember>
    Public Property IDModelo As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoModelo As String

    <DataMember>
    Public Property IDMarca As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoMarca As String

    <DataMember>
    Public Property IDTratamentoLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoTratamentoLente As String

    <DataMember>
    Public Property IDCorLente As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoCorLente As String

    <DataMember>
    Public Property IDTipoLente As Nullable(Of Long)

    <DataMember>
    Public Property IDMateria As Nullable(Of Long)

    <DataMember>
    Public Property IDsSuplementos As List(Of Long)

    <DataMember>
    Public Property PotenciaCilindrica As Nullable(Of Double)

    <DataMember>
    Public Property PotenciaPrismatica As Nullable(Of Double)

    <DataMember>
    Public Property PotenciaEsferica As Nullable(Of Double)

    <DataMember>
    Public Property Adicao As Nullable(Of Double)

    <DataMember>
    Public Property RaioCurvatura As String

    <DataMember>
    Public Property DetalheRaio As String

    <DataMember>
    Public Property Eixo As Nullable(Of Integer)

    <DataMember>
    Public Property Preco As Nullable(Of Double)

    <DataMember>
    Public Property CustoMedioArtigoDestino As Nullable(Of Double)

    <DataMember>
    Public Property TaxaIvaArtigoDestino As Nullable(Of Double)
End Class