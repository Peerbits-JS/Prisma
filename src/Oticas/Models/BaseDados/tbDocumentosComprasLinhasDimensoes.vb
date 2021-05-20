'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Collections.Generic

Partial Public Class tbDocumentosComprasLinhasDimensoes
    Public Property ID As Long
    Public Property IDDocumentoCompraLinha As Long
    Public Property IDArtigoDimensao As Long
    Public Property Quantidade As Nullable(Of Double)
    Public Property PrecoUnitario As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivo As Nullable(Of Double)
    Public Property Ordem As Long
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property QuantidadeStock As Nullable(Of Double)
    Public Property QuantidadeStock2 As Nullable(Of Double)
    Public Property PrecoUnitarioMoedaRef As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoMoedaRef As Nullable(Of Double)
    Public Property QtdStockAnterior As Nullable(Of Double)
    Public Property QtdStockAtual As Nullable(Of Double)
    Public Property UPCMoedaRef As Nullable(Of Double)
    Public Property PCMAnteriorMoedaRef As Nullable(Of Double)
    Public Property PCMAtualMoedaRef As Nullable(Of Double)
    Public Property PVMoedaRef As Nullable(Of Double)
    Public Property Alterada As Nullable(Of Boolean)
    Public Property QtdStockAnteriorOrigem As Nullable(Of Double)
    Public Property QtdStockAtualOrigem As Nullable(Of Double)
    Public Property PCMAnteriorMoedaRefOrigem As Nullable(Of Double)
    Public Property QtdAfetacaoStock As Nullable(Of Double)
    Public Property QtdAfetacaoStock2 As Nullable(Of Double)
    Public Property CodigoArtigo As String
    Public Property CodigoBarrasArtigo As String
    Public Property UPCompraMoedaRef As Nullable(Of Double)
    Public Property UltCustosAdicionaisMoedaRef As Nullable(Of Double)
    Public Property UltDescComerciaisMoedaRef As Nullable(Of Double)
    Public Property ValorIva As Nullable(Of Double)
    Public Property ValorIvaDedutivel As Nullable(Of Double)
    Public Property ValorIncidencia As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoMoedaRefOrigem As Nullable(Of Double)
    Public Property IDLinhaDimensaoDocumentoCompraInicial As Nullable(Of Long)
    Public Property IDLinhaDimensaoDocumentoStockInicial As Nullable(Of Long)
    Public Property IDLinhaDimensaoDocumentoCompra As Nullable(Of Long)
    Public Property IDLinhaDimensaoDocumentoStock As Nullable(Of Long)
    Public Property QtdStockSatisfeita As Nullable(Of Double)
    Public Property QtdStockDevolvida As Nullable(Of Double)
    Public Property QtdStockAcerto As Nullable(Of Double)
    Public Property QtdStock2Satisfeita As Nullable(Of Double)
    Public Property QtdStock2Devolvida As Nullable(Of Double)
    Public Property QtdStock2Acerto As Nullable(Of Double)
    Public Property IDLinhaDimensaoDocumentoOrigem As Nullable(Of Long)
    Public Property QuantidadeSatisfeita As Nullable(Of Double)
    Public Property QuantidadeDevolvida As Nullable(Of Double)
    Public Property Satisfeito As Nullable(Of Boolean)
    Public Property QtdStockReserva As Nullable(Of Double)
    Public Property QtdStockReserva2Uni As Nullable(Of Double)
    Public Property ValorDescontoEfetivoSemIva As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoSemIva As Nullable(Of Double)
    Public Property ValorDescontoLinha As Nullable(Of Double)
    Public Property AcertoIncidencia As Nullable(Of Double)
    Public Property AcertoIVA As Nullable(Of Double)

    Public Overridable Property tbArtigosDimensoes As tbArtigosDimensoes
    Public Overridable Property tbDocumentosComprasLinhas As tbDocumentosComprasLinhas
    Public Overridable Property tbDocumentosComprasLinhasDimensoes1 As ICollection(Of tbDocumentosComprasLinhasDimensoes) = New HashSet(Of tbDocumentosComprasLinhasDimensoes)
    Public Overridable Property tbDocumentosComprasLinhasDimensoes2 As tbDocumentosComprasLinhasDimensoes
    Public Overridable Property tbDocumentosComprasLinhasDimensoes11 As ICollection(Of tbDocumentosComprasLinhasDimensoes) = New HashSet(Of tbDocumentosComprasLinhasDimensoes)
    Public Overridable Property tbDocumentosComprasLinhasDimensoes3 As tbDocumentosComprasLinhasDimensoes
    Public Overridable Property tbDocumentosStockLinhasDimensoes As tbDocumentosStockLinhasDimensoes
    Public Overridable Property tbDocumentosStockLinhasDimensoes1 As tbDocumentosStockLinhasDimensoes

End Class
