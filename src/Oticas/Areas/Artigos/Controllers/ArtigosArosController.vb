Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio

Namespace Areas.Artigos.Controllers
    Public Class ArtigosArosController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbAros, ArtigosAros)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosAros())
        End Sub
#End Region

        <F3MAcesso>
        Function Index(AcaoForm As AcoesFormulario, vistaParcial As Boolean?, IDArtigo As Long?) As ActionResult
            Dim Aros As ArtigosAros = Nothing
            Dim blnDuplicar As Boolean = AcaoForm = AcoesFormulario.Adicionar AndAlso IDArtigo IsNot Nothing AndAlso IDArtigo <> 0
            Dim IDAro As Long = If(AcaoForm = AcoesFormulario.Adicionar AndAlso Not blnDuplicar, 0, (From x In repositorio.BDContexto.tbAros Where x.IDArtigo = IDArtigo Select x.ID).FirstOrDefault())

            If IDArtigo <> 0 AndAlso IDAro <> 0 Then
                Aros = repositorio.ObtemPorObjID(IDAro)
                Aros.TipoPai = GetType(ArtigosAros)
                Aros.AcaoFormulario = AcaoForm

                Using rpClientes As New RepositorioClientes
                    If rpClientes.TemDocumentos("artigos", IDArtigo) > 0 Then
                        ViewBag.blnTemDocumentos = True
                    Else
                        ViewBag.blnTemDocumentos = False
                    End If
                End Using

                If blnDuplicar Then
                    ViewBag.blnTemDocumentos = False
                End If
            Else
                Aros = New ArtigosAros
                Aros.AcaoFormulario = AcoesFormulario.Adicionar
                Aros.TipoPai = GetType(ArtigosAros)
            End If

            Return PartialView(Aros)
        End Function
    End Class
End Namespace
