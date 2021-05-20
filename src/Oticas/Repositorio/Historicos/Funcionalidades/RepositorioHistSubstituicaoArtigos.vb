Imports F3M
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.Comum

Namespace Repositorio.Historicos
    Public Class RepositorioHistSubstituicaoArtigos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, Object, F3M.Historicos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' Funcao que retorna o hostorico para os servicos
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="idDocumentoVendaServico"></param>
        ''' <param name="objFiltro"></param>
        Protected Friend Shared Sub RetornaHistorico(ctx As BD.Dinamica.Aplicacao,
                                                 historico As F3M.Historicos,
                                                 idDocumentoVendaServico As Long,
                                                 objFiltro As ClsF3MFiltro)

            Dim documentoVendaServico As tbDocumentosVendas = ctx.tbDocumentosVendas.Find(idDocumentoVendaServico)

            If documentoVendaServico IsNot Nothing Then
                ' 1 ---- DOCS ASSOCIADOS AO SERVICO ----
                PreencheDocsAssociadosAoServicoHistoricoServico(ctx, historico, documentoVendaServico)

                ' 2 ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(documentoVendaServico, historico, 3)
            End If
        End Sub
#End Region

#Region "DOCS ASSOCIADOS AO SERVICO"
        ''' <summary>
        ''' Funcao que retorna a seccao de documentos associados ao servico (FA // FT // FR // FS // FRA)
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="documentoVendaServico"></param>
        Private Shared Sub PreencheDocsAssociadosAoServicoHistoricoServico(ctx As BD.Dinamica.Aplicacao,
                                                                           historico As F3M.Historicos,
                                                                           documentoVendaServico As tbDocumentosVendas)
            Dim HistSec As HistoricosSecoes = New HistoricosSecoes With {
                             .Titulo = "Documentos Associados",
                             .Tipo = RepositorioHistoricos.TipoSeccao.Parametrizavel,
                             .Icone = "f3icon-doc-finance",
                             .ClassesCssExtra = "col-6 col-md-4 f3m-card card3item",
                             .Ordem = 1}
            'COLUNAS
            Dim colunas As New List(Of F3M.HistoricosSeccaoElementoTableColunas) From {
                New HistoricosSeccaoElementoTableColunas With {.Ordem = 100, .Descricao = "Documento"},
                New HistoricosSeccaoElementoTableColunas With {.Ordem = 200, .Descricao = "Data"},
                New HistoricosSeccaoElementoTableColunas With {.Ordem = 300, .Descricao = "Estado"}
            }

            'LINHAS
            Dim linhas As New List(Of HistoricosSeccaoElementoTableLinhas)
            Dim docOrigem As tbDocumentosVendas = RetornaDocumentosAssociadosAoServico(ctx, documentoVendaServico)
            Dim strAcao As String = String.Concat(" onclick=""UtilsAbreTab('", "/Documentos/DocumentosVendasServicos?IDDrillDown=", docOrigem.ID, "', 'Serviços','f3icon-doc-finance', '1', '', '')""")

            Dim linha As New HistoricosSeccaoElementoTableLinhas With {
                    .Ordem = 100,
                    .HistoricosSecoesElementosListas = New List(Of HistoricosSecoesElementosListas) From {
                        New HistoricosSecoesElementosListas With {.Ordem = 100, .Valor = docOrigem.Documento, .AcaoResultado = HttpUtility.HtmlDecode(strAcao), .ClassesCssExtra = "clsF3MHistorico"},
                        New HistoricosSecoesElementosListas With {.Ordem = 200, .Valor = docOrigem.DataDocumento},
                        New HistoricosSecoesElementosListas With {.Ordem = 300, .Valor = docOrigem.tbEstados.Descricao}}}

            linhas.Add(linha)

            Dim HSElem = New HistoricosSecoesElementos With {
                .Tipo = RepositorioHistoricos.TipoElemento.Table,
                .Ordem = 1,
                .HistoricosSeccaoElementoTable = New HistoricosSeccaoElementoTable With {
                    .Colunas = colunas,
                    .Linhas = linhas,
                    .TextoSemLinhas = "Não existe serviço associado."}}

            HistSec.HistoricosSecoesElementos.Add(HSElem)
            historico.HistoricosSecoes.Add(HistSec)
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna o servico origem
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="documentoVendaServico"></param>
        ''' <returns></returns>
        Private Shared Function RetornaDocumentosAssociadosAoServico(ctx As BD.Dinamica.Aplicacao,
                                                                     ByVal documentoVendaServico As tbDocumentosVendas) As tbDocumentosVendas
            Dim idDocOrigem As Long = documentoVendaServico.tbDocumentosVendasLinhas.FirstOrDefault.IDDocumentoOrigemInicial

            If idDocOrigem <> 0 Then
                Return ctx.tbDocumentosVendas.FirstOrDefault(Function(w) w.ID = idDocOrigem)
            End If

            Return New tbDocumentosVendas
        End Function
#End Region
    End Class
End Namespace
