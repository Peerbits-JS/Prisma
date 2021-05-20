Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SetoresAtividadeIdiomasController
        Inherits SetoresAtividadeIdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbSetoresAtividadeIdiomas, SetoresAtividadeIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSetoresAtividadeIdiomas())
        End Sub
#End Region

    End Class
End Namespace
