Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosLotesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosLotes, ArtigosLotes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosLotes())
        End Sub
#End Region

    End Class
End Namespace
