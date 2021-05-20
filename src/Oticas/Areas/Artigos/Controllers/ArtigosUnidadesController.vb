Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosUnidadesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosUnidades, ArtigosUnidades)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosUnidades())
        End Sub
#End Region

    End Class
End Namespace
