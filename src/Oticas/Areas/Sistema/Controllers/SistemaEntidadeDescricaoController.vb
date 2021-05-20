Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaEntidadeDescricaoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadeDescricao, SistemaEntidadeDescricao)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaEntidadeDescricao)
        End Sub
#End Region

    End Class
End Namespace