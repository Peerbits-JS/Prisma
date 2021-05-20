Imports F3M.Areas.Alertas.Controllers
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorios.Alertas
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio

Namespace Areas.Alertas.Controllers
    Public Class EmailAnexosController
        Inherits AnexosController(Of BD.Dinamica.Aplicacao, F3M.Email)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioEmailAnexos)
        End Sub
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Anexos,
                                           inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function
#End Region


    End Class
End Namespace
