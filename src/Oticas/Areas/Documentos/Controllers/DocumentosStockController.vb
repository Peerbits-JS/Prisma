Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Documentos.Controllers
Imports Oticas.Repositorio.Documentos
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports Kendo.Mvc.UI

Namespace Areas.Documentos.Controllers
    Public Class DocumentosStockController
        Inherits DocumentosController(Of BD.Dinamica.Aplicacao, tbDocumentosStock, DocumentosStock)

        Const DocsComumViewsPath = "~/F3M/Areas/DocumentosComum/Views/"
        Const DocsStockViewsPath As String = "~/Areas/Documentos/Views/DocumentosStock/"

        ReadOnly _repositorioDocumentosStock As RepositorioDocumentosStock

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosStock)

            _repositorioDocumentosStock = repositorio
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
                repositorio.BDContexto, Nothing, TiposEntidadeEstados.DocumentosStock, TiposEntidade.Clientes,
                SistemaCodigoModulos.Stocks, Menus.Clientes, CampoValorPorDefeito, IDVista)
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosStock, filtro As ClsF3MFiltro) As JsonResult
            Using rep As New RepositorioDocumentosStock
                rep.PreencheDadosLoja(modelo)
            End Using
            Return MyBase.Adiciona(request, modelo, filtro)
        End Function

        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosStock, filtro As ClsF3MFiltro) As JsonResult
            Using rep As New RepositorioDocumentosStock
                rep.DefineCamposEvitaMapear(modelo)
            End Using
            Return MyBase.Edita(request, modelo, filtro)
        End Function
#End Region

#Region "ACOES DE LEITURA"
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

                RepositorioDocumentosStock.CalculaGeralDoc(Of tbDocumentosStock, DocumentosStock, tbDocumentosStockLinhas, DocumentosStockLinhas)(repositorio.BDContexto, docMOD, inColunaAlterada)

                Return RetornaJSONTamMaximo(LZString.RetornaModeloComp(docMOD))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Função para efetuar o calculo dos totais do documento
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function DaTotaisDocumento(inModeloStr As String, Optional inCampoAlterado As String = "") As JsonResult
            Return MyBase.DaTotaisDoc(Of DocumentosStockLinhas, tbClientes)(repositorio.BDContexto, inModeloStr, inCampoAlterado)
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
                DocumentosStockLinhas)(repositorio.BDContexto, inModeloStr, objFiltro)
        End Function

        ''' <summary>
        ''' Função para preencher Incidências
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        <F3MAcesso>
        Public Function PreencherIncidencias(inModeloStr As String) As JsonResult
            Return MyBase.PreencheIncidenciasDoc(Of DocumentosStockLinhas)(repositorio.BDContexto, inModeloStr)
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
            ModDuplica = _repositorioDocumentosStock.RetornaModSelectTipoDocDuplica(IDDuplica)

            Return View(DocsComumViewsPath & "DocumentosSelectTipoDocDuplicar/Index.vbhtml", ModDuplica)
        End Function

        ''' <summary>
        ''' Funcao para a duplicacao doc stock 
        ''' </summary>
        ''' <param name="IDDuplica"></param>
        ''' <param name="IDTipoDocumento"></param>
        ''' <param name="IDTipoDocumentoSeries"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Function DuplicaComprimidoBase64Esp(IDDuplica As Long, IDTipoDocumento As Long, IDTipoDocumentoSeries As Long) As String
            Dim objActionRes As PartialViewResult = MyBase.DuplicaDocs(Of Oticas.DocumentosStock,
                Oticas.DocumentosStockLinhas,
                tbEstados,
                tbTiposDocumento,
                tbTiposDocumentoSeries)(repositorio.BDContexto, IDDuplica, IDTipoDocumento, IDTipoDocumentoSeries, TiposEntidadeEstados.DocumentosStock)

            Dim ModDocStock As Oticas.DocumentosStock = DirectCast(DirectCast(objActionRes, PartialViewResult).Model, Oticas.DocumentosStock)

            'reset values especifico doc stocks
            With ModDocStock

            End With

            Return LZString.CompressViewtoBase64(Of Oticas.DocumentosStock)(objActionRes, ControllerContext, DocsStockViewsPath & "Adiciona.vbhtml")
        End Function

        ''' <summary>
        ''' Json result -> DuplicaComprimido especifico doc stocks
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <HttpPost>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overridable Function DuplicaComprimidoBase64Esp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As String, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim modDoc As Oticas.DocumentosStock = LZString.DecompressModelFromBase64(Of Oticas.DocumentosStock)(modelo)
            Dim jsonRes As JsonResult = Adiciona(request, modDoc, inObjFiltro)

            LZString.CompressJSONDataToBase64(jsonRes)

            Return jsonRes
        End Function
#End Region
    End Class
End Namespace