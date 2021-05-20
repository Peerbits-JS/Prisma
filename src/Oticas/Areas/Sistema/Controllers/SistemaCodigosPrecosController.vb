Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaCodigosPrecosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCodigosPrecos, SistemaCodigosPrecos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaCodigosPrecos)
        End Sub
#End Region

    End Class
End Namespace