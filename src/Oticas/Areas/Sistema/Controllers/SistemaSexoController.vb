Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaSexoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaSexo, SistemaSexo)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaSexo)
        End Sub
#End Region

    End Class
End Namespace