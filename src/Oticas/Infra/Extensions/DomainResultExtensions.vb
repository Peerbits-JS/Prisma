Imports System.Runtime.CompilerServices
Imports F3M.Core.Domain.Validators
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes

Public Module DomainResultExtensions
    <Extension()>
    Public Function ToPrismaErrors(ByVal domainResult As DomainResult) As JsonResult
        Dim listaNotificacoes As New List(Of ClsF3MRespostaMensagemServidorCliente) From {
            New ClsF3MRespostaMensagemServidorCliente With {
                                .Tipo = TipoAlerta.Informacao,
                                .Mensagem = String.Join(", ", domainResult.ApplicationErros)}
        }

        Return New JsonResult() With {
            .MaxJsonLength = Integer.MaxValue,
            .Data = New With {.Erros = listaNotificacoes},
            .JsonRequestBehavior = JsonRequestBehavior.AllowGet
        }
    End Function

    <Extension()>
    Public Function ToPrismaErrors(Of T)(ByVal domainResult As DomainResult(Of T)) As JsonResult
        Dim listaNotificacoes As New List(Of ClsF3MRespostaMensagemServidorCliente) From {
            New ClsF3MRespostaMensagemServidorCliente With {
                                .Tipo = TipoAlerta.Informacao,
                                .Mensagem = String.Join(", ", domainResult.ApplicationErros)}
        }

        Return New JsonResult() With {
            .MaxJsonLength = Integer.MaxValue,
            .Data = New With {.Erros = listaNotificacoes},
            .JsonRequestBehavior = JsonRequestBehavior.AllowGet
        }
    End Function
End Module

