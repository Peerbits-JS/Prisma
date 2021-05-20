Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosAlternativosController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosAlternativos, ArtigosAlternativos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosAlternativos())
        End Sub
#End Region

    End Class
End Namespace
