Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Documentos

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasServicosSubstituicaoController
        Inherits GrelhaFormController(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendasServicosSubstituicao)

        ReadOnly _rpDocumentosVendasServicosSubstituicao As RepositorioDocumentosVendasServicosSubstituicao

        Sub New()
            MyBase.New(New RepositorioDocumentosVendasServicosSubstituicao)

            _rpDocumentosVendasServicosSubstituicao = New RepositorioDocumentosVendasServicosSubstituicao()
        End Sub

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function AdicionaEsp(IDServico As Long) As ActionResult
            Dim resAr As ActionResult = Me.Adiciona()
            Dim docServSubstituicaoMOD As DocumentosVendasServicosSubstituicao = DirectCast(resAr, System.Web.Mvc.PartialViewResult).Model

            docServSubstituicaoMOD = _rpDocumentosVendasServicosSubstituicao.GetServico(IDServico)

            Return View("Adiciona", docServSubstituicaoMOD)
        End Function

        <HttpPost, F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function AdicionaEsp(<DataSourceRequest> request As DataSourceRequest, <Bind> modelo As DocumentosVendasServicosSubstituicao, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function

        <F3MAcesso, HttpPost>
        Public Function ValidaExisteArtigo(<Bind> model As DocumentosVendasServicosSubstituicao) As JsonResult
            Try
                Return Json(_rpDocumentosVendasServicosSubstituicao.ValidaExisteArtigo(model))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
    End Class
End Namespace