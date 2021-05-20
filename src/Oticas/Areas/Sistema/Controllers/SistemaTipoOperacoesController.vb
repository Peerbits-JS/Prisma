Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTipoOperacoesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTipoOperacoes, SistemaTipoOperacoes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTipoOperacoes)
        End Sub
#End Region

    End Class
End Namespace