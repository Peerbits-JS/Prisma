Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEmissaoFaturaController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEmissaoFatura, SistemaEmissaoFatura)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEmissaoFatura)
        End Sub
#End Region

    End Class
End Namespace