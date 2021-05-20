Imports System.IO
Imports CsvHelper
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.UI
Imports Newtonsoft.Json
Imports Oticas.Repositorio.Artigos
Imports Oticas.Repositorio.TabelasAuxiliares
Imports RepositorioEstados = F3M.Repositorio.Comum.RepositorioEstados

Namespace Areas.Documentos.Controllers
    Public Class DocumentosStockContagemController
        Inherits GrelhaFormController(Of BD.Dinamica.Aplicacao, tbDocumentosStockContagem, DocumentosStockContagem)

        Private ReadOnly _repositorioArtigos As RepositorioArtigos
        Private ReadOnly _repositorioTipoDocumento As RepositorioTiposDocumento
        Private ReadOnly _repositorioArmazens As RepositorioArmazens

        Public Sub New()
            MyBase.New(New RepositorioDocumentosStockContagem)
            _repositorioArtigos = New RepositorioArtigos()
            _repositorioTipoDocumento = New RepositorioTiposDocumento()
            _repositorioArmazens = New RepositorioArmazens()
        End Sub

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Dim estado As F3M.Estados = RepositorioEstados.ValoresPorDefeito(Of tbEstados)(repositorio.BDContexto, TiposEntidadeEstados.DocumentosStockContagem)
            Dim tipoDocumentoSerie = _repositorioTipoDocumento.ObtemSeriePorDefeitoContagemStock()
            Dim parametroLocalizacao As Long = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
            Dim armazem As tbArmazens = _repositorioArmazens.ObtemArmazemPorIdLocalizacao(parametroLocalizacao)
            Dim localizacao = armazem.tbArmazensLocalizacoes.FirstOrDefault()

            Dim actionResult As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            With DirectCast(DirectCast(actionResult, PartialViewResult).Model, DocumentosStockContagem)
                .IDEstado = estado.ID : .DescricaoEstado = estado.Descricao : .CodigoEstado = estado.Codigo
                .IDTipoDocumento = tipoDocumentoSerie.IDTiposDocumento : .CodigoTipoDocumento = tipoDocumentoSerie.CodigoTipoDocumento : .DescricaoTiposDocumentoSeries = tipoDocumentoSerie.DescricaoSerie
                .DescricaoTipoDocumento = tipoDocumentoSerie.DescricaoTipoDocumento : .IDTiposDocumentoSeries = tipoDocumentoSerie.ID : .CodigoTipoEstado = estado.CodigoTipoEstado
                .CodigoSerie = tipoDocumentoSerie.CodigoSerie
                .CodigoDescricaoTipoDocumento = tipoDocumentoSerie.CodigoDescricao
                .IDArmazem = armazem.ID
                .DescricaoArmazem = armazem.Descricao
                .IDLocalizacao = localizacao.ID
                .DescricaoLocalizacao = localizacao.Descricao

                If Not String.IsNullOrEmpty(.CodigoTipoDocumento) AndAlso Not String.IsNullOrEmpty(.CodigoSerie) Then
                    .Documento = .CodigoTipoDocumento & Operadores.EspacoEmBranco & .CodigoSerie & Operadores.Slash
                End If
            End With

            Return actionResult
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaComprimidoBase64(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As String, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim model As DocumentosStockContagem = LZString.DecompressModelFromBase64(Of DocumentosStockContagem)(modelo)
            Dim result As JsonResult = Adiciona(request, model, inObjFiltro)

            LZString.CompressJSONDataToBase64(result)

            Return result
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosStockContagem, filtro As ClsF3MFiltro) As JsonResult
            Try
                If (modelo.Artigos.Where(Function(x) x.IDArtigo IsNot Nothing).Any() = False) Then
                    Throw New Exception(Traducao.EstruturaDocumentosStockContagem.ArtigosNaoPodeSerVazio)
                End If


                If (modelo.EstaEfetivo()) Then
                    modelo = AtualizaQuantidadeEmStock(modelo)
                End If

                Dim documentoStockContagem = MyBase.Adiciona(request, modelo, filtro)

                If (modelo.EstaEfetivo()) Then
                    AtualizaContaCorrente(modelo, AcoesFormulario.Adicionar)
                End If

                Return documentoStockContagem
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function EditaComprimidoBase64(ID As Long, IDVista As Long?, inObjFiltro As ClsF3MFiltro, CampoValorPorDefeito As String, IDDuplica As Long?) As String
            'my base
            Dim actRes As ActionResult = Edita(ID)

            Using rp As New RepositorioDocumentosStockContagem
                With DirectCast(DirectCast(actRes, PartialViewResult).Model, DocumentosStockContagem)
                    'set linhas
                    .Artigos = rp.RetornaLinhasByID(.ID)
                End With
            End Using

            'return view
            Return LZString.CompressViewtoBase64(Of DocumentosStockContagem)(actRes, ControllerContext, Mvc.Grelha.AccaoEdicao)
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function EditaComprimidoBase64(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As String, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim model As DocumentosStockContagem = LZString.DecompressModelFromBase64(Of DocumentosStockContagem)(modelo)
            Dim result As JsonResult = Edita(request, model, inObjFiltro)

            LZString.CompressJSONDataToBase64(result)

            Return result
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosStockContagem, filtro As ClsF3MFiltro) As JsonResult
            Try
                If (modelo.Artigos.Where(Function(x) x.IDArtigo IsNot Nothing).Any() = False) Then
                    Throw New Exception(Traducao.EstruturaDocumentosStockContagem.ArtigosNaoPodeSerVazio)
                End If

                'click no botao de efetivar
                If modelo.GravouViaEfetivar Then
                    Using rpEstados As New Repositorio.TabelasAuxiliares.RepositorioEstados
                        'instance new model estados
                        Dim EstadoEFT As New F3M.Estados
                        'get  estado efetivo (por defeito) para a contagem de stocks
                        EstadoEFT = rpEstados.RetornaEstadoByEntidadeETipoEstado(TiposEntidadeEstados.DocumentosStockContagem, TiposEstados.Efetivo)
                        If EstadoEFT Is Nothing Then
                            EstadoEFT = rpEstados.ValorInicial(True, TiposEntidadeEstados.DocumentosStockContagem)
                        End If
                        'set DocumentosStockContagem model
                        With modelo
                            .IDEstado = EstadoEFT.ID : .CodigoTipoEstado = EstadoEFT.CodigoTipoEstado
                        End With
                    End Using
                End If

                Dim documentoContagemStock = repositorio.ObtemPorObjID(modelo.ID)

                If (documentoContagemStock.EstaComoRascunho() AndAlso modelo.EstaEfetivo()) Then
                    modelo = AtualizaQuantidadeEmStock(modelo)
                    Dim res As JsonResult = MyBase.Edita(request, modelo, filtro)
                    AtualizaContaCorrente(modelo, AcoesFormulario.Adicionar)
                    Return res
                End If

                If (documentoContagemStock.EstaEfetivo() AndAlso modelo.EstaComoRascunho()) Then
                    AtualizaContaCorrente(modelo, AcoesFormulario.Remover)
                End If


                Return MyBase.Edita(request, modelo, filtro)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        Public Overrides Function Remove(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosStockContagem, filtro As ClsF3MFiltro) As JsonResult
            Dim documentoContagemStock As DocumentosStockContagem = repositorio.ObtemPorObjID(modelo.ID)

            If (documentoContagemStock.EstaEfetivo()) Then
                AtualizaContaCorrente(documentoContagemStock, AcoesFormulario.Remover)
            End If

            Return MyBase.Remove(request, modelo, filtro)
        End Function

        <F3MAcesso>
        Public Function Importa() As JsonResult
            Try
                Dim filtroFormulario As String = Request.Form.Get("filter")
                Dim filtro As DocumentosStockContagemFiltro = JsonConvert.DeserializeObject(Of DocumentosStockContagemFiltro)(filtroFormulario)
                Dim ficheiro As HttpPostedFileBase = Request.Files.Get(0)

                If (ficheiro.FileName.EndsWith(".csv") = False) AndAlso (ficheiro.FileName.EndsWith(".txt") = False) Then
                    Throw New Exception(Traducao.EstruturaDocumentosStockContagem.FicheiroImportacaoNaoECsv)
                End If

                Dim artigosContagemImportacao = LeArquivoCSVDeImportacao(ficheiro)

                Dim importacaoResultado = _repositorioArtigos.ObterArtigosDeImportacaoDaContagemDeEstoque(artigosContagemImportacao, filtro)

                Return RetornaJSONTamMaximo(importacaoResultado)
            Catch ex As ValidationException
                Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaDocumentosStockContagem.FicheiroImportacaoNaoECsvValido, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function ObtemArtigos(filtro As DocumentosStockContagemFiltro) As JsonResult
            Try
                Dim artigos = _repositorioArtigos.ObtemArtigosParaContagem(filtro)
                Return RetornaJSONTamMaximo(artigos)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Private Function AtualizaQuantidadeEmStock(modelo As DocumentosStockContagem)
            Dim artigosExistentes = modelo.Artigos.Where(Function(artigo) artigo.IDArtigo IsNot Nothing)
            Dim idArtigosContados = artigosExistentes.Select(Function(artigo) artigo.IDArtigo)
            Dim artigos = _repositorioArtigos.ObtemArtigos(idArtigosContados, modelo.Filtro)
            For Each artigo In artigosExistentes
                artigo.AtualizaQuantidadeEmStock(artigos.FirstOrDefault(Function(artigoContagem) artigoContagem.IDArtigo = artigo.IDArtigo))
                artigo.CalculaDiferenca()
            Next
            Return modelo
        End Function

        <F3MAcesso>
        Private Sub AtualizaContaCorrente(documento As DocumentosStockContagem, acaoFormulario As AcoesFormulario)
            DirectCast(repositorio, RepositorioDocumentosStockContagem).AtualizaStock(documento, acaoFormulario)
        End Sub

        <F3MAcesso>
        Private Function LeArquivoCSVDeImportacao(file As HttpPostedFileBase) As List(Of DocumentosStockContagemArtigoImportacao)
            Using fileStream As New StreamReader(file.InputStream)
                Dim csvReader = New CsvReader(fileStream)

                csvReader.Configuration.Delimiter = ";"
                csvReader.Configuration.MissingFieldFound = Nothing
                csvReader.Configuration.RegisterClassMap(Of DocumentosStockContagemArtigoImportacaoMap)()

                Return csvReader.GetRecords(Of DocumentosStockContagemArtigoImportacao)().ToList()
            End Using
        End Function

        <F3MAcesso>
        Public Function ValidaArtigo(IDArtigo As Long, Filtro As DocumentosStockContagemFiltro, Optional ByVal Codigo As String = "") As JsonResult
            Try
                If IDArtigo = 0 AndAlso Not String.IsNullOrEmpty(Codigo) Then
                    IDArtigo = _repositorioArtigos.GetIDArtigoByCodigoOuCodigoBarras(Codigo.Trim())
                End If

                Dim resultado = _repositorioArtigos.ValidaSeArtigoExisteParaContagem(IDArtigo, Filtro)

                Return RetornaJSONTamMaximo(resultado)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Action result da modal de contar
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Consultar)>
        Public Function DocumentosStockContagemContar() As ActionResult
            Return View("Modals/Contar", New Oticas.DocumentosStockContagemContar)
        End Function
    End Class

End Namespace