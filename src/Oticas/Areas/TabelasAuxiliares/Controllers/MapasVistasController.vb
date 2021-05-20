Imports F3M.Modelos.Comunicacao
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Kendo.Mvc.UI

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MapasVistasController
        Inherits MapasVistasController(Of BD.Dinamica.Aplicacao, tbMapasVistas, MapasVistas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioMapasVistas())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ''' <summary>
        ''' Controller que permite alterar o mapa por defeito
        ''' </summary>
        ''' <param name="inObjFiltro">Lista de mapas</param>
        ''' <returns></returns>
        Public Function UpdatePorDefeito(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim blnMapaPorDefeito As Boolean = False
                ' Dim result As JsonResult

                Using rep As New RepositorioMapasVistas
                    blnMapaPorDefeito = rep.UpdateVistasPorDefeito(inObjFiltro)
                End Using


                Return RetornaJSONTamMaximo(blnMapaPorDefeito)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try

        End Function

        ''' <summary>
        ''' Controlador que verifica a password
        ''' </summary>
        ''' <param name="infiltro">filtro onde se recebe a password</param>
        ''' <returns></returns>
        Public Overrides Function VerificaPassDesigner(infiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.VerificaPassDesigner(infiltro)
        End Function

#End Region
    End Class
End Namespace
