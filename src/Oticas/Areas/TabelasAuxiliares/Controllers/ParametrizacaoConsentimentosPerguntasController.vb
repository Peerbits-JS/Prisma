Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Comunicacao
Imports Kendo.Mvc.UI

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ParametrizacaoConsentimentosPerguntasController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbParametrizacaoConsentimentosPerguntas, ParametrizacaoConsentimentosPerguntas)

        Sub New()
            MyBase.New(New RepositorioParametrizacaoConsentimentosPerguntas())
        End Sub

        Public Overrides Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result As List(Of ParametrizacaoConsentimentosPerguntas) = repositorio.ListaCombo(inObjFiltro).ToList()

            result.Insert(0, New ParametrizacaoConsentimentosPerguntas With {.ID = 0, .IDParametrizacaoConsentimento = 0, .Codigo = 0, .Descricao = "Cliente Permite Comunicações", .OrdemApresentaPerguntas = 0, .Sistema = 1, .Ativo = 1})
            Return RetornaJSONTamMaximo(result)
        End Function
    End Class
End Namespace
