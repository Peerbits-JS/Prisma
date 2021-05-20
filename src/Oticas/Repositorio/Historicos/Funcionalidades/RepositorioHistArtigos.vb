Imports F3M
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.Comum

Namespace Repositorio.Historicos
    Public Class RepositorioHistArtigos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, Object, F3M.Historicos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' Funcao que retorna o hostorico para os artigos
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="idArtigo"></param>
        ''' <param name="objFiltro"></param>
        Protected Friend Shared Sub RetornaHistorico(ctx As BD.Dinamica.Aplicacao,
                                                 historico As F3M.Historicos,
                                                 idArtigo As Long,
                                                 objFiltro As ClsF3MFiltro)

            Dim artigo As tbArtigos = ctx.tbArtigos.Find(idArtigo)

            If artigo IsNot Nothing Then
                ' 1 ---- STOCK ARMAZEM ----
                PreencheStockArmazens(ctx, historico, artigo)

                ' 2 ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(artigo, historico, 2)
            End If
        End Sub
#End Region

#Region "STOCK POR ARMAZEM"
        ''' <summary>
        ''' Funcao que retorna a seccao de stocks por armazens
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="artigo"></param>
        Private Shared Sub PreencheStockArmazens(ctx As BD.Dinamica.Aplicacao, historico As F3M.Historicos, artigo As tbArtigos)
            Dim HistSec As HistoricosSecoes = New HistoricosSecoes With {
                             .Titulo = "STOCK",
                             .Tipo = RepositorioHistoricos.TipoSeccao.Parametrizavel,
                             .Icone = "f3icon-doc-finance",
                             .ClassesCssExtra = "col-6 col-lg-4 col-lg-3 f3m-card card2item",
                             .Ordem = 1}

            'COLUNAS
            Dim colunas As New List(Of F3M.HistoricosSeccaoElementoTableColunas) From {
                New HistoricosSeccaoElementoTableColunas With {.Ordem = 100, .Descricao = "Armazém"},
                New HistoricosSeccaoElementoTableColunas With {.Ordem = 200, .Descricao = "Qtd.", .ClassesCssExtra = "text-right"}
            }

            'LINHAS
            Dim linhas As New List(Of HistoricosSeccaoElementoTableLinhas)

            Dim stkArt = ctx.tbStockArtigos.Where(Function(f) f.IDArtigo = artigo.ID AndAlso f.IDArmazem IsNot Nothing).GroupBy(Function(g) g.IDArmazem).ToList()

            If stkArt.Any Then
                For Each grp In stkArt
                    Dim strAcao As String = String.Concat(" onclick=""UtilsAbreTab('", "/TabelasAuxiliares/Armazens?IDDrillDown=", grp.FirstOrDefault.tbArmazens.ID, "', 'Armazéns','f3icon-armazem', '1', '', '')""")

                    Dim linha As New HistoricosSeccaoElementoTableLinhas With {
                        .Ordem = 100,
                        .HistoricosSecoesElementosListas = New List(Of HistoricosSecoesElementosListas) From {
                        New HistoricosSecoesElementosListas With {.Ordem = 100, .Valor = grp.FirstOrDefault.tbArmazens.Descricao, .AcaoResultado = HttpUtility.HtmlDecode(strAcao)},
                        New HistoricosSecoesElementosListas With {.Ordem = 200, .Valor = grp.Sum(Function(s) s.Quantidade) & " " & grp.FirstOrDefault.tbArtigos.tbUnidades.Codigo, .ClassesCssExtra = "text-right"}}}

                    linhas.Add(linha)
                Next
            End If

            Dim HSElem = New HistoricosSecoesElementos With {
                .Tipo = RepositorioHistoricos.TipoElemento.Table,
                .Ordem = 1,
                .HistoricosSeccaoElementoTable = New F3M.HistoricosSeccaoElementoTable With {
                    .Colunas = colunas,
                    .Linhas = linhas,
                    .TextoSemLinhas = "Não existe stock em nenhum armazém."}}

            HistSec.HistoricosSecoesElementos.Add(HSElem)
            historico.HistoricosSecoes.Add(HistSec)
        End Sub
#End Region
    End Class
End Namespace
