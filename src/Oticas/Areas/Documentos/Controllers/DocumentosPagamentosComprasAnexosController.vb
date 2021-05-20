Imports Kendo.Mvc.UI
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Documentos
Imports F3M.Modelos.Autenticacao

Namespace Areas.Documentos.Controllers
    Public Class DocumentosPagamentosComprasAnexosController
        Inherits AnexosController(Of Oticas.BD.Dinamica.Aplicacao, tbPagamentosComprasAnexos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioDocumentosPagamentosComprasAnexos)
        End Sub
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Anexos,
                                           inObjFiltro As ClsF3MFiltro) As JsonResult
            inObjFiltro.CamposAPreencher = New Dictionary(Of String, Object)
            inObjFiltro.CamposAPreencher.Add("IDPagamentoCompra", modelo.IDChaveEstrangeira)
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace