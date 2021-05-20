Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ArmazensController
        Inherits ArmazensController(Of BD.Dinamica.Aplicacao, tbArmazens, Armazens)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArmazens())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        Function ImportaArmazemSelecionarMorada(inIDArmazem As Long) As JsonResult
            Try
                Dim result As Armazens = Nothing

                Using repo As New RepositorioArmazens
                    result = repo.ImportaArmazemSelecionarMorada(inIDArmazem)
                End Using

                Return RetornaJSONTamMaximo(F3M.Modelos.Utilitarios.LZString.CompressModelToBase64(result))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace
