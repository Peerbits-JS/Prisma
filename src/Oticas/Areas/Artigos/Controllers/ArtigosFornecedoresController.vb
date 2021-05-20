Imports Oticas.Repositorio.Artigos
Imports F3M.Areas.Comum.Controllers

Namespace Areas.Artigos.Controllers
    Public Class ArtigosFornecedoresController
        Inherits GrelhaController(Of BD.Dinamica.Aplicacao, tbArtigosFornecedores, ArtigosFornecedores)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosFornecedores())
        End Sub
#End Region

    End Class
End Namespace
