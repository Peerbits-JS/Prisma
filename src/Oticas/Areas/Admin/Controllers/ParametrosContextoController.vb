Imports F3M.Areas.Comum.Controllers
Imports F3M.Areas.Administracao.Controllers
Imports Oticas.Repositorio.Administracao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.UI

Namespace Areas.Admin.Controllers
    Public Class ParametrosContextoController
        Inherits ParametrosContextoController(Of Oticas.BD.Dinamica.Aplicacao, tbParametrosContexto, ParametrosContexto)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioParametrosContexto())
        End Sub
#End Region

#Region "Views"
        <F3MAcesso>
        Function Index() As ActionResult
            Return View()
        End Function

        <F3MAcesso>
        Function PartialTaxasIva() As ActionResult
            Return PartialView()
        End Function

        <F3MAcesso>
        Function PartialOutros() As ActionResult
            Return PartialView()
        End Function

        <F3MAcesso>
        Function PartialStocks() As ActionResult
            Return PartialView()
        End Function

        <F3MAcesso>
        Function PartialArtigos() As ActionResult
            Return PartialView()
        End Function

        <F3MAcesso>
        Function PartialComunicacao() As ActionResult
            Return PartialView()
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Public Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As ParametrosContexto,
                                        inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim jsResult As JsonResult = ExecutaAcoes(request, modelo, inObjFiltro, AcoesFormulario.Alterar)

                Return jsResult
            Catch ex As Exception
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            End Try
        End Function
#End Region

#Region "FUNCAO DE INICIO TREE PARAMETROS"
        <F3MAcesso()>
        Public Function IniciaTreeParametros(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim resposta As String
                Dim IDEmpresa As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, CamposGenericos.IDEmpresa, GetType(Long))
                Dim IDLoja As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, CamposGenericos.IDLoja, GetType(Long))

                Using rep As New RepositorioParametrosContexto
                    resposta = rep.DaListaParametrosTree(IDEmpresa, IDLoja)
                End Using

                Return Json(resposta, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return Json(ex.Message)
            End Try
        End Function
#End Region

    End Class
End Namespace
