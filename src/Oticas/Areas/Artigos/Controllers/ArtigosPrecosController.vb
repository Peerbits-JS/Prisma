Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosPrecosController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosPrecos, ArtigosPrecos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosPrecos())
        End Sub
#End Region
    End Class
End Namespace