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

Partial Public Class tbDocumentosStockLinhas
    Public Property ID As Long
    Public Property IDDocumentoStock As Long
    Public Property IDArtigo As Nullable(Of Long)
    Public Property Descricao As String
    Public Property IDUnidade As Nullable(Of Long)
    Public Property NumCasasDecUnidade As Nullable(Of Short)
    Public Property Quantidade As Nullable(Of Double)
    Public Property PrecoUnitario As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivo As Nullable(Of Double)
    Public Property PrecoTotal As Nullable(Of Double)
    Public Property Observacoes As String
    Public Property IDLote As Nullable(Of Long)
    Public Property CodigoLote As String
    Public Property DescricaoLote As String
    Public Property DataFabricoLote As Nullable(Of Date)
    Public Property DataValidadeLote As Nullable(Of Date)
    Public Property IDArtigoNumSerie As Nullable(Of Long)
    Public Property ArtigoNumSerie As String
    Public Property IDArmazem As Nullable(Of Long)
    Public Property IDArmazemLocalizacao As Nullable(Of Long)
    Public Property IDArmazemDestino As Nullable(Of Long)
    Public Property IDArmazemLocalizacaoDestino As Nullable(Of Long)
    Public Property NumLinhasDimensoes As Nullable(Of Long)
    Public Property Desconto1 As Nullable(Of Double)
    Public Property Desconto2 As Nullable(Of Double)
    Public Property IDTaxaIva As Nullable(Of Long)
    Public Property TaxaIva As Nullable(Of Double)
    Public Property MotivoIsencaoIva As String
    Public Property IDEspacoFiscal As Nullable(Of Long)
    Public Property EspacoFiscal As String
    Public Property IDRegimeIva As Nullable(Of Long)
    Public Property RegimeIva As String
    Public Property SiglaPais As String
    Public Property Ordem As Integer
    Public Property Sistema As Boolean
    Public Property Ativo As Boolean
    Public Property DataCriacao As Date
    Public Property UtilizadorCriacao As String
    Public Property DataAlteracao As Nullable(Of Date)
    Public Property UtilizadorAlteracao As String
    Public Property F3MMarcador As Byte()
    Public Property IDUnidadeStock As Nullable(Of Long)
    Public Property IDUnidadeStock2 As Nullable(Of Long)
    Public Property QuantidadeStock As Nullable(Of Double)
    Public Property QuantidadeStock2 As Nullable(Of Double)
    Public Property ValorIva As Nullable(Of Double)
    Public Property ValorIncidencia As Nullable(Of Double)
    Public Property PrecoUnitarioMoedaRef As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoMoedaRef As Nullable(Of Double)
    Public Property QtdStockAnterior As Nullable(Of Double)
    Public Property QtdStockAtual As Nullable(Of Double)
    Public Property UPCMoedaRef As Nullable(Of Double)
    Public Property PCMAnteriorMoedaRef As Nullable(Of Double)
    Public Property PCMAtualMoedaRef As Nullable(Of Double)
    Public Property PVMoedaRef As Nullable(Of Double)
    Public Property Alterada As Nullable(Of Boolean)
    Public Property DataDocOrigem As Nullable(Of Date)
    Public Property ValorizouOrigem As Nullable(Of Boolean)
    Public Property MovStockOrigem As Nullable(Of Boolean)
    Public Property IDTipoDocumentoOrigem As Nullable(Of Long)
    Public Property IDDocumentoOrigem As Nullable(Of Long)
    Public Property IDLinhaDocumentoOrigem As Nullable(Of Long)
    Public Property NumCasasDecUnidadeStk As Nullable(Of Short)
    Public Property NumCasasDec2UnidadeStk As Nullable(Of Short)
    Public Property FatorConvUnidStk As Nullable(Of Double)
    Public Property FatorConv2UnidStk As Nullable(Of Double)
    Public Property QtdStockAnteriorOrigem As Nullable(Of Double)
    Public Property QtdStockAtualOrigem As Nullable(Of Double)
    Public Property PCMAnteriorMoedaRefOrigem As Nullable(Of Double)
    Public Property QtdAfetacaoStock As Nullable(Of Double)
    Public Property QtdAfetacaoStock2 As Nullable(Of Double)
    Public Property CodigoTaxaIva As String
    Public Property IDTipoIva As Nullable(Of Long)
    Public Property OperacaoConvUnidStk As String
    Public Property OperacaoConv2UnidStk As String
    Public Property IDTipoPreco As Nullable(Of Long)
    Public Property CodigoTipoPreco As String
    Public Property IDCodigoIva As Nullable(Of Long)
    Public Property CodigoArtigo As String
    Public Property CodigoBarrasArtigo As String
    Public Property CodigoUnidade As String
    Public Property CodigoTipoIva As String
    Public Property CodigoRegiaoIva As String
    Public Property UPCompraMoedaRef As Nullable(Of Double)
    Public Property UltCustosAdicionaisMoedaRef As Nullable(Of Double)
    Public Property UltDescComerciaisMoedaRef As Nullable(Of Double)
    Public Property PercIncidencia As Nullable(Of Double)
    Public Property PercDeducao As Nullable(Of Double)
    Public Property ValorIvaDedutivel As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoMoedaRefOrigem As Nullable(Of Double)
    Public Property CodigoMotivoIsencaoIva As String
    Public Property QuantidadeSatisfeita As Nullable(Of Double)
    Public Property QuantidadeDevolvida As Nullable(Of Double)
    Public Property DocumentoOrigem As String
    Public Property VossoNumeroDocumentoOrigem As String
    Public Property NumeroDocumentoOrigem As Nullable(Of Long)
    Public Property IDTiposDocumentoSeriesOrigem As Nullable(Of Long)
    Public Property Satisfeito As Nullable(Of Boolean)
    Public Property IDArtigoPara As Nullable(Of Long)
    Public Property IDTipoDocumentoOrigemInicial As Nullable(Of Long)
    Public Property IDDocumentoOrigemInicial As Nullable(Of Long)
    Public Property IDLinhaDocumentoOrigemInicial As Nullable(Of Long)
    Public Property DocumentoOrigemInicial As String
    Public Property IDLinhaDocumentoStockInicial As Nullable(Of Long)
    Public Property IDOFArtigo As Nullable(Of Long)
    Public Property QtdStockSatisfeita As Nullable(Of Double)
    Public Property QtdStockDevolvida As Nullable(Of Double)
    Public Property QtdStockAcerto As Nullable(Of Double)
    Public Property QtdStock2Satisfeita As Nullable(Of Double)
    Public Property QtdStock2Devolvida As Nullable(Of Double)
    Public Property QtdStock2Acerto As Nullable(Of Double)
    Public Property IDArtigoPA As Nullable(Of Long)
    Public Property IDLinhaDocumentoStock As Nullable(Of Long)
    Public Property QtdStockReserva As Nullable(Of Double)
    Public Property QtdStockReserva2Uni As Nullable(Of Double)
    Public Property DataEntrega As Nullable(Of Date)
    Public Property ValorDescontoEfetivoSemIva As Nullable(Of Double)
    Public Property PrecoUnitarioEfetivoSemIva As Nullable(Of Double)
    Public Property ValorDescontoLinha As Nullable(Of Double)

    Public Overridable Property tbArmazens As tbArmazens
    Public Overridable Property tbArmazens1 As tbArmazens
    Public Overridable Property tbArmazensLocalizacoes As tbArmazensLocalizacoes
    Public Overridable Property tbArmazensLocalizacoes1 As tbArmazensLocalizacoes
    Public Overridable Property tbArtigos As tbArtigos
    Public Overridable Property tbArtigos1 As tbArtigos
    Public Overridable Property tbArtigos2 As tbArtigos
    Public Overridable Property tbArtigosLotes As tbArtigosLotes
    Public Overridable Property tbArtigosNumerosSeries As tbArtigosNumerosSeries
    Public Overridable Property tbDocumentosComprasLinhas As ICollection(Of tbDocumentosComprasLinhas) = New HashSet(Of tbDocumentosComprasLinhas)
    Public Overridable Property tbDocumentosComprasLinhas1 As ICollection(Of tbDocumentosComprasLinhas) = New HashSet(Of tbDocumentosComprasLinhas)
    Public Overridable Property tbDocumentosStock As tbDocumentosStock
    Public Overridable Property tbTiposDocumento As tbTiposDocumento
    Public Overridable Property tbDocumentosStockLinhas1 As ICollection(Of tbDocumentosStockLinhas) = New HashSet(Of tbDocumentosStockLinhas)
    Public Overridable Property tbDocumentosStockLinhas2 As tbDocumentosStockLinhas
    Public Overridable Property tbDocumentosStockLinhas11 As ICollection(Of tbDocumentosStockLinhas) = New HashSet(Of tbDocumentosStockLinhas)
    Public Overridable Property tbDocumentosStockLinhas3 As tbDocumentosStockLinhas
    Public Overridable Property tbIVA As tbIVA
    Public Overridable Property tbSistemaCodigosIVA As tbSistemaCodigosIVA
    Public Overridable Property tbSistemaEspacoFiscal As tbSistemaEspacoFiscal
    Public Overridable Property tbSistemaRegimeIVA As tbSistemaRegimeIVA
    Public Overridable Property tbSistemaTiposIVA As tbSistemaTiposIVA
    Public Overridable Property tbSistemaTiposPrecos As tbSistemaTiposPrecos
    Public Overridable Property tbTiposDocumento1 As tbTiposDocumento
    Public Overridable Property tbTiposDocumentoSeries As tbTiposDocumentoSeries
    Public Overridable Property tbUnidades As tbUnidades
    Public Overridable Property tbUnidades1 As tbUnidades
    Public Overridable Property tbUnidades2 As tbUnidades
    Public Overridable Property tbDocumentosStockLinhasDimensoes As ICollection(Of tbDocumentosStockLinhasDimensoes) = New HashSet(Of tbDocumentosStockLinhasDimensoes)
    Public Overridable Property tbDocumentosVendasLinhas As ICollection(Of tbDocumentosVendasLinhas) = New HashSet(Of tbDocumentosVendasLinhas)

End Class