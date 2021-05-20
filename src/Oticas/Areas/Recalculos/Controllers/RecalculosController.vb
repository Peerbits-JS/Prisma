Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports Oticas.Repositorio.Recalculos

Namespace Areas.Recalculos
    Public Class RecalculosController
        Inherits F3M.Areas.RecalculosComum.RecalculosController

        Public Shared P As Boolean = False

        Const RecalculosViewsPath As String = "~/F3M/Areas/RecalculosComum/Views/"
        Const RecalculosStockViewsPath As String = RecalculosViewsPath & "RecalculoStocks/"

        ReadOnly _rpRecalculoStocks As RepositorioRecalculos

        Sub New()
            _rpRecalculoStocks = New RepositorioRecalculos
        End Sub


#Region "RECALCULO DE STOCKS"
        ''' <summary>
        ''' Funcao que retorna a acao de recalculo de stocks (view plus model)
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RecalculoStocks() As ActionResult
            'props options
            propOpcaoMenu = ClsF3MSessao.RetornaOpcaoMenu("RecalculoStocks")
            ViewBag.OpcaoMenu = ClsF3MSessao.OpcaoMenu(propOpcaoMenu)
            'get context
            Dim ctx As DbContext = Activator.CreateInstance(Of BD.Dinamica.Aplicacao)
            'instance new model
            Dim modelo As New F3M.RecalculoStocks
            'set props
            With modelo
                .RecalculoStocksArtigos = _rpRecalculoStocks.RetornaArtigosMarcados(ctx)
            End With
            'return action result with new model
            Return View(RecalculosStockViewsPath & "Index.vbhtml", modelo)
        End Function

        ''' <summary>
        ''' Função que retorna todos os artigos marcados para o recalculo de stocks
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function RetornaArtigosMarcados() As JsonResult
            Try
                'get context
                Dim ctx As DbContext = Activator.CreateInstance(Of BD.Dinamica.Aplicacao)
                'return list
                Return RetornaJSONTamMaximo(_rpRecalculoStocks.RetornaArtigosMarcados(ctx))

            Catch ex As Exception
                'error
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        <F3MAcesso>
        Public Function Semaforo() As JsonResult
            Try
                Return RetornaJSONTamMaximo(Not P)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que executa o processo de recalculo de stocks
        ''' </summary>
        ''' <param name="modelo"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function ExecutaRecalculoStocks(modelo As F3M.RecalculoStocks) As JsonResult
            Try
                If P = True Then
                    'throw errror message
                    Throw New Exception(Traducao.EstruturaRecalculos.MsgErroRecalculo) 'A informação foi alterada por outro utilizador, por isso será atualizada. Tente novamente mais tarde.
                Else
                    P = True
                End If

                'lets execute recalculo
                If modelo.REC_Completo Then
                    '[Reconstrução da conta corrente de artigos. = TRUE]
                    _rpRecalculoStocks.ExecutaRecalculoCompletoStocks(Of BD.Dinamica.Aplicacao,
                        tbArtigos,
                        tbArtigosDimensoes,
                        tbArtigosStock,
                        tbTiposArtigos)(modelo)
                Else
                    '[Reconstrução da conta corrente de artigos. = FALSE]
                    _rpRecalculoStocks.ExecutaRecalculoOnlyAtualizacao(Of BD.Dinamica.Aplicacao, tbArtigos, tbF3MRecalculo)(modelo)
                End If

                P = False
                Return RetornaJSONTamMaximo(True)

            Catch ex As Exception
                'set flag to false
                If P AndAlso ex.Message <> Traducao.EstruturaRecalculos.MsgErroRecalculo Then P = False
                'return error
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace
