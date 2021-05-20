Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Modelos.Comunicacao

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares
    Public Class ComposicoesController
        Inherits ComposicoesController(Of Oticas.BD.Dinamica.Aplicacao, tbComposicoes, Composicoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioComposicoes())
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"

        Public Function ProximoCodigo(Optional inObjFiltro As ClsF3MFiltro = Nothing) As ActionResult
            Dim strCodigo As String = String.Empty

            Using rp As New RepositorioComposicoes
                strCodigo = rp.ProximoCodigo
            End Using

            Return Content(strCodigo)
        End Function
#End Region



    End Class
End Namespace
