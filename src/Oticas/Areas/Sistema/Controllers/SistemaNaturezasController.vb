Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaNaturezasController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaNaturezas, SistemaNaturezas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaNaturezas)
        End Sub
#End Region

    End Class
End Namespace