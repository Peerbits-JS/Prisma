Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Comunicacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class IVAController
        Inherits IVAController(Of Oticas.BD.Dinamica.Aplicacao, tbIVA, IVA)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioIVA())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' LEITURA PARA A COMBO/DDL
        Public Function ListaComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of IVA) = Nothing

                Using rep As New RepositorioIVA
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
