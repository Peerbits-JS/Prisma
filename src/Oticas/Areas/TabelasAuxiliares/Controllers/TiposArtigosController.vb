Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposArtigosController
        Inherits TiposArtigosController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposArtigos, TiposArtigos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposArtigos())
        End Sub
#End Region

    End Class
End Namespace
