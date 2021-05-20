Imports F3M.Areas.Comum.Controllers
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Comunicacao
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ArmazensLocalizacoesController
        Inherits ArmazensLocalizacoesController(Of BD.Dinamica.Aplicacao, tbArmazensLocalizacoes, Localizacoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioLocalizacoes())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' LEITURA PARA A COMBO/DDL
        Public Function ListaComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of Localizacoes) = Nothing

                Using rep As New RepositorioLocalizacoes
                    result = rep.ListaComboCodigo(inObjFiltro)
                End Using

                Return Json(result, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace
