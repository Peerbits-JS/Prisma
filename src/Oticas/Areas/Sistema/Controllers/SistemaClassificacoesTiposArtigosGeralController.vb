Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaClassificacoesTiposArtigosGeralController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaClassificacoesTiposArtigosGeral, SistemaClassificacoesTiposArtigosGeral)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaClassificacoesTiposArtigosGeral)
        End Sub
#End Region

    End Class
End Namespace
