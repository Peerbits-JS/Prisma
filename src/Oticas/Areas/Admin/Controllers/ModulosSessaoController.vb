Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Modulos

Namespace Areas.Admin.Controllers
    Public Class ModulosSessaoController
        Inherits SimpleFormController

        ''' <summary>
        ''' DEVIDO A NAO TERMOS CONTEXTO PARTILHADO NO F3M ... OU SEJA O CONTEXTO N É PARTILHADO ENTRE AS APLICACOES F3M E ESOCIAL ..
        ''' DESTA FORMA O PEDIDO TEM QUE SER FEITO AO ESOCIAL
        ''' </summary>
        ''' <returns></returns>
        Public Function RetornaModulos() As JsonResult
            Return RetornaJSONTamMaximo(New With {.Erros = Nothing, .Data = ModulosSessao.RetornaModulosSessao()})
        End Function

    End Class
End Namespace