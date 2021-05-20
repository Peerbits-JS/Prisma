Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Imports F3M.Areas.TabelasAuxiliares.Controllers

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposRelacaoController
        Inherits TiposRelacaoController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposRelacao, TiposRelacao)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposRelacao())
        End Sub
#End Region

    End Class
End Namespace
