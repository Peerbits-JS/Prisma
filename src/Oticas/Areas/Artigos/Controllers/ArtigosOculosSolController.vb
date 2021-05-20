Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio

Namespace Areas.Artigos.Controllers
    Public Class ArtigosOculosSolController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbOculosSol, ArtigosOculosSol)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigosOculosSol())
        End Sub
#End Region

        <F3MAcesso>
        Function Index(AcaoForm As AcoesFormulario, vistaParcial As Boolean?, IDArtigo As Long?) As ActionResult
            Dim OculosSol As ArtigosOculosSol = Nothing
            Dim blnDuplicar As Boolean = AcaoForm = AcoesFormulario.Adicionar AndAlso IDArtigo IsNot Nothing AndAlso IDArtigo <> 0
            Dim IDOculoSol As Long = If(AcaoForm = AcoesFormulario.Adicionar AndAlso Not blnDuplicar, 0, (From x In repositorio.BDContexto.tbOculosSol Where x.IDArtigo = IDArtigo Select x.ID).FirstOrDefault())

            If IDArtigo <> 0 AndAlso IDOculoSol <> 0 Then
                OculosSol = repositorio.ObtemPorObjID(IDOculoSol)
                OculosSol.TipoPai = GetType(ArtigosOculosSol)
                OculosSol.AcaoFormulario = AcaoForm

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
                OculosSol = New ArtigosOculosSol
                OculosSol.AcaoFormulario = AcoesFormulario.Adicionar
                OculosSol.TipoPai = GetType(ArtigosOculosSol)
            End If

            Return PartialView(OculosSol)
        End Function
    End Class
End Namespace
