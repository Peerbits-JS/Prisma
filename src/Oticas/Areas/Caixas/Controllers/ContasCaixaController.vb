Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Caixas


Namespace Areas.Caixas.Controllers
    Public Class ContasCaixaController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbContasCaixa, ContasCaixa)

        Sub New()
            MyBase.New(New RepositorioContasCaixa())
        End Sub


        Public Function CaixasPorLoja(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim lstContasCaixa As New List(Of ContasCaixa)
                Dim idLoja As Long = ClsF3MSessao.RetornaLojaID()

                Using repContasCaixa As New RepositorioContasCaixa
                    lstContasCaixa = repContasCaixa.ObtemCaixasPorLoja(idLoja)
                End Using

                Return RetornaJSONTamMaximo(lstContasCaixa)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

    End Class
End Namespace
