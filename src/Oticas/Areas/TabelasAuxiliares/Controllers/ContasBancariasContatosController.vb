Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ContasBancariasContatosController
        Inherits ContasBancariasContatosController(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancariasContatos, ContasBancariasContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioContasBancariasContatos())
        End Sub
#End Region

    End Class
End Namespace
