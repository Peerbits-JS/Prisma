Imports Oticas.Repositorio.TabelasAuxiliares
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SuplementosLentesController
        Inherits SuplementosLentesController(Of Oticas.BD.Dinamica.Aplicacao, tbSuplementosLentes, SuplementosLentes)

        ReadOnly _rpSuplementosLentes As RepositorioSuplementosLentes

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSuplementosLentes())

            _rpSuplementosLentes = New RepositorioSuplementosLentes()
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            Dim actionResult As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            With DirectCast(DirectCast(actionResult, PartialViewResult).Model, SuplementosLentes)
                .Codigo = _rpSuplementosLentes.ProximoCodigo()
            End With

            Return actionResult
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaF4(TabID As String, CampoClicadoID As String, Optional OrigemAdicionaF4 As String = "", Optional IDDuplica As Long = 0) As ActionResult
            Dim actionResult As ActionResult = MyBase.AdicionaF4(TabID, CampoClicadoID, OrigemAdicionaF4, IDDuplica)

            With DirectCast(DirectCast(actionResult, PartialViewResult).Model, SuplementosLentes)
                .Codigo = _rpSuplementosLentes.ProximoCodigo()
            End With

            Return actionResult
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
#End Region
    End Class
End Namespace
