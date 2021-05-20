Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEntidadeComparticipacaoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadeComparticipacao, SistemaEntidadeComparticipacao)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEntidadeComparticipacao)
        End Sub
#End Region

    End Class
End Namespace