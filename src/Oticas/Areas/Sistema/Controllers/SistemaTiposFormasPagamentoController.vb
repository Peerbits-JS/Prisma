Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposFormasPagamentoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposFormasPagamento, SistemaTiposFormasPagamento)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposFormasPagamento)
        End Sub
#End Region

    End Class
End Namespace