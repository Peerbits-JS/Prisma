Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Comunicacao
Imports Kendo.Mvc.UI
Imports Oticas.Repositorio.Sistema

Namespace Areas.Sistema.Controllers
    Public Class SistemaClassificacoesTiposArtigosController
        Inherits GrelhaSistemaController(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaClassificacoesTiposArtigos, SistemaClassificacoesTiposArtigos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New(New RepositorioSistemaClassificacoesTiposArtigos)
        End Sub
#End Region

#Region "LEITURA"
        Public Function ListaComboTiposFases(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Return RetornaJSONTamMaximo(repositorio.ListaCombo(inObjFiltro).Where(Function(w) w.Codigo = "LO" OrElse w.Codigo = "LC"))
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region
    End Class
End Namespace
