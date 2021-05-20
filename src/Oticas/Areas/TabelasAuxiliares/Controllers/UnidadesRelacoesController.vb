Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class UnidadesRelacoesController
        Inherits UnidadesRelacoesController(Of BD.Dinamica.Aplicacao, tbUnidadesRelacoes, UnidadesRelacoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioUnidadesRelacoes())
        End Sub
#End Region

    End Class
End Namespace
