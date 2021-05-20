Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.Fornecedores.Controllers
Imports Oticas.Repositorio.Fornecedores

Namespace Areas.Fornecedores.Controllers
    Public Class FornecedoresContatosController
        Inherits FornecedoresGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedoresContatos, F3M.FornecedoresContatos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFornecedoresContatos())
        End Sub
#End Region

    End Class
End Namespace