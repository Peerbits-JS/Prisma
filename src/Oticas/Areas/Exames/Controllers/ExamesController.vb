Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Exames

Namespace Areas.Exames.Controllers
    Public Class ExamesController
        Inherits FotosController(Of BD.Dinamica.Aplicacao, tbExames, Oticas.Exames)
        'Inherits GrelhaFormController(Of BD.Dinamica.Aplicacao, tbExames, Oticas.Exames)

        Const ExamesViewsPath As String = "~/Areas/Exames/Views/Exames/"
        Const ExamesEnginePath As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
        Const LoginBasePath As String = "~/F3M/Areas/Administracao/Views/Autentica/Loginbase.vbhtml"

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioExames())
        End Sub
#End Region

#Region "VIEWS"
        ''' <summary>
        ''' Funcao overrides da action do index
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <param name="IDVista"></param>
        ''' <returns></returns>
        <F3MAcessoExames>
        Public Overrides Function Index(Optional inObjFiltro As ClsF3MFiltro = Nothing, Optional IDVista As Long = 0) As ActionResult
            Return MyBase.Index(inObjFiltro, IDVista)
        End Function

        ''' <summary>
        ''' Funcao que abre a janela de info "Tem que associar um médico/técnico a este utilizador."
        ''' </summary>
        ''' <param name="returnUrl"></param>
        ''' <param name="popuplogin"></param>
        ''' <param name="tab"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function BloqueiaConsultas(returnUrl As String, popuplogin As String, tab As Integer?) As ActionResult
            ViewData("msgNotAcesso") = Traducao.EstruturaExames.AssociarMedTecUtilzador
            ViewData("returnUrl") = returnUrl
            ViewData("tab") = tab

            Return PartialView(LoginBasePath)
        End Function
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' Funcao especifica para retornar os dados para a grid
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Overrides Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As DataSourceResult = Nothing
                Dim lst As New List(Of Oticas.Exames)
                Dim IDDrillDown As Long? = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDDrillDown", GetType(Long))

                Using rpExames As New RepositorioExames
                    If (Not IDDrillDown Is Nothing AndAlso IDDrillDown <> 0) Then
                        lst = rpExames.ListaDadosIDDrillDown(inObjFiltro)
                        lst.FirstOrDefault.PaginaManipulada = 1
                        result = New DataSourceResult With {.Data = lst, .Total = 1}

                    Else
                        lst = rpExames.ListaDadosEsp(inObjFiltro)
                        result = RetornaDataSourceResult(request, inObjFiltro, lst)
                    End If
                End Using

                request.PageSize = 1000

                'RGPD - MJS - Registo de log quando lista
                ClsControloBDLogs.EscreveLog(Of Oticas.Exames)(Nothing, AcoesFormulario.Consultar, request)

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary> 
        ''' Funcao especifica para retornar os dados para a grid
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        Public Function ListaEspecifico(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim res As New List(Of Oticas.Exames)
                Using rpExames As New RepositorioExames
                    res = rpExames.ListaDadosImp(inObjFiltro)
                End Using

                Dim result As DataSourceResult = RetornaDataSourceResult(request, inObjFiltro, res)

                'RGPD - MJS - Registo de log quando lista
                ClsControloBDLogs.EscreveLog(Of Oticas.Exames)(Nothing, AcoesFormulario.Consultar, request)

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "ADICIONAR"
        ''' <summary>
        '''  GET adiciona obj especifico
        ''' </summary>
        ''' <param name="CampoValorPorDefeito"></param>
        ''' <param name="IDVista"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpGet>
        Public Function AdicionaEsp(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0,
                                    Optional IDCliente As Long = 0,
                                    Optional IDMedicoTecnico As Long = 0,
                                    Optional IDEspecialidade As Long = 0,
                                    Optional IDAgendamento As Long = 0) As ActionResult

            'instance new model
            Dim Model As Oticas.Exames
            Dim ViewAux As String = "Adiciona"

            'get model
            Using rpExames As New RepositorioExames
                'new or existing one
                Model = rpExames.RetornaModelFromAgendamento(IDAgendamento)

                If Model Is Nothing Then
                    Model = rpExames.RetornaModelAdicionar()

                    Dim Agendamento As tbAgendamento = repositorio.BDContexto.tbAgendamento.Where(Function(w) w.ID = IDAgendamento).FirstOrDefault()

                    If Agendamento Is Nothing Then Agendamento = New tbAgendamento

                    'set from agendamento
                    rpExames.PreencheModelFromAgendamento(Model, Agendamento.IDCliente, Agendamento.IDMedicoTecnico, Agendamento.IDEspecialidade, IDAgendamento, Agendamento.Start)

                    'set model main props
                    With Model
                        .ID = CLng(0) : .AcaoFormulario = AcoesFormulario.Adicionar
                    End With

                Else
                    'set model edita props
                    With Model
                        .AcaoFormulario = AcoesFormulario.Alterar
                    End With
                    ViewAux = "Edita"
                End If

                'get history from cliente
                If Not Model.IDCliente Is Nothing Then
                    'Using rpExames As New RepositorioExames
                    With Model
                        .HistoricoExames = rpExames.RetornaHistoricoExamesByIDCliente(Model.IDCliente)
                    End With
                    'End Using

                Else
                    With Model
                        .HistoricoExames.CodigoTemplate = rpExames.RetornaMedicoTecnicoUtilizadorSessao()?.CodigoTemplate
                    End With
                End If
            End Using

            'return veiw with model
            Return View(ExamesViewsPath & ViewAux & ".vbhtml", Model)
        End Function

        ''' <summary>
        '''  POST adiciona obj especifico
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Public Function AdicionaEsp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As ExamesCustomModel, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result As New ClsF3MRespostaCrud
            Dim lngPos As Long = Nothing
            Dim Model As New Oticas.Exames
            Dim lstLista As IQueryable(Of Oticas.Exames) = Nothing
            Dim ID As Long = CLng(modelo.ExamesModel.Where(Function(w) w.Key = "ID").FirstOrDefault().Value)

            Using rpExames As New RepositorioExames
                If ID <> 0 Then
                    Model = rpExames.EditaEsp(modelo)

                Else
                    Model = rpExames.AdicionaEsp(modelo)
                End If

                'generico
                lstLista = rpExames.ListaDadosEsp(inObjFiltro).AsQueryable()
            End Using

            result = RetornaPaginaRegistoManipulado(request, Model, lstLista, lngPos)
            Return RetornaJSONTamMaximo(result)
        End Function
#End Region

#Region "EDITAR"
        ''' <summary>
        ''' GET edita obj especifico
        ''' </summary>
        ''' <param name="ID"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpGet>
        Public Function EditaEsp(Optional ID As Long = 0) As ActionResult
            'instance new model
            Dim Model As Oticas.Exames

            'get model
            Using rpExames As New RepositorioExames
                Model = rpExames.RetornaModelEditar(ID)
            End Using

            'set model main props
            With Model
                .AcaoFormulario = AcoesFormulario.Alterar
            End With

            'return veiw
            Return View(ExamesViewsPath & "Adiciona.vbhtml", Model)
        End Function

        ''' <summary>
        ''' POST edita obj especifico
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="modelo"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Public Function EditaEsp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As ExamesCustomModel, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result As New ClsF3MRespostaCrud
            Dim lngPos As Long = Nothing
            Dim Model As New Oticas.Exames
            Dim lstLista As IQueryable(Of Oticas.Exames) = Nothing

            Using rpExames As New RepositorioExames
                Model = rpExames.EditaEsp(modelo)

                'generico
                lstLista = rpExames.ListaDadosEsp(inObjFiltro).AsQueryable()
            End Using

            result = RetornaPaginaRegistoManipulado(request, Model, lstLista, lngPos)
            Return RetornaJSONTamMaximo(result)
        End Function
#End Region

#Region "HISTORICO"
        ''' <summary>
        ''' Funcao que retorna o historico by id cliente (1 exame selecionado e info carregada para os accordions)
        ''' </summary>
        ''' <param name="IDCliente"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RetornaLadoDireitoCompleto(IDCliente As Nullable(Of Long), CodigoTemplate As String) As ActionResult
            Dim Model As New HistoricoExames

            Using rpExames As New RepositorioExames
                With Model
                    Model = rpExames.RetornaHistoricoExamesByIDCliente(IDCliente)

                    If String.IsNullOrEmpty(Model.CodigoTemplate) Then
                        Model.CodigoTemplate = CodigoTemplate
                    End If

                End With
            End Using

            Return View(ExamesViewsPath & "LadoDireito/Aberto.vbhtml", Model)
        End Function


        ''' <summary>
        ''' Funcao que retorna o historico (html -> accordions) de consultas do cliente
        ''' </summary>
        ''' <param name="IDExame"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RetornaHistoricoExame(IDExame As Long) As ActionResult
            Dim model As New HistoricoExames

            Using rpExames As New RepositorioExames
                model = rpExames.RetornaHistoricoByIDExame(IDExame)
            End Using

            Return View(ExamesViewsPath & "LadoDireito/Accordions/" & model.ExamesAccordions.ViewName & ".vbhtml", model)
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna a view by IDTemplate
        ''' </summary>
        ''' <param name="IDTemplate"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RetornaViewTemplateByIDTemplate(IDTemplate As Long) As ActionResult
            Using rpExames As New RepositorioExames
                Dim ModelTemplate As Oticas.Exames = rpExames.RetornaModelTemplateByIDTemplate(False, IDTemplate)
                Return View("Content/MainContent", ModelTemplate)
            End Using
        End Function
#End Region

#Region "GET"
        ' GET: IndexGrelha
        <F3MAcesso>
        Public Function IndexGrelhaEspecifico(Optional ByVal IDVista As Long = 0) As ActionResult
            Return MyBase.IndexGF(IDVista, True)
        End Function
#End Region
    End Class

    Public Class F3MAcessoExames
        Inherits F3MAcesso

        ''' <summary>
        ''' Funcao overrides da funcao que valida o licenciamento / perfis
        ''' </summary>
        ''' <param name="filterContext"></param>
        Public Overrides Sub OnAuthorization(filterContext As AuthorizationContext)
            MyBase.OnAuthorization(filterContext)
            'se passar no licenciamento e nos perfis valida se utilziador esta associado a um med tec
            If filterContext.Result Is Nothing AndAlso filterContext.HttpContext.Request.QueryString("IDDrillDown") Is Nothing Then
                Using rpExames As New RepositorioExames
                    'se o utulzador em sessao nao estiver associado a um med tec dá msg de info
                    If rpExames.RetornaMedicoTecnicoUtilizadorSessao() Is Nothing Then
                        'get tab
                        Dim _tab As Integer = 0
                        If Not ClsTexto.ENuloOuVazio(filterContext.HttpContext.Request.QueryString("link")) Then _tab = CInt(filterContext.HttpContext.Request.QueryString("tab"))
                        'get utl
                        Dim _url As String = filterContext.RequestContext.HttpContext.Request.Url.ToString()
                        'get url to redirect
                        Dim _urlRedirect As String = "../Exames/Exames/BloqueiaConsultas?returnUrl=" & _url & "&popuplogin=popup&tab=" & _tab
                        'set to result
                        filterContext.Result = New RedirectResult(_urlRedirect)
                    End If
                End Using
            End If
        End Sub
    End Class
End Namespace