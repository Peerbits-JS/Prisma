Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.Comum.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MapaCaixaController
        Inherits GrelhaFormController(Of BD.Dinamica.Aplicacao, tbMapaCaixa, MapaCaixa)

        Sub New()
            MyBase.New(New RepositorioMapaCaixa())
        End Sub

    End Class
End Namespace
