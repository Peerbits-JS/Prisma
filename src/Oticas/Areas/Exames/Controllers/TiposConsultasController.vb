Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Exames

Namespace Areas.Exames.Controllers
    Public Class TiposConsultasController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbTiposConsultas, Oticas.TiposConsultas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposConsultas())
        End Sub
#End Region

    End Class
End Namespace