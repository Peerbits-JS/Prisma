Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EntidadesComparticipacoesController
        Inherits EntidadesComparticipacoesController(Of Oticas.BD.Dinamica.Aplicacao, tbEntidadesComparticipacoes, EntidadesComparticipacoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEntidadesComparticipacoes())
        End Sub
#End Region

    End Class
End Namespace
