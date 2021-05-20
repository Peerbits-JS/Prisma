Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTipoDistMatPrimaController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTipoDistMatPrima, SistemaTipoDistMatPrima)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTipoDistMatPrima)
        End Sub
#End Region

    End Class
End Namespace