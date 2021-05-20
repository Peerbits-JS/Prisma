Imports Kendo.Mvc.UI
Imports F3M.Areas.Utilitarios.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.UtilitariosComum
Imports Oticas.Repositorio.Utilitarios

Namespace Areas.Utilitarios.Controllers
    Public Class SAFTPTGestaoController
        Inherits SAFTController(Of Oticas.BD.Dinamica.Aplicacao, Oticas.tbSAFT, Oticas.SAFTPT)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSAFTPT)
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: Index
        <F3MAcesso>
        Public Overrides Function Index(Optional vistaParcial As Boolean = False, Optional ByVal ID As Long = 0) As ActionResult
            ViewBag.VistaParcial = vistaParcial
            Dim saft As New F3M.SAFT With {.TipoSAFT = 3}
            If vistaParcial Then
                Return PartialView(saft)
            End If

            Return View(saft)
        End Function
#End Region

        '#Region "ACOES DEFAULT POST CRUD"
        '        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        '        <HttpPost>
        '        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest,
        '                                           <Bind> ByVal modelo As SAFTPT, inObjFiltro As ClsF3MFiltro) As JsonResult
        '            Try
        '                If modelo IsNot Nothing Then
        '                    Dim listaSAFT As New List(Of F3M.SAFT) From {modelo}

        '                    RepositorioSAFT.GerarSAFT(
        '                    Of tbParametrosEmpresa, tbDocumentosStock, tbDocumentosStockLinhas,
        '                        tbDocumentosVendas, tbDocumentosVendasLinhas, tbDocumentosVendasFormasPagamento,
        '                        tbRecibos, tbRecibosLinhas, tbRecibosLinhasTaxas, tbRecibosFormasPagamento, tbClientes, tbFornecedores, tbDocumentosCompras, tbDocumentosComprasLinhas)(
        '                            repositorio.BDContexto, listaSAFT, Nothing, Nothing, Nothing, Nothing)

        '                    Dim lngCount As Long = 0

        '                    For Each SAFT In listaSAFT
        '                        Dim o As New Oticas.SAFTPT

        '                        RepositorioSAFTPT.Mapear(SAFT, o)
        '                        lngCount += 1

        '                        If Not ClsTexto.ENuloOuVazio(SAFT.Ficheiro) Then
        '                            If lngCount = listaSAFT.Count Then
        '                                Return ExecutaAcoes(request, o, inObjFiltro, AcoesFormulario.Adicionar)
        '                            Else
        '                                ExecutaAcoes(request, o, inObjFiltro, AcoesFormulario.Adicionar)
        '                            End If
        '                        Else
        '                            Throw New Exception("Erro a guardar SAFT!")
        '                        End If
        '                    Next
        '                End If

        '                Return Nothing
        '            Catch ex As Exception
        '                Return RetornaJSONErrosTamMaximo(ex)
        '            End Try
        '        End Function
        '#End Region

#Region "ACOES DE LEITURA"

#End Region

    End Class
End Namespace
