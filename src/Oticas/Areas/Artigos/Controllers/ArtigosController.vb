Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Areas.Comum.Controllers
Imports Oticas.Repositorio.Artigos
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Comunicacao
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Repositorio

Namespace Areas.Artigos.Controllers
    Public Class ArtigosController
        Inherits FotosController(Of BD.Dinamica.Aplicacao, tbArtigos, Oticas.Artigos)
        Const ArtigosViewsPath As String = "~/Areas/Artigos/Views/Artigos/"

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioArtigos())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ''' <summary>
        ''' Funcao overrides Adiciona
        ''' </summary>
        ''' <param name="CampoValorPorDefeito"></param>
        ''' <param name="IDVista"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional IDVista As Long = 0) As ActionResult
            'get action result
            Dim resAr As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            'get model
            Dim ArtigosMOD As Oticas.Artigos = DirectCast(DirectCast(resAr, PartialViewResult).Model, Oticas.Artigos)

            'model with default info
            ArtigosMOD = RetornaInformacaoPorDefeito(ArtigosMOD)

            'return  action result
            Return resAr
        End Function

        ''' <summary>
        ''' Funcao overrides AdicionaF4
        ''' </summary>
        ''' <param name="TabID"></param>
        ''' <param name="CampoClicadoID"></param>
        ''' <param name="OrigemAdicionaF4"></param>
        ''' <param name="IDDuplica"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaF4(TabID As String, CampoClicadoID As String, Optional OrigemAdicionaF4 As String = "", Optional ByVal IDDuplica As Long = 0) As ActionResult
            'get action result
            Dim resAr As ActionResult = MyBase.AdicionaF4(TabID, CampoClicadoID, OrigemAdicionaF4, IDDuplica)

            'get model
            Dim ArtigosMOD As Oticas.Artigos = DirectCast(DirectCast(resAr, PartialViewResult).Model, Oticas.Artigos)

            If IDDuplica <> 0 Then
                'model from duplica
                Dim Art As Oticas.Artigos = DirectCast(DirectCast(MyBase.Edita(IDDuplica), PartialViewResult).Model, Oticas.Artigos)

                ArtigosMOD = RetornaModeloDuplicado(Art, IDDuplica)

            Else
                'model with default info
                ArtigosMOD = RetornaInformacaoPorDefeito(ArtigosMOD)
            End If

            'return  action result
            Return resAr
        End Function

        ''' <summary>
        ''' ''' Funcao overrides Edita
        ''' </summary>
        ''' <param name="ID"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Alterar)>
        Public Overrides Function Edita(Optional ByVal ID As Long = 0) As ActionResult
            Using rpArtigosComponentes As New RepositorioArtigosComponentes
                ViewBag.ExistemArtigosComponentes = rpArtigosComponentes.ExistemComponentes(ID)
            End Using

            Using rpArtigos As New RepositorioArtigos
                ViewBag.ExistemMovimentosStock = rpArtigos.ExistemDocumentosArtigos(ID)
            End Using

            Using rpLentesOftalmicas As New RepositorioArtigosLentesOftalmicas
                ViewBag.IDLenteOftalmica = rpLentesOftalmicas.getIDLenteOftalmica(ID)
            End Using

            Using rpClientes As New RepositorioClientes
                If rpClientes.TemDocumentos("artigos", ID) > 0 Then
                    ViewBag.blnTemDocumentos = True
                    ViewBag.ExistemMovimentosStock = True
                Else
                    ViewBag.blnTemDocumentos = False
                End If
            End Using

            Return RetornaAcoes(ID, AcoesFormulario.Alterar)
        End Function
#End Region

#Region "ACOES DE LEITURA"
        ''' <summary>
        ''' Funcao de leitura para as combos
        ''' </summary>
        ''' <param name="request"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function ListaComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of Oticas.Artigos) = Nothing

                Using rep As New RepositorioArtigos
                    result = rep.ListaComboCodigo(inObjFiltro)
                End Using

                Return Json(result, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' funcao que retorna uma partial vazia
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks></remarks>
        <F3MAcesso>
        Function EmptyPartial() As ActionResult
            Return New EmptyResult
        End Function

        ''' <summary>
        ''' funcao que atribui o proximo codigo do artigo
        ''' </summary>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        <F3MAcesso>
        Public Function ProximoCodigo(Optional inObjFiltro As ClsF3MFiltro = Nothing) As ActionResult
            Dim strCodigo As String = String.Empty
            Dim strGrupo As String = inObjFiltro.FiltroTexto
            'Dim Codigo As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "Codigo", GetType(String))
            'Dim Tipos() As String = {"AR", "OS", "LO", "LC", "DV", "PR", "ML"} 'Tipos

            Using rm As New RepositorioMarcas
                If ClsF3MSessao.RetornaParametros.Lojas.ParametroArtigoCodigo = True Then
                    strCodigo = rm.AtribuirCodigo(1, strGrupo)
                    'If Codigo = String.Empty OrElse Tipos.Contains(Left(Codigo.ToUpper, 2)) Then
                    '    strCodigo = rm.AtribuirCodigo(1, strGrupo)
                    'Else
                    '    strCodigo = Codigo
                    'End If
                End If

            End Using

            Return Content(strCodigo)
        End Function

        ''' <summary>
        ''' funcao que atribui valores por defeito -> UNIDADES, (...)
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function RetornaInformacaoPorDefeito(inModelo As Oticas.Artigos) As Oticas.Artigos
            'unidade por defeito
            Dim UnidadePorDefeito As Unidades
            Using rp As New RepositorioUnidades
                UnidadePorDefeito = rp.GetUnidadePorDefeito()
            End Using

            With inModelo
                If UnidadePorDefeito IsNot Nothing Then
                    'unidades de venda
                    .IDUnidadeVenda = UnidadePorDefeito.ID : .DescricaoUnidadeVenda = UnidadePorDefeito.Descricao

                    'unidades de compra
                    .IDUnidadeCompra = UnidadePorDefeito.ID : .DescricaoUnidadeCompra = UnidadePorDefeito.Descricao

                    'unidades de stock
                    .IDUnidadeStock = UnidadePorDefeito.ID : .DescricaoUnidadeStock = UnidadePorDefeito.Descricao
                End If

                'gere lotes
                .GereLotes = False

                'percentagens
                .DedutivelPercentagem = CDbl(100) : .IncidenciaPercentagem = CDbl(100)
            End With

            'return model
            Return inModelo
        End Function
#End Region

#Region "DUPLICA"
        ''' <summary>
        ''' Funcao para a duplicacao de artigos
        ''' </summary>
        ''' <param name="ID"></param>
        ''' <param name="IDVista"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <param name="CampoValorPorDefeito"></param>
        ''' <param name="IDDuplica"></param>
        ''' <returns></returns>
        <F3MAcesso(Acao:=AcoesFormulario.Duplicar)>
        Public Overrides Function Duplica(ID As Long, IDVista As Long, inObjFiltro As ClsF3MFiltro, CampoValorPorDefeito As String, IDDuplica As Long) As ActionResult
            'get action result
            Dim objActionRes As ActionResult = MyBase.Edita(IDDuplica)

            'get model
            Dim ArtigoMOD As Oticas.Artigos = DirectCast(DirectCast(objActionRes, PartialViewResult).Model, Oticas.Artigos)

            'get copied model
            ArtigoMOD = RetornaModeloDuplicado(ArtigoMOD, IDDuplica)

            'return action result
            Return View(ArtigosViewsPath + "Adiciona.vbhtml", ArtigoMOD)
        End Function

        ''' <summary>
        ''' Funcao que mapeia e retorna o modelo duplicado
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <param name="inIDDuplica"></param>
        ''' <returns></returns>
        Private Function RetornaModeloDuplicado(inModelo As Oticas.Artigos, ByVal inIDDuplica As Long) As Oticas.Artigos
            Dim strCodigo As String = String.Empty

            'reset values
            With inModelo
                'main
                .ID = 0 : .AcaoFormulario = AcoesFormulario.Adicionar : .IDDuplica = inIDDuplica

                'codigo
                Using rm As New RepositorioMarcas
                    strCodigo = rm.AtribuirCodigo(1, Left(.Codigo, 2))
                End Using
                .Codigo = strCodigo : .CodigoBarras = strCodigo

                'stocks
                .PrimeiraEntrada = String.Empty : .PrimeiraSaida = String.Empty : .UltimaEntrada = String.Empty : .UltimaSaida = String.Empty
                .Medio = CDbl(0) : .Atual = CDbl(0) : .Reposicao = CDbl(0) : .Reservado = CDbl(0) : .StockDisponivel = CDbl(0) : .StockReqPendente = CDbl(0)

                'precos
                .UltimoPrecoCompra = Nothing : .UltimoPrecoCusto = Nothing : .UltimosCustosAdicionais = Nothing : .UltimosDescontosComerciais = Nothing
            End With

            ViewBag.blnTemDocumentos = False
            ViewBag.ExistemMovimentosStock = False

            'return model
            Return inModelo
        End Function
#End Region
    End Class
End Namespace
