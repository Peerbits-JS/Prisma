Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposRetencaoController
        Inherits TiposRetencaoController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposRetencao, TiposRetencao)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposRetencao())
        End Sub
#End Region

    End Class
End Namespace
