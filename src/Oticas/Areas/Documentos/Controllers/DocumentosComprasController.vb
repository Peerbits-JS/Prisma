Imports Kendo.Mvc.UI
Imports F3M.Areas.Documentos.Controllers
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports Oticas.Repositorio.Documentos
Imports F3M.Modelos.Utilitarios

Namespace Areas.Documentos.Controllers
    Public Class DocumentosComprasController
        Inherits DocumentosController(Of BD.Dinamica.Aplicacao, tbDocumentosCompras, DocumentosCompras)

        Const DocsComumViewsPath = "~/F3M/Areas/DocumentosComum/Views/"
        Const DocsComprasViewsPath As String = "~/Areas/Documentos/Views/DocumentosCompras/"

        ReadOnly _repositorioDocumentosCompras As RepositorioDocumentosCompras

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosCompras)
            _repositorioDocumentosCompras = repositorio
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ''' <summary>
        ''' ActionResult - Adiciona
        ''' </summary>
        ''' <param name="CampoValorPorDefeito"></param>
        ''' <param name="IDVista"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Return MyBase.AdicionaPorDefeito(Of tbEstados, tbTiposDocumentoTipEntPermDoc, tbTiposDocumentoSeries, tbParametrosEmpresa, tbSistemaTiposDocumentoColunasAutomaticas)(
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosCompras, TiposEntidade.Fornecedores,
                SistemaCodigoModulos.Compras, Menus.Fornecedores, CampoValorPorDefeito, IDVista)
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosCompras, filtro As ClsF3MFiltro) As JsonResult
            Using rep As New RepositorioDocumentosCompras
                rep.PreencheDadosLoja(modelo)
            End Using
            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosCompras, filtro As ClsF3MFiltro) As JsonResult
            Using rep As New RepositorioDocumentosCompras
                rep.DefineCamposEvitaMapear(modelo)
            End Using
            Return MyBase.Edita(request, modelo, filtro)
        End Function
#End Region

#Region "ACOES DE LEITURA"
#End Region

#Region "ACOES DE LEITURA IMPORTACAO"
        <F3MAcesso>
        Public Function ListaDocsImportacao(inDSReq As DataSourceRequest, inIDEntidade As Long?, inIDMoeda As Long?, inIDTipoDoc As Long?,
                                            inCodTipoDocSist As String, inTipoFiscal As String, inIDSerie As Long?, inLstDocLinhas As String) As JsonResult
            Return ImportacaoListaDocs(Of tbDocumentosComprasLinhas, tbTiposDocumento, tbTiposDocumentoSeries)(
                repositorio.BDContexto, inDSReq, inIDEntidade, inIDMoeda, inIDTipoDoc, inCodTipoDocSist, inTipoFiscal, inIDSerie,
                inLstDocLinhas, CamposGenericos.IDDocCompra)
        End Function

        <F3MAcesso>
        Public Function ListaDocLinhasImportacao(inDSReq As DataSourceRequest, inCodModulo As String, inLstDocsComp As String,
                                                 inLstDocLinhasComp As String, inIDTipoDoc As Long?) As JsonResult
            Return ImportacaoListaDocLinhas(Of tbDocumentosComprasLinhas, DocumentosComprasLinhas, tbTiposDocumento)(
                repositorio.BDContexto, inDSReq, inCodModulo, inLstDocsComp, inLstDocLinhasComp, inIDTipoDoc, CamposGenericos.IDDocCompra)
        End Function

        <F3MAcesso>
        Public Function ImportaDocsLinhas(inObjFiltro As ClsF3MFiltro, inIDTipoDoc As Long?, inLstDocsComp As String, inLstDocLinhasComp As String) As JsonResult
            Try
                Dim lstLinhasDocCompras As List(Of DocumentosComprasLinhas) = Nothing

                Dim lstDocumentos As List(Of DocumentosCompras) = LZString.RetornaListaModelosDescomp(Of DocumentosCompras)(inLstDocsComp)
                Dim lstLinhasDocumentos As List(Of DocumentosComprasLinhas) = LZString.RetornaListaModelosDescomp(Of DocumentosComprasLinhas)(inLstDocLinhasComp)

                lstLinhasDocCompras = RepositorioDocumentosCompras.ListaDocsLinhas(Of tbDocumentosCompras, DocumentosCompras, tbDocumentosComprasLinhas, DocumentosComprasLinhas)(
                        repositorio.BDContexto, inObjFiltro, lstDocumentos, lstLinhasDocumentos, inIDTipoDoc, CamposGenericos.IDDocCompra, CamposGenericos.IDDocCompraLin)

                Return RetornaJSONTamMaximo(lstLinhasDocCompras)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
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
                Dim docMOD As DocumentosCompras = LZString.DecompressModelFromBase64(Of DocumentosCompras)(inModeloStr)

                RepositorioDocumentosCompras.CalculaGeralDoc(Of tbDocumentosCompras, DocumentosCompras, tbDocumentosComprasLinhas, DocumentosComprasLinhas)(repositorio.BDContexto, docMOD, inColunaAlterada)

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
        Public Function DaTotaisDocumento(inModeloStr As String, Optional ByVal inCampoAlterado As String = "") As JsonResult
            Return MyBase.DaTotaisDoc(Of DocumentosComprasLinhas, tbClientes)(repositorio.BDContexto, inModeloStr, inCampoAlterado)
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
                DocumentosComprasLinhas)(repositorio.BDContexto, inModeloStr, objFiltro)
        End Function

        ''' <summary>
        ''' Função que preenche as incidências
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function PreencherIncidencias(inModeloStr As String) As JsonResult
            Return MyBase.PreencheIncidenciasDoc(Of DocumentosComprasLinhas)(repositorio.BDContexto, inModeloStr)
        End Function

        ''' <summary>
        ''' funcao que verifica se o documento e 2ª via
        ''' </summary>
        ''' <param name="IDDocumento"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function DocumentoSegundaVia(IDDocumento As Long) As JsonResult
            Return MyBase.SegundaViaDoc(repositorio.BDContexto, IDDocumento)
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
            ModDuplica = _repositorioDocumentosCompras.RetornaModSelectTipoDocDuplica(IDDuplica)

            Return View(DocsComumViewsPath & "DocumentosSelectTipoDocDuplicar/Index.vbhtml", ModDuplica)
        End Function

        ''' <summary>
        ''' Funcao para a duplicacao docs compras
        ''' </summary>
        ''' <param name="IDDuplica"></param>
        ''' <param name="IDTipoDocumento"></param>
        ''' <param name="IDTipoDocumentoSeries"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Function DuplicaComprimidoBase64Esp(IDDuplica As Long, IDTipoDocumento As Long, IDTipoDocumentoSeries As Long) As String
            Dim objActionRes As PartialViewResult = MyBase.DuplicaDocs(Of Oticas.DocumentosCompras,
                Oticas.DocumentosComprasLinhas,
                tbEstados,
                tbTiposDocumento,
                tbTiposDocumentoSeries)(repositorio.BDContexto, IDDuplica, IDTipoDocumento, IDTipoDocumentoSeries, TiposEntidadeEstados.DocumentosCompras)

            Dim ModDocCompra As Oticas.DocumentosCompras = DirectCast(DirectCast(objActionRes, PartialViewResult).Model, Oticas.DocumentosCompras)

            'reset values especifico docs compras
            With ModDocCompra

            End With

            Return LZString.CompressViewtoBase64(Of Oticas.DocumentosCompras)(objActionRes, ControllerContext, DocsComprasViewsPath & "Adiciona.vbhtml")
        End Function

        ''' <summary>
        ''' Json result -> DuplicaComprimido especifico docs compras
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <HttpPost>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overridable Function DuplicaComprimidoBase64Esp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As String, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim modDoc As Oticas.DocumentosCompras = LZString.DecompressModelFromBase64(Of Oticas.DocumentosCompras)(modelo)
            Dim jsonRes As JsonResult = Adiciona(request, modDoc, inObjFiltro)

            LZString.CompressJSONDataToBase64(jsonRes)

            Return jsonRes
        End Function
#End Region
    End Class
End Namespace