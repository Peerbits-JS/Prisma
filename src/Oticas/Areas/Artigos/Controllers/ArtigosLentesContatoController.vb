Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes

Namespace Areas.Artigos.Controllers
    Public Class ArtigosLentesContatoController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbLentesContato, ArtigosLentesContato)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosLentesContato())
        End Sub
#End Region

        <F3MAcesso>
        Function Index(AcaoForm As AcoesFormulario, vistaParcial As Boolean?, IDArtigo As Long?) As ActionResult
            Dim LentesContato As ArtigosLentesContato = Nothing
            Dim blnDuplicar As Boolean = AcaoForm = AcoesFormulario.Adicionar AndAlso IDArtigo IsNot Nothing AndAlso IDArtigo <> 0
            Dim IDLenteContato As Long = If(AcaoForm = AcoesFormulario.Adicionar AndAlso Not blnDuplicar, 0, (From x In repositorio.BDContexto.tbLentesContato Where x.IDArtigo = IDArtigo Select x.ID).FirstOrDefault())

            If IDArtigo <> 0 AndAlso IDLenteContato <> 0 Then
                LentesContato = repositorio.ObtemPorObjID(IDLenteContato)
                LentesContato.TipoPai = GetType(ArtigosLentesContato)
                LentesContato.AcaoFormulario = AcaoForm

                If blnDuplicar Then
                    ViewBag.blnTemDocumentos = False
                End If
            Else
                LentesContato = New ArtigosLentesContato
                LentesContato.AcaoFormulario = AcoesFormulario.Adicionar
                LentesContato.TipoPai = GetType(ArtigosLentesContato)

                LentesContato.Adicao = 0
                LentesContato.Eixo = 0
                LentesContato.PotenciaEsferica = 0
                LentesContato.PotenciaCilindrica = 0
            End If

            Return PartialView(LentesContato)
        End Function
    End Class
End Namespace
