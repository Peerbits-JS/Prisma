Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaOrdemLotesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaOrdemLotes, SistemaOrdemLotes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaOrdemLotes)
        End Sub
#End Region

    End Class
End Namespace