Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposEntidadeController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposEntidade, SistemaTiposEntidade)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposEntidade)
        End Sub
#End Region


#Region "ACOES DE LEITURA"
        Function ListaArvore(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim resultJSON As JsonResult = Nothing

            Try
                Using rep As New RepositorioSistemaTiposEntidade
                    resultJSON = Json(rep.ListaArvore(inObjFiltro), JsonRequestBehavior.AllowGet)
                End Using
            Catch ex As Exception
                resultJSON = Json(New With {.Errors = ex.Message}, JsonRequestBehavior.AllowGet)
            End Try
            Return resultJSON
        End Function
#End Region


    End Class
End Namespace