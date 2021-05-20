Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaParametrosLojaController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaParametrosLoja, SistemaParametrosLoja)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaParametrosLoja)
        End Sub
#End Region

    End Class
End Namespace