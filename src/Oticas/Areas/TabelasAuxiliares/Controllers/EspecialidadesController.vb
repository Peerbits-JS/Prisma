Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class EspecialidadesController
        Inherits GrelhaController(Of Oticas.BD.Dinamica.Aplicacao, tbEspecialidades, Especialidades)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioEspecialidades())
        End Sub
#End Region

    End Class
End Namespace
