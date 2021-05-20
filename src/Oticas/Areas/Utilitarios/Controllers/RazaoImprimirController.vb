Imports F3M.Areas.Utilitarios.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Repositorio.Documentos

Namespace Areas.Utilitarios.Controllers
    Public Class RazaoImprimirController
        Inherits RazaoController

        <F3MAcesso>
        Public Function Adiciona(inModelo As F3M.Razao) As JsonResult
            Try
                Dim documentSaleNcaId As Long = 0
                If inModelo.Entidade.ToLower() = "documentosvendas" Then
                    Using salesDocumentRep As New RepositorioDocumentosVendas
                        documentSaleNcaId = salesDocumentRep.GetDocumentSaleNcaId(inModelo.RegistoID)
                    End Using
                End If

                Using ctx As New BD.Dinamica.Aplicacao
                    F3M.Repositorio.UtilitariosComum.RepositorioRazoes.AdicionaEsp(Of tbRazoes)(ctx, inModelo, Nothing)

                    If documentSaleNcaId <> 0 Then
                        inModelo.RegistoID = documentSaleNcaId
                        F3M.Repositorio.UtilitariosComum.RepositorioRazoes.AdicionaEsp(Of tbRazoes)(ctx, inModelo, Nothing)
                    End If
                End Using

                Return RetornaJSONTamMaximo(True)
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
    End Class
End Namespace