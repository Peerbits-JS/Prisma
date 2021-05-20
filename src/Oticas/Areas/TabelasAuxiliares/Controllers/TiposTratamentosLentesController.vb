Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Areas.Comum.Controllers

Namespace Areas.TabelasAuxiliares.Controllers

    Public Class TiposTratamentosLentesController
        Inherits GrelhaController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposTratamentosLentes, TiposTratamentosLentes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposTratamentosLentes())
        End Sub
#End Region

    End Class
End Namespace