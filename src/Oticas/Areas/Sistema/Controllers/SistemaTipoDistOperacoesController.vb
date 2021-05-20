Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTipoDistOperacoesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTipoDistOperacoes, SistemaTipoDistOperacoes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTipoDistOperacoes)
        End Sub
#End Region

    End Class
End Namespace