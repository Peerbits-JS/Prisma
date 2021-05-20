Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposFasesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposFases, SistemaTiposFases)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposFases)
        End Sub
#End Region

    End Class
End Namespace