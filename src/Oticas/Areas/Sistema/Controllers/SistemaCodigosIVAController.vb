Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaCodigosIVAController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCodigosIVA, SistemaCodigosIVA)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaCodigosIVA)
        End Sub
#End Region

    End Class
End Namespace