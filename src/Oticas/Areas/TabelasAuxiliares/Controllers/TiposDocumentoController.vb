Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Repositorio.TabelasAuxiliaresComum
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposDocumentoController
        Inherits TiposDocumentoController(Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, TiposDocumento)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposDocumento())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: TabelasAuxiliares/TiposDocumento/Edita/5
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult
            ViewBag.getSeries = RepositorioTipoDoc.GetSeriesById(Of tbTiposDocumentoSeries)(repositorio.BDContexto, ID)
            ViewBag.getDefaultSerie = RepositorioTipoDoc.GetDefaultSerie(Of tbTiposDocumentoSeries)(repositorio.BDContexto, ID)
            ViewBag.ExisteDocumento = RepositorioTipoDoc.ExisteDocumento(Of tbControloDocumentos)(repositorio.BDContexto, ID)
            ViewBag.CodigoNatureza = RepositorioTipoDoc.CodigoNatureza(Of tbTiposDocumento)(repositorio.BDContexto, ID)

            Dim ar As ActionResult = RetornaAcoes(ID, AcoesFormulario.Alterar)

            Using rpSeries As New RepositorioTiposDocumentoSeries
                With DirectCast(DirectCast(ar, PartialViewResult).Model, TiposDocumento)
                    .Series = rpSeries.ListaEsp(ID)
                End With
            End Using

            Return ar
        End Function
#End Region

    End Class
End Namespace
