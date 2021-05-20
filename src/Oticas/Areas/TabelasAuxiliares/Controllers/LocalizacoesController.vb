Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class LocalizacoesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArmazensLocalizacoes, Localizacoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioLocalizacoes())
        End Sub
#End Region

    End Class
End Namespace