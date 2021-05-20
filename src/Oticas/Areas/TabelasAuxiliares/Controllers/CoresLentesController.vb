Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao
Imports Oticas.Repositorio

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CoresLentesController
        Inherits CoresLentesController(Of BD.Dinamica.Aplicacao, tbCoresLentes, CoresLentes)

        ReadOnly _rpCoresLentes As RepositorioCoresLentes

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCoresLentes())
            _rpCoresLentes = New RepositorioCoresLentes()
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Dim actionResult As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            With DirectCast(DirectCast(actionResult, PartialViewResult).Model, CoresLentes)
                .Codigo = _rpCoresLentes.ProximoCodigo()
            End With

            Return actionResult
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaF4(TabID As String, CampoClicadoID As String, Optional OrigemAdicionaF4 As String = "", Optional IDDuplica As Long = 0) As ActionResult
            Dim actionResult As ActionResult = MyBase.AdicionaF4(TabID, CampoClicadoID, OrigemAdicionaF4, IDDuplica)

            With DirectCast(DirectCast(actionResult, PartialViewResult).Model, CoresLentes)
                .Codigo = _rpCoresLentes.ProximoCodigo()
            End With

            Return actionResult
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult

            Using rp As New RepositorioClientes
                ViewBag.blnTemDocumentos = rp.TemDocumentos("cores", ID) > 0
            End Using

            Return RetornaAcoes(ID, AcoesFormulario.Alterar)
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
#End Region

    End Class
End Namespace
