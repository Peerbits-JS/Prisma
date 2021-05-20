Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaAcoesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaAcoes, SistemaAcoes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaAcoes)
        End Sub
#End Region

    End Class
End Namespace