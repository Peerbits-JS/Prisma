Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ProfissoesController
        Inherits ProfissoesController(Of Oticas.BD.Dinamica.Aplicacao, tbProfissoes, Profissoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioProfissoes())
        End Sub
#End Region
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function Importa(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Importacao, filtro As F3M.Modelos.Comunicacao.ClsF3MFiltro) As JsonResult
            Try
                Dim rep As New Repositorio.RepositorioClientes
                modelo = rep.Importar(modelo)
                modelo.strFicheiro = String.Empty
                Return Json(New With {.DadosObjeto = modelo})
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            Catch ex As Exception
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            End Try
        End Function

    End Class
End Namespace
