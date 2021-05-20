Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes

Namespace Areas.Utilitarios.Controllers
    Public Class IVADescontosController
        Inherits SimpleFormController

        ''' <summary>
        ''' Action que retorna a view dos descontos do iva 
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Consultar)>
        Public Function Index() As ActionResult
            'return view with model
            Return View(RetornaLinhas())
        End Function

        ''' <summary>
        ''' Json result que retorna as linhas de desconto do iva
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Consultar)>
        Public Function ListaLinhas() As JsonResult
            Try
                'return
                Return RetornaJSONTamMaximo(RetornaLinhas())
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''Funcao que grava e retorna o novo modelo para a grelha de descontos do iva
        <F3MAcesso()>
        Public Function GravaObIVADescontos(modelo As List(Of IVA)) As JsonResult
            Try
                'save 
                Using rpIVA As New Repositorio.TabelasAuxiliares.RepositorioIVA
                    rpIVA.GravaObIVADescontos(modelo)
                End Using

                'RETURN NEW MODEL TO UPDATE GRID
                Return RetornaJSONTamMaximo(RetornaLinhas())
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function

        ''' <summary>
        ''' Funcao que retorna as linhas de desconto do iva
        ''' </summary>
        ''' <returns></returns>
        Private Function RetornaLinhas() As List(Of IVA)
            'instance new model
            Dim Model As New List(Of IVA)
            'get list 
            Using rpIVA As New Repositorio.TabelasAuxiliares.RepositorioIVA
                Model = rpIVA.ListaDescontosIVA()
            End Using
            'return model
            Return Model
        End Function
    End Class
End Namespace