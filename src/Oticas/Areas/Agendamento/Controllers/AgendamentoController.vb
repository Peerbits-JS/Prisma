Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.Extensions
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Agendamento
Imports Oticas.Repositorio.Planeamento

Namespace Areas.Agendamento.Controllers
    Public Class AgendamentoController
        Inherits F3M.Areas.AgendamentoComum.AgendamentoComumController(Of BD.Dinamica.Aplicacao, tbAgendamento, F3M.Agendamento)

        ReadOnly _repositorioPlaneamento As RepositorioPlaneamento

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioAgendamento())

            _repositorioPlaneamento = New RepositorioPlaneamento
        End Sub
#End Region

#Region "CRUD EVENTS"
        <F3MAcesso(Acao:=AcoesFormulario.Consultar)>
        Public Overloads Function Lista(<DataSourceRequest> ByVal request As DataSourceRequest, filtro As ClsF3MFiltro) As JsonResult
            Dim l As IList(Of F3M.Agendamento) = Nothing
            Dim p As IList(Of F3M.Planeamento) = Nothing

            l = repositorio.Lista(filtro).ToList()

            Dim CarregaP As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, "CarregaPlanificacoes", GetType(Boolean))
            If CarregaP Then
                p = _repositorioPlaneamento.Lista(filtro).ToList()
                _repositorioPlaneamento.PreencheOcorrenciasPlaneamento(p, filtro)
            End If

            Return RetornaJSONTamMaximo(New With {Key .Data = l.ToDataSourceResult(request), Key .Data2 = p?.ToDataSourceResult(request)})
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overloads Function Adiciona(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Agendamento) As JsonResult
            Dim MensagemErro As String = ""

            If ModelState.IsValid Then repositorio.AdicionaObj(evento, New ClsF3MFiltro())

            Dim dsResource = {evento}.ToDataSourceResult(request, ModelState)
            If MensagemErro <> "" Then dsResource.Errors = MensagemErro

            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        Public Overloads Function Apaga(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Agendamento) As JsonResult
            repositorio.RemoveObj(evento, New ClsF3MFiltro())
            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overloads Function Edita(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Agendamento) As JsonResult
            repositorio.EditaObj(evento, New ClsF3MFiltro())
            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function
#End Region
    End Class
End Namespace