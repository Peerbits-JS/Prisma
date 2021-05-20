Imports System.Data.Entity
Imports System.Data.SqlClient
Imports System.Data.Entity.Infrastructure
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Dapper
Imports F3M
Imports Kendo.Mvc

Namespace Repositorio.Artigos
    Public Class RepositorioArtigos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigos, Oticas.Artigos)

        Structure Classificacao
            Const Aros = "AR"
            Const OculosSol = "OS"
            Const LentesContato = "LC"
            Const LentesOftalmicas = "LO"
            Const Diversos = "DV"
        End Structure

        Const SiglaPais_Default As String = "PT"

        Public Function ObtemArtigosParaContagem(filtro As DocumentosStockContagemFiltro) As List(Of DocumentosStockContagemArtigos)
            If (IsNothing(filtro.IDMarca)) Then filtro.IDMarca = New List(Of Long)
            If (IsNothing(filtro.IDTipoArtigo)) Then filtro.IDTipoArtigo = New List(Of Long)

            Dim query = BDContexto.tbArtigos.
                Include(Function(artigo) artigo.tbCCStockArtigos).
                Include(Function(artigo) artigo.tbUnidades).
                Include(Function(artigo) artigo.tbArtigosLotes).
                Include(Function(artigo) artigo.tbStockArtigos).
                Where(Function(artigo) If(filtro.IDTipoArtigo.Any(), filtro.IDTipoArtigo.Contains(artigo.IDTipoArtigo), True)).
                Where(Function(artigo) If(filtro.IDMarca.Any(), filtro.IDMarca.Contains(artigo.IDMarca), True)).
                Where(Function(artigo) If(filtro.Inativos, True, artigo.Ativo.Equals(True))).
                Where(Function(artigo) If(filtro.NaoMovimentados, True, artigo.tbCCStockArtigos.Any())).
                ToList()


            Dim resultado As New List(Of DocumentosStockContagemArtigos)

            For Each artigo In query
                Dim stock = ObtemStockDoArtigoPorFiltro(artigo, filtro)
                Dim quantidadeEmStock As Decimal = ObtemQuantidadeContaCorrenteDoArtigoPorFiltro(artigo, filtro)

                If quantidadeEmStock <> 0 Then
                    resultado.Add(DocumentosStockContagemArtigos.Criar(artigo, stock, quantidadeEmStock))
                End If
            Next

            Return resultado
        End Function

        Private Function ObtemStockDoArtigoPorFiltro(artigo As tbArtigos, filtro As DocumentosStockContagemFiltro)
            Dim comparaArmazem As Func(Of tbStockArtigos, Boolean) =
                Function(stock) As Boolean
                    Return If(filtro.IDArmazem Is Nothing OrElse filtro.IDArmazem <= 0, True, stock.IDArmazem IsNot Nothing AndAlso stock.IDArmazem = filtro.IDArmazem)
                End Function

            Dim comparaLocalizacao As Func(Of tbStockArtigos, Boolean) =
                Function(stock) As Boolean
                    If filtro.IDLocalizacao Is Nothing OrElse filtro.IDLocalizacao <= 0 Then
                        Return True
                    End If

                    Return stock.tbArtigos.tbCCStockArtigos _
                        .Any(Function(stockArtigo) stockArtigo.IDArmazemLocalizacao IsNot Nothing AndAlso stockArtigo.IDArmazemLocalizacao = filtro.IDLocalizacao)
                End Function

            Return artigo.tbStockArtigos.
                Where(comparaArmazem).
                Where(comparaLocalizacao).
                FirstOrDefault()
        End Function

        Private Function ObtemQuantidadeContaCorrenteDoArtigoPorFiltro(artigo As tbArtigos, filtro As DocumentosStockContagemFiltro)
            Dim comparaDataStock As Func(Of tbCCStockArtigos, Boolean) = Function(item) As Boolean
                                                                             If (filtro.DataDocumento Is Nothing) Then
                                                                                 Return True
                                                                             End If
                                                                             Return item.DataDocumento.Value.Date <= filtro.DataDocumento.Value.Date
                                                                         End Function

            Dim contaCorrente = artigo.tbCCStockArtigos.Where(comparaDataStock).Where(Function(x) x.IDArmazemLocalizacao IsNot Nothing AndAlso x.IDArmazemLocalizacao = filtro.IDLocalizacao)

            Dim quantidade = 0

            For Each item In contaCorrente
                If (item.Natureza = "E") Then
                    quantidade = quantidade + item.Quantidade.GetValueOrDefault()
                Else
                    quantidade = quantidade - item.Quantidade.GetValueOrDefault()
                End If
            Next

            Return quantidade
        End Function

        Friend Function ObtemArtigos(artigosId As IEnumerable(Of Long?), filtro As DocumentosStockContagemFiltro) As List(Of DocumentosStockContagemArtigos)
            If (IsNothing(filtro.IDMarca)) Then filtro.IDMarca = New List(Of Long)
            If (IsNothing(filtro.IDTipoArtigo)) Then filtro.IDTipoArtigo = New List(Of Long)

            Dim query = BDContexto.tbArtigos.
                Include(Function(artigo) artigo.tbCCStockArtigos).
                Include(Function(artigo) artigo.tbUnidades).
                Include(Function(artigo) artigo.tbArtigosLotes).
                Include(Function(artigo) artigo.tbStockArtigos).
                Where(Function(artigo) If(filtro.IDTipoArtigo.Any(), filtro.IDTipoArtigo.Contains(artigo.IDTipoArtigo), True)).
                Where(Function(artigo) If(filtro.IDMarca.Any(), filtro.IDMarca.Contains(artigo.IDMarca), True)).
                Where(Function(artigo) If(filtro.Inativos, True, artigo.Ativo.Equals(True))).
                Where(Function(artigo) If(filtro.NaoMovimentados, True, artigo.tbCCStockArtigos.Any())).
                Where(Function(artigo) artigosId.Contains(artigo.ID)).
                ToList()


            Dim resultado As New List(Of DocumentosStockContagemArtigos)

            For Each artigo In query
                Dim stock = ObtemStockDoArtigoPorFiltro(artigo, filtro)
                Dim quantidadeEmStock = ObtemQuantidadeContaCorrenteDoArtigoPorFiltro(artigo, filtro)

                resultado.Add(DocumentosStockContagemArtigos.Criar(artigo, stock, quantidadeEmStock))
            Next

            Return resultado
        End Function

        Friend Function ObterArtigosDeImportacaoDaContagemDeEstoque(artigosContagemImportacao As List(Of DocumentosStockContagemArtigoImportacao), filtro As DocumentosStockContagemFiltro)
            Dim strTipoArtigo As String = "@tiposartigo"
            Dim strTipoMarca As String = "@tiposmarca"

            If (IsNothing(filtro.IDMarca)) Then
                filtro.IDMarca = New List(Of Long)
            Else
                strTipoMarca = "''' + " & strTipoMarca & " + '''"
            End If

            If (IsNothing(filtro.IDTipoArtigo)) Then
                filtro.IDTipoArtigo = New List(Of Long)
            Else
                strTipoArtigo = "''' + " & strTipoArtigo & " + '''"
            End If

            Dim lotesImportacao = artigosContagemImportacao.Where(Function(x) String.IsNullOrWhiteSpace(x.Lote) = False).Select(Function(x) x.Lote)
            Dim codigosImportacao = artigosContagemImportacao.Select(Function(x) x.Codigo)

            Dim artigos As New List(Of tbArtigos)

            Using conexao = BDContexto.Database.Connection
                conexao.Open()

                Using trans = conexao.BeginTransaction(IsolationLevel.RepeatableRead)
                    Dim tblName As String = ClsBaseDadosTabelasTemp.Cria_Insere_RetornaNomeTbl(Of BD.Dinamica.Aplicacao, DocumentosStockContagemArtigoImportacao)(artigosContagemImportacao, RetornaColunasTabelaTemp())

                    Dim query = String.Format("SELECT   a.[id], 
                                                        a.[codigo], 
                                                        a.[descricao], 
                                                        a.[medio], 
                                                        a.[codigobarras],
                                                        al.[id], 
                                                        al.[codigo], 
                                                        al.[descricao], 
                                                        u.[id], 
                                                        u.[codigo], 
                                                        u.[descricao], 
                                                        sa.[id], 
                                                        sa.[idarmazem], 
                                                        sa.[quantidade], 
                                                        af.*, 
                                                        cc.* 
                                                FROM   [dbo].[tbartigos] a 
                                                        LEFT JOIN [dbo].[tbartigoslotes] al 
                                                                ON al.[idartigo] = a.[id] 
                                                        INNER JOIN [dbo].[tbunidades] u 
                                                                ON a.[idunidade] = u.[id] 
                                                        LEFT JOIN [dbo].[tbstockartigos] sa 
                                                                ON sa.idartigo = a.id 
                                                        LEFT JOIN [dbo].[tbartigosfornecedores] af 
                                                                ON af.[idartigo] = a.[id] 
                                                        LEFT JOIN [dbo].[tbccstockartigos] cc 
                                                                ON cc.[idartigo] = a.[id] 
                                                        INNER JOIN 
                                                        {0} tmp 
                                                                ON a.[codigo] COLLATE DATABASE_DEFAULT = tmp.[codigo] COLLATE DATABASE_DEFAULT
                                                                    OR a.[codigobarras] COLLATE DATABASE_DEFAULT = tmp.[codigo] COLLATE DATABASE_DEFAULT
                                                                    OR af.[codigobarras] COLLATE DATABASE_DEFAULT = tmp.[codigo] COLLATE DATABASE_DEFAULT
                                                WHERE  ( " & strTipoArtigo & " IS NOT NULL 
                                                            AND a.idtipoartigo IN @tiposartigo 
                                                            OR " & strTipoArtigo & " IS NULL) 
                                                        AND ( " & strTipoMarca & " IS NOT NULL 
                                                                AND a.idmarca IN @tiposmarca 
                                                                OR " & strTipoMarca & " IS NULL) 
                                                        AND (@inativos <> 0 
                                                                AND a.ativo = @inativos 
                                                                OR @inativos = 0) 
                                                        AND (@naomovimentados <> 0 
                                                                AND cc.id IS NOT NULL 
                                                                OR @naomovimentados = 0)
                                                        AND (a.[gerelotes] = 1 
                                                                AND al.[codigo] COLLATE DATABASE_DEFAULT = tmp.[lote] COLLATE DATABASE_DEFAULT
                                                                OR a.[gerelotes] = 0)", tblName)


                    conexao.Query(Of tbArtigos, tbArtigosLotes, tbUnidades, tbStockArtigos, tbArtigosFornecedores, tbCCStockArtigos, tbArtigos)(query, Function(artigo, lote, unidade, stock, fornecedor, contacorrente)

                                                                                                                                                           Dim artigoExistente = artigos.FirstOrDefault(Function(x) x.ID = artigo.ID Or x.tbArtigosLotes.Any(Function(y) y.ID = lote?.ID))

                                                                                                                                                           If (artigoExistente Is Nothing) Then
                                                                                                                                                               If (contacorrente IsNot Nothing) Then
                                                                                                                                                                   artigo.tbCCStockArtigos.Add(contacorrente)
                                                                                                                                                               End If

                                                                                                                                                               If (stock IsNot Nothing) Then
                                                                                                                                                                   stock.tbArtigos = artigo
                                                                                                                                                                   artigo.tbStockArtigos.Add(stock)
                                                                                                                                                               End If

                                                                                                                                                               If (fornecedor IsNot Nothing) Then
                                                                                                                                                                   artigo.tbArtigosFornecedores.Add(fornecedor)
                                                                                                                                                               End If

                                                                                                                                                               If (lote IsNot Nothing) Then
                                                                                                                                                                   artigo.tbArtigosLotes.Add(lote)
                                                                                                                                                               End If

                                                                                                                                                               artigo.tbUnidades = unidade
                                                                                                                                                               artigos.Add(artigo)

                                                                                                                                                           Else
                                                                                                                                                               If (contacorrente IsNot Nothing AndAlso artigoExistente.tbCCStockArtigos.All(Function(x) x.ID <> contacorrente.ID)) Then
                                                                                                                                                                   artigoExistente.tbCCStockArtigos.Add(contacorrente)
                                                                                                                                                               End If

                                                                                                                                                               If (stock IsNot Nothing AndAlso artigoExistente.tbStockArtigos.All(Function(x) x.ID <> stock.ID)) Then
                                                                                                                                                                   stock.tbArtigos = artigoExistente
                                                                                                                                                                   artigoExistente.tbStockArtigos.Add(stock)
                                                                                                                                                               End If

                                                                                                                                                               If (fornecedor IsNot Nothing AndAlso artigoExistente.tbArtigosFornecedores.All(Function(x) x.ID <> fornecedor.ID)) Then
                                                                                                                                                                   artigoExistente.tbArtigosFornecedores.Add(fornecedor)
                                                                                                                                                               End If

                                                                                                                                                               If (lote IsNot Nothing AndAlso artigoExistente.tbArtigosLotes.All(Function(x) x.ID <> lote.ID)) Then
                                                                                                                                                                   artigoExistente.tbArtigosLotes.Add(lote)
                                                                                                                                                               End If
                                                                                                                                                           End If
                                                                                                                                                           Return artigo
                                                                                                                                                       End Function, New With {
                                                                                                                    .TiposArtigo = If(filtro.IDTipoArtigo.Any(), filtro.IDTipoArtigo, Nothing),
                                                                                                                    .TiposMarca = If(filtro.IDMarca.Any(), filtro.IDMarca, Nothing),
                                                                                                                    .Inativos = If(filtro.Inativos, Nothing, True),
                                                                                                                    .NaoMovimentados = If(filtro.NaoMovimentados, Nothing, True),
                                                                                                                    .Lotes = If(lotesImportacao.Any(), lotesImportacao, Nothing)
                                                                                                                 }, trans)
                End Using
            End Using

            Dim resultado As New List(Of DocumentosStockContagemArtigos)


            For Each artigo In artigos
                Dim stock = ObtemStockDoArtigoPorFiltro(artigo, filtro)
                Dim quantidadeEmStock As Decimal = ObtemQuantidadeContaCorrenteDoArtigoPorFiltro(artigo, filtro)
                Dim artigosImportados = artigosContagemImportacao.Where(Function(f) f.Codigo = artigo.Codigo Or
                                                            f.Codigo = artigo.CodigoBarras Or
                                                            artigo.tbArtigosFornecedores?.Any(Function(fornecedor) fornecedor.CodigoBarras = f.Codigo))

                For Each artigoImportado In artigosImportados
                    Dim contagemArtigo = DocumentosStockContagemArtigos.Criar(artigo, stock, quantidadeEmStock)
                    contagemArtigo.QuantidadeContada = artigoImportado.Quantidade
                    contagemArtigo.Diferenca = contagemArtigo.CalculaDiferenca()
                    resultado.Add(contagemArtigo)
                Next
            Next

            Dim quantidadeNaoImportados = 0
            If (artigosContagemImportacao.Count() > resultado.Count()) Then
                quantidadeNaoImportados = artigosContagemImportacao.Count() - resultado.Count()
            End If

            Return New DocumentosStockContagemImportacaoResultado With {
                .artigos = resultado,
                .QuantidadeDeNaoImportados = quantidadeNaoImportados
            }
        End Function

        Friend Function ValidaSeArtigoExisteParaContagem(iDArtigo As Long, filtro As DocumentosStockContagemFiltro)
            Dim comparaDataStock As Func(Of tbStockArtigos, Boolean) = Function(stock) As Boolean
                                                                           If (filtro.DataDocumento Is Nothing) Then
                                                                               Return True
                                                                           End If
                                                                           Return stock.tbArtigos.tbCCStockArtigos.Any(Function(ccStockArtigo) ccStockArtigo.DataDocumento <= filtro.DataDocumento)
                                                                       End Function

            Dim comparaArmazem As Func(Of tbStockArtigos, Boolean) = Function(stock) As Boolean
                                                                         If (filtro.IDArmazem Is Nothing Or filtro.IDArmazem <= 0) Then
                                                                             Return True
                                                                         End If
                                                                         Return stock.IDArmazem = filtro.IDArmazem
                                                                     End Function

            Dim comparaLocalizacao As Func(Of tbStockArtigos, Boolean) = Function(stock) As Boolean
                                                                             If (filtro.IDLocalizacao Is Nothing Or filtro.IDLocalizacao <= 0) Then
                                                                                 Return True
                                                                             End If
                                                                             Return stock.tbArtigos.tbCCStockArtigos.Any(Function(ccStockArtigo) ccStockArtigo.IDArmazemLocalizacao = filtro.IDLocalizacao)
                                                                         End Function



            Dim artigo = BDContexto.tbArtigos.
                Include(Function(x) x.tbCCStockArtigos).
                Include(Function(x) x.tbUnidades).
                Include(Function(x) x.tbArtigosLotes).
                Include(Function(x) x.tbStockArtigos).
                Where(Function(x) If(filtro.IDTipoArtigo.Any(), filtro.IDTipoArtigo.Contains(x.IDTipoArtigo), True)).
                Where(Function(x) If(filtro.IDMarca.Any(), filtro.IDMarca.Contains(x.IDMarca), True)).
                Where(Function(x) If(filtro.NaoMovimentados, True, x.tbCCStockArtigos.Any())).
                Where(Function(x) x.ID = iDArtigo).FirstOrDefault()

            Dim artigoValido = If(artigo IsNot Nothing, True, False)
            Dim quantidadeEmStock = If(artigoValido, ObtemQuantidadeContaCorrenteDoArtigoPorFiltro(artigo, filtro), 0)

            Dim artigores As Object = Nothing
            Dim artigolotesres As Object = Nothing

            If artigoValido Then
                artigores = New With {.ID = artigo.ID, .Codigo = artigo.Codigo, .Descricao = artigo.Descricao,
                    .IDUnidade = artigo.IDUnidade, .CodigoUnidade = artigo.tbUnidades.Codigo, .DescricaoUnidade = artigo.tbUnidades.Descricao,
                    .GereLotes = artigo.GereLotes, .nLotes = artigo.tbArtigosLotes?.Count,
                    .Medio = artigo.Medio}

                If artigo?.tbArtigosLotes.Count Then
                    Dim dbSetArtigosLotes As tbArtigosLotes = artigo.tbArtigosLotes.FirstOrDefault
                    artigolotesres = New With {.ID = dbSetArtigosLotes.ID, .Codigo = dbSetArtigosLotes.Codigo, .Descricao = dbSetArtigosLotes.Descricao}
                End If
            End If

            Return New With {artigoValido, quantidadeEmStock, artigores, artigolotesres}
        End Function

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigos)) As IQueryable(Of Oticas.Artigos)
            Dim lstArtigos As List(Of Oticas.Artigos) = query.Select(Function(f) New Oticas.Artigos With {
            .ID = f.ID, .Codigo = f.Codigo, .Ativo = f.Ativo, .Descricao = f.Descricao, .DescricaoAbreviada = f.DescricaoAbreviada,
            .IDFamilia = f.IDFamilia, .DescricaoFamilia = f.tbFamilias.Descricao,
            .IDSubFamilia = f.IDSubFamilia, .DescricaoSubFamilia = f.tbSubFamilias.Descricao,
            .IDTipoArtigo = f.IDTipoArtigo, .DescricaoTipoArtigo = f.tbTiposArtigos.Descricao,
            .IDComposicao = f.IDComposicao, .DescricaoComposicao = f.tbComposicoes.Descricao,
            .IDTipoComposicao = f.IDTipoComposicao, .DescricaoTipoComposicao = f.tbSistemaTiposComposicoes.Descricao,
            .IDGrupoArtigo = f.IDGrupoArtigo, .DescricaoGrupoArtigo = f.tbGruposArtigo.Descricao,
            .IDMarca = f.IDMarca, .DescricaoMarca = f.tbMarcas.Descricao,
            .CodigoBarras = f.CodigoBarras, .QRCode = f.QRCode, .Observacoes = f.Observacoes, .GereLotes = f.GereLotes,
            .GereStock = f.GereStock, .GereNumeroSerie = f.GereNumeroSerie, .DescricaoVariavel = f.DescricaoVariavel,
            .IDTipoDimensao = f.IDTipoDimensao, .DescricaoTipoDimensao = f.tbSistemaTiposDimensoes.Descricao,
            .IDDimensaoPrimeira = f.IDDimensaoPrimeira, .DescricaoDimensaoPrimeira = f.tbDimensoes.Descricao,
            .IDDimensaoSegunda = f.IDDimensaoSegunda, .DescricaoDimensaoSegunda = f.tbDimensoes1.Descricao,
            .IDOrdemLoteApresentar = f.IDOrdemLoteApresentar,
            .IDUnidade = f.IDUnidade, .DescricaoUnidade = f.tbUnidades.Descricao,
            .IDUnidadeVenda = f.IDUnidadeVenda, .DescricaoUnidadeVenda = f.tbUnidades2.Descricao,
            .IDUnidadeCompra = f.IDUnidadeCompra, .DescricaoUnidadeCompra = f.tbUnidades1.Descricao,
            .IDEstacao = f.IDEstacao, .DescricaoEstacao = f.tbEstacoes.Descricao,
            .VariavelContabilidade = f.VariavelContabilidade, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao,
            .UtilizadorCriacao = f.UtilizadorCriacao, .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
            .F3MMarcador = f.F3MMarcador, .NE = f.NE, .DTEX = f.DTEX, .CodigoEstatistico = f.CodigoEstatistico,
            .LimiteMax = f.LimiteMax, .LimiteMin = f.LimiteMin, .Reposicao = f.Reposicao,
            .CodigoSistemaTipoArtigo = f.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo,
            .CodigoSistemaTipoDim = f.tbSistemaTiposDimensoes.Codigo, .PrimeiraEntrada = f.tbArtigosStock.FirstOrDefault().PrimeiraEntrada,
            .PrimeiraSaida = f.tbArtigosStock.FirstOrDefault().PrimeiraSaida, .UltimaEntrada = f.tbArtigosStock.FirstOrDefault().UltimaEntrada,
            .UltimaSaida = f.tbArtigosStock.FirstOrDefault().UltimaSaida, .Atual = f.tbArtigosStock.FirstOrDefault().Atual,
            .StockAtual2 = f.tbArtigosStock.FirstOrDefault.StockAtual2,
            .Reservado = f.tbArtigosStock.FirstOrDefault().Reservado, .Reservado2 = f.tbArtigosStock.FirstOrDefault.Reservado2,
            .IDOrdemLoteMovEntrada = f.IDOrdemLoteMovEntrada, .DescricaoOrdemLoteMovEntrada = f.tbSistemaOrdemLotes1.Descricao,
            .IDOrdemLoteMovSaida = f.IDOrdemLoteMovSaida, .DescricaoOrdemLoteMovSaida = f.tbSistemaOrdemLotes2.Descricao,
            .IDTaxa = f.IDTaxa, .DescricaoTaxa = f.tbIVA.Descricao, .DedutivelPercentagem = f.DedutivelPercentagem,
            .IncidenciaPercentagem = f.IncidenciaPercentagem, .UltimoPrecoCusto = f.UltimoPrecoCusto,
            .Medio = f.Medio, .Padrao = f.Padrao, .UltimosCustosAdicionais = f.UltimosCustosAdicionais,
            .UltimosDescontosComerciais = f.UltimosDescontosComerciais, .UltimoPrecoCompra = f.UltimoPrecoCompra,
            .CasasDecimaisUnidadeStock = f.tbUnidades.NumeroDeCasasDecimais,
            .CodigoUnidade = f.tbUnidades.Codigo, .Inventariado = f.Inventariado,
            .IDTiposComponente = f.IDTiposComponente, .DescricaoTiposComponente = f.tbSistemaTiposComponente.Descricao,
            .IDCompostoTransformacaoMetodoCusto = f.IDCompostoTransformacaoMetodoCusto, .DescricaoCompostoTransformacaoMetodoCusto = f.tbSistemaCompostoTransformacaoMetodoCusto.Descricao,
            .IDImpostoSelo = f.IDImpostoSelo, .DescricaoImpostoSelo = f.tbImpostoSelo.Descricao,
            .StockDisponivel = (If(f.tbArtigosStock.FirstOrDefault.Atual IsNot Nothing, f.tbArtigosStock.FirstOrDefault.Atual, 0) - If(f.tbArtigosStock.FirstOrDefault.Reservado IsNot Nothing, f.tbArtigosStock.FirstOrDefault.Reservado, 0)),
            .StockDisponivel2 = (If(f.tbArtigosStock.FirstOrDefault.StockAtual2 IsNot Nothing, f.tbArtigosStock.FirstOrDefault.StockAtual2, 0) - If(f.tbArtigosStock.FirstOrDefault.Reservado2 IsNot Nothing, f.tbArtigosStock.FirstOrDefault.Reservado2, 0)),
            .FatorFTOFPercentagem = f.FatorFTOFPercentagem, .ValorComIva = If(Not f.tbArtigosPrecos.FirstOrDefault() Is Nothing, f.tbArtigosPrecos.FirstOrDefault().ValorComIva, 0),
            .Foto = f.Foto, .FotoCaminho = f.FotoCaminho, .FotoAnterior = f.Foto, .FotoCaminhoAnterior = f.FotoCaminho, .IDSistemaClassificacao = f.tbTiposArtigos.IDSistemaClassificacao,
            .DescricaoSistemaClassificacao = f.tbSistemaClassificacoesTiposArtigos.Descricao,
            .StockReqPendente = If(f.tbArtigosStock.FirstOrDefault.StockReqPendente IsNot Nothing, f.tbArtigosStock.FirstOrDefault.StockReqPendente, 0),
             .Taxa = f.tbIVA.Taxa}).ToList()
            'Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
            For Each lin In lstArtigos
                Dim CodigoClassificacaoTipoArtigo As String = GetCodigoClassificacaoTipoArtigo(lin.IDTipoArtigo)

                If Not String.IsNullOrEmpty(CodigoClassificacaoTipoArtigo) Then

                    Select Case CodigoClassificacaoTipoArtigo
                        Case Classificacao.LentesOftalmicas 'LO
                            Dim tLO As ArtigosLentesOftalmicas = (From x In BDContexto.tbLentesOftalmicas
                                                                  Where x.IDArtigo = lin.ID
                                                                  Select New ArtigosLentesOftalmicas With {.ID = x.ID, .Diametro = x.Diametro, .PotenciaEsferica = x.PotenciaEsferica, .PotenciaCilindrica = x.PotenciaCilindrica, .PotenciaPrismatica = x.PotenciaPrismatica, .Adicao = x.Adicao,
                                                                                                           .IDTratamentoLente = x.IDTratamentoLente, .IDCorLente = x.IDCorLente, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao,
                                                                                                           .IDTipoLente = x.tbModelos.IDTipoLente, .IdMateriaLente = x.tbModelos.IDMateriaLente}).FirstOrDefault()

                            If Not tLO Is Nothing Then
                                With lin
                                    .IDMateriaLente = tLO.IdMateriaLente
                                    .IDTipoLente = tLO.IDTipoLente
                                    .IDModelo = tLO.IDModelo
                                    .Diametro = tLO.Diametro
                                    .IDTratamentoLente = tLO.IDTratamentoLente
                                    .IDCorLente = tLO.IDCorLente
                                    .DescricaoModelo = tLO.DescricaoModelo
                                    .PotenciaEsferica = tLO.PotenciaEsferica
                                    .PotenciaCilindrica = tLO.PotenciaCilindrica
                                    .PotenciaPrismatica = tLO.PotenciaPrismatica
                                    .Adicao = tLO.Adicao
                                End With
                            End If

                        Case Classificacao.Aros
                            Dim tAro As ArtigosAros = (From x In BDContexto.tbAros
                                                       Where x.IDArtigo = lin.ID
                                                       Select New ArtigosAros With {.ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao, .Tamanho = x.Tamanho, .CodigoCor = x.CodigoCor, .CorGenerica = x.CorGenerica, .CorLente = x.CorLente, .Hastes = x.Hastes}).FirstOrDefault()

                            If Not tAro Is Nothing Then
                                With lin
                                    .IDModelo = tAro.IDModelo
                                    .DescricaoModelo = tAro.DescricaoModelo
                                    .Tamanho = tAro.Tamanho
                                    .Hastes = tAro.Hastes
                                    .CodigoCor = tAro.CodigoCor
                                    .CorLente = tAro.CorLente
                                    .CorGenerica = tAro.CorGenerica
                                End With
                            End If

                        Case Classificacao.LentesContato
                            Dim tLC As ArtigosLentesContato = (From x In BDContexto.tbLentesContato
                                                               Where x.IDArtigo = lin.ID
                                                               Select New ArtigosLentesContato With {.ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao,
                                                                                                     .PotenciaEsferica = x.PotenciaEsferica, .PotenciaCilindrica = x.PotenciaCilindrica, .Raio = x.Raio, .Adicao = x.Adicao,
                                                                                                     .Diametro = x.Diametro, .IDTipoLente = x.tbModelos.IDTipoLente}).FirstOrDefault()

                            If Not tLC Is Nothing Then
                                With lin
                                    .IDTipoLente = tLC.IDTipoLente
                                    .IDModelo = tLC.IDModelo
                                    .Diametro = tLC.Diametro
                                    .DescricaoModelo = tLC.DescricaoModelo
                                    .PotenciaEsferica = tLC.PotenciaEsferica
                                    .PotenciaCilindrica = tLC.PotenciaCilindrica
                                    .Adicao = tLC.Adicao
                                    .Raio = tLC.Raio
                                End With
                            End If

                        Case Classificacao.OculosSol
                            Dim tOS As ArtigosOculosSol = (From x In BDContexto.tbOculosSol
                                                           Where x.IDArtigo = lin.ID
                                                           Select New ArtigosOculosSol With {.ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao, .Tamanho = x.Tamanho, .CodigoCor = x.CodigoCor, .CorGenerica = x.CorGenerica, .CorLente = x.CorLente, .Hastes = x.Hastes}).FirstOrDefault()

                            If Not tOS Is Nothing Then
                                With lin
                                    .IDModelo = tOS.IDModelo
                                    .DescricaoModelo = tOS.DescricaoModelo
                                    .Tamanho = tOS.Tamanho
                                    .Hastes = tOS.Hastes
                                    .CodigoCor = tOS.CodigoCor
                                    .CorLente = tOS.CorLente
                                    .CorGenerica = tOS.CorGenerica
                                End With
                            End If
                    End Select
                End If
            Next

            Return lstArtigos.AsQueryable()
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigos)) As IQueryable(Of Oticas.Artigos)
            Dim newQuery As List(Of Oticas.Artigos) = query.Select(Function(e) New Oticas.Artigos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .IDTipoArtigo = e.IDTipoArtigo,
                .IDUnidade = e.tbUnidades.ID, .CodigoUnidade = e.tbUnidades.Codigo, .IDMarca = e.IDMarca,
                .CodigoSistemaTipoDim = e.tbSistemaTiposDimensoes.Codigo, .UltimoPrecoCusto = e.UltimoPrecoCusto,
                .IDTipoDimensao = e.IDTipoDimensao, .DescricaoTipoDimensao = e.tbSistemaTiposDimensoes.Descricao,
                .IDDimensaoPrimeira = e.IDDimensaoPrimeira, .DescricaoDimensaoPrimeira = e.tbDimensoes.Descricao,
                .IDDimensaoSegunda = e.IDDimensaoSegunda, .DescricaoDimensaoSegunda = e.tbDimensoes1.Descricao,
                .Medio = e.Medio, .Padrao = e.Padrao, .FatorFTOFPercentagem = e.FatorFTOFPercentagem, .IDTaxa = e.tbIVA.ID,
                .MotivoIsencaoIva = e.tbIVA.Mencao, .CodigoMotivoIsencaoIva = e.tbIVA.tbSistemaCodigosIVA.Codigo, .CodigoArtigo = e.Codigo,
                .CodigoTipoIVA = e.tbIVA.tbSistemaTiposIVA.Codigo, .CodigoIva = e.tbIVA.Codigo,
                .Taxa = e.tbIVA.Taxa, .CasasDecimaisUnidadeStock = e.tbUnidades.NumeroDeCasasDecimais, .CodigoTaxa = e.tbIVA.Codigo, .DescricaoVariavel = e.DescricaoVariavel,
                .CodigoBarrasArtigo = e.CodigoBarras,
                .CodigoBarrasFornecedor = e.CodigoBarrasFornecedor,
                .NumCasasDecUnidade = e.tbUnidades.NumeroDeCasasDecimais,
                .CodigoSistemaTipoIva = e.tbIVA.tbSistemaTiposIVA.Codigo, .Sistema = e.Sistema,
                .DescricaoTaxa = e.tbIVA.Descricao, .MencaoIva = e.tbIVA.Mencao, .IDTipoIva = e.tbIVA.IDTipoIva,
                .NumCasasDec2UnidadeStock = e.tbUnidades3.NumeroDeCasasDecimais,
                .Ativo = e.Ativo, .Foto = e.Foto, .FotoCaminho = e.FotoCaminho,
                .IDOrdemLoteMovEntrada = e.IDOrdemLoteMovEntrada, .DescricaoOrdemLoteMovEntrada = e.tbSistemaOrdemLotes1.Descricao, .CodigoOrdemLoteMovEntrada = e.tbSistemaOrdemLotes1.Codigo,
                .IDOrdemLoteMovSaida = e.IDOrdemLoteMovSaida, .DescricaoOrdemLoteMovSaida = e.tbSistemaOrdemLotes2.Descricao, .CodigoOrdemLoteMovSaida = e.tbSistemaOrdemLotes2.Codigo,
                .DescricaoUnidade = e.tbUnidades.Descricao, .IDLote = If(Not e.tbArtigosLotes.FirstOrDefault Is Nothing, e.tbArtigosLotes.FirstOrDefault.ID, Nothing),
                .CodigoLote = If(Not e.tbArtigosLotes.FirstOrDefault Is Nothing, e.tbArtigosLotes.FirstOrDefault.Codigo, String.Empty),
                .DescricaoLote = If(Not e.tbArtigosLotes.FirstOrDefault Is Nothing, e.tbArtigosLotes.FirstOrDefault.Descricao, String.Empty),
                .IDUnidadeVenda = e.IDUnidadeVenda, .DescricaoUnidadeVenda = e.tbUnidades2.Descricao,
                .IDUnidadeCompra = e.IDUnidadeCompra, .DescricaoUnidadeCompra = e.tbUnidades1.Descricao,
                .CodigoUnidadeCompra = e.tbUnidades1.Codigo,
                .IDUnidadeStock2 = e.IDUnidadeStock2, .CodigoUnidadeStock2 = e.tbUnidades3.Codigo, .DescricaoUnidadeStock2 = e.tbUnidades3.Descricao,
                .IDComposicao = e.IDComposicao, .DescricaoComposicao = e.tbComposicoes.Descricao,
                .CodigoBarras = e.CodigoBarras, .Inventariado = e.Inventariado,
                .DescricaoTipoArtigo = e.tbTiposArtigos.Descricao,
                .UnidStkConvVariavel = e.tbTiposArtigos.StkUnidade1, .Controla2UnidStk = e.tbTiposArtigos.StkUnidade2,
                .IDTipoPreco = e.IDTipoPreco, .DescricaoTipoPreco = e.tbSistemaTiposPrecos.Descricao,
                .GereLotes = e.GereLotes, .GereStock = e.GereStock, .GereNumeroSerie = e.GereNumeroSerie,
                .CodigoSistemaTipoArtigo = e.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo,
                .DescricaoMarca = e.tbMarcas.Descricao}).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo).ToList()

            'HERE PERFORMANCE! EVERYWHERE! PEDIDOS EVERYWHERE! MADE BY MAF! VER SQL PROFILER e NETWORK NA HANDSONTABLE
            If newQuery.Count > 0 Then
                For Each lin In newQuery
                    'count mumero de lotes (contagem de stocks)
                    lin.NLotes = (From x In BDContexto.tbArtigosLotes Where x.IDArtigo = lin.ID).Count

                    Dim CodigoClassificacaoTipoArtigo As String = GetCodigoClassificacaoTipoArtigo(lin.IDTipoArtigo)

                    With lin
                        .ValorComIva = (From x In BDContexto.tbArtigosPrecos Where x.IDArtigo = lin.ID Select x.ValorComIva).DefaultIfEmpty(0).FirstOrDefault()

                        Dim valorComIva2Aux As Double? = (From x In BDContexto.tbArtigosPrecos
                                                          Where x.IDArtigo = lin.ID AndAlso x.tbSistemaCodigosPrecos.Codigo = "PV2"
                                                          Select x.ValorComIva).FirstOrDefault

                        .ValorComIva2 = If(valorComIva2Aux Is Nothing, CDbl(0), valorComIva2Aux)
                        .SiglaPais = SiglaPais_Default
                    End With

                    If Not String.IsNullOrEmpty(CodigoClassificacaoTipoArtigo) Then
                        Select Case CodigoClassificacaoTipoArtigo
                            Case Classificacao.LentesOftalmicas 'LO
                                Dim tLO As ArtigosLentesOftalmicas =
                                    (From x In BDContexto.tbLentesOftalmicas
                                     Where x.IDArtigo = lin.ID
                                     Select New ArtigosLentesOftalmicas With {
                                         .ID = x.ID, .Diametro = x.Diametro,
                                         .IDTratamentoLente = x.IDTratamentoLente,
                                         .DescricaoTratamentoLente = If(Not x.tbTratamentosLentes Is Nothing, x.tbTratamentosLentes.Descricao, String.Empty),
                                         .IDCorLente = x.IDCorLente,
                                         .CodigoCorLente = x.tbCoresLentes.Codigo,
                                         .DescricaoCorLente = If(Not x.tbCoresLentes Is Nothing, x.tbCoresLentes.Descricao, String.Empty),
                                         .IDModelo = x.IDModelo,
                                         .DescricaoModelo = x.tbModelos.Descricao,
                                         .IDTipoLente = x.tbModelos.IDTipoLente,
                                         .IdMateriaLente = x.tbModelos.IDMateriaLente,
                                         .CodigosSuplementos = x.CodigosSuplementos,
                                         .IndiceRefracao = x.tbModelos.IndiceRefracao,
                                         .Fotocromatica = x.tbModelos.Fotocromatica}).FirstOrDefault()


                                If Not tLO Is Nothing Then
                                    With lin
                                        .IDMateriaLente = tLO.IdMateriaLente
                                        .IDTipoLente = tLO.IDTipoLente
                                        .IDModelo = tLO.IDModelo : .DescricaoModelo = tLO.DescricaoModelo
                                        .Diametro = tLO.Diametro
                                        .IDTratamentoLente = tLO.IDTratamentoLente : .DescricaoTratamentoLente = tLO.DescricaoTratamentoLente
                                        .IDCorLente = tLO.IDCorLente : .CodigoCor = tLO.DescricaoCorLente : .DescricaoCorLente = tLO.DescricaoCorLente
                                        .IndiceRefracao = tLO.IndiceRefracao
                                        .Fotocromatica = tLO.Fotocromatica

                                        If Not String.IsNullOrEmpty(tLO.CodigosSuplementos) Then
                                            .IDsSuplementos = tLO.CodigosSuplementos.Split("-").ToList()
                                        End If
                                    End With
                                End If

                            Case Classificacao.Aros
                                Dim tAro As ArtigosAros = (From x In BDContexto.tbAros
                                                           Where x.IDArtigo = lin.ID
                                                           Select New ArtigosAros With {.ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao, .CodigoCor = x.CodigoCor}).FirstOrDefault()

                                If Not tAro Is Nothing Then
                                    With lin
                                        .IDModelo = tAro.IDModelo : .DescricaoModelo = tAro.DescricaoModelo
                                        .CodigoCor = tAro.CodigoCor
                                    End With
                                End If

                            Case Classificacao.LentesContato
                                Dim tLC As ArtigosLentesContato = (From x In BDContexto.tbLentesContato
                                                                   Where x.IDArtigo = lin.ID
                                                                   Select New ArtigosLentesContato With {
                                                                       .ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao, .Diametro = x.Diametro, .IDTipoLente = x.tbModelos.IDTipoLente,
                                                                       .IndiceRefracao = x.tbModelos.IndiceRefracao, .Fotocromatica = x.tbModelos.Fotocromatica}).FirstOrDefault()

                                If Not tLC Is Nothing Then
                                    With lin
                                        .IDTipoLente = tLC.IDTipoLente
                                        .IDModelo = tLC.IDModelo : .DescricaoModelo = tLC.DescricaoModelo
                                        .Diametro = tLC.Diametro
                                        .IndiceRefracao = tLC.IndiceRefracao
                                        .Fotocromatica = tLC.Fotocromatica
                                    End With
                                End If

                            Case Classificacao.OculosSol
                                Dim tOS As ArtigosOculosSol = (From x In BDContexto.tbOculosSol
                                                               Where x.IDArtigo = lin.ID
                                                               Select New ArtigosOculosSol With {.ID = x.ID, .IDModelo = x.IDModelo, .DescricaoModelo = x.tbModelos.Descricao}).FirstOrDefault()

                                If Not tOS Is Nothing Then
                                    With lin
                                        .IDModelo = tOS.IDModelo : .DescricaoModelo = tOS.DescricaoModelo
                                        .CodigoCor = tOS.CodigoCor
                                    End With
                                End If
                        End Select
                    End If
                Next
            End If
            Return newQuery.AsQueryable()
        End Function

        Public Overrides Function GridDataFilters(objFiltro As ClsF3MFiltro) As List(Of IFilterDescriptor)
            Dim IDTipoArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(objFiltro, "IDTipoArtigo", GetType(Long))
            If IDTipoArtigo <> 0 Then
                Dim IDTipoArtigoARO As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "AR" Select x.IDSistemaClassificacao).FirstOrDefault()
                Dim IDTipoArtigoOS As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "OS" Select x.IDSistemaClassificacao).FirstOrDefault()
                Dim IDTipoArtigoDIV As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "DV" Select x.IDSistemaClassificacao).FirstOrDefault()

                If IDTipoArtigo = IDTipoArtigoARO Then
                    Return New List(Of IFilterDescriptor) From {New FilterDescriptor With {
                        .Member = "IDTipoArtigo",
                        .Value = {IDTipoArtigo.ToString(), IDTipoArtigoOS.ToString()},
                        .[Operator] = FilterOperator.IsContainedIn}}

                ElseIf IDTipoArtigo <> IDTipoArtigoDIV Then
                    Return New List(Of IFilterDescriptor) From {New FilterDescriptor With {
                        .Member = "IDTipoArtigo",
                        .Value = IDTipoArtigo}}
                End If
            End If

            Dim IDSistemaClassificacaoArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(objFiltro, "IDSistemaClassificacao", GetType(Long))
            If IDSistemaClassificacaoArtigo <> 0 Then
                Return New List(Of IFilterDescriptor) From {New FilterDescriptor With {
                        .Member = "IDSistemaClassificacao",
                        .Value = IDSistemaClassificacaoArtigo}}
            End If

            Return MyBase.GridDataFilters(objFiltro)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Artigos)
            Dim filtroTxt As String = inFiltro.FiltroTexto

            Dim query As IQueryable(Of Oticas.Artigos) = AplicaQueryListaPersonalizada(inFiltro)

            query = query.Where(Function(f) f.IDLoja IsNot Nothing AndAlso f.IDLoja = ClsF3MSessao.RetornaLojaID)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)

            Return query.OrderBy(Function(f) f.Codigo)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Artigos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigos)
            Dim query As IQueryable(Of tbArtigos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            'FILTRAR APENAS OS QUE NAO SAO DE SISTEMA (INTERNOS)
            'query = query.Where(Function(f) f.Sistema <> True)
            'END

            ' --- GENERICO ---
            '' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    Dim strCodigo As String = ClsUtilitarios.EnvolveSQL(filtroTxt)
            '    Dim strCodigoContem As String = ClsUtilitarios.EnvolveSQL("%" & filtroTxt & "%")
            '    Dim arrIDArtigo As Long() = BDContexto.Database.SqlQuery(Of Long)("select id from tbArtigos where codigo like " & strCodigoContem & " or CodigoBarras=" & strCodigo & " union select id as idartigo from tbArtigosfornecedores where CodigoBarras=" & strCodigo & " or referencia=" & strCodigo).ToArray()
            '    query = query.Where(Function(w) arrIDArtigo.Contains(w.ID))
            'End If

            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Codigo.StartsWith(filtroTxt) Or w.CodigoBarras.Equals(filtroTxt) Or w.tbArtigosFornecedores.Any(Function(e) e.CodigoBarras.Equals(filtroTxt) Or e.Referencia.Equals(filtroTxt)))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim strTipoSistema As List(Of String) = Split(ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoSistemaTipoArtigo", GetType(String)), ", ").ToList

            If strTipoSistema.Count > 0 AndAlso strTipoSistema.Item(0) <> "" Then
                query = query.Where(Function(w) strTipoSistema.Contains(w.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo))
            End If

            Return query.OrderBy(Function(o) o.Descricao)
        End Function

        Protected Function FiltraQueryCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigos)
            Dim query As IQueryable(Of tbArtigos) = tabela.AsNoTracking

            'FILTRAR APENAS OS QUE NAO SAO DE SISTEMA (INTERNOS)
            'query = query.Where(Function(f) f.Sistema <> True)
            'END

            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim IDTipoArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoArtigo", GetType(Long))
            Dim IDTipoServico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoServico", GetType(Long))
            Dim IDTipoOlho As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoOlho", GetType(Long))
            Dim IDSistemaClassificacao As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaClassificacao", GetType(Long))

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    Dim strCodigo As String = ClsUtilitarios.EnvolveSQL(filtroTxt)
            '    Dim strCodigoContem As String = ClsUtilitarios.EnvolveSQL("%" & filtroTxt & "%")
            '    Dim arrIDArtigo As Long() = BDContexto.Database.SqlQuery(Of Long)("select id from tbArtigos where codigo like " & strCodigoContem & " or CodigoBarras=" & strCodigo & " union select id as idartigo from tbArtigosfornecedores where CodigoBarras=" & strCodigo & " or referencia=" & strCodigo).ToArray()
            '    query = query.Where(Function(w) arrIDArtigo.Contains(w.ID))
            'End If

            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Ativo = True AndAlso (w.Codigo.StartsWith(filtroTxt) OrElse w.CodigoBarras.Equals(filtroTxt) OrElse w.tbArtigosFornecedores.Where(Function(e) e.CodigoBarras.Equals(filtroTxt) OrElse e.Referencia.Equals(filtroTxt)).Count > 0))
            End If

            'ESPECIFICO SERVICOS
            If IDTipoArtigo <> 0 Then
                Dim IDTipoArtigoARO As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "AR" Select x.ID).FirstOrDefault()
                Dim IDTipoArtigoOS As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "OS" Select x.ID).FirstOrDefault()
                Dim IDTipoArtigoDIV As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "DV" Select x.ID).FirstOrDefault()
                Dim IDTipoArtigoLO As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "LO" Select x.ID).FirstOrDefault()
                Dim IDTipoArtigoLC As Long = (From x In BDContexto.tbTiposArtigos Where x.Codigo = "LC" Select x.ID).FirstOrDefault()

                If IDTipoArtigo = IDTipoArtigoARO Then
                    query = query.Where(Function(f) f.IDTipoArtigo <> IDTipoArtigoLO AndAlso f.IDTipoArtigo <> IDTipoArtigoLC AndAlso f.IDTipoArtigo <> IDTipoArtigoDIV)

                ElseIf IDTipoArtigo <> IDTipoArtigoDIV Then
                    query = query.Where(Function(f) f.IDTipoArtigo = IDTipoArtigo)

                    Dim CodigoSistemaTipoLente As String = String.Empty

                    Select Case IDTipoServico
                        Case 1, 2, 3, 7 And IDTipoOlho = 2, 8 And IDTipoOlho = 1, 9 And IDTipoOlho = 2, 10 And IDTipoOlho = 1 'UNIFOCAL
                            CodigoSistemaTipoLente = "1"

                        Case 4, 7 And IDTipoOlho = 1, 8 And IDTipoOlho = 2 'BIFOCAL (AMBOS / OD / OE)
                            CodigoSistemaTipoLente = "2"

                        Case 5, 9 And IDTipoOlho = 1, 10 And IDTipoOlho = 2 'PROGRESSIVA (AMBOS / OD / OE)
                            CodigoSistemaTipoLente = "3"
                    End Select

                    If Not String.IsNullOrEmpty(CodigoSistemaTipoLente) Then 'LENTES DE CONTACTO => CodigoSistemaTipoLente = String.Empty
                        query = query.Where(Function(f) f.tbLentesOftalmicas.FirstOrDefault().tbModelos.tbSistemaTiposLentes.Codigo = CodigoSistemaTipoLente)
                    End If

                End If

                Return query.OrderBy(Function(o) o.Codigo)
            End If

            If IDSistemaClassificacao <> 0 Then query = query.Where(Function(w) w.IDSistemaClassificacao = IDSistemaClassificacao)

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            query = query.Where(Function(entity) entity.Ativo)

            Return query.OrderBy(Function(o) o.Codigo)
        End Function

        ' LISTA COMBO
        Public Function ListaComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Artigos)
            Dim Artigos As IQueryable(Of Oticas.Artigos) = ListaCamposCombo(FiltraQueryCodigo(inFiltro))
            If Artigos.Count Then
                Dim lstArtigosIds As Long() = Artigos.Select(Function(artigo) artigo.ID).ToArray()
                Dim lngIDMoeda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMoeda", GetType(Long))
                Dim lngIDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEntidade", GetType(Long))
                Dim strTaxaConversao = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TaxaConversao", GetType(String))
                Dim IDTipoServico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoServico", GetType(Long))

                Dim dblTaxaConversao As Double = 0
                Dim dblValorComIVA As Double? = 0
                Dim lngIDPrecoSugerido As Long
                Dim intNumCasasDecimais As Integer
                Dim lstArtsPrecos = From x In BDContexto.tbArtigosPrecos.Where(Function(w) lstArtigosIds.Any(Function(artigoid) artigoid = w.IDArtigo)).ToList()

                Dim art As Oticas.Artigos = Artigos(0)

                lngIDPrecoSugerido = If(lngIDEntidade = 0, 1, (From x In BDContexto.tbClientes Where x.ID = lngIDEntidade Select x.IDPrecoSugerido).FirstOrDefault())

                intNumCasasDecimais = If(lngIDMoeda = 0, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios, (From x In BDContexto.tbMoedas Where x.ID = lngIDMoeda Select x.CasasDecimaisPrecosUnitarios).FirstOrDefault())

                Dim ln = lstArtsPrecos.Where(Function(x) x.IDArtigo = art.ID And x.IDCodigoPreco = lngIDPrecoSugerido)

                Dim PrecLojaAtual = ln.FirstOrDefault(Function(f) Not f.IDLoja Is Nothing AndAlso f.IDLoja = ClsF3MSessao.RetornaLojaID)
                If PrecLojaAtual Is Nothing Then
                    PrecLojaAtual = ln.FirstOrDefault(Function(f) f.IDLoja Is Nothing)
                End If

                dblValorComIVA = If(PrecLojaAtual IsNot Nothing, PrecLojaAtual.ValorComIva, 0)

                dblTaxaConversao = If(Not IsNumeric(strTaxaConversao), 1, If(strTaxaConversao = 0, 1, strTaxaConversao))

                art.ValorComIva = Math.Round(CDbl(dblValorComIVA) / dblTaxaConversao, intNumCasasDecimais)

                'TODO Validar que se se aplica também aos serviços
                If IDTipoServico = 0 Then
                    If ClsF3MSessao.RetornaParametros.Lojas.ParametroArtigoTipoDescricao = 2 Then
                        intPos = InStr(art.Descricao, "Esf:")
                        If intPos > 0 Then
                            art.Descricao = art.Descricao.Substring(0, intPos - 1)
                        End If
                    End If
                End If

                Dim lnf = BDContexto.tbArtigosFornecedores _
                    .Where(Function(x) x.IDArtigo = art.ID AndAlso x.Ordem = 1) _
                    .Select(Function(s) New With {.CodigoFornecedor = s.tbFornecedores.Codigo, .CodigoBarrasFornecedor = s.CodigoBarras}) _
                    .FirstOrDefault()

                If lnf IsNot Nothing Then
                    art.CodigoFornecedor = lnf.CodigoFornecedor
                    If Not String.IsNullOrEmpty(lnf.CodigoBarrasFornecedor) Then
                        art.CodigoBarrasFornecedor = lnf.CodigoBarrasFornecedor
                    End If
                End If
            End If

            Return Artigos
        End Function

        Public Overrides Function Pesquisa(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Artigos)
            Dim NumRegmaximo As Integer = ParametrosEntidade.NumeroMaximoRegistosPesquisa
            Dim strfiltro As String = ClsUtilitarios.AplicaWildcard(inFiltro.FiltroTexto)

            If Not ClsTexto.ENuloOuVazio(strfiltro) Then
                strfiltro = ClsUtilitarios.TrataTextoQuerySQL(strfiltro)

                Dim queryCount As String = ClsTexto.ConcatenaStrings(New String() {
                    " AND (SELECT COUNT(ID) FROM tbArtigos",
                        " WHERE Codigo LIKE '", strfiltro, "'", " OR Descricao LIKE '", strfiltro, "') <= ", NumRegmaximo})
                Dim strQuery As String = ClsTexto.ConcatenaStrings(New String() {
                    "SELECT TOP ", NumRegmaximo, " ID, Codigo, Descricao",
                        " FROM tbArtigos WHERE (Codigo LIKE '", strfiltro, "'", " OR Descricao LIKE '", strfiltro, "')", queryCount,
                        " ORDER BY Codigo ASC, Descricao ASC"})

                Dim sqlParametroQuery As New SqlParameter() With {
                                                   .ParameterName = "query",
                                                   .Value = strQuery}
                Dim res As DbRawSqlQuery(Of Oticas.Artigos) =
                    BDContexto.Database.SqlQuery(Of Oticas.Artigos)(
                        "EXEC [dbo].[sp_F3M_DaResultadoPesquisa] @query", sqlParametroQuery)
                Dim iQueryArtigos As IQueryable(Of Oticas.Artigos) =
                    res.AsQueryable().Select(Function(row) New Oticas.Artigos() With {
                      .ID = row.ID,
                      .Codigo = row.Codigo,
                      .Descricao = row.Descricao})

                Return iQueryArtigos
            Else
                Return Nothing
            End If
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef inModelo As Oticas.Artigos, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            Dim IDTipo As Long = inModelo.IDTipoArtigo

                            With inModelo
                                If .IDUnidade Is Nothing Then
                                    .IDUnidade = .IDUnidadeStock
                                Else 'Artigo criado de forma automática
                                    .IDUnidadeStock = .IDUnidade
                                    .IDUnidadeCompra = .IDUnidade
                                    .IDUnidadeVenda = .IDUnidade
                                    If .GereLotes Is Nothing Then
                                        .GereLotes = False
                                    End If
                                    If .GereStock Is Nothing Then
                                        .GereStock = True
                                    End If
                                    If .DescricaoVariavel Is Nothing Then
                                        .DescricaoVariavel = False
                                    End If
                                End If

                                .IDSistemaClassificacao = (From x In BDContexto.tbTiposArtigos Where x.ID = IDTipo Select x.IDSistemaClassificacao).FirstOrDefault()
                                If String.IsNullOrEmpty(inModelo.CodigoBarras) Then
                                    .CodigoBarras = AtribuirProximoCodigoBarras(ctx, 6)
                                    If Len(.CodigoBarras) > 6 Then
                                        .CodigoBarras = AtribuirProximoCodigoBarras(ctx, 7)
                                    ElseIf Len(.CodigoBarras) > 7 Then
                                        .CodigoBarras = AtribuirProximoCodigoBarras(ctx, 8)
                                    ElseIf Len(.CodigoBarras) > 8 Then
                                        .CodigoBarras = AtribuirProximoCodigoBarras(ctx, 9)
                                    End If
                                End If
                            End With

                            blnOk = ClsUtilitarios.ContainTrailingSpaces(inModelo.Codigo)
                            If blnOk Then
                                Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.CodigoComEspacos)
                            End If

                            If Not inModelo.Diametro Is Nothing Then
                                Using rm As New TabelasAuxiliares.RepositorioMarcas
                                    Select Case IDTipo
                                        Case 1
                                            If rm.LerIDArtigo("LO", inModelo.IDModelo, , , , , inModelo.IDTratamentoLente, inModelo.IDCorLente, inModelo.CodigosSuplementos, inModelo.Diametro, inModelo.PotenciaEsferica, inModelo.PotenciaCilindrica, inModelo.PotenciaPrismatica, inModelo.Adicao) Then
                                                Throw New Exception("Já existe uma lente oftálmica com as mesmas características (modelo, tratamentos e graduações).")
                                            End If
                                            If inModelo.IDModelo IsNot Nothing AndAlso inModelo.Adicao <> 0 Then
                                                Dim IDModeloLente = inModelo.IDModelo
                                                Dim IDTipoLente = ctx.tbModelos.Where(Function(f) f.ID = IDModeloLente).FirstOrDefault?.IDTipoLente
                                                If IDTipoLente IsNot Nothing AndAlso IDTipoLente = 1 Then ' Unifocal
                                                    inModelo.Adicao = 0
                                                End If
                                            End If
                                        Case 3
                                            If rm.LerIDArtigo("LC", inModelo.IDModelo, , , , , , , , inModelo.Diametro, inModelo.PotenciaEsferica, inModelo.PotenciaCilindrica, inModelo.PotenciaPrismatica, inModelo.Adicao, inModelo.Eixo, inModelo.Raio) Then
                                                Throw New Exception("Já existe uma lente de contacto com as mesmas características (modelo, tratamentos e graduações).")
                                            End If
                                    End Select
                                End Using
                            End If

                            ValidaLinhas(ctx, inModelo, AcoesFormulario.Adicionar)

                            Dim e As tbArtigos = GravaObjContexto(ctx, inModelo, AcoesFormulario.Adicionar)

                            ctx.SaveChanges()
                            ' GRAVA LINHAS
                            GravaLinhasTodas(ctx, inModelo, e, AcoesFormulario.Adicionar)
                            trans.Commit()
                            inModelo.ID = e.ID

                            'Prenche campos do modelo do artigo no modo F4
                            PreencheModeloArtigo(inModelo, e, ctx)

                        Catch ex As Exception
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

        ' PREENCHE NO MODELO DO ARTIGO ADICIONADO OS CAMPOS NECESSARIOS
        Public Sub PreencheModeloArtigo(ByRef o As Oticas.Artigos, e As tbArtigos, ctx As BD.Dinamica.Aplicacao)
            Dim desPrimeira = String.Empty
            Dim desSegunda = String.Empty
            Dim IDTipoDim = e.IDTipoDimensao
            Dim IdPrimeira = ctx.tbArtigos.Where(Function(f) f.ID = e.ID).FirstOrDefault.IDDimensaoPrimeira
            If IdPrimeira <> 0 Then
                desPrimeira = ctx.tbDimensoes.Where(Function(f) f.ID = IdPrimeira).FirstOrDefault.Descricao
            End If
            Dim IdSegunda = ctx.tbArtigos.Where(Function(f) f.ID = e.ID).FirstOrDefault.IDDimensaoSegunda
            If IdSegunda <> 0 Then
                desSegunda = ctx.tbDimensoes.Where(Function(f) f.ID = IdSegunda).FirstOrDefault.Descricao
            End If
            If IDTipoDim = 3 Then
                o.DescricaoTipoDimensao = "Duas"
                o.DescricaoDimensaoPrimeira = desPrimeira
                o.DescricaoDimensaoSegunda = desSegunda
                o.CodigoSistemaTipoDim = 2
            ElseIf IDTipoDim = 2 Then
                o.DescricaoTipoDimensao = "Uma"
                o.DescricaoDimensaoPrimeira = desPrimeira
                o.CodigoSistemaTipoDim = 1
            Else
                o.DescricaoTipoDimensao = "Nenhuma"
                o.DescricaoDimensaoSegunda = desSegunda
                o.CodigoSistemaTipoDim = 0
            End If
            o.FatorFTOFPercentagem = e.FatorFTOFPercentagem
            o.CodigoUnidade = ctx.tbUnidades.Where(Function(f) f.ID = e.IDUnidade).FirstOrDefault.Codigo
            o.CasasDecimaisUnidadeStock = ctx.tbUnidades.Where(Function(f) f.ID = e.IDUnidade).FirstOrDefault.NumeroDeCasasDecimais
        End Sub

        ' REMOVER POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Oticas.Artigos, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Oticas.Artigos, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try

                            Dim blnEmArtigoUso As Boolean = False
                            Dim lngIDArtigo As Long = o.ID
                            Dim tbArtigoAnterior As tbArtigos = ctx.tbArtigos.Find(lngIDArtigo)

                            Using rep As New RepositorioArtigos
                                blnEmArtigoUso = rep.ExistemDocumentosArtigos(lngIDArtigo, Nothing)
                            End Using

                            If blnEmArtigoUso Then
                                DevolveMsgErro(o, tbArtigoAnterior)
                            End If

                            Dim lngID As Long = o.ID
                            Dim blnSistema As Boolean = (From x In ctx.tbArtigos Where x.ID = lngID Select x.Sistema).FirstOrDefault()
                            If blnSistema Then 'se o registo é de sistema não permite alterar a sua informação
                                Throw New Exception(Traducao.EstruturaArtigos.ArtigoSistema)
                            Else

                                blnOk = ClsUtilitarios.ContainTrailingSpaces(o.Codigo)
                                If blnOk Then
                                    Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.CodigoComEspacos)
                                End If

                                ValidaLinhas(ctx, o, AcoesFormulario.Alterar)

                                Dim IDTipo As Long = o.IDTipoArtigo
                                With o
                                    .IDUnidade = .IDUnidadeStock
                                    .IDSistemaClassificacao = (From x In BDContexto.tbTiposArtigos Where x.ID = IDTipo Select x.IDSistemaClassificacao).FirstOrDefault()
                                End With
                                Dim e As tbArtigos = GravaObjContexto(ctx, o, AcoesFormulario.Alterar)

                                ' GRAVA LINHAS
                                GravaLinhasTodas(ctx, o, e, AcoesFormulario.Alterar)
                            End If

                            trans.Commit()
                        Catch
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

        Protected Overrides Sub ValidaLinhas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Oticas.Artigos,
                                             inAcao As AcoesFormulario)
            Try
                Dim IDArt As Long = o.ID
                Dim listAU As List(Of tbUnidadesRelacoes) = inCtx.tbUnidadesRelacoes.ToList


                Dim IDUni As Long = o.IDUnidade
                Dim IDUniCompra As Long = o.IDUnidadeCompra
                Dim IDUniVenda As Long = o.IDUnidadeVenda
                Dim urExisteComp As Boolean = (IDUni = IDUniCompra)
                Dim urExisteVenda As Boolean = (IDUni = IDUniVenda)
                Dim ListaIDS As List(Of Long)

                If o.ArtigosUnidades IsNot Nothing AndAlso o.ArtigosUnidades.Count > 0 Then
                    ListaIDS = o.ArtigosUnidades.Select(Function(r) r.ID).ToList
                Else
                    ListaIDS = New List(Of Long)
                End If

                ' Verifica relacao entre a unidade com unidade compra e a unidade com unidade venda
                If Not urExisteComp AndAlso listAU IsNot Nothing AndAlso listAU.Count > 0 Then
                    urExisteComp = listAU.Exists(Function(f) (f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniCompra) Or
                                                                                (f.IDUnidade = IDUniCompra AndAlso f.IDUnidadeConversao = IDUni))
                End If

                If Not urExisteVenda AndAlso listAU IsNot Nothing AndAlso listAU.Count > 0 Then
                    urExisteVenda = listAU.Exists(Function(f) (f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniVenda) Or
                                                                (f.IDUnidade = IDUniVenda AndAlso f.IDUnidadeConversao = IDUni))
                End If

                If Not urExisteComp Or Not urExisteVenda Then
                    Dim listAU2 As List(Of tbArtigosUnidades) = inCtx.tbArtigosUnidades.Where(Function(f) f.IDArtigo.Equals(IDArt) And Not ListaIDS.Contains(f.ID)).ToList

                    ' Verifica relacao entre a unidade com unidade compra e a unidade com unidade venda
                    If Not urExisteComp Then
                        urExisteComp = listAU2.Exists(Function(f) (f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniCompra) Or
                                                                        (f.IDUnidade = IDUniCompra AndAlso f.IDUnidadeConversao = IDUni))
                    End If

                    If Not urExisteVenda Then
                        urExisteVenda = listAU2.Exists(Function(f) (f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniVenda) Or
                                                                        (f.IDUnidade = IDUniVenda AndAlso f.IDUnidadeConversao = IDUni))
                    End If

                    If Not urExisteComp Or Not urExisteVenda Then
                        If o.ArtigosUnidades IsNot Nothing AndAlso o.ArtigosUnidades.Count > 0 Then
                            ' Verifica relacao entre a unidade com unidade compra e a unidade com unidade venda
                            If Not urExisteComp Then
                                urExisteComp = o.ArtigosUnidades.Exists(Function(f) ((f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniCompra) Or
                                                                                (f.IDUnidade = IDUniCompra AndAlso f.IDUnidadeConversao = IDUni)) And f.AcaoCRUD <> 2)
                            End If

                            If Not urExisteVenda Then
                                urExisteVenda = o.ArtigosUnidades.Exists(Function(f) ((f.IDUnidade = IDUni AndAlso f.IDUnidadeConversao = IDUniVenda) Or
                                                                                (f.IDUnidade = IDUniVenda AndAlso f.IDUnidadeConversao = IDUni)) And f.AcaoCRUD <> 2)
                            End If

                        End If

                        If Not urExisteComp Then
                            Throw New Exception(Traducao.EstruturaDeErrosIX.IX_tbUnidadesRelacoesCompra)
                        ElseIf Not urExisteVenda Then
                            Throw New Exception(Traducao.EstruturaDeErrosIX.IX_tbUnidadesRelacoesVenda)
                        End If
                    End If
                End If

                ' Verifica relacao das linhas
                If o.ArtigosUnidades IsNot Nothing AndAlso o.ArtigosUnidades.Count > 0 AndAlso listAU IsNot Nothing AndAlso listAU.Count > 0 Then
                    For Each au In o.ArtigosUnidades
                        Dim uniID As Long = au.IDUnidade
                        Dim uniIDConv As Long = au.IDUnidadeConversao
                        Dim urExiste As Boolean = listAU.Exists(Function(f) (f.IDUnidade = uniID AndAlso f.IDUnidadeConversao = uniIDConv) Or
                                                                    (f.IDUnidade = uniIDConv AndAlso f.IDUnidadeConversao = uniID))

                        If urExiste Then
                            Throw New Exception(Traducao.EstruturaDeErrosIX.IX_tbUnidadesRelacoes)
                        End If
                    Next
                End If

            Catch
                Throw
            End Try
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As Oticas.Artigos,
                                                 e As tbArtigos, inAcao As AcoesFormulario)
            Try
                Dim CodigoClasse As String = GetCodigoClassificacaoTipoArtigo(o.IDTipoArtigo)

                'Define ID tbArmazensLocalizacoes
                If o.ArtigosArmazensLocalizacoes IsNot Nothing Then
                    For Each linha In o.ArtigosArmazensLocalizacoes
                        linha.Sistema = True
                    Next
                End If

                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                dict.Add(CamposGenericos.IDArtigo, e.ID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    'GravaLinhas(Of tbArtigosAlternativos, ArtigosAlternativos)(inCtx, e, o, Nothing)
                    'GravaLinhas(Of tbArtigosAssociados, ArtigosAssociados)(inCtx, e, o, Nothing)
                    GravaLinhas(Of tbArtigosArmazensLocalizacoes, ArtigosArmazensLocalizacoes)(inCtx, e, o, dict)
                    GravaLinhas(Of tbArtigosIdiomas, ArtigosIdiomas)(inCtx, e, o, dict)
                    GravaLinhas(Of tbArtigosLotes, ArtigosLotes)(inCtx, e, o, dict)
                    GravaLinhas(Of tbArtigosPrecos, ArtigosPrecos)(inCtx, e, o, dict)

                    If Not o.ArtigosPrecos Is Nothing AndAlso o.ArtigosPrecos.Count > 0 Then
                        For Each artPreco As ArtigosPrecos In o.ArtigosPrecos
                            Dim tbArtPreco As tbArtigosPrecos = e.tbArtigosPrecos.Where(Function(w) w.ID = artPreco.ID).FirstOrDefault

                            If tbArtPreco IsNot Nothing AndAlso artPreco.IDLoja Is Nothing Then
                                tbArtPreco.IDLoja = Nothing
                                inCtx.Entry(tbArtPreco).Property("IDLoja").IsModified = True
                            End If

                            If tbArtPreco IsNot Nothing AndAlso artPreco.ValorComIva Is Nothing Then

                                With tbArtPreco
                                    .ValorComIva = CDbl(0)
                                    .ValorSemIva = CDbl(0)
                                End With

                                With inCtx.Entry(tbArtPreco)
                                    .Property("ValorSemIva").IsModified = True
                                    .Property("ValorComIva").IsModified = True
                                End With
                            End If
                        Next
                    End If

                    GravaLinhas(Of tbArtigosUnidades, ArtigosUnidades)(inCtx, e, o, dict)
                    GravaLinhas(Of tbArtigosFornecedores, ArtigosFornecedores)(inCtx, e, o, dict)
                    GravaEspecifico(inCtx, o, inAcao, e, CodigoClasse)

                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    'Preencher props do modelo para depois remover foto
                    o.Foto = e.Foto
                    o.FotoCaminho = e.FotoCaminho
                    'GravaLinhasEntidades(Of tbArtigosAlternativos)(inCtx, e.tbArtigosAlternativos.ToList, AcoesFormulario.Remover, Nothing)
                    'GravaLinhasEntidades(Of tbArtigosAssociados)(inCtx, e.tbArtigosAssociados.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosArmazensLocalizacoes)(inCtx, e.tbArtigosArmazensLocalizacoes.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosIdiomas)(inCtx, e.tbArtigosIdiomas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosLotes)(inCtx, e.tbArtigosLotes.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosPrecos)(inCtx, e.tbArtigosPrecos.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosUnidades)(inCtx, e.tbArtigosUnidades.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosFornecedores)(inCtx, e.tbArtigosFornecedores.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbArtigosStock)(inCtx, e.tbArtigosStock.ToList, AcoesFormulario.Remover, Nothing)
                    RemoveEspecifico(inCtx, e, True, True, True, True)
                End If

                inCtx.SaveChanges()
            Catch
                Throw
            End Try
        End Sub



        Private Sub GravaEspecifico(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As Oticas.Artigos, inAcao As AcoesFormulario, e As tbArtigos, ByVal CodigoClasse As String)
            Select Case CodigoClasse
                Case Classificacao.Aros
                    o.ArtigosAros = New List(Of ArtigosAros)
                    Dim ArtigoAro As New ArtigosAros
                    o.ArtigosAros.Add(ArtigoAro)

                    For Each lin In o.ArtigosAros
                        newObjectArosOculosSol(lin, o, e, If(inAcao = AcoesFormulario.Adicionar, 0, (From x In BDContexto.tbAros Where x.IDArtigo = e.ID Select x.ID).FirstOrDefault()))
                    Next

                    RemoveEspecifico(inCtx, e, False, True, True, True)
                    GravaLinhas(Of tbAros, ArtigosAros)(inCtx, e, o, Nothing)

                Case Classificacao.OculosSol
                    o.ArtigosOculosSol = New List(Of ArtigosOculosSol)
                    Dim ArtigoOculoSol As New ArtigosOculosSol
                    o.ArtigosOculosSol.Add(ArtigoOculoSol)

                    For Each lin In o.ArtigosOculosSol
                        newObjectArosOculosSol(lin, o, e, If(inAcao = AcoesFormulario.Adicionar, 0, (From x In BDContexto.tbOculosSol Where x.IDArtigo = e.ID Select x.ID).FirstOrDefault()))
                    Next

                    RemoveEspecifico(inCtx, e, True, False, True, True)
                    GravaLinhas(Of tbOculosSol, ArtigosOculosSol)(inCtx, e, o, Nothing)

                Case Classificacao.LentesContato
                    If o.ArtigosLentesContato Is Nothing Then
                        o.ArtigosLentesContato = New List(Of ArtigosLentesContato)
                        Dim LenteContato As New ArtigosLentesContato
                        o.ArtigosLentesContato.Add(LenteContato)

                        For Each lin In o.ArtigosLentesContato
                            newObjectLentesContato(lin, o, e, If(inAcao = AcoesFormulario.Adicionar, 0, (From x In BDContexto.tbLentesContato Where x.IDArtigo = e.ID Select x.ID).FirstOrDefault()))
                        Next
                    Else
                        o.ArtigosLentesContato(0).IDArtigo = e.ID
                    End If

                    RemoveEspecifico(inCtx, e, True, True, False, True)
                    GravaLinhas(Of tbLentesContato, ArtigosLentesContato)(inCtx, e, o, Nothing)

                Case Classificacao.LentesOftalmicas
                    If o.ArtigosLentesOftalmicas Is Nothing Then
                        o.ArtigosLentesOftalmicas = New List(Of ArtigosLentesOftalmicas)

                        Dim LenteOftalmica As New ArtigosLentesOftalmicas
                        o.ArtigosLentesOftalmicas.Add(LenteOftalmica)

                        For Each lin In o.ArtigosLentesOftalmicas
                            newObjectLentesOftalmicas(lin, o, e, If(inAcao = AcoesFormulario.Adicionar, 0, (From x In BDContexto.tbLentesOftalmicas Where x.IDArtigo = e.ID Select x.ID).FirstOrDefault()))
                        Next
                    Else
                        o.ArtigosLentesOftalmicas(0).IDArtigo = e.ID
                    End If

                    RemoveEspecifico(inCtx, e, True, True, True, False)
                    Using rp As New RepositorioArtigosLentesOftalmicas
                        Dim ALOS = If(o.ArtigosLentesOftalmicasSuplementos IsNot Nothing, o.ArtigosLentesOftalmicasSuplementos.Where(Function(x) x.Checked), New List(Of Oticas.ArtigosLentesOftalmicasSuplementos))
                        o.ArtigosLentesOftalmicas(0).CodigosSuplementos = String.Join("-", ALOS.OrderBy(Function(x) x.IDSuplementoLente).Select(Function(y) y.IDSuplementoLente))
                        rp.GravaObjEsp(inCtx, o.ArtigosLentesOftalmicas(0), inAcao, ALOS.ToList())
                    End Using

                Case Else
                    RemoveEspecifico(inCtx, e, True, True, True, True)
            End Select
        End Sub

        Private Sub RemoveEspecifico(ByRef inCtx As BD.Dinamica.Aplicacao, e As tbArtigos, blnRemoveAros As Boolean, blnRemoveOculosSol As Boolean, blnRemoveLentesContato As Boolean, blnRemoveLentesOftalmicas As Boolean)
            If blnRemoveAros Then GravaLinhasEntidades(Of tbAros)(inCtx, e.tbAros.ToList(), AcoesFormulario.Remover, Nothing)
            If blnRemoveOculosSol Then GravaLinhasEntidades(Of tbOculosSol)(inCtx, e.tbOculosSol.ToList(), AcoesFormulario.Remover, Nothing)
            If blnRemoveLentesContato Then GravaLinhasEntidades(Of tbLentesContato)(inCtx, e.tbLentesContato.ToList(), AcoesFormulario.Remover, Nothing)
            If blnRemoveLentesOftalmicas Then GravaLinhasEntidades(Of tbLentesOftalmicas)(inCtx, e.tbLentesOftalmicas.ToList(), AcoesFormulario.Remover, Nothing)
        End Sub

        Private Function newObjectArosOculosSol(ByRef obj As Object, ByRef o As Oticas.Artigos, e As tbArtigos, ID As Long)
            With obj
                .ID = ID : .IDArtigo = e.ID : .IDModelo = o.IDModelo
                .CodigoCor = o.CodigoCor : .Tamanho = o.Tamanho : .Hastes = o.Hastes : .CorGenerica = o.CorGenerica : .CorLente = o.CorLente : .TipoLente = o.TipoLente
                .Ativo = True : .AcaoCRUD = If(.ID <> 0, AcoesFormulario.Alterar, AcoesFormulario.Adicionar) : .UtilizadorCriacao = o.UtilizadorCriacao : .DataCriacao = o.DataCriacao
                .UtilizadorAlteracao = If(.ID <> 0, o.UtilizadorAlteracao, Nothing) : .DataAlteracao = If(.ID <> 0, o.DataAlteracao, Nothing)
            End With

            Return obj
        End Function

        Private Function newObjectLentesContato(ByRef obj As Object, ByRef o As Oticas.Artigos, e As tbArtigos, ID As Long)
            With obj
                .ID = ID : .IDArtigo = e.ID : .IDModelo = o.IDModelo
                .Raio = o.Raio : .Diametro = o.Diametro : .PotenciaEsferica = o.PotenciaEsferica : .PotenciaCilindrica = o.PotenciaCilindrica : .Eixo = o.Eixo : .Adicao = o.Adicao : .Raio2 = If(o.Raio2 IsNot Nothing, o.Raio2, "0")
                .Ativo = True : .AcaoCRUD = If(.ID <> 0, AcoesFormulario.Alterar, AcoesFormulario.Adicionar) : .UtilizadorCriacao = o.UtilizadorCriacao : .DataCriacao = o.DataCriacao
                .UtilizadorAlteracao = If(.ID <> 0, o.UtilizadorAlteracao, Nothing) : .DataAlteracao = If(.ID <> 0, o.DataAlteracao, Nothing)
            End With

            Return obj
        End Function

        Private Function newObjectLentesOftalmicas(ByRef obj As ArtigosLentesOftalmicas, ByRef o As Oticas.Artigos, e As tbArtigos, ID As Long)
            With obj
                .ID = ID : .IDArtigo = e.ID : .IDModelo = o.IDModelo
                .IDTratamentoLente = o.IDTratamentoLente : .Diametro = o.Diametro
                .PotenciaEsferica = o.PotenciaEsferica : .PotenciaCilindrica = o.PotenciaCilindrica : .PotenciaPrismatica = o.PotenciaPrismatica : .IDCorLente = o.IDCorLente
                .Adicao = o.Adicao
                .Ativo = True : .AcaoCRUD = If(.ID <> 0, AcoesFormulario.Alterar, AcoesFormulario.Adicionar) : .UtilizadorCriacao = o.UtilizadorCriacao : .DataCriacao = o.DataCriacao
                .UtilizadorAlteracao = If(.ID <> 0, o.UtilizadorAlteracao, Nothing) : .DataAlteracao = If(.ID <> 0, o.DataAlteracao, Nothing)
            End With

            Return obj
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        'MAF - 17-03-2016 
        'Função que vai retornar se existem movimentos de stock  para bloquear as Combos Gere Stock / Gere stock por nº de série / Gere stock por lotes
        Public Function ExistemMovimentosStock(ByVal IDArtigo As Long) As Boolean
            Try
                Dim strQry As String = "select idartigo from tbStockArtigos where idartigo=" & IDArtigo & " and isnull(quantidade,0)<>0"
                Dim intRes As Int64 = 0
                intRes = BDContexto.Database.SqlQuery(Of Int64)(strQry).FirstOrDefault()
                Return intRes > 0
            Catch
                Throw
            End Try
        End Function

        'Função que vai retornar se existem artigo ou tipo de artigos em uso por outra entidade / documentos
        Public Function ExistemDocumentosArtigos(Optional lngIDArtigo As Long = 0, Optional lngIDTipoArtigo As Long = 0) As Boolean
            Dim blnResult As Boolean? = False

            If lngIDArtigo > 0 Then
                blnResult = BDContexto.sp_ExistemDocumentos(lngIDArtigo, Nothing).FirstOrDefault
            ElseIf lngIDTipoArtigo > 0 Then
                blnResult = BDContexto.sp_ExistemDocumentos(Nothing, lngIDTipoArtigo).FirstOrDefault
            End If

            Return blnResult
        End Function

        ''' <summary>
        ''' funcao que retorna o codigo do artigo
        ''' </summary>
        ''' <param name="IDArtigo"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Function GetCodigoArtigo(ByVal IDArtigo As Long) As String
            Return (From x In BDContexto.tbArtigos
                    Where x.ID = IDArtigo
                    Select x.Codigo).FirstOrDefault()
        End Function

        ''' <summary>
        ''' funcao que retorna o id do artigo by codigo /// codigo barras
        ''' </summary>
        ''' <param name="Codigo"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Function GetIDArtigoByCodigoOuCodigoBarras(ByVal Codigo As String) As Long

            Dim strCodigo As String = ClsUtilitarios.EnvolveSQL(Codigo)
            Dim IDArtigo As Long = BDContexto.Database.SqlQuery(Of Long)("select id from tbArtigos where codigo =" & strCodigo & " or CodigoBarras=" & strCodigo & " union select idartigo as id from tbArtigosfornecedores where CodigoBarras=" & strCodigo & " or referencia=" & strCodigo).FirstOrDefault()
            Return IDArtigo
        End Function

        ''' <summary>
        ''' funcao que retorna o codigo da tbSistemaClassificacoesTiposArtigos mediante o IDTipoArtigo (returns LO || AR ||LC || OS || DV)
        ''' </summary>
        ''' <param name="IDTipoArtigo"></param>
        ''' <returns>LO || AR ||LC || OS || DV</returns>
        ''' <remarks></remarks>
        Private Function GetCodigoClassificacaoTipoArtigo(ByVal IDTipoArtigo As Long) As String
            Return (From x In BDContexto.tbSistemaClassificacoesTiposArtigos
                    Join y In BDContexto.tbTiposArtigos On y.IDSistemaClassificacao Equals x.ID
                    Where y.ID = IDTipoArtigo
                    Select x.Codigo).FirstOrDefault()
        End Function

        Private Sub DevolveMsgErro(ByRef inObjNovo As Oticas.Artigos, ByRef inObjAnterior As Oticas.tbArtigos)
            Dim result As String = String.Empty

            Dim strLstCampos As List(Of String) = New List(Of String)
            If inObjNovo.GereLotes <> inObjAnterior.GereLotes Then
                strLstCampos.Add(Traducao.EstruturaArtigos.GereLotes)
            End If
            If inObjNovo.GereStock <> inObjAnterior.GereStock Then
                strLstCampos.Add(Traducao.EstruturaArtigos.GERESTOCKS)
            End If
            If inObjNovo.IDUnidadeStock <> inObjAnterior.IDUnidade Then
                strLstCampos.Add(Traducao.EstruturaArtigos.DESCRICAOUNIDADESTOCK)
            End If
            If inObjNovo.IDUnidadeStock2 <> inObjAnterior.IDUnidadeStock2 Then
                strLstCampos.Add(Traducao.EstruturaArtigos.DESCRICAOUNIDADESTOCK2)
            End If
            If inObjNovo.IDTipoArtigo <> inObjAnterior.IDTipoArtigo Then
                strLstCampos.Add(Traducao.EstruturaArtigos.TIPOARTIGO)
            End If
            If strLstCampos.Count > 0 Then
                result = String.Join(",", strLstCampos.ToArray())
                Throw New Exception(Traducao.EstruturaArtigos.ArtigoEmUso.Replace("{0}", "(" + result + ")"))
            End If
        End Sub
#End Region

#Region "FUNÇÕES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna a lista de colunas para a tabela temporária
        ''' </summary>
        ''' <returns></returns>
        Private Function RetornaColunasTabelaTemp() As List(Of TempColumns)
            Dim colunas As New List(Of TempColumns)
            With colunas
                .Add(New TempColumns With {.Nome = "Codigo", .TipoDados = "nvarchar(max)", .Null = True})
                .Add(New TempColumns With {.Nome = "Quantidade", .TipoDados = "int", .Null = True})
                .Add(New TempColumns With {.Nome = "Lote", .TipoDados = "nvarchar(max)", .Null = True})
            End With

            Return colunas
        End Function

        Public Function AtribuirProximoCodigoBarras(inCtx As BD.Dinamica.Aplicacao, inTam As Integer) As String
            Try
                Dim strQry As String = "select cast(isnull(max(cast(isnull(right(codigobarras," & inTam & "),0) as bigint)),0)+1 as nvarchar) as codigo from tbartigos with (nolock) where CodigoBarras not like '%[^0-9]%'"
                Return inCtx.Database.SqlQuery(Of String)(strQry).FirstOrDefault()
            Catch
                Throw
            End Try
        End Function

#End Region

    End Class
End Namespace