Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.Fornecedores.Controllers
Imports Oticas.Repositorio.Fornecedores

Namespace Areas.Fornecedores.Controllers
    Public Class FornecedoresMoradasController
        Inherits FornecedoresMoradasController(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedoresMoradas, F3M.FornecedoresMoradas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioFornecedoresMoradas())
        End Sub
#End Region

    End Class
End Namespace