Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Areas.Documentos.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.Documentos
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasController
        Inherits DocumentosController(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendas)

        Const DocsComumViewsPath = "~/F3M/Areas/DocumentosComum/Views/"
        Const DocsVendasViewsPath As String = "~/Areas/Documentos/Views/DocumentosVendas/"

        ReadOnly _repositorioDocumentosVendas As RepositorioDocumentosVendas
        ReadOnly _repositorioDocumentosVendasServicos As RepositorioDocumentosVendasServicos
        ReadOnly _repositorioDocumentosVendasPendentes As RepositorioDocumentosVendasPendentes
        ReadOnly _repositorioPagamentosVendas As RepositorioPagamentosVendas

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosVendas)

            _repositorioDocumentosVendas = repositorio
            _repositorioDocumentosVendasServicos = New RepositorioDocumentosVendasServicos
            _repositorioDocumentosVendasPendentes = New RepositorioDocumentosVendasPendentes
            _repositorioPagamentosVendas = New RepositorioPagamentosVendas
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional ByVal IDVista As Long = 0) As ActionResult
            Dim CampoValorPorDefeitoAux As String = CampoValorPorDefeito
            If String.IsNullOrEmpty(CampoValorPorDefeito) Then CampoValorPorDefeito = "FT"

            Dim resAR As ActionResult = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
                SistemaCodigoModulos.Vendas, Menus.Clientes, CampoValorPorDefeito, IDVista)

            ViewBag.EEditavelEntidade2 = False

            'TODO - VER +
            If CampoValorPorDefeitoAux = TiposDocumentosFiscal.Fatura Then ViewBag.FiltrarTipoDocumentos = "ftfsfr"

            If CampoValorPorDefeitoAux = TiposDocumentosFiscal.NotaCredito Then
                ViewBag.FiltrarTipoDocumentos = "nc"
                ViewBag.ENotaCredito = True
            End If
            'END TODO

            Return resAR
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosVendas, filtro As ClsF3MFiltro) As JsonResult
            modelo.IDLojaSede = ClsF3MSessao.RetornaIDLojaSede()
            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

#End Region

#Region "ACOES DE LEITURA"
        <F3MAcesso>
        Public Function ListaEspByID(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendas.ListaEspByID(inObjFiltro).ToDataSourceResult(request))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function ValidaEstado(ByVal inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendas) As JsonResult
            Try
                _repositorioDocumentosVendas.ValidaEstado(inObjFiltro, modelo)

                Return RetornaJSONTamMaximo(modelo)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function LerDocumentosAssociados(modelo As DocumentosVendas, objetoFiltro As ClsF3MFiltro) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendasServicos.LerDocumentosAssociados(objetoFiltro))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que retorna se existe alguma NCDA com o documento como origem
        ''' </summary>
        ''' <param name="idDocumentoOrigem"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function Retorna_DocNCDA(idDocumentoOrigem As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendas.Retorna_DocNCDA(idDocumentoOrigem))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "CALCULOS"
        ''' <summary>
        ''' Função para efetuar a inicialização dos valores, o calculo dos totais de linha e do documento
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <param name="inColunaAlterada"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function CalculaGeralDocumento(inModeloStr As String, inColunaAlterada As String) As JsonResult
            Try
                Dim docMOD As DocumentosStock = LZString.DecompressModelFromBase64(Of DocumentosStock)(inModeloStr)

                RepositorioDocumentosVendas.CalculaGeralDoc(Of tbDocumentosVendas, DocumentosVendas, tbDocumentosVendasLinhas, DocumentosVendasLinhas)(repositorio.BDContexto, docMOD, inColunaAlterada)

                Return RetornaJSONTamMaximo(LZString.RetornaModeloComp(docMOD))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Função para efetuar o calculo dos totais do documento
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <param name="inCampoAlterado"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function DaTotaisDocumento(inModeloStr As String, Optional ByVal inCampoAlterado As String = "", Optional ByVal ELinhasTodas As Boolean = False) As JsonResult
            Try
                Dim modelo As DocumentosVendas = LZString.DecompressModelFromBase64(Of DocumentosVendas)(inModeloStr)
                Dim inFiltro As New ClsF3MFiltro

                Dim dict As New Dictionary(Of String, String) From {{"CampoValor", inCampoAlterado}, {"CampoTexto", inCampoAlterado}}
                Dim dictionary As New Dictionary(Of String, Dictionary(Of String, String)) From {{"CampoAlterado", dict}}

                inFiltro.CamposFiltrar = dictionary
                inFiltro.AddCampoValor("ELinhasTodas", ELinhasTodas, "ElinhasTodas")

                _repositorioDocumentosVendas.Calcula(inFiltro, modelo)

                Return RetornaJSONTamMaximo(LZString.CompressModelToBase64(modelo))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao de Calculo
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <param name="modelo"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function Calcula(inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendas) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendas.Calcula(inObjFiltro, modelo))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        ''' <summary>
        ''' Função que preenche a carga e descarga por defeito
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <param name="objFiltro"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function PreencheCargaDescarga(inModeloStr As String, objFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.PreencheCargaDescargaDoc(Of tbTiposDocumento, tbClientesMoradas, tbFornecedoresMoradas, tbArmazens,
                DocumentosVendasLinhas)(repositorio.BDContexto, inModeloStr, objFiltro)
        End Function

        ''' <summary>
        ''' Função para preencher Incidências
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        <F3MAcesso>
        Public Function PreencherIncidencias(inModeloStr As String) As JsonResult
            Return MyBase.PreencheIncidenciasDoc(Of DocumentosVendasLinhas)(repositorio.BDContexto, inModeloStr)
        End Function

        ''' <summary>
        ''' funcao que verifica se o documento e 2ª via
        ''' </summary>
        ''' <param name="IDDocumento"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function DocumentoSegundaVia(IDDocumento As Long) As JsonResult
            'Tipos de documentos que não deve pedir a segunda via
            Dim whereSqlTiposDoc As String = "(STD.Tipo = 'VndTransporte' AND STDF.Tipo in ('GD', 'NF')) OR (STD.Tipo = 'VndFinanceiro' AND STDF.Tipo = 'NF')"
            Dim segundaVia As Integer

            Using repoDV As New F3M.Repositorio.Comum.RepositorioDocumentos
                segundaVia = repoDV.ImprimirSegundaVia(Of tbDocumentosVendas)(repositorio.BDContexto, IDDocumento, whereSqlTiposDoc)
            End Using

            If segundaVia > 0 Then
                Return RetornaJSONTamMaximo(False)
            Else
                Return MyBase.SegundaViaDoc(repositorio.BDContexto, IDDocumento)
            End If
        End Function

        ''' <summary>
        ''' Funcao que verifica se existem docs vendas pendentes associados ao doc venda
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <param name="IDEntidade"></param>
        ''' <param name="IDMoeda"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function BlnExistemDocsVendasPendentes(IDDocumentoVenda As Long, IDEntidade As Long, IDMoeda As Long) As JsonResult
            Try
                If _repositorioDocumentosVendas.EDocumentoAnulado(IDDocumentoVenda) Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocAnulado, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

                ElseIf _repositorioDocumentosVendas.EDocumentoRascunho(IDDocumentoVenda) Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocRascunho, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}

                ElseIf Not _repositorioDocumentosVendas.VerificaValorPago(IDDocumentoVenda) Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocPago, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                Dim blnResult = If(_repositorioDocumentosVendasPendentes.GetDocumentosVendasPendentes(IDDocumentoVenda, IDEntidade, IDMoeda).Count > 0, True, False)
                If Not blnResult Then
                    Return New JsonResult() With {.Data = New With {.Errors = Traducao.EstruturaAplicacaoTermosBase.DocNaoFinanceiro, .TipoAlerta = "i"}, .JsonRequestBehavior = JsonRequestBehavior.AllowGet}
                End If

                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function BlnExistemDocsVendasPagamentos(IDDocumentoVenda As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(If(_repositorioPagamentosVendas.GetPagamentosVendas(IDDocumentoVenda).Count > 0, True, False))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function ValidaDocumento_FROMPagamentos(modelo As DocumentosVendas) As JsonResult
            Try
                _repositorioDocumentosVendas.ValidarDocumento(repositorio.BDContexto, modelo)
                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que retorna o id da nota de credito ou 0 se nao existir
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function LerNCExistentes(IDDocumentoVenda As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendas.LerNCExistentes(IDDocumentoVenda))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function


        ''' <summary>
        ''' Function that returns document sale nca id from document sale 
        ''' </summary>
        ''' <param name="documentSaleId"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function GetDocumentSaleNcaId(documentSaleId As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioDocumentosVendas.GetDocumentSaleNcaId(documentSaleId))
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
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar), HttpPost>
        Public Function AdicionaEsp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosVendas, filtro As ClsF3MFiltro) As JsonResult
            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

        ''' <summary>
        ''' Funcao adiciona espedifica (quando vem de clientes, docs vendas, etc)
        ''' </summary>
        ''' <param name="IDEntidade"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar), HttpGet>
        Public Function AdicionaEsp(Optional ByVal IDEntidade As Long = 0,
                                    Optional ByVal IDDocumentoVenda As Long = 0,
                                    Optional ByVal IDServico As Long = 0,
                                    Optional ByVal IDServicoToFT2 As Long = 0) As ActionResult

            If IDEntidade <> 0 Then
                Return AdicionaEspFromClientesToDV(IDEntidade)

            ElseIf IDDocumentoVenda <> 0 Then
                Return AdicionaEspFromDocsVendasToNC(IDDocumentoVenda)

            ElseIf IDServico <> 0 Then
                Return AdicionaEspFromServicosToDV(IDServico)

            ElseIf IDServicoToFT2 <> 0 Then
                Return AdicionaEspFromServicosToFT2(IDServicoToFT2)
            End If

            Return AdicionaEspFromEspToGen()
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona que executa a funcao generica de adicionar
        ''' </summary>
        ''' <returns></returns>
        Private Function AdicionaEspFromEspToGen() As ActionResult
            Dim resAR As ActionResult = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
                SistemaCodigoModulos.Vendas, Menus.Clientes, String.Empty, 0)

            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAR, PartialViewResult).Model)
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona quando vem de clientes para documentos de venda
        ''' </summary>
        ''' <param name="inIDEntidade"></param>
        ''' <returns></returns>
        Private Function AdicionaEspFromClientesToDV(ByVal inIDEntidade As Long) As ActionResult
            'preenche o tipo doc por defeito
            Dim resAR As ActionResult = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
             repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
             SistemaCodigoModulos.Vendas, Menus.Clientes, TiposDocumentosFiscal.Fatura, 0)

            _repositorioDocumentosVendas.ImportarClientesToDocVenda(inIDEntidade, DirectCast(resAR, PartialViewResult).Model)

            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAR, PartialViewResult).Model)
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona quando vem de servicos para documentos de venda
        ''' </summary>
        ''' <param name="inIDServico"></param>
        ''' <returns></returns>
        Private Function AdicionaEspFromServicosToDV(ByVal inIDServico As Long) As ActionResult
            'ActionResult's instance
            Dim resAR As ActionResult

            'verifica se tem adiantamentos
            Dim countAdi As Short = 0
            'Using rpPagamentosVendas As New RepositorioPagamentosVendas
            '    countAdi = 0 'RpPagamentosVendas.GetPagamentosVendasServicos(inIDServico).Where(Function(w) w.CodigoTipoEstado <> TiposEstados.Anulado AndAlso w.Recibo Is Nothing).Count()
            'End Using

            'If countAdi > 0 Then
            '    'preenche o tipo doc por defeito
            '    resAR = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
            '     repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
            '     SistemaCodigoModulos.Vendas, Menus.Clientes, "FromServicosToDVWithAdiantamentos", 0)
            '
            'Else
            'preenche o tipo doc por defeito
            resAR = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
                SistemaCodigoModulos.Vendas, Menus.Clientes, TiposDocumentosFiscal.Fatura, 0)
            'End If

            _repositorioDocumentosVendas.ImportarServicoToDV(inIDServico, DirectCast(resAR, PartialViewResult).Model)

            'se tiver adiantamentos não permite editar o tipo doc e a serie
            With DirectCast(DirectCast(resAR, PartialViewResult).Model, DocumentosVendas)
                .flgPermiteEditarTipoDoc = countAdi = 0
                .IDDocumentoVendaServico = inIDServico
            End With

            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAR, PartialViewResult).Model)
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona quando vem de documentos de venda para documentos de venda (notas de credito)
        ''' </summary>
        ''' <param name="inIDDocumentoVenda"></param>
        ''' <returns></returns>
        Private Function AdicionaEspFromDocsVendasToNC(ByVal inIDDocumentoVenda As Long) As ActionResult
            'preenche o tipo doc por defeito
            Dim resAR As ActionResult = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
             repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
             SistemaCodigoModulos.Vendas, Menus.Clientes, TiposDocumentosFiscal.NotaCredito, 0)

            _repositorioDocumentosVendas.ImportarDocVendaToNC(inIDDocumentoVenda, DirectCast(resAR, PartialViewResult).Model)

            ViewBag.FiltrarTipoDocumentos = "nc"
            ViewBag.ENotaCredito = True

            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAR, PartialViewResult).Model)
        End Function

        ''' <summary>
        ''' Funcao especifica de adiciona quando vem de servico para a fatura da entidade 2
        ''' </summary>
        ''' <param name="inIDServico"></param>
        ''' <returns></returns>
        Private Function AdicionaEspFromServicosToFT2(ByVal inIDServico As Long) As ActionResult
            'preenche o tipo doc por defeito
            Dim resAR As ActionResult = MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
             repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosVenda, TiposEntidade.Clientes,
             SistemaCodigoModulos.Vendas, Menus.Clientes, TiposDocumentosFiscal.Fatura, 0)

            _repositorioDocumentosVendas.ImportarServicoToFT2(inIDServico, DirectCast(resAR, PartialViewResult).Model)

            Return View(DocsVendasViewsPath + "Adiciona.vbhtml", DirectCast(resAR, PartialViewResult).Model)
        End Function
#End Region

#Region "DUPLICA"
        ''' <summary>
        ''' Funcao que abre o pop up para escolher o tipo doc de destino
        ''' </summary>
        ''' <param name="IDDuplica"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Function SelectTipoDocDuplicar(IDDuplica As Long, IDEntidade As Long?) As ActionResult
            Dim ModDuplica As New F3M.DocumentosSelectTipoDocDuplicar
            ModDuplica = _repositorioDocumentosVendas.RetornaModSelectTipoDocDuplica(IDDuplica)

            Return View(DocsComumViewsPath & "DocumentosSelectTipoDocDuplicar/Index.vbhtml", ModDuplica)
        End Function

        ''' <summary>
        ''' Funcao para a duplicacao docs vendas
        ''' </summary>
        ''' <param name="IDDuplica"></param>
        ''' <param name="IDTipoDocumento"></param>
        ''' <param name="IDTipoDocumentoSeries"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Function DuplicaComprimidoBase64Esp(IDDuplica As Long, IDTipoDocumento As Long, IDTipoDocumentoSeries As Long) As String
            Dim objActionRes As PartialViewResult = MyBase.DuplicaDocs(Of Oticas.DocumentosVendas,
                Oticas.DocumentosVendasLinhas,
                tbEstados,
                tbTiposDocumento,
                tbTiposDocumentoSeries)(repositorio.BDContexto, IDDuplica, IDTipoDocumento, IDTipoDocumentoSeries, TiposEntidadeEstados.DocumentosVenda)

            Dim ModDocVenda As DocumentosVendas = DirectCast(DirectCast(objActionRes, PartialViewResult).Model, DocumentosVendas)

            'reset values especifico docs vendas
            With ModDocVenda
                .RazaoEstado = String.Empty
            End With

            Return LZString.CompressViewtoBase64(Of Oticas.DocumentosVendas)(objActionRes, ControllerContext, DocsVendasViewsPath & "Adiciona.vbhtml")
        End Function

        ''' <summary>
        ''' Json result -> DuplicaComprimido especifico docs vendas
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <HttpPost>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overridable Function DuplicaComprimidoBase64Esp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As String, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim modDoc As Oticas.DocumentosVendas = LZString.DecompressModelFromBase64(Of Oticas.DocumentosVendas)(modelo)
            Dim jsonRes As JsonResult = Adiciona(request, modDoc, inObjFiltro)

            LZString.CompressJSONDataToBase64(jsonRes)

            Return jsonRes
        End Function
#End Region
    End Class
End Namespace