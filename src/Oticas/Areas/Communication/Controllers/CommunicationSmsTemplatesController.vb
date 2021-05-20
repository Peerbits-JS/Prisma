Imports System.Threading.Tasks
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports Kendo.Mvc.UI
Imports Oticas.Areas.Communication.Models
Imports Oticas.Repositorio.Communication

Namespace Areas.Communication
    Public Class CommunicationSmsTemplatesController
        Inherits SimpleFormController

        ReadOnly _repositorioComunicacaoSmsTemplates As RepositorioComunicacaoSmsTemplates

#Region "CONSTRUCTOR"
        Sub New()
            _repositorioComunicacaoSmsTemplates = New RepositorioComunicacaoSmsTemplates()
        End Sub
#End Region

#Region "ACTION RESULT"
        Public Function Index() As ActionResult
            Return PartialView(New CommunicationSmsTemplates With {
                .IDSistemaEnvio = _repositorioComunicacaoSmsTemplates.GetMsgSystemDefault(),
                .Grupo = _repositorioComunicacaoSmsTemplates.GetNovoGrupoDefaultValues()
            })
        End Function

        Public Function Template(idTemplate As Long) As ActionResult
            Return PartialView("Index", _repositorioComunicacaoSmsTemplates.Read(idTemplate))
        End Function

        Public Function Copy(idTemplate As Long) As ActionResult
            Return PartialView("Index", _repositorioComunicacaoSmsTemplates.Copy(idTemplate))
        End Function

        Public Function Regra() As ActionResult
            Return PartialView(New CommunicationSmsTemplatesRegras With {.Filtros = _repositorioComunicacaoSmsTemplates.GetFiltros()})
        End Function

        Public Function Grupo() As ActionResult
            Return PartialView(_repositorioComunicacaoSmsTemplates.GetNovoGrupoDefaultValues())
        End Function

        Public Function CondicaoValor(idFiltro As Long) As ActionResult
            Dim condicoes As List(Of CommunicationSmsTemplatesCondicoes) = _repositorioComunicacaoSmsTemplates.GetCondicoes(idFiltro)
            Dim valores As List(Of CommunicationSmsTemplatesValores) = Nothing
            Dim sqlQueryValores As New List(Of SqlQuery)

            If condicoes.Count = 1 Then
                valores = _repositorioComunicacaoSmsTemplates.GetValores(condicoes.FirstOrDefault().ID)

                For Each valo In valores
                    If valo.TipoComponente = "select" OrElse valo.TipoComponente = "multiselect" Then
                        valo.SqlQueryValores = _repositorioComunicacaoSmsTemplates.GetSqlQueryValores(valo.IDSistemaComunicacaoSmsTemplatesValores)
                    End If
                Next
            End If

            Return PartialView(New CommunicationSmsTemplatesRegras With {
                .IDFiltro = idFiltro,
                .Condicoes = condicoes,
                .Valores = valores})
        End Function

        Public Function Valor(idCondicao As Long)
            Dim valores As List(Of CommunicationSmsTemplatesValores) = _repositorioComunicacaoSmsTemplates.GetValores(idCondicao)

            For Each valo In valores
                If valo.TipoComponente = "select" OrElse valo.TipoComponente = "multiselect" Then
                    valo.SqlQueryValores = _repositorioComunicacaoSmsTemplates.GetSqlQueryValores(valo.IDSistemaComunicacaoSmsTemplatesValores)
                End If
            Next

            Return PartialView(valores)
        End Function
#End Region

#Region "JSON RESULT"
        Public Function GetTemplates() As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.GetTemplates())
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        Public Function Create(model As CommunicationSmsTemplates) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.Create(model))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        Public Function Update(model As CommunicationSmsTemplates) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.Update(model))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        Public Function Delete(idTemplate As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.Delete(idTemplate))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try

        End Function
#End Region

#Region "RECIPTS"
        Public Function GetRecipts(idTemplate As Long) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.GetRecipts(idTemplate))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        Public Function SendTemplateSms(model As SendTemplateSms) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioComunicacaoSmsTemplates.SendTemplateSms(model))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

    End Class
End Namespace