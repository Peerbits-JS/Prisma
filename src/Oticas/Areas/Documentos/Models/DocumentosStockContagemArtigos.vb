Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports Oticas

Public Class DocumentosStockContagemArtigos
    Inherits ClsF3MModeloLinhas

    Public Property IDArtigo As Long?
    Public Property IDDocumentoStockContagem As Long?
    Public Property Codigo As String
    Public Property Descricao As String
    Public Property ValorUnitario As Double?
    Public Property IDUnidade As Long?
    Public Property CodigoUnidade As String
    Public Property DescricaoUnidade As String
    Public Property QuantidadeEmStock As Double? = 0
    Public Property QuantidadeContada As Double? = 0
    Public Property Diferenca As Double?
    Public Property IDLote As Long?
    Public Property CodigoLote As String
    Public Property DescricaoLote As String
    Public Property GereLotes As Boolean?

    Public Function MapeiaParaModelo() As tbDocumentosStockContagemLinhas
        Return New tbDocumentosStockContagemLinhas With {
            .ID = ID,
            .IDDocumentoStockContagem = IDDocumentoStockContagem,
            .CodigoArtigo = Codigo,
            .DescricaoArtigo = Descricao,
            .CodigoLote = CodigoLote,
            .CodigoUnidade = CodigoUnidade,
            .DescricaoLote = DescricaoLote,
            .DescricaoUnidade = DescricaoUnidade,
            .IDArtigo = IDArtigo,
            .IDLote = IDLote,
            .IDUnidade = IDUnidade,
            .PrecoUnitario = ValorUnitario,
            .Ordem = Ordem,
            .PVMoedaRef = 0,
            .QuantidadeContada = If(QuantidadeContada, 0),
            .QuantidadeEmStock = If(QuantidadeEmStock, 0),
            .QuantidadeDiferenca = CalculaDiferenca(),
            .DataCriacao = Now(),
            .Sistema = False,
            .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome,
            .DataAlteracao = DataAlteracao,
            .UtilizadorAlteracao = UtilizadorAlteracao
        }
    End Function

    Public Function CalculaDiferenca() As Double
        Return QuantidadeContada.GetValueOrDefault() - QuantidadeEmStock.GetValueOrDefault()
    End Function

    Friend Sub AtualizaQuantidadeEmStock(artigo As DocumentosStockContagemArtigos)
        QuantidadeEmStock = artigo?.QuantidadeEmStock
    End Sub

    Friend Shared Function Criar(stock As tbStockArtigos) As DocumentosStockContagemArtigos
        Return New DocumentosStockContagemArtigos With {
            .IDArtigo = stock.tbArtigos.ID,
            .Codigo = stock.tbArtigos.Codigo,
            .Descricao = stock.tbArtigos.Descricao,
            .ValorUnitario = stock.tbArtigos.Medio,
            .IDLote = stock.tbArtigosLotes?.ID,
            .CodigoLote = stock.tbArtigosLotes?.Codigo,
            .DescricaoLote = stock.tbArtigosLotes?.Descricao,
            .IDUnidade = stock.tbArtigos.tbUnidades?.ID,
            .CodigoUnidade = stock.tbArtigos.tbUnidades?.Codigo,
            .DescricaoUnidade = stock.tbArtigos.tbUnidades?.Descricao,
            .QuantidadeEmStock = stock.QuantidadeStock,
            .Diferenca = .CalculaDiferenca()
        }
    End Function

    Friend Shared Function Criar(artigo As tbArtigos, stock As tbStockArtigos, quantidadeEmStock As Decimal) As DocumentosStockContagemArtigos
        Return New DocumentosStockContagemArtigos With {
            .IDArtigo = artigo.ID,
            .Codigo = artigo.Codigo,
            .Descricao = artigo.Descricao,
            .ValorUnitario = artigo.Medio,
            .IDLote = stock?.tbArtigosLotes?.ID,
            .CodigoLote = If(stock Is Nothing, String.Empty, stock?.tbArtigosLotes?.Codigo),
            .DescricaoLote = If(stock Is Nothing, String.Empty, stock?.tbArtigosLotes?.Descricao),
            .IDUnidade = artigo.tbUnidades?.ID,
            .CodigoUnidade = artigo.tbUnidades?.Codigo,
            .DescricaoUnidade = artigo.tbUnidades?.Descricao,
            .QuantidadeEmStock = quantidadeEmStock,
            .Diferenca = .CalculaDiferenca()
        }
    End Function

    Friend Shared Function Criar(linha As tbDocumentosStockContagemLinhas) As DocumentosStockContagemArtigos
        Return New DocumentosStockContagemArtigos With {
            .ID = linha.ID,
            .IDDocumentoStockContagem = linha.IDDocumentoStockContagem,
            .IDArtigo = linha.IDArtigo,
            .Codigo = linha.CodigoArtigo,
            .Descricao = linha.DescricaoArtigo,
            .ValorUnitario = linha.PrecoUnitario,
            .IDLote = linha.IDLote,
            .CodigoLote = linha.CodigoLote,
            .DescricaoLote = linha.DescricaoLote,
            .IDUnidade = linha.IDUnidade,
            .CodigoUnidade = linha.CodigoUnidade,
            .DescricaoUnidade = linha.DescricaoUnidade,
            .QuantidadeEmStock = linha.QuantidadeEmStock,
            .Diferenca = linha.QuantidadeDiferenca,
            .QuantidadeContada = linha.QuantidadeContada
        }
    End Function
End Class
