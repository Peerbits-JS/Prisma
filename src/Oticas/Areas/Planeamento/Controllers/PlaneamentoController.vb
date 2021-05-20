Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.Extensions
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Planeamento

Namespace Areas.Planeamento.Controllers
    Public Class PlaneamentoController
        Inherits F3M.Areas.PlaneamentoComum.PlaneamentoComumController(Of BD.Dinamica.Aplicacao, tbPlaneamento, F3M.Planeamento)


#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioPlaneamento())
        End Sub
#End Region

#Region "CRUD EVENTS"
        <F3MAcesso(Acao:=AcoesFormulario.Consultar)>
        Public Overloads Function Lista(<DataSourceRequest> ByVal request As DataSourceRequest, filtro As ClsF3MFiltro) As JsonResult
            Return RetornaJSONTamMaximo(repositorio.Lista(filtro).ToDataSourceResult(request))
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overloads Function Adiciona(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Planeamento) As JsonResult
            Dim MensagemErro As String = String.Empty
            If ModelState.IsValid Then repositorio.AdicionaObj(evento, New F3M.Modelos.Comunicacao.ClsF3MFiltro())

            Dim dsResource = {evento}.ToDataSourceResult(request, ModelState)
            If MensagemErro <> "" Then dsResource.Errors = MensagemErro

            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        Public Overloads Function Apaga(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Planeamento) As JsonResult
            repositorio.RemoveObj(evento, New ClsF3MFiltro())
            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overloads Function Edita(<DataSourceRequest> ByVal request As DataSourceRequest, ByVal evento As F3M.Planeamento) As JsonResult
            repositorio.EditaObj(evento, New ClsF3MFiltro())
            Return RetornaJSONTamMaximo({evento}.ToDataSourceResult(request, ModelState))
        End Function
#End Region
    End Class
End Namespace