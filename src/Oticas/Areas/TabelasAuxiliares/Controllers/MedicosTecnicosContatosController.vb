Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MedicosTecnicosContatosController
        Inherits MedicosTecnicosContatosController(Of Oticas.BD.Dinamica.Aplicacao, tbMedicosTecnicosContatos, MedicosTecnicosContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioMedicosTecnicosContatos())
        End Sub
#End Region

    End Class
End Namespace
