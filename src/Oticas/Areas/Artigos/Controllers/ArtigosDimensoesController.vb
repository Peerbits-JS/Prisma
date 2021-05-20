Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Excepcoes
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosDimensoesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosDimensoes, ArtigosDimensoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosDimensoes())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        <F3MAcesso>
        Public Overrides Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result As Object = repositorio.GeraTabela(inObjFiltro)
            Return Json(result, JsonRequestBehavior.AllowGet)
        End Function

        ' METODO PARA DE LEITURA PARA A COMBO/DDL
        <F3MAcesso>
        Public Overrides Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result = repositorio.ListaCombo(inObjFiltro)
            Return Json(result, JsonRequestBehavior.AllowGet)
        End Function

        <F3MAcesso>
        Function ListaAcessos(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Dim result = RetornaAcessosArea(inObjFiltro)
            Return Json(result, JsonRequestBehavior.AllowGet)
        End Function
#End Region

#Region "ACOES DE ESCRITA"
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest,
                                        <Bind> ByVal modelo As ArtigosDimensoes, inObjFiltro As ClsF3MFiltro) As JsonResult
            Using rep As New RepositorioArtigosDimensoes
                rep.EditaLinhas(inObjFiltro)
            End Using

            Return Json(True, JsonRequestBehavior.AllowGet)
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Function GuardaMatriz(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Using rep As New RepositorioArtigosDimensoes
                    rep.GuardaMatriz(inObjFiltro)
                End Using

                Return Json(True, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Dim listaRMSC As List(Of ClsF3MRespostaMensagemServidorCliente) = ClsExcepcoes.VerificaModelState(ModelState, ex)

                Return Json(New With {.errors = listaRMSC}, JsonRequestBehavior.AllowGet)
            End Try
        End Function
#End Region

    End Class
End Namespace
