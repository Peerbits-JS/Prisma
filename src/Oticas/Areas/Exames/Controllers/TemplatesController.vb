Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Exames

Namespace Areas.Exames.Controllers
    Public Class TemplatesController
        Inherits FotosController(Of BD.Dinamica.Aplicacao, tbTemplates, Oticas.Templates)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTemplates())
        End Sub
#End Region
    End Class
End Namespace