Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.Comum.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class ComunicacaoSmsController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbComunicacao, ComunicacaoSms)

        Sub New()
            MyBase.New(New RepositorioComunicacaoSms())
        End Sub

    End Class
End Namespace
