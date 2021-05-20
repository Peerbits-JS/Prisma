Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaComunicacaoSmsController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaComunicacao, SistemaComunicacaoSms)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaComunicacaoSms)
        End Sub
#End Region

    End Class
End Namespace