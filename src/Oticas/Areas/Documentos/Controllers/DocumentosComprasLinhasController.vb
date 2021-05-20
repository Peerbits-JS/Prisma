Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Areas.Documentos.Controllers
Imports Oticas.Repositorio.Documentos

Namespace Areas.Documentos.Controllers
    Public Class DocumentosComprasLinhasController
        Inherits DocumentosLinhasController(Of BD.Dinamica.Aplicacao, tbDocumentosComprasLinhas, DocumentosComprasLinhas)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioDocumentosComprasLinhas)
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE CARREGAR DS
        <F3MAcesso>
        Function GrelhaExcel(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As DataSourceResult = Nothing

                Using repDCL As New RepositorioDocumentosComprasLinhas
                    result = repDCL.Lista(inObjFiltro).ToDataSourceResult(request)
                End Using

                Return RetornaJSONTamMaximo(result)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace