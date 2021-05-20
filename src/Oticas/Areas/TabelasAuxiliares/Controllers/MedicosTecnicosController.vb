Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MedicosTecnicosController
        Inherits MedicosTecnicosController(Of BD.Dinamica.Aplicacao, tbMedicosTecnicos, MedicosTecnicos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioMedicosTecnicos())
        End Sub
#End Region

#Region "ESCRITA"

        Public Overridable Function Importar(Optional ID As Long = 0) As ActionResult
            Return View()
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function Importa(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Importacao, filtro As ClsF3MFiltro) As JsonResult
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
#End Region
    End Class
End Namespace