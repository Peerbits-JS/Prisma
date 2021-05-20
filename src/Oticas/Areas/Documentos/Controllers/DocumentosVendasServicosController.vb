Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Documentos.Controllers
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Repositorios.Administracao
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.ConstantesKendo

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasServicosController
        Inherits DocumentosController(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendasServicos)

        Const DocsVendasViewsPath As String = "~/Areas/Documentos/Views/DocumentosVendas/"
        Const DocsVendasServicosViewsPath As String = "~/Areas/Documentos/Views/DocumentosVendasServicos/"

        ReadOnly _repositorioDocumentosVendasServicos As RepositorioDocumentosVendasServicos

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosVendasServicos)

            _repositorioDocumentosVendasServicos = New RepositorioDocumentosVendasServicos()
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional ByVal IDVista As Long = 0) As ActionResult
            Dim EMultiEmpresa As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)
            ' Tipo Doc Especifico para Serviços
            Dim tipoDS As tbTiposDocumentoSeries
            If EMultiEmpresa Then
                Dim IDLojaSedeByIDLojaEmSessao As Long
                Using rpLojas As New RepositorioLojas
                    IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                End Using

                tipoDS = repositorio.BDContexto.tbTiposDocumentoSeries.Where(Function(w) w.AtivoSerie = True AndAlso
                                                                                 w.tbTiposDocumento.IDSistemaTiposDocumento = 17 AndAlso
                                                                                 w.IDLoja = IDLojaSedeByIDLojaEmSessao).FirstOrDefault()

            Else
                tipoDS = repositorio.BDContexto.tbTiposDocumentoSeries.Where(Function(w) w.AtivoSerie = True AndAlso w.tbTiposDocumento.IDSistemaTiposDocumento = 17).FirstOrDefault()
            End If


            Dim resAR As ActionResult =
                MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                    repositorio.BDContexto, tipoDS, TiposEntidadeEstados.Servicos, TiposEntidade.Clientes, SistemaCodigoModulos.Vendas,
                    Menus.Clientes, CampoValorPorDefeito, IDVista)

            Dim docServMOD As DocumentosVendasServicos = DirectCast(resAR, System.Web.Mvc.PartialViewResult).Model
            ' Tem de estar vazio para que os campos não bloqueiem, porque o estado inicial é Efetivo
            docServMOD.CodigoTipoEstado = String.Empty

            'tutorial de 1ª utilização
            docServMOD.isNewUserOnFeature = _repositorioDocumentosVendasServicos.userFeature()

            Using rp As New RepositorioDocumentosVendasServicos
                docServMOD.Servicos.Add(rp.AddSubServico())
            End Using
            'preenche flag se UtilizaConfigDescontos
            Using rpIVA As New RepositorioIVA
                docServMOD.UtilizaConfigDescontos = rpIVA.UtilizaConfigDescontos
            End Using
            'return view
            Return resAR
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult
            Dim resAR As ActionResult = MyBase.Edita(ID)
            Dim docServMOD As DocumentosVendasServicos = DirectCast(DirectCast(resAR, System.Web.Mvc.PartialViewResult).Model, DocumentosVendasServicos)
            'set view bags
            Using rp As New RepositorioDocumentosVendasServicos
                ViewBag.BlnExitemEntidade1ou2 = rp.BlnExitemEntidade1ou2(ID)
                ViewBag.BlnExistemDocsAssociados = rp.BlnExistemDocsAssociados(ID)
            End Using
            'preenche flag se UtilizaConfigDescontos
            Using rpIVA As New RepositorioIVA
                docServMOD.UtilizaConfigDescontos = rpIVA.UtilizaConfigDescontos
            End Using

            Dim lstAcessos = (New RepositorioPerfisAcessosEmpresa()).ListaMenusAreasEmpresaPorDescricao("TiposDocumento")
            Dim acesso = lstAcessos.FirstOrDefault(Function(e) e.IDLinhaTabela = 2)
            ViewBag.blnAdiantamentos = If(acesso IsNot Nothing, acesso.Consultar, False)

            'tutorial de 1ª utilização
            docServMOD.isNewUserOnFeature = _repositorioDocumentosVendasServicos.userFeature()

            'return view
            Return resAR
        End Function

#Region "Duplica"

        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Overrides Function Duplica(ID As Long, IDVista As Long, inObjFiltro As ClsF3MFiltro, CampoValorPorDefeito As String, IDDuplica As Long) As ActionResult
            Dim res As ActionResult = MyBase.Edita(IDDuplica)

            Dim servicoDuplicado As DocumentosVendasServicos = DirectCast(DirectCast(res, PartialViewResult).Model, DocumentosVendasServicos)
            servicoDuplicado = RetornaModeloDuplicado(servicoDuplicado, IDDuplica)

            Return View(DocsVendasServicosViewsPath + "Adiciona.vbhtml", servicoDuplicado)
        End Function

        Private Function RetornaModeloDuplicado(modeloDuplicado As DocumentosVendasServicos, ByVal idDocDuplica As Long) As DocumentosVendasServicos
            With modeloDuplicado
                .ID = 0
                .AcaoFormulario = AcoesFormulario.Adicionar

                TrataDocumentoDuplicado(modeloDuplicado)
                TrataEstadoDuplicado(modeloDuplicado)
                TrataCargaDescargaDuplicado(modeloDuplicado)

                TrataLinhasServicoDuplicado(modeloDuplicado)

                .Assinatura = Nothing
                .DataAssinatura = Nothing

                .Observacoes = String.Empty

                .flgDocEstaEmDuplicacao = True
                .flgEditaDados = True
                .flgEEditavelEntidade = True
            End With

            Return modeloDuplicado
        End Function

        Private Sub TrataDocumentoDuplicado(ByRef modeloDuplicado As DocumentosVendasServicos)
            With modeloDuplicado
                .NumeroDocumento = 0
                .VossoNumeroDocumento = String.Empty
                .SerieDocManual = String.Empty
                .NumeroDocManual = String.Empty
                .Documento = If(String.IsNullOrEmpty(.CodigoTipoDocumento), String.Empty, .CodigoTipoDocumento & " " & .CodigoTipoDocumentoSerie & "/")
                .DataDocumento = Now()

                .flgPermiteEditarTipoDoc = True
                .RegistoBloqueado = False
            End With
        End Sub

        Private Sub TrataEstadoDuplicado(ByRef modeloDuplicado As DocumentosVendasServicos)
            If modeloDuplicado.CodigoTipoEstado <> TiposEstados.Anulado Then
                ViewBag.IDEstadoInicial = modeloDuplicado.IDEstado
                ViewBag.DescricaoEstadoInicialDefeito = modeloDuplicado.DescricaoEstado
            Else
                ViewBag.IDEstadoInicial = 0
                ViewBag.DescricaoEstadoInicialDefeito = String.Empty
            End If
        End Sub

        Private Sub TrataCargaDescargaDuplicado(ByRef modeloDuplicado As DocumentosVendasServicos)
            If Not modeloDuplicado.AcompanhaBensCirculacao Then
                With modeloDuplicado
                    .MoradaCarga = String.Empty
                    .IDCodigoPostalCarga = Nothing
                    .DescricaoCodigoPostalCarga = String.Empty
                    .LocalCarga = String.Empty
                    .IDConcelhoCarga = Nothing
                    .DescricaoConcelhoCarga = String.Empty
                    .IDDistritoCarga = Nothing
                    .DescricaoDistritoCarga = String.Empty
                    .IDPaisCarga = Nothing
                    .DescricaoPaisCarga = String.Empty
                    .DataCarga = Nothing
                    .HoraCarga = Nothing
                    .Matricula = String.Empty

                    .MoradaDescarga = String.Empty
                    .IDCodigoPostalDescarga = Nothing
                    .DescricaoCodigoPostalDescarga = String.Empty
                    .LocalDescarga = String.Empty
                    .IDConcelhoDescarga = Nothing
                    .DescricaoConcelhoDescarga = String.Empty
                    .IDDistritoDescarga = Nothing
                    .DescricaoDistritoDescarga = String.Empty
                    .IDPaisDescarga = Nothing
                    .DescricaoPaisDescarga = String.Empty
                    .DataDescarga = Nothing
                    .HoraDescarga = Nothing
                End With
            End If
        End Sub

        Private Sub TrataLinhasServicoDuplicado(ByRef modeloDuplicado As DocumentosVendasServicos)
            Dim diversos As List(Of DocumentosVendasLinhas) = modeloDuplicado.Diversos
            Dim servicosFases As List(Of ServicosFases) = modeloDuplicado.ServicoFases
            Dim servicos As List(Of Servicos) = modeloDuplicado.Servicos

            For Each diverso In diversos
                With diverso
                    .ID = 0
                    .AcaoCRUD = 0
                    .AcaoFormulario = AcoesFormulario.Adicionar
                    .IDDocumento = 0
                    .IDDocumentoOrigem = 0
                    .DocumentoOrigem = Nothing
                    .IDServico = 0
                End With
            Next

            For Each servicoFase In servicosFases
                With servicoFase
                    servicoFase.IDServico = 0

                    For Each fase In servicoFase.Fases
                        With fase
                            .ID = 0
                            .AcaoCRUD = 0
                            .AcaoFormulario = AcoesFormulario.Adicionar
                            .IDServico = 0
                        End With
                    Next
                End With
            Next

            Dim index As Short = 0
            For Each servico In servicos
                With servico
                    .ID = index
                    .AcaoCRUD = 0
                    .IDDocumentosVendasServicosSubstituicaoArtigos = 0

                    For Each artigo In servico.Artigos
                        With artigo
                            .Id = 0
                            .IDServico = 0
                        End With
                    Next

                    For Each diverso In servico.Diversos
                        With diverso
                            .ID = 0
                            .AcaoCRUD = 0
                            .AcaoFormulario = AcoesFormulario.Adicionar
                            .IDDocumento = Nothing
                            .IDDocumentoVenda = Nothing
                            .IDDocumentoOrigem = Nothing
                            .DocumentoOrigem = Nothing
                            .IDServico = Nothing
                        End With
                    Next

                    For Each linhaVenda In servico.DocumentosVendasLinhas
                        With linhaVenda
                            .ID = 0
                            .AcaoCRUD = 0
                            .AcaoFormulario = AcoesFormulario.Adicionar
                            .IDDocumento = Nothing
                            .IDDocumentoVenda = Nothing
                            .IDDocumentoOrigem = Nothing
                            .DocumentoOrigem = Nothing
                            .IDServico = 0
                        End With
                    Next

                    For Each graduacao In servico.DocumentosVendasLinhasGraduacoes
                        With graduacao
                            .ID = 0
                            .AcaoCRUD = 0
                            .AcaoFormulario = AcoesFormulario.Adicionar
                            .IDDocumento = Nothing
                            .IDDocumentoOrigem = Nothing
                            .DocumentoOrigem = Nothing
                            .IDDocumentoVenda = Nothing
                            .IDDocumentoVendaLinha = Nothing
                        End With
                    Next
                End With
                index = index + 1
            Next
        End Sub

#End Region

#End Region

#Region "ACOES DE ESCRITA"

#End Region

#Region "ACOES DE LEITURA"
        Public Overrides Function Visualiza(Optional inObjFiltro As ClsF3MFiltro = Nothing, Optional ByVal ID As Long = 0) As ActionResult
            ViewBag.IDDocumentoVenda = ID
            Return RetornaAcoes(ID, AcoesFormulario.Consultar)
        End Function

        <F3MAcesso>
        Public Function IndexGrelhaEspecifico(Optional ByVal IDVista As Long = 0) As ActionResult
            Return MyBase.IndexGF(IDVista, True)
        End Function

        '' LEITURA PARA AS GRELHAS
        '<F3MAcesso>
        'Public Overrides Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
        '    Try
        '        Dim result As DataSourceResult = Nothing
        '
        '        Dim listvendas As List(Of DocumentosVendasServicos) = Nothing
        '
        '        Using rep As New RepositorioDocumentosVendasServicos
        '            listvendas = rep.Lista(inObjFiltro).ToList()
        '        End Using
        '
        '        'If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, "015.005.003") Then
        '        '    listvendas = listvendas.Where(Function(f) f.IDLoja = ClsF3MSessao.RetornaLojaID)
        '        'End If
        '
        '        Return RetornaJSONTamMaximo(MyBase.RetornaDataSourceResult(request, inObjFiltro, listvendas))
        '    Catch ex As Exception
        '        Return RetornaJSONErrosTamMaximo(ex)
        '    End Try
        'End Function

        ' LEITURA PARA A COMBO/DDL
        <F3MAcesso>
        Public Function ListaArtigosComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of Oticas.Artigos) = Nothing

                Using rep As New RepositorioDocumentosVendasServicos
                    result = rep.ListaArtigosComboCodigo(inObjFiltro)
                End Using

                Return Json(result, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que adiciona um sub servico
        ''' </summary>
        ''' <param name="modelo"></param>
        ''' <param name="IDTipoServico"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Function AddSubServico(modelo As Servicos, Optional ByVal IDTipoServico As Long = 0) As JsonResult
            Try
                Dim result As New Servicos

                Using rp As New RepositorioDocumentosVendasServicos
                    If modelo IsNot Nothing Then
                        result = rp.AddSubServicoByModel(modelo)
                    Else
                        result = rp.AddSubServico(IDTipoServico)
                    End If
                End Using

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function ValidaExisteArtigo(modelo As DocumentosVendasServicos, servico As Servicos, objfiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As New Servicos
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 0 " & Now.ToString(“HH:mm:ss.fff”))
                Using rp As New RepositorioDocumentosVendasServicos
                    result = rp.ValidaExisteArtigo(modelo, servico, objfiltro)
                End Using
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 100 " & Now.ToString(“HH:mm:ss.fff”))
                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function ValidaEstado(ByVal inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendas) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendasServicos
                    rp.ValidaEstado(inObjFiltro, modelo)
                End Using

                Return RetornaJSONTamMaximo(modelo)

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Function Calcula(inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendasServicos) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendasServicos
                    modelo = rp.Calcula(inObjFiltro, modelo)
                End Using
                Return RetornaJSONTamMaximo(modelo)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function BlnExistemDocsVendasPendentes(IDDocumentoVenda As Long, IDEntidade As Long, IDMoeda As Long) As JsonResult
            Try
                Dim blnResult As Boolean = False

                Using rp As New RepositorioDocumentosVendasPendentes
                    blnResult = If(rp.GetDocumentosVendasPendentes(IDDocumentoVenda, IDEntidade, IDMoeda).Count > 0, True, False)
                End Using

                Return RetornaJSONTamMaximo(blnResult)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function PreencherIncidencias(inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendasServicos) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendasServicos
                    Return RetornaJSONTamMaximo(rp.PreencherIncidencias(inObjFiltro, modelo))
                End Using
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function LerDocumentosAssociados(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendasServicos

                    Dim t As DocumentosVendas = rp.LerDocumentosAssociados(inObjFiltro)

                    Return RetornaJSONTamMaximo(t)
                End Using
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function BlnPodeAdiantar(IDDocumentoVenda As Long) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendas
                    If Not rp.EDocumentoEfetivo(IDDocumentoVenda) Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.DocNaoEfetivo, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    If Not rp.VerificaValorPago(IDDocumentoVenda) Then
                        Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.DocPago, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                    End If

                    Using rp2 As New RepositorioDocumentosVendasServicos
                        If rp2.BlnExitemEntidade1ou2(IDDocumentoVenda) AndAlso Not rp2.BlnExistemDocsAssociados(IDDocumentoVenda) Then
                            Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaErros.PagarTemQueGerarDocumentoVenda, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If
                    End Using

                    Using rp2 As New RepositorioDocumentosVendasServicos
                        If rp2.BlnDocumentoServicoDIFF(IDDocumentoVenda) Then
                            Return New JsonResult() With {.Data = New With {.Errors = "Linhas do serviço diferentes do documento de venda. Para poder pagar tem que selecionar o documento de venda.", .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                        End If
                    End Using

                    Return RetornaJSONTamMaximo(True)
                End Using

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function BlnTemRecebimentos(IDDocumentoVenda As Long) As JsonResult
            Try
                Using rp As New RepositorioPagamentosVendas
                    Return RetornaJSONTamMaximo(rp.GetPagamentosVendasServicos(IDDocumentoVenda).Count > 0)
                End Using

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function UpdateSegundaVia(Tabela As String, IDDocumento As Long) As JsonResult
            Try
                F3M.Repositorio.UtilitariosComum.RepositorioRazoes.UpdateSegundaVia(repositorio.BDContexto, Tabela, IDDocumento, 0)
                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que verifica se o servico esta no estado efetivo
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function BlnEEfetivo(IDDocumentoVenda As Long) As JsonResult
            Try
                Using rp As New RepositorioDocumentosVendas
                    Return RetornaJSONTamMaximo(rp.EDocumentoEfetivo(IDDocumentoVenda))
                End Using

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        Public Function ImportaSubServicos(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim lstServicos As New List(Of DocumentosVendasServicos)

                Using rpServicos As New RepositorioDocumentosVendasServicos
                    Dim idCliente As Long = 0

                    If ClsUtilitarios.TemKeyDicionario(inObjFiltro.CamposFiltrar, "IDCliente") Then
                        idCliente = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDCliente", GetType(Long))
                    End If

                    lstServicos = rpServicos.ObtemListaSubServicosImportar(idCliente)
                End Using

                Dim result As DataSourceResult = RetornaDataSourceResult(request, inObjFiltro, lstServicos)

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

#End Region

#Region "ADICIONA ESPECIFICO"
        ''' <summary>
        ''' Funcao de post para o adicona especifico
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="filtro"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Public Function AdicionaEsp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosVendasServicos, filtro As ClsF3MFiltro) As JsonResult
            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

        ''' <summary>
        ''' Funcao adiciona espedifica (quando vem de clientes)
        ''' </summary>
        ''' <param name="IDEntidade"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpGet>
        Public Function AdicionaEsp(Optional ByVal IDEntidade As Long = 0) As ActionResult
            If IDEntidade <> 0 Then
                'return esp
                Return AdicionaEspFromClientesToSV(IDEntidade)
            End If
            'return gen
            Return Me.Adiciona()
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona quando vem de clientes para servicos
        ''' </summary>
        ''' <param name="inIDEntidade"></param>
        ''' <returns></returns>
        Private Function AdicionaEspFromClientesToSV(ByVal inIDEntidade As Long) As ActionResult
            'preenche o tipo doc por defeito
            Dim resAr As ActionResult = Me.Adiciona()
            Dim docServMOD As DocumentosVendasServicos = DirectCast(resAr, System.Web.Mvc.PartialViewResult).Model
            'preenche entidade por defeito
            Using rpDocsVendas As New RepositorioDocumentosVendasServicos
                rpDocsVendas.ImportarClientesToServico(inIDEntidade, docServMOD)
            End Using
            'preenche flag se UtilizaConfigDescontos
            Using rpIVA As New RepositorioIVA
                docServMOD.UtilizaConfigDescontos = rpIVA.UtilizaConfigDescontos
            End Using
            'return view
            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAr, PartialViewResult).Model)
        End Function
#End Region

#Region "FASES"
        <F3MAcesso>
        Public Function CrudFasesAndRefreshHistory(model As DocumentosVendasServicosFases) As JsonResult
            Try
                Using rpDocumentosVendasServicos As New RepositorioDocumentosVendasServicosFases
                    Return RetornaJSONTamMaximo(rpDocumentosVendasServicos.CRUD(model))
                End Using

                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace
