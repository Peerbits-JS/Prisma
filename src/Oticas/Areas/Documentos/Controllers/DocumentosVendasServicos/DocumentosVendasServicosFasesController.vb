Imports Oticas.Repositorio.Documentos
Imports F3M.Modelos.Base

Namespace Areas.Documentos.Controllers
    Public Class DocumentosVendasServicosFasesController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbServicosFases, DocumentosVendasServicosFases)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioDocumentosVendasServicosFases)
        End Sub
#End Region
    End Class
End Namespace
