Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Repositorio.UtilitariosComum
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.PagamentosVendas.Controllers
    Public Class RecebimentosController
        Inherits SimpleFormController

#Region "ACOES DEFAULT GET CRUD"
        ''' <summary>
        ''' GET Index
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function Index(IDDocumentoVenda As Long) As ActionResult
            Using rp As New RepositorioPagamentosVendas
                ViewBag.ListOfPagamentos = rp.GetPagamentosVendas(IDDocumentoVenda)
            End Using

            Return PartialView()
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        ''' <summary>
        ''' funcao que verifica se e 2ª via
        ''' </summary>
        ''' <param name="IDDocumento"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function DocumentoSegundaVia(IDDocumento As Long) As JsonResult
            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    Using repRaz As New RepositorioRazoes
                        Return RetornaJSONTamMaximo(repRaz.DocumentoSegundaVia(Of tbRecibos)(ctx, IDDocumento))
                    End Using
                End Using
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace