Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes

Namespace Areas.Artigos.Controllers
    Public Class ArtigosLentesOftalmicasController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbLentesOftalmicas, ArtigosLentesOftalmicas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosLentesOftalmicas())
        End Sub
#End Region

        <F3MAcesso>
        Function Index(AcaoForm As AcoesFormulario, vistaParcial As Boolean?, IDArtigo As Long?) As ActionResult
            Dim LentesOftalmicas As ArtigosLentesOftalmicas = Nothing

            Dim blnDuplicar As Boolean = AcaoForm = AcoesFormulario.Adicionar AndAlso IDArtigo IsNot Nothing AndAlso IDArtigo <> 0
            Dim IDLenteOftalmica As Long = If(AcaoForm = AcoesFormulario.Adicionar AndAlso Not blnDuplicar, 0, (From x In repositorio.BDContexto.tbLentesOftalmicas Where x.IDArtigo = IDArtigo Select x.ID).FirstOrDefault())
            Dim IDModeloLO As Long = If(AcaoForm = AcoesFormulario.Adicionar OrElse IDLenteOftalmica = 0, 0, (From x In repositorio.BDContexto.tbLentesOftalmicas Where x.IDArtigo = IDArtigo Select x.IDModelo).FirstOrDefault())

            If IDArtigo <> 0 AndAlso IDLenteOftalmica <> 0 Then
                LentesOftalmicas = repositorio.ObtemPorObjID(IDLenteOftalmica)
                LentesOftalmicas.TipoPai = GetType(ArtigosLentesOftalmicas)
                LentesOftalmicas.AcaoFormulario = AcaoForm

                LentesOftalmicas.ArtigosLentesOftalmicasSuplementos = New List(Of ArtigosLentesOftalmicasSuplementos)

                If blnDuplicar Then
                    ViewBag.blnTemDocumentos = False
                End If
            Else
                LentesOftalmicas = New ArtigosLentesOftalmicas
                LentesOftalmicas.AcaoFormulario = AcoesFormulario.Adicionar
                LentesOftalmicas.TipoPai = GetType(ArtigosLentesOftalmicas)

                LentesOftalmicas.Adicao = 0
                LentesOftalmicas.PotenciaEsferica = 0
                LentesOftalmicas.PotenciaCilindrica = 0
                LentesOftalmicas.PotenciaPrismatica = 0
            End If

            Return PartialView(LentesOftalmicas)
        End Function
    End Class
End Namespace
