Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class BancosController
        Inherits BancosController(Of Oticas.BD.Dinamica.Aplicacao, tbBancos, Bancos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioBancos())
        End Sub
#End Region
    End Class
End Namespace
