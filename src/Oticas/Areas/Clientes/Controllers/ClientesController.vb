Imports Kendo.Mvc.UI
Imports Kendo.Mvc.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Comunicacao
Imports F3M.Areas.Clientes.Controllers
Imports Oticas.Repositorio
Imports System.Threading.Tasks
Imports F3M.Modelos.Grelhas
Imports F3M.Modelos.BaseDados
Imports Oticas.Repositorio.Exames

Namespace Areas.Clientes.Controllers
    Public Class ClientesController
        Inherits ClientesController(Of Oticas.BD.Dinamica.Aplicacao, tbClientes, Oticas.Clientes)

        ReadOnly _repositorioClientes As RepositorioClientes

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioClientes())

            _repositorioClientes = repositorio
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional ByVal IDVista As Long = 0) As ActionResult
            Dim result As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            With DirectCast(DirectCast(result, PartialViewResult).Model, Oticas.Clientes)
                .Codigo = _repositorioClientes.RetornaProximoCodigo()
                .IDTipoPessoa = 1 : .CodigoTipoPessoa = "S" : .DescricaoTipoPessoa = "Singular"
                .IDFormaPagamento = 1 : .DescricaoFormaPagamento = "NUMERÁRIO"
                .IDCondicaoPagamento = 1 : .DescricaoCondicaoPagamento = "A PRONTO"
                .IDMoeda = ClsF3MSessao.RetornaParametros.MoedaReferencia.ID
                .DescricaoMoeda = ClsF3MSessao.RetornaParametros.MoedaReferencia.DescricaoInteira
                .IDIdioma = If(String.IsNullOrEmpty(ClsF3MSessao.RetornaParametros.Lojas?.IDIdiomaBase), 2, ClsF3MSessao.RetornaParametros.Lojas?.IDIdiomaBase)
                .DescricaoIdioma = If(String.IsNullOrEmpty(ClsF3MSessao.RetornaParametros.Lojas?.DescricaoIdiomaBase), "PORTUGUÊS", ClsF3MSessao.RetornaParametros.Lojas?.DescricaoIdiomaBase)
                .IDEspacoFiscal = 1 : .DescricaoEspacoFiscal = "Nacional"
                .IDRegimeIva = 1 : .DescricaoRegimeIva = "Normal"
                .IDLocalOperacao = 1 : .DescricaoLocalOperacao = "Continente"
                .NContribuinte = If(String.IsNullOrEmpty(ClsF3MSessao.RetornaParametros.NIF_Defeito), "", ClsF3MSessao.RetornaParametros.NIF_Defeito)
                .IDPrecoSugerido = 1 : .DescricaoPrecoSugerido = "PV1"
                .IDPais = If(String.IsNullOrEmpty(ClsF3MSessao.RetornaParametros.Lojas?.IDPais), 184, ClsF3MSessao.RetornaParametros.Lojas?.IDPais)
                .DescricaoPais = If(String.IsNullOrEmpty(ClsF3MSessao.RetornaParametros.Lojas?.DescricaoPais), "Portugal", ClsF3MSessao.RetornaParametros.Lojas?.DescricaoPais)
                .IDPaisPorDefeito = .IDPais : .DescricaoPaisPorDefeito = .DescricaoPais
                .Desconto1 = CDbl(0) : .Desconto2 = CDbl(0) : .Comissao1 = CDbl(0) : .Comissao2 = CDbl(0)
                .Prioridade = CLng(999) : .NMaximoDiasAtraso = CLng(0)
                .IvaCaixa = False
                .PermiteComunicacoes = False
                .IDLocalOperacao = If(ClsF3MSessao.RetornaParametros.Lojas.IDLocalOperacao Is Nothing, 1, ClsF3MSessao.RetornaParametros.Lojas.IDLocalOperacao)
                .DescricaoLocalOperacao = If(ClsF3MSessao.RetornaParametros.Lojas.DescricaoLocalOperacao Is Nothing, 1, ClsF3MSessao.RetornaParametros.Lojas.DescricaoLocalOperacao)
            End With

            Return result
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaF4(TabID As String, CampoClicadoID As String, Optional OrigemAdicionaF4 As String = "", Optional ByVal IDDuplica As Long = 0) As ActionResult
            MyBase.AdicionaF4(TabID, CampoClicadoID, OrigemAdicionaF4, IDDuplica)

            Return Me.Adiciona()
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult

            ' se tem documentos e o nif é inválido
            ViewBag.blnTemDocumentos = _repositorioClientes.TemDocumentos("clientes", ID) > 0

            ' se tem documentos e o nif é válido
            ViewBag.blnNIFValido = _repositorioClientes.TemDocumentos("clientesnif", ID) > 0

            Return RetornaAcoes(ID, AcoesFormulario.Alterar)
        End Function
#End Region

#Region "ESPECIFICO"
        ' Lista entidades por tipo de documento (Grelha)
        <F3MAcesso>
        Public Function ListaDadosPorTipoDoc(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioClientes.ListaPorTipoDoc(request, inObjFiltro))
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function

        ' Lista entidades por tipo de documento (Combo)
        <F3MAcesso>
        Public Function ListaComboPorTipoDoc(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Return RetornaJSONTamMaximo(_repositorioClientes.ListaCombo(inObjFiltro).ToList())
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

        Public Async Function Appointments() As Task(Of ActionResult)
            ViewBag.VistaParcial = True
            Return Await Task.FromResult(View("~/Areas/Clientes/Views/Appointments/Appointments.vbhtml", New ClsMvcKendoGrid))
        End Function

        Public Function GetAppointments(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim res As New List(Of Oticas.Exames)
                Using rpExames As New RepositorioExames
                    res = rpExames.ListaDadosImp(inObjFiltro)
                End Using

                Return RetornaJSONTamMaximo(res)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
    End Class
End Namespace
