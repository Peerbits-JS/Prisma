Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class TiposDocumentoTipEntPermDocController
        Inherits ClsF3MController(Of BD.Dinamica.Aplicacao, tbTiposDocumentoTipEntPermDoc, TiposDocumentoTipEntPermDoc)


#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioTiposDocumentoTipEntPermDoc())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: TabelasAuxiliares/ArmazensLocalizacoes
        <F3MAcesso>
        Function Index(vistaParcial As Boolean?) As ActionResult
            Return MyBase.IndexG(vistaParcial)
        End Function

        ' GET: TabelasAuxiliares/ArmazensLocalizacoes/IndexGrelha
        <F3MAcesso>
        Function IndexGrelha() As ActionResult
            Return View()
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Function Adiciona(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoTipEntPermDoc, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Adicionar)
        End Function

        ' POST: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        <HttpPost>
        Function Edita(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoTipEntPermDoc, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Alterar)
        End Function

        ' POST: Remove
        <F3MAcesso(Acao:=AcoesFormulario.Remover)>
        <HttpPost>
        Function Remove(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As TiposDocumentoTipEntPermDoc, filtro As ClsF3MFiltro) As JsonResult
            Return ExecutaAcoes(request, modelo, filtro, AcoesFormulario.Remover)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        ' METODO PARA DE LEITURA PARA AS GRELHAS
        <F3MAcesso>
        Function Lista(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDados(request, inObjFiltro)
        End Function

        ' METODO PARA DE LEITURA PARA A COMBO/DDL
        <F3MAcesso>
        Function ListaCombo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return ListaDadosCombo(request, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace
