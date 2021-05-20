Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class UnidadesController
        Inherits UnidadesController(Of BD.Dinamica.Aplicacao, tbUnidades, Unidades)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioUnidades())
        End Sub
#End Region
#Region "ACOES DE LEITURA"
        ' LEITURA PARA A COMBO/DDL
        <F3MAcesso>
        Public Function ListaComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of Oticas.Unidades) = Nothing

                Using rep As New RepositorioUnidades
                    result = rep.ListaComboCodigo(inObjFiltro)
                End Using

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace