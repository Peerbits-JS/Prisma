Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEntidadesEstadosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadesEstados, SistemaEntidadesEstados)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEntidadesEstados)
        End Sub
#End Region

    End Class
End Namespace