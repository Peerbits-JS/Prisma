Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Areas.Comum.Controllers

Namespace Areas.TabelasAuxiliares.Controllers

    Public Class SegmentosMarcasController
        Inherits GrelhaController(Of Oticas.BD.Dinamica.Aplicacao, tbSegmentosMarcas, SegmentosMarcas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSegmentosMarcas())
        End Sub
#End Region

    End Class
End Namespace