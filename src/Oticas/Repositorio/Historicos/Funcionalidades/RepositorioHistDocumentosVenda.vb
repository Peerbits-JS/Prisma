﻿Imports System.Data.SqlClient
Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.Comum
Imports Oticas.Repositorio.Documentos

Namespace Repositorio.Historicos
    Public Class RepositorioHistDocumentosVenda
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, Object, F3M.Historicos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' Funcao que retorna o hostorico para os documentos de venda
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="idDocumentoVenda"></param>
        ''' <param name="objFiltro"></param>
        Protected Friend Shared Sub RetornaHistorico(ctx As BD.Dinamica.Aplicacao,
                                                 historico As F3M.Historicos,
                                                 idDocumentoVenda As Long,
                                                 objFiltro As ClsF3MFiltro)

            Dim documentoVenda As tbDocumentosVendas = ctx.tbDocumentosVendas.Find(idDocumentoVenda)

            If documentoVenda IsNot Nothing Then
                ' 1 ---- DOCS ASSOCIADOS ----
                PreencheDocsAssociadosHistoricoVendas(ctx, historico, documentoVenda)

                ' 2 ---- DADOS FINANCEIROS ----
                PreencheDadosFinanceiros(ctx, historico, documentoVenda)

                ' 3 ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(documentoVenda, historico, 3)
            End If
        End Sub
#End Region

#Region "DOCS ASSOCIADOS"
        ''' <summary>
        ''' Funcao que retorna a seccao de documentos associados
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="documentoVenda"></param>
        Private Shared Sub PreencheDocsAssociadosHistoricoVendas(ctx As BD.Dinamica.Aplicacao, historico As F3M.Historicos, documentoVenda As tbDocumentosVendas)
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

            Dim ordem As Integer = 100
            Dim docsAssociados As List(Of tbDocumentosVendas) = RetornaDocumentosAssociados(ctx, documentoVenda.ID)
            For Each doc In docsAssociados
                Dim strAcao As String = String.Concat(" onclick=""UtilsAbreTab('", "/Documentos/DocumentosVendas?IDDrillDown=", doc.ID, "', 'Documentos de Venda','f3icon-doc-finance', '1', '', '')""")

                If doc.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico Then
                    strAcao = String.Concat(" onclick=""UtilsAbreTab('", "/Documentos/DocumentosVendasServicos?IDDrillDown=", doc.ID, "', 'Serviços','f3icon-glasses', '1', '', '')""")
                End If

                Dim linha As New HistoricosSeccaoElementoTableLinhas With {
                .Ordem = ordem,
                .HistoricosSecoesElementosListas = New List(Of HistoricosSecoesElementosListas) From {
                New HistoricosSecoesElementosListas With {.Ordem = 100, .Valor = doc.Documento, .AcaoResultado = HttpUtility.HtmlDecode(strAcao)},
                New HistoricosSecoesElementosListas With {.Ordem = 200, .Valor = doc.DataDocumento},
                New HistoricosSecoesElementosListas With {.Ordem = 300, .Valor = doc.tbEstados.Descricao}}}

                linhas.Add(linha)
                ordem = ordem + 100
            Next

            Dim HSElem = New HistoricosSecoesElementos With {
                .Tipo = RepositorioHistoricos.TipoElemento.Table,
                .Ordem = 1,
                .HistoricosSeccaoElementoTable = New F3M.HistoricosSeccaoElementoTable With {
                    .Colunas = colunas,
                    .Linhas = linhas,
                    .TextoSemLinhas = "Não existem documentos associados."}}

            HistSec.HistoricosSecoesElementos.Add(HSElem)
            historico.HistoricosSecoes.Add(HistSec)
        End Sub
#End Region

#Region "DADOS FINANCEIROS"
        ''' <summary>
        ''' Funcao que retorna a seccao de dados financeiros
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="documentoVenda"></param>
        Private Shared Sub PreencheDadosFinanceiros(ctx As BD.Dinamica.Aplicacao, historico As F3M.Historicos, documentoVenda As tbDocumentosVendas)
            Dim HS As F3M.HistoricosSecoes = Nothing
            Dim HSE As F3M.HistoricosSecoesElementos = Nothing
            Dim strTabela As String = GetType(tbDocumentosVendas).Name

            Dim lojaDesc As String = ctx.Database.SqlQuery(Of String)("select l.descricao as resultado" &
                    " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l" &
                    " inner join " & strTabela & " d on l.id=d.idloja" &
                    " where d.id=" & documentoVenda.ID).FirstOrDefault()

            Dim casasDecTot As Short? = If(documentoVenda?.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
            Dim simbMoeda As String = If(documentoVenda?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)

            dblValor = documentoVenda.ValorPago

            HS = New F3M.HistoricosSecoes With {
                .Titulo = Traducao.EstruturaHistorico.Tesouraria,
                .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                .Icone = "f3icon-eur",
                .Ordem = 2}

            HSE = New F3M.HistoricosSecoesElementos With {
                .Titulo = Traducao.EstruturaAplicacaoTermosBase.Pago,
                .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                .Valor = FormatNumber(dblValor, casasDecTot),
                .Icone = simbMoeda,
                .AcaoCaminho = "FUNC",
                .AcaoIndex = "DocumentosVendasCliqueRecebimentos(this)",
                .Ordem = 1}

            Dim strDataPago As Date? = ctx.Database.SqlQuery(Of Date?)("select max(data) as resultado from tbpagamentosvendas PV inner join tbpagamentosvendaslinhas PVL on PV.ID=PVL.IDPagamentoVenda where PVL.IDDocumentoVenda=" & documentoVenda.ID).FirstOrDefault()

            If strDataPago Is Nothing Then
                HSE.Rodape1 = Operadores.EspacoEmBranco
                HSE.Rodape2 = "--/--/----"
                HSE.Rodape3 = ""
            Else
                HSE.Rodape1 = Traducao.EstruturaHistorico.UltimoPagamento
                HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataPago)
                HSE.Rodape3 = lojaDesc
            End If
            HS.HistoricosSecoesElementos.Add(HSE)

            dblValor = ctx.Database.SqlQuery(Of Double?)("select (case when codigotipoestado='" & TiposEstados.Anulado & "' then 0 else ValorPendente end) as resultado from tbDocumentosVendasPendentes p with (nolock) inner join tbDocumentosVendas d with (nolock) on p.IDDocumentoVenda=d.id where p.iddocumentovenda=" & documentoVenda.ID).FirstOrDefault()

            HSE = New F3M.HistoricosSecoesElementos With {
                .Titulo = Traducao.EstruturaAplicacaoTermosBase.PorPagar,
                .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                .Valor = FormatNumber(dblValor, casasDecTot),
                .Icone = simbMoeda,
                .AcaoCaminho = "FUNC",
                .AcaoIndex = "DocumentosVendasCliquePagamentos(this)",
                .Ordem = 2}

            HS.HistoricosSecoesElementos.Add(HSE)

            dblValor = documentoVenda.TotalMoedaDocumento

            HSE = New F3M.HistoricosSecoesElementos With {
                .Titulo = Traducao.EstruturaAplicacaoTermosBase.TotalDocumento,
                .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                .Valor = FormatNumber(dblValor, casasDecTot),
                .Icone = simbMoeda,
                .Ordem = 3}

            HS.HistoricosSecoesElementos.Add(HSE)
            historico.HistoricosSecoes.Add(HS)
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna os documentos associados
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="idDocumentoVenda"></param>
        ''' <returns></returns>
        Private Shared Function RetornaDocumentosAssociados(ctx As BD.Dinamica.Aplicacao, ByVal idDocumentoVenda As Long) As List(Of tbDocumentosVendas)
            Dim documentosAssociados As New List(Of tbDocumentosVendas)
            Dim documento As String = String.Empty

            'documento 
            Dim linhasDocumento As List(Of tbDocumentosVendasLinhas) = ctx.tbDocumentosVendasLinhas.
            Where(Function(w) w.IDDocumentoVenda = idDocumentoVenda).ToList()

            If linhasDocumento.Any Then
                'set documento
                documento = linhasDocumento.FirstOrDefault.tbDocumentosVendas.Documento

                'documento origem
                For Each linha In linhasDocumento
                    If Not linha.IDDocumentoOrigem Is Nothing Then
                        If Not documentosAssociados.Where(Function(w) w.ID = linha.IDDocumentoOrigem).Any Then

                            Dim documentoAssociado As tbDocumentosVendas = ctx.tbDocumentosVendas.
                                Where(Function(w) w.ID = linha.IDDocumentoOrigem AndAlso
                                Not w.Documento.EndsWith("/")).FirstOrDefault()

                            If Not documentoAssociado Is Nothing Then documentosAssociados.Add(documentoAssociado)
                        End If

                    ElseIf Not String.IsNullOrEmpty(linha.DocumentoOrigem) AndAlso Not linha.DocumentoOrigem.EndsWith("/") Then 'SERVICOS - FT - NC 
                        Dim servicoAssociado As tbDocumentosVendas = ctx.tbDocumentosVendas.Where(Function(w) w.Documento = linha.DocumentoOrigem).FirstOrDefault()

                        If Not servicoAssociado Is Nothing Then
                            If Not documentosAssociados.Where(Function(w) w.ID = servicoAssociado.ID).Any Then
                                documentosAssociados.Add(servicoAssociado)
                            End If
                        End If
                    End If
                Next
            End If

            'documentos em que o documento e origem - NCs
            Dim lista As New List(Of Long)

            lista = ctx.tbDocumentosVendasLinhas.
                        Where(Function(w) w.IDDocumentoOrigem = idDocumentoVenda OrElse
                        (Not String.IsNullOrEmpty(w.DocumentoOrigem) AndAlso Not String.IsNullOrEmpty(documento) AndAlso w.DocumentoOrigem = documento)).
                        Select(Function(s) s.IDDocumentoVenda).Distinct().ToList()

            documentosAssociados.AddRange(ctx.tbDocumentosVendas.
                                              Where(Function(w) lista.Contains(w.ID)).ToList())
            If documentosAssociados.Any Then
                Return documentosAssociados.OrderByDescending(Function(o) o.DataDocumento).ThenByDescending(Function(o) o.DataCriacao).ToList()
            End If

            Return New List(Of tbDocumentosVendas)
        End Function
#End Region
    End Class
End Namespace
