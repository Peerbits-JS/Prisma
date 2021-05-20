Imports Oticas.Repositorio.Artigos
Imports F3M.Modelos.Base
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes

Namespace Areas.Artigos.Controllers
    Public Class ArtigosLentesOftalmicasSuplementosController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbLentesOftalmicasSuplementos, ArtigosLentesOftalmicasSuplementos)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosLentesOftalmicasSuplementos())
        End Sub
#End Region

        <F3MAcesso>
        Function Index(AcaoForm As AcoesFormulario, vistaParcial As Boolean?, IDModelo As Long?, IDLO As Long?) As ActionResult
            Dim LentesOftalmicas As ArtigosLentesOftalmicasSuplementos = Nothing

            Using rp As New RepositorioArtigosLentesOftalmicasSuplementos
                ViewBag.Suplementos = rp.getSuplementosByLente(IDLO, IDModelo)
            End Using


            Return PartialView(LentesOftalmicas)
        End Function
    End Class
End Namespace
