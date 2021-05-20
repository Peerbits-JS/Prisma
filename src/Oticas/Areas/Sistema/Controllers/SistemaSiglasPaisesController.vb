Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaSiglasPaisesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaSiglasPaises, SistemaSiglasPaises)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaSiglasPaises)
        End Sub
#End Region

    End Class
End Namespace