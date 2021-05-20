Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Areas.Documentos.Controllers
Imports Oticas.Repositorio.Documentos

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasLinhasController
        Inherits DocumentosLinhasController(Of Oticas.BD.Dinamica.Aplicacao, tbDocumentosVendasLinhas, DocumentosVendasLinhas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioDocumentosVendasLinhas)
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE CARREGAR DS
        <F3MAcesso>
        Function GrelhaExcel(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As DataSourceResult = repositorio.Lista(inObjFiltro).ToDataSourceResult(request)

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace