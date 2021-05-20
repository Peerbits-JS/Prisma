Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports Kendo.Mvc.UI

Namespace Areas.Caixas.Controllers

    Public Class AberturaFechoCaixaController
        Inherits F3M.Areas.CaixasComum.AberturaFechoCaixaController

        <F3MAcesso>
        Public Function Index() As ActionResult
            Using ctx As New BD.Dinamica.Aplicacao
                Return MyBase.DesenhaView(Of tbFormasPagamento, tbMapaCaixa, tbContasCaixa)(ctx, ClsF3MSessao.RetornaLojaNome, TiposFormaPagamento.Numerario)
            End Using
        End Function

        <F3MAcesso>
        Public Function InformacaoContaCaixa(<DataSourceRequest> request As DataSourceRequest, filtro As ClsF3MFiltro) As JsonResult
            Try
                Dim idContaCaixa As Long = 0

                If ClsUtilitarios.TemKeyDicionario(filtro.CamposFiltrar, "IDContaCaixa") Then
                    idContaCaixa = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, "IDContaCaixa", GetType(Long))
                End If

                Dim infoCaixa As New F3M.AberturaFechoCaixa

                Using ctx As New BD.Dinamica.Aplicacao
                    infoCaixa = ObtemInformacaoCaixa(Of tbFormasPagamento, tbMapaCaixa)(ctx, TiposFormaPagamento.Numerario, idContaCaixa)
                End Using

                Return RetornaJSONTamMaximo(infoCaixa)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function


        <F3MAcesso>
        Public Function Adiciona(inModelo As F3M.AberturaFechoCaixa) As JsonResult
            Try
                'especifico
                With inModelo
                    .IDLoja = ClsF3MSessao.RetornaLojaID
                End With

                'generico
                Using ctx As New BD.Dinamica.Aplicacao
                    MyBase.AdicionaObj(Of BD.Dinamica.Aplicacao, tbFormasPagamento, tbMapaCaixa)(ctx, inModelo, TiposFormaPagamento.Numerario)
                    Return RetornaJSONTamMaximo(inModelo.EFecho)
                End Using

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

    End Class
End Namespace