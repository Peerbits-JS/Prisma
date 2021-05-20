Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaRegimeIVAController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaRegimeIVA, SistemaRegimeIVA)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaRegimeIVA)
        End Sub
#End Region

    End Class
End Namespace