Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaFormasCalculoComissoesController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaFormasCalculoComissoes, SistemaFormasCalculoComissoes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaFormasCalculoComissoes)
        End Sub
#End Region

    End Class
End Namespace