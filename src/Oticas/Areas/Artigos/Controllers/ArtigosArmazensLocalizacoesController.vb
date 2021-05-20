Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos

Namespace Areas.Artigos.Controllers
    Public Class ArtigosArmazensLocalizacoesController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosArmazensLocalizacoes, ArtigosArmazensLocalizacoes)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosArmazensLocalizacoes())
        End Sub
#End Region

    End Class
End Namespace
