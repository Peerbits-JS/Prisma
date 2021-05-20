Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposEstadosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposEstados, SistemaTiposEstados)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposEstados)
        End Sub
#End Region

    End Class
End Namespace