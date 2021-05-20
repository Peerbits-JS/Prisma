Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Excepcoes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc
Imports Oticas
Imports Oticas.BD.Dinamica

Public Class RepositorioDocumentosStockContagem
    Inherits RepositorioGenerico(Of Aplicacao, tbDocumentosStockContagem, DocumentosStockContagem)

#Region "LEITURA"
    ''' <summary>
    ''' Funcao que retorna by id
    ''' </summary>
    ''' <param name="objID"></param>
    ''' <returns></returns>
    Public Overrides Function ObtemPorObjID(objID As Object) As DocumentosStockContagem
        Dim criaNovoModelo As Func(Of tbDocumentosStockContagem, DocumentosStockContagem) = Function(documento)
                                                                                                Return DocumentosStockContagem.Criar(documento)
                                                                                            End Function
        Dim id As Long = objID

        Dim query = BDContexto.tbDocumentosStockContagem.
            Include("tbDocumentosStockContagemLinhas").
            Include("tbDocumentosStockContagemAnexos").
            Include("tbArmazens").
            Include("tbArmazensLocalizacoes").
            Include("tbEstados").
            Include("tbSistemaMoedas").
            Include("tbTiposDocumento").
            Include("tbTiposDocumentoSeries").
            Where(Function(documento) documento.ID = id).
            Select(criaNovoModelo)

        Return query.FirstOrDefault()
    End Function

    ''' <summary>
    ''' Funcao lista (mapeia para o modelo)
    ''' </summary>
    ''' <param name="inDocumentosStockContagem"></param>
    ''' <returns></returns>
    Protected Overrides Function ListaCamposTodos(inDocumentosStockContagem As IQueryable(Of tbDocumentosStockContagem)) As IQueryable(Of DocumentosStockContagem)
        Dim criaNovoModelo As Func(Of tbDocumentosStockContagem, DocumentosStockContagem) = Function(documento)
                                                                                                Return DocumentosStockContagem.Criar(documento)
                                                                                            End Function
        Return inDocumentosStockContagem.Select(criaNovoModelo).AsQueryable
    End Function

    ''' <summary>
    ''' Funcao que retorna as linhas by id documento contagem
    ''' </summary>
    ''' <param name="IDDocumentoStockContagem"></param>
    ''' <returns></returns>
    Public Function RetornaLinhasByID(IDDocumentoStockContagem As Long) As List(Of DocumentosStockContagemArtigos)
        Return BDContexto.tbDocumentosStockContagemLinhas.Where(Function(w) w.IDDocumentoStockContagem = IDDocumentoStockContagem).Select(Function(linha) New DocumentosStockContagemArtigos With {
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
            .QuantidadeContada = linha.QuantidadeContada,
            .GereLotes = linha.tbArtigos.GereLotes
        }).ToList
    End Function

    Public Overrides Function GridDataFilters(objFiltro As ClsF3MFiltro) As List(Of IFilterDescriptor)
        Dim lstFiltros As New List(Of IFilterDescriptor)

        Dim podeVerDocsLojas = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "DocumentosOutrasLojas", True)

        If Not podeVerDocsLojas Then
            Dim idLoja As String = ClsF3MSessao.RetornaLojaID

            lstFiltros.Add(New FilterDescriptor With {
                .Member = "IDLoja",
                .Value = idLoja
            })
        End If

        Return lstFiltros
    End Function
#End Region

#Region "ESCRITA"
    ''' <summary>
    ''' Funcao Adiciona
    ''' </summary>
    ''' <param name="documentoStockContagem"></param>
    ''' <param name="inObjFiltro"></param>
    Public Overrides Sub AdicionaObj(ByRef documentoStockContagem As DocumentosStockContagem, inObjFiltro As ClsF3MFiltro)
        Dim tentativas As Short = ClsExcepcoes.CalculaNumeroInicialTentativa(ClsUtilitarios.RetornaZeroSeVazio(CObj(documentoStockContagem).NumTentativas))
        AdicionaPorTentativas(documentoStockContagem, tentativas)
    End Sub

    ''' <summary>
    ''' Funcao que adiciona por tentativas (MÁX = 5)
    ''' </summary>
    ''' <param name="documentoStockContagem"></param>
    ''' <param name="inTentativas"></param>
    Private Sub AdicionaPorTentativas(documentoStockContagem As DocumentosStockContagem, inTentativas As Short)
        Dim blnRepete As Boolean = False
        Using ctx As New BD.Dinamica.Aplicacao
            Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                Try
                    'get main db set
                    Dim tbDocumentoStockContagem As tbDocumentosStockContagem = documentoStockContagem.MapeiaParaModelo()
                    'get tipo doc + serie
                    Dim tbTiposDocSeries As tbTiposDocumentoSeries = ctx.tbTiposDocumentoSeries.FirstOrDefault(
                    Function(w) w.ID = tbDocumentoStockContagem.IDTiposDocumentoSeries)
                    'set props
                    With tbDocumentoStockContagem
                        If documentoStockContagem.CodigoTipoEstado = TiposEstados.Efetivo Then
                            .NumeroDocumento = RetornaProximoNumDocumento(ctx, documentoStockContagem)
                            .Documento = tbTiposDocSeries.tbTiposDocumento.Codigo & " " & tbTiposDocSeries.CodigoSerie & "/" & .NumeroDocumento
                        Else
                            .Documento = tbTiposDocSeries.tbTiposDocumento.Codigo & " " & tbTiposDocSeries.CodigoSerie & "/"
                            .NumeroDocumento = CLng(0)
                        End If
                        'main props
                        .DataCriacao = Now() : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                    End With
                    'save
                    With ctx
                        .tbDocumentosStockContagem.Add(tbDocumentoStockContagem)
                        .Entry(tbDocumentoStockContagem).State = Entity.EntityState.Added
                        .SaveChanges()
                    End With
                    'set id to model
                    With documentoStockContagem
                        .ID = tbDocumentoStockContagem.ID
                    End With
                    'commit
                    trans.Commit()
                Catch ex As Exception
                    'verifica se repeta
                    blnRepete = ClsExcepcoes.RepeteFuncaoPorConcorrencia(ex, inTentativas, ClsUtilitarios.RetornaZeroSeVazio(documentoStockContagem.NumTentativas))
                    'roolback
                    If trans.UnderlyingTransaction IsNot Nothing AndAlso trans.UnderlyingTransaction.Connection IsNot Nothing Then
                        trans.Rollback()
                    End If
                    'verifica se repete
                    If blnRepete And inTentativas < Concorrencia.NumTentativasServidor Then
                        trans.Dispose()
                        ctx.Dispose()
                        'repeta com tentativa incrementada
                        AdicionaPorTentativas(documentoStockContagem, inTentativas)
                    Else
                        Throw ex
                    End If
                End Try
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Funcao Edita
    ''' </summary>
    ''' <param name="documentoStockContagem"></param>
    ''' <param name="inObjFiltro"></param>
    Public Overrides Sub EditaObj(ByRef documentoStockContagem As DocumentosStockContagem, inObjFiltro As ClsF3MFiltro)
        Dim tentativas As Short = ClsExcepcoes.CalculaNumeroInicialTentativa(ClsUtilitarios.RetornaZeroSeVazio(CObj(documentoStockContagem).NumTentativas))
        EditaPorTentativas(documentoStockContagem, tentativas)
    End Sub

    ''' <summary>
    ''' Funcao que edita por tentativas (MAX = 5)
    ''' </summary>
    ''' <param name="documentoStockContagem"></param>
    ''' <param name="inTentativas"></param>
    Private Sub EditaPorTentativas(documentoStockContagem As DocumentosStockContagem, inTentativas As Short)
        Dim blnRepete As Boolean = False
        Using ctx As New BD.Dinamica.Aplicacao
            Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                Try
                    Dim id = documentoStockContagem.ID
                    Dim novosArtigos = documentoStockContagem.Artigos.Where(Function(artigo) artigo.ID = 0)
                    Dim tbDocumentoStockContagem = ctx.tbDocumentosStockContagem.
                    Include("tbDocumentosStockContagemLinhas").
                    Include("tbDocumentosStockContagemAnexos").
                    Include("tbArmazens").
                    Include("tbArmazensLocalizacoes").
                    Include("tbEstados").
                    Include("tbSistemaMoedas").
                    Include("tbTiposDocumento").
                    Include("tbTiposDocumentoSeries").
                    FirstOrDefault(Function(documento) documento.ID = id)

                    If (documentoStockContagem.Artigos.All(Function(artigo) artigo.ID = 0)) Then
                        RemoveLinhas(ctx, tbDocumentoStockContagem.tbDocumentosStockContagemLinhas)
                    Else
                        AtualizaLinhas(tbDocumentoStockContagem.tbDocumentosStockContagemLinhas, documentoStockContagem)
                    End If

                    If (novosArtigos.Any()) Then
                        CriaLinhas(ctx, tbDocumentoStockContagem, novosArtigos)
                    End If

                    With tbDocumentoStockContagem
                        .AtualizaValores(documentoStockContagem)

                        'update numero documento
                        If documentoStockContagem.CodigoTipoEstado = TiposEstados.Efetivo AndAlso .tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Rascunho Then
                            .NumeroDocumento = RetornaProximoNumDocumento(ctx, documentoStockContagem)
                            .Documento = tbDocumentoStockContagem.tbTiposDocumentoSeries.tbTiposDocumento.Codigo & " " & tbDocumentoStockContagem.tbTiposDocumentoSeries.CodigoSerie & "/" & .NumeroDocumento

                        ElseIf documentoStockContagem.CodigoTipoEstado = TiposEstados.Rascunho Then
                            .Documento = tbDocumentoStockContagem.tbTiposDocumentoSeries.tbTiposDocumento.Codigo & " " & tbDocumentoStockContagem.tbTiposDocumentoSeries.CodigoSerie & "/"
                            .NumeroDocumento = CLng(0)
                        End If
                    End With
                    'save
                    ctx.SaveChanges()
                    'commit
                    trans.Commit()
                Catch ex As Exception
                    'verifica se repeta
                    blnRepete = ClsExcepcoes.RepeteFuncaoPorConcorrencia(ex, inTentativas, ClsUtilitarios.RetornaZeroSeVazio(documentoStockContagem.NumTentativas))
                    'roolback
                    If trans.UnderlyingTransaction IsNot Nothing AndAlso trans.UnderlyingTransaction.Connection IsNot Nothing Then
                        trans.Rollback()
                    End If
                    'verifica se repete
                    If blnRepete And inTentativas < Concorrencia.NumTentativasServidor Then
                        trans.Dispose()
                        ctx.Dispose()
                        'repeta com tentativa incrementada
                        AdicionaPorTentativas(documentoStockContagem, inTentativas)
                    Else
                        Throw ex
                    End If
                End Try
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Funcao Remove
    ''' </summary>
    ''' <param name="documentoStockContagem"></param>
    ''' <param name="inObjFiltro"></param>
    Public Overrides Sub RemoveObj(ByRef documentoStockContagem As DocumentosStockContagem, inObjFiltro As ClsF3MFiltro)
        Dim tbocumentoStockContagem = BDContexto.tbDocumentosStockContagem.Find(documentoStockContagem.ID)

        With BDContexto
            .tbDocumentosStockContagemLinhas.RemoveRange(tbocumentoStockContagem.tbDocumentosStockContagemLinhas)
            .tbDocumentosStockContagemAnexos.RemoveRange(tbocumentoStockContagem.tbDocumentosStockContagemAnexos)
            .tbDocumentosStockContagem.Remove(tbocumentoStockContagem)
            .SaveChanges()
        End With
    End Sub
#End Region

#Region "FUNCOES AUXILIARES"
    ''' <summary>
    ''' Funcao que adiciona as linhas quando foram adicionadas ao edtiar
    ''' </summary>
    ''' <param name="inCtx"></param>
    ''' <param name="tbDocumentoStockContagem"></param>
    ''' <param name="novosArtigos"></param>
    Private Sub CriaLinhas(inCtx As Aplicacao, tbDocumentoStockContagem As tbDocumentosStockContagem, novosArtigos As IEnumerable(Of DocumentosStockContagemArtigos))
        novosArtigos = novosArtigos.Where(Function(x) x.IDArtigo IsNot Nothing)
        For Each artigo In novosArtigos
            Dim novoArtigo = artigo.MapeiaParaModelo()
            novoArtigo.IDDocumentoStockContagem = tbDocumentoStockContagem.ID
            inCtx.tbDocumentosStockContagemLinhas.Add(novoArtigo)
        Next
    End Sub

    ''' <summary>
    ''' Funcao que atualiza o valor da linha quando foi editada ao editar
    ''' </summary>
    ''' <param name="tbDocumentosStockContagemLinhas"></param>
    ''' <param name="documentoStockContagem"></param>
    Private Sub AtualizaLinhas(tbDocumentosStockContagemLinhas As ICollection(Of tbDocumentosStockContagemLinhas), documentoStockContagem As DocumentosStockContagem)
        For Each linha In tbDocumentosStockContagemLinhas
            Dim artigoDaLinha = documentoStockContagem.Artigos.FirstOrDefault(Function(artigo) artigo.ID = linha.ID)
            linha.AtualizaValores(artigoDaLinha)
        Next
    End Sub

    ''' <summary>
    ''' Funcao que remove as linhas quando foram removidas ao edtiar
    ''' </summary>
    ''' <param name="inCtx"></param>
    ''' <param name="tbDocumentosStockContagemLinhas"></param>
    Private Sub RemoveLinhas(inCtx As Aplicacao, tbDocumentosStockContagemLinhas As ICollection(Of tbDocumentosStockContagemLinhas))
        With inCtx
            .tbDocumentosStockContagemLinhas.RemoveRange(tbDocumentosStockContagemLinhas)
        End With
    End Sub

    ''' <summary>
    ''' Funcao que executa o sp sp_AtualizaStock
    ''' </summary>
    ''' <param name="documento"></param>
    ''' <param name="acaoFormulario"></param>
    Public Sub AtualizaStock(documento As DocumentosStockContagem, acaoFormulario As AcoesFormulario)
        BDContexto.sp_AtualizaStock(documento.ID,
                                    documento.IDTipoDocumento,
                                    acaoFormulario,
                                    NameOf(tbDocumentosStockContagem),
                                    NameOf(tbDocumentosStockContagemLinhas),
                                    String.Empty,
                                    NameOf(tbDocumentosStockContagemLinhas.IDDocumentoStockContagem),
                                    String.Empty,
                                    ClsF3MSessao.RetornaUtilizadorNome,
                                    False,
                                    False)
    End Sub

    ''' <summary>
    ''' Funcao que retorna o proximo numero de documento
    ''' </summary>
    ''' <param name="inCtx"></param>
    ''' <param name="documentoStockContagem"></param>
    ''' <returns></returns>
    Private Function RetornaProximoNumDocumento(inCtx As Aplicacao, documentoStockContagem As DocumentosStockContagem) As Long
        Dim ultimoDoc As Long = (From x In inCtx.tbDocumentosStockContagem
                                 Where x.IDTiposDocumentoSeries = documentoStockContagem.IDTiposDocumentoSeries
                                 Select x.NumeroDocumento).DefaultIfEmpty(0).Max()

        Return ultimoDoc + 1
    End Function
#End Region
End Class
