Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaRegioesIVAController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaRegioesIVA, SistemaRegioesIVA)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaRegioesIVA)
        End Sub
#End Region

    End Class
End Namespace