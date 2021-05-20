Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEspacoFiscalController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEspacoFiscal, SistemaEspacoFiscal)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEspacoFiscal)
        End Sub
#End Region

    End Class
End Namespace