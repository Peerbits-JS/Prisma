Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Utilitarios

Namespace Areas.Utilitarios.Controllers
    Public Class InventarioATAnexosController
        Inherits AnexosController(Of Oticas.BD.Dinamica.Aplicacao, tbComunicacaoAutoridadeTributariaAnexos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioInventarioATAnexos)
        End Sub
#End Region

#Region "ACOES DEFAULT POST CRUD"
        '' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Anexos,
                                           inObjFiltro As ClsF3MFiltro) As JsonResult

            inObjFiltro.CamposAPreencher = New Dictionary(Of String, Object)
            inObjFiltro.CamposAPreencher.Add("IDComunicacaoAutoridadeTributaria", modelo.IDChaveEstrangeira)
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace