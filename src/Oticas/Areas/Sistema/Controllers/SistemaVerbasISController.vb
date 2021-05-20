Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaVerbasISController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaVerbasIS, SistemaVerbasIS)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaVerbasIS)
        End Sub
#End Region

    End Class
End Namespace