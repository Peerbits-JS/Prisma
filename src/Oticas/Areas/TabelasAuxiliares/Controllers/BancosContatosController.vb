Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class BancosContatosController
        Inherits BancosContatosController(Of Oticas.BD.Dinamica.Aplicacao, tbBancosContatos, BancosContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioBancosContatos())
        End Sub
#End Region

    End Class
End Namespace
