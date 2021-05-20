Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosIdiomasController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosIdiomas, ArtigosIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosIdiomas())
        End Sub
#End Region

    End Class
End Namespace
