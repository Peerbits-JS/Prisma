Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes
Imports F3M.Modelos.Autenticacao
Imports F3M.Areas.Clientes.Controllers
Imports F3M.Modelos.Repositorio
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Comunicacao
Imports Oticas.Repositorio.Documentos

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasAnexosController
        Inherits AnexosController(Of BD.Dinamica.Aplicacao, tbDocumentosVendasAnexos)


#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioDocumentosVendasAnexos)
        End Sub
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso>
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Anexos, inObjFiltro As ClsF3MFiltro) As JsonResult
            inObjFiltro.CamposAPreencher = New Dictionary(Of String, Object)
            inObjFiltro.CamposAPreencher.Add("IDDocumentoVenda", modelo.IDChaveEstrangeira)
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace