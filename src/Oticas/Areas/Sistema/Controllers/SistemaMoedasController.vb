Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaMoedasController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaMoedas, F3M.SistemaMoedas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaMoedas)
        End Sub
#End Region

    End Class
End Namespace