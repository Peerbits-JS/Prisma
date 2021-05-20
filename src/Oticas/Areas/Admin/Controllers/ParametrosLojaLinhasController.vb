Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.Administracao
Imports Oticas.Repositorio.Sistema

Namespace Areas.Admin.Controllers
    Public Class ParametrosLojaLinhasController
        Inherits GrelhaController(Of F3MEntities, tbParametrosLojaLinhas, ParametrosLojaLinhas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioParametrosLojaLinhas())
        End Sub
#End Region


#Region "ACOES DE LEITURA"
        'METODO PARA DE CARREGAR DS
        Function GrelhaExcel(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As DataSourceResult = Nothing
                Dim IDParametrosLoja As Long
                Dim IDLoja As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDLoja", GetType(Long))
                Dim ModoExecucao As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "ModoExecucao", GetType(Long))

                Using rp As New RepositorioParametrosLoja
                    IDParametrosLoja = rp.getID(IDLoja)
                End Using

                If ModoExecucao = AcoesFormulario.Adicionar Then
                    Using rep As New RepositorioSistemaParametrosLoja
                        result = rep.getLinhas(IDParametrosLoja, ModoExecucao).ToDataSourceResult(request)
                    End Using
                Else
                    Using rep As New RepositorioParametrosLojaLinhas
                        result = rep.getLinhas(IDLoja, ModoExecucao).ToDataSourceResult(request)
                    End Using
                End If

                Return RetornaJSONTamMaximo(result)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace
