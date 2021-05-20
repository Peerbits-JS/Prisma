Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EntidadesContatosController
        Inherits EntidadesContatosController(Of Oticas.BD.Dinamica.Aplicacao, tbEntidadesContatos, EntidadesContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEntidadesContatos())
        End Sub
#End Region

    End Class
End Namespace
