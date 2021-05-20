Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class IVARegioesController
        Inherits IVARegioesController(Of Oticas.BD.Dinamica.Aplicacao, tbIVARegioes, IVARegioes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioIVARegioes())
        End Sub
#End Region

    End Class
End Namespace
