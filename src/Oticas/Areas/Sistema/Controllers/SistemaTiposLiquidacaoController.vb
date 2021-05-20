Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaTiposLiquidacaoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposLiquidacao, SistemaTiposLiquidacao)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaTiposLiquidacao)
        End Sub
#End Region

    End Class
End Namespace