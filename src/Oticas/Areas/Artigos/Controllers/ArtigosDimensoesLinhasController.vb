Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosDimensoesLinhasController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbDimensoesLinhas, ArtigosDimensoesLinhas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosDimensoesLinhas())
        End Sub
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Remove
        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        <HttpPost>
        Public Overrides Function Remove(<DataSourceRequest> request As DataSourceRequest,
                                         <Bind> ByVal modelo As ArtigosDimensoesLinhas, filtro As ClsF3MFiltro) As JsonResult
            Dim rep As New RepositorioArtigosDimensoesLinhas
            Dim result = ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Remover)
            If (DirectCast(result.Data, Object).GetType().GetProperty("Erros") Is Nothing) Then
                rep.TrocaOrdemLinhas(Nothing, modelo.IDDimensao, modelo.Ordem, Nothing)
            End If
            Return result
        End Function
#End Region

#Region "ACOES DE ESCRITA"
        ' METODO PARA ATUALIZAR A ORDEM DAS DIMENSOES-LINHAS
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Function OrdenaLinhas(<DataSourceRequest> request As DataSourceRequest, IDDimensao As Integer, OrdemTarget As Integer, OrdemDest As Integer) As JsonResult
            Dim rep As New RepositorioArtigosDimensoesLinhas
            rep.TrocaOrdemLinhas(request.Sorts.FirstOrDefault.SortDirection.ToString, IDDimensao, OrdemTarget, OrdemDest)
            Return Json(True, JsonRequestBehavior.AllowGet)
        End Function
#End Region

    End Class
End Namespace
