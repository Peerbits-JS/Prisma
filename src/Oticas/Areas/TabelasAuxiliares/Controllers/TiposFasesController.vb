Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.Comum.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposFasesController
        Inherits GrelhaController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposFases, TiposFases)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposFases())
        End Sub
#End Region
    End Class
End Namespace