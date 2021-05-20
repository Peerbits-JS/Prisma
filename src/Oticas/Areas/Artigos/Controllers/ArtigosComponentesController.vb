Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosComponentesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosComponentes, ArtigosComponentes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosComponentes())
        End Sub
#End Region

    End Class
End Namespace

