

Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports Oticas.Repositorios.TabelasAuxiliares
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Controlos
Imports F3M.Repositorios.Administracao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MedicosTecnicosEspecialidadesController
        Inherits MedicosTecnicosEspecialidadesController(Of Oticas.BD.Dinamica.Aplicacao, tbMedicosTecnicosEspecialidades, MedicosTecnicosEspecialidades)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioMedicosTecnicosEspecialidades())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE LEITURA PARA AS GRELHAS
        <F3MAcesso>
        Function ListaEspecialidades(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim resultado As TreeDataSourceResult = Nothing
            Dim objetoRespostaJSON As New List(Of MedicosTecnicosEspecialidades)

            Using rep As New RepositorioMedicosTecnicosEspecialidades

                resultado = rep.ListaEspecialidades(0, 0, objetoRespostaJSON, Nothing, Nothing,
                                        inObjFiltro).ToTreeDataSourceResult(request)

            End Using

            Return Json(resultado, JsonRequestBehavior.AllowGet)
        End Function
#End Region

    End Class
End Namespace
