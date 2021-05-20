Imports System.Data.Entity
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Modelos.Constantes

Namespace Areas.MedicosTecnicos.Controllers
    Public Class MedicosTecnicosController(Of ContextoBD As {DbContext, New}, TipoEntidade As Class, TipoObjeto As Class)
        Inherits FotosController(Of ContextoBD, TipoEntidade, TipoObjeto)

        Const strOpcaoMenu As String = OpcoesAcesso.cTabelasMedicosTecnicos

#Region "CONSTRUTORES"
        Sub New(inRepositorio As RepositorioGenerico(Of ContextoBD, TipoEntidade, TipoObjeto))
            MyBase.New(inRepositorio, strOpcaoMenu, TiposEntidade.MedicosTecnicos)
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: Index
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function Index(Optional ByVal IDVista As Long = 0) As ActionResult
            Return MyBase.Index(IDVista)
        End Function

        ' GET: IndexGrelhaForm
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function IndexGrelhaForm(Optional ByVal IDVista As Long = 0) As ActionResult
            Return MyBase.IndexGrelhaForm(IDVista)
        End Function

        ' GET: IndexGrelha
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function IndexGrelha() As ActionResult
            Return MyBase.IndexGrelha()
        End Function

        ' GET: Visualiza
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function Visualiza(ByVal id As Long?) As ActionResult
            Return MyBase.Visualiza(id)
        End Function

        ' GET: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar, Acesso:=strOpcaoMenu)>
        Public Overrides Function Adiciona(IDVista As Long) As ActionResult
            Return MyBase.Adiciona(IDVista)
        End Function

        ' GET: AdicionaF4
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar, Acesso:=strOpcaoMenu)>
        Overloads Function AdicionaF4(TabID As String, CampoClicadoID As String) As ActionResult
            Return MyBase.AdicionaF4(TabID, CampoClicadoID)
        End Function

        ' GET: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar, Acesso:=strOpcaoMenu)>
        Public Overrides Function Edita(ByVal id As Long?) As ActionResult
            Return MyBase.Edita(id)
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        ' POST: Adiciona
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest,
                                           <Bind> ByVal modelo As TipoObjeto, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Adiciona(request, modelo, inObjFiltro)
        End Function

        ' POST: Edita
        <F3MAcesso(Acao:=AcoesFormulario.Alterar, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Public Overrides Function Edita(<DataSourceRequest> request As DataSourceRequest,
                                        <Bind> ByVal modelo As TipoObjeto, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Edita(request, modelo, inObjFiltro)
        End Function

        ' POST: Remove
        <F3MAcesso(Acao:=AcoesFormulario.Remover, Acesso:=strOpcaoMenu)>
        <HttpPost>
        Public Overrides Function Remove(<DataSourceRequest> request As DataSourceRequest,
                                         <Bind> ByVal modelo As TipoObjeto, inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Remove(request, modelo, inObjFiltro)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        ' LEITURA PARA AS GRELHAS
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function Lista(<DataSourceRequest> request As DataSourceRequest,
                                        inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Lista(request, inObjFiltro)
        End Function

        ' LEITURA PARA A COMBO/DDL
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function ListaCombo(<DataSourceRequest> request As DataSourceRequest,
                                             inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.ListaCombo(request, inObjFiltro)
        End Function

        ' PESQUISA NA LISTA BASE
        <F3MAcesso(Acesso:=strOpcaoMenu)>
        Public Overrides Function Pesquisa(<DataSourceRequest> request As DataSourceRequest,
                                           inObjFiltro As ClsF3MFiltro) As JsonResult
            Return MyBase.Pesquisa(request, inObjFiltro)
        End Function
#End Region

    End Class
End Namespace
