Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposDocumentoSeriesController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbTiposDocumentoSeries, TiposDocumentoSeries)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposDocumentoSeries())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"

        <F3MAcesso>
        Function Index(vistaParcial As Boolean?, ID As Long?, ByVal defaultSerie As String, ByVal tipoDoc As String) As ActionResult
            Dim TiposDocsSeries As TiposDocumentoSeries = Nothing
            Dim NumDocSerie As Long
            Dim idTipoDoc As Long = 0
            If ID > 0 Then
                TiposDocsSeries = repositorio.ObtemPorObjID(ID)
                idTipoDoc = TiposDocsSeries.IDTiposDocumento
                If (defaultSerie <> TiposDocsSeries.CodigoSerie) Then
                    TiposDocsSeries.SugeridaPorDefeito = False
                End If

                TiposDocsSeries.AcaoFormulario = AcoesFormulario.Alterar
                TiposDocsSeries.TipoPai = TiposDocsSeries.GetType()
                If TiposDocsSeries.NumUltimoDoc Is Nothing Then
                    NumDocSerie = 0
                Else
                    NumDocSerie = TiposDocsSeries.NumUltimoDoc
                End If
            Else
                TiposDocsSeries = New TiposDocumentoSeries
                TiposDocsSeries.AcaoFormulario = AcoesFormulario.Adicionar
                TiposDocsSeries.TipoPai = TiposDocsSeries.GetType()
                NumDocSerie = 0
            End If

            Using rp As New RepositorioTiposDocumentoSeries
                ViewBag.getUltimoDoc = rp.BlnExisteUltimoDoc(ID, idTipoDoc)
            End Using

            Return PartialView(TiposDocsSeries)
        End Function

        ' GET: TabelasAuxiliares/ArmazensLocalizacoes/IndexGrelha
        <F3MAcesso>
        Function IndexGrelha() As ActionResult
            Return View()
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoSeries, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Adicionar)
        End Function

        ' POST: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoSeries, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Alterar)
        End Function

        ' POST: Remove
        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        <HttpPost>
        Function Remove(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoSeries, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Remover)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE LEITURA PARA AS GRELHAS
        <F3MAcesso>
        Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDados(request, inObjFiltro)
        End Function

        ' METODO PARA DE LEITURA PARA A COMBO/DDL
        <F3MAcesso>
        Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDadosCombo(request, inObjFiltro)
        End Function

        'METODO PARA DE CARREGAR DS
        Function GrelhaExcel(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As DataSourceResult = Nothing
                Dim IDSerie As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDSerie", GetType(Long))

                Using rep As New RepositorioTiposDocumentoSeriesPermissoes
                    result = rep.getPermissoes(IDSerie).ToDataSourceResult(request)
                End Using

                Return RetornaJSONTamMaximo(result)

            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que verifica se pode inativar a serie
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Function PermiteInAtivarSerie(inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim res As SerieInAtivar = New SerieInAtivar
                Dim IDSerie As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDSerie", GetType(Long))
                Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "IDTipoDoc", GetType(Long))

                Using rep As New RepositorioTiposDocumentoSeries
                    res = rep.PermiteInAtivarSerie(IDSerie, IDTipoDoc)
                End Using

                Return Json(res, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace
