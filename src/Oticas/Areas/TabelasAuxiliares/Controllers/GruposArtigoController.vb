Imports F3M.Areas.Comum.Controllers
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class GruposArtigoController
        Inherits GruposArtigoController(Of Oticas.BD.Dinamica.Aplicacao, tbGruposArtigo, GruposArtigo)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioGruposArtigo())
        End Sub
#End Region

    End Class
End Namespace
