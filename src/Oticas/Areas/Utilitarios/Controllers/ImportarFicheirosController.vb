Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio

Namespace Areas.Utilitarios.Controllers
    Public Class ImportarFicheirosController
        Inherits F3M.Areas.Utilitarios.Controllers.ImportarFicheirosController


#Region "ESCRITA"

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function Importa(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Importacao, filtro As ClsF3MFiltro) As JsonResult
            Try
                Dim rep As New RepositorioClientes
                modelo = rep.Importar(modelo)
                modelo.strFicheiro = String.Empty
                Return Json(New With {.DadosObjeto = modelo})
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            Catch ex As Exception
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            End Try
        End Function
#End Region

    End Class
End Namespace