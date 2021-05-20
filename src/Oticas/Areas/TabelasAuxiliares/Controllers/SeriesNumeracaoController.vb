Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class SeriesNumeracaoController
        Inherits ClsF3MController(Of Oticas.BD.Dinamica.Aplicacao, tbSeriesNumeracao, SeriesNumeracao)

        Const strOpcaoMenu As String = OpcoesAcesso.cTabelasAuxiliaresSeriesNumeracao

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSeriesNumeracao(), strOpcaoMenu)
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: TabelasAuxiliares/SeriesNumeracao
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Function Index(vistaParcial As Boolean?) As ActionResult
            Return MyBase.IndexG(vistaParcial)
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As SeriesNumeracao, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, inObjFiltro, AcoesFormulario.Adicionar)
        End Function

        ' POST: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As SeriesNumeracao, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, inObjFiltro, AcoesFormulario.Alterar)
        End Function

        ' POST: Remove
        <F3MAcesso(Acao:=AcoesFormulario.Remover, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Function Remove(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As SeriesNumeracao, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, inObjFiltro, AcoesFormulario.Remover)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE LEITURA PARA AS GRELHAS
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDados(request, inObjFiltro)
        End Function

        ' METODO PARA DE LEITURA PARA A COMBO/DDL
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDadosCombo(request, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace
