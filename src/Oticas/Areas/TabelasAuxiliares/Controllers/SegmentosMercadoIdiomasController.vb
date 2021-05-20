Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SegmentosMercadoIdiomasController
        Inherits SegmentosMercadoIdiomasController(Of Oticas.BD.Dinamica.Aplicacao, tbSegmentosMercadoIdiomas, SegmentosMercadoIdiomas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSegmentosMercadoIdiomas())
        End Sub
#End Region

    End Class
End Namespace
