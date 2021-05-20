Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.Fornecedores.Controllers
Imports Oticas.Repositorio.Fornecedores

Namespace Areas.Fornecedores.Controllers
    Public Class FornecedoresGrelhaController
        Inherits FornecedoresGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedores, Oticas.Fornecedores)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFornecedores())
        End Sub
#End Region

    End Class
End Namespace
