Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.Fornecedores
Imports F3M.Areas.Fornecedores.Controllers

Namespace Areas.Fornecedores.Controllers
    Public Class FornecedoresTiposFornecimentosController
        Inherits FornecedoresGrelhasController(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedoresTiposFornecimento, FornecedoresTiposFornecimentos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioFornecedoresTiposFornecimento())
        End Sub
#End Region

    End Class
End Namespace