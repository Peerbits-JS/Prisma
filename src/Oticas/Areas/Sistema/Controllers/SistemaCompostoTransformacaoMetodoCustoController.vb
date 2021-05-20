Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaCompostoTransformacaoMetodoCustoController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCompostoTransformacaoMetodoCusto, SistemaCompostoTransformacaoMetodoCusto)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaCompostoTransformacaoMetodoCusto)
        End Sub
#End Region

    End Class
End Namespace