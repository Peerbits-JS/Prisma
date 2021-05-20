Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosAssociadosController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosAssociados, ArtigosAssociados)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosAssociados())
        End Sub
#End Region

    End Class
End Namespace
