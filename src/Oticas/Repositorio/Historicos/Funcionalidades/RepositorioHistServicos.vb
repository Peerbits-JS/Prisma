Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.Comum

Namespace Repositorio.Historicos
    Public Class RepositorioHistServicos
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

                'TODO - DIVIDIR POR SECCOES
                PreencheHistorico(ctx, historico, documentoVendaServico)

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

            Dim ordem As Integer = 100
            Dim docsAssociadosAoServico As List(Of tbDocumentosVendas) = RetornaDocumentosAssociadosAoServico(ctx, documentoVendaServico)
            For Each doc As tbDocumentosVendas In docsAssociadosAoServico

                Dim strAcao As String = String.Concat(" onclick=""UtilsAbreTab('", "/Documentos/DocumentosVendas?IDDrillDown=", doc.ID, "', 'Documentos de Venda','f3icon-doc-finance', '1', '', '')""")

                Dim linha As New HistoricosSeccaoElementoTableLinhas With {
                    .Ordem = ordem,
                    .HistoricosSecoesElementosListas = New List(Of HistoricosSecoesElementosListas) From {
                        New HistoricosSecoesElementosListas With {.Ordem = 100, .Valor = doc.Documento, .AcaoResultado = HttpUtility.HtmlDecode(strAcao), .ClassesCssExtra = "clsF3MHistorico"},
                        New HistoricosSecoesElementosListas With {.Ordem = 200, .Valor = doc.DataDocumento},
                        New HistoricosSecoesElementosListas With {.Ordem = 300, .Valor = doc.tbEstados.Descricao}}}

                linhas.Add(linha)
                ordem = ordem + 100
            Next

            Dim HSElem = New HistoricosSecoesElementos With {
                .Tipo = RepositorioHistoricos.TipoElemento.Table,
                .Ordem = 1,
                .HistoricosSeccaoElementoTable = New HistoricosSeccaoElementoTable With {
                    .Colunas = colunas,
                    .Linhas = linhas,
                    .TextoSemLinhas = "Não existem documentos associados."}}

            HistSec.HistoricosSecoesElementos.Add(HSElem)
            historico.HistoricosSecoes.Add(HistSec)
        End Sub
#End Region

#Region "HIST"
        ''' <summary>
        ''' Funcao que retorna todas as seccoes
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="historico"></param>
        ''' <param name="documentoVendaServico"></param>
        Private Shared Sub PreencheHistorico(ctx As BD.Dinamica.Aplicacao, historico As F3M.Historicos, documentoVendaServico As tbDocumentosVendas)
            Dim HS As F3M.HistoricosSecoes = Nothing
            Dim HSE As F3M.HistoricosSecoesElementos = Nothing
            Dim strTabela As String = GetType(tbDocumentosVendas).Name

            Dim casasDecTot As Short? = If(documentoVendaServico.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
            Dim simbMoeda As String = If(documentoVendaServico?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)

            Dim dblValorTotal As Double? = documentoVendaServico?.TotalClienteMoedaDocumento
            Dim dataFat As Date = documentoVendaServico?.DataDocumento
            Dim lojaDesc As String = RepositorioHistoricosOticas.LerValorQuery(ctx,
                    String.Concat("select l.descricao as resultado",
                        " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l",
                        " inner join ", strTabela, " d on l.id=d.idloja",
                        " where d.id=", documentoVendaServico.ID))

            Dim lngIDEstadoDV As Long? = ctx.tbEstados.Where(
                    Function(f) f.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.DocumentosVenda AndAlso
                        f.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo)?.FirstOrDefault?.ID
            Dim lngIDEstadoEfetivoSV As Long? = ctx.tbEstados.Where(
                    Function(f) f.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.Servicos AndAlso
                        f.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo)?.FirstOrDefault?.ID

            Dim strDataFaturado As String = RepositorioHistoricosOticas.LerValorQuery(ctx, "select max(convert(nvarchar(10), datadocumento, 105)) As resultado from tbDocumentosVendas DV inner join tbDocumentosVendasLinhas DVL On DV.ID=dvl.IDDocumentoVenda inner join tbtiposdocumento TD On DV.IDTipoDocumento=TD.id where td.Adiantamento=0 And DV.idestado=" & lngIDEstadoDV & " And (dvl.iddocumentoorigem=" & documentoVendaServico.ID & " or (dvl.iddocumentoorigeminicial=" & documentoVendaServico.ID & " and dvl.idlinhadocumentoorigeminicial is null))", True)
            Dim acaoCaminhoFaturado As String = String.Empty
            Dim acaoIndexFaturado As String = String.Empty

            If IsDate(strDataFaturado) Then
                blnTemDocumento = True
                acaoCaminhoFaturado = "FUNC"
                acaoIndexFaturado = "ServicosAbreDocumentoVendaAssociadoFromHistorico()"

                dblValorFaturado = CDbl(RepositorioHistoricosOticas.LerValorQuery(ctx, "Select sum(total) As resultado from (select isnull(sum((Case When t.IDSistemaNaturezas=6 Then ValorIncidencia+valoriva Else -(ValorIncidencia+valoriva) End)),0) As total from tbDocumentosVendasLinhas DVL inner join
                            (Select distinct dv.id, td.IDSistemaNaturezas from  tbDocumentosVendas DV inner join tbDocumentosVendasLinhas DVL On DV.ID=dvl.IDDocumentoVenda 
                             inner Join tbtiposdocumento TD On DV.IDTipoDocumento=TD.id 
                             where td.Adiantamento=0 And dv.idestado=" & lngIDEstadoDV & " And (dvl.iddocumentoorigem=" & documentoVendaServico.ID & " or (dvl.iddocumentoorigeminicial=" & documentoVendaServico.ID & " and dvl.idlinhadocumentoorigeminicial is null))) t on dvl.iddocumentovenda=t.id) v ", True))
                dblPorFaturar = 0
                dblValorAdiantamento = 0
                strDataAdiantamento = ""

                strDataPago = RepositorioHistoricosOticas.LerValorQuery(ctx, "Select convert(nvarchar(10), max(data), 105) As resultado from tbpagamentosvendas PV inner join tbpagamentosvendasLinhas PVL On PV.ID=PVL.IDPagamentoVenda inner join tbdocumentosvendasLinhas DVL On PVL.IDDocumentoVenda=dvl.IDDocumentoVenda where DVL.IDDocumentoOrigem=" & documentoVendaServico.ID, False)
                dblValorPago = CDbl(RepositorioHistoricosOticas.LerValorQuery(ctx, "Select (isnull(valorpago,0)) As resultado from " & strTabela & " where ID=" & documentoVendaServico.ID, True))
                dblValorcomparticipacoes = CDbl(RepositorioHistoricosOticas.LerValorQuery(ctx, "Select sum(total) As resultado from (Select isnull(sum((Case When td.IDSistemaNaturezas=6 Then valorentidade1 Else -(valorentidade1) End)),0) As total from " & strTabela & " DV inner join tbDocumentosVendasLinhas DVL On DV.ID=dvl.IDDocumentoVenda inner join tbtiposdocumento TD On DV.IDTipoDocumento=TD.id where td.Adiantamento=0 And dv.idestado=" & lngIDEstadoDV & " And dvl.iddocumentoorigem=" & documentoVendaServico.ID & ") t", True))

                If documentoVendaServico.CodigoTipoEstado = TiposEstados.Anulado Then
                    dblValorPorPagar = 0
                Else
                    dblValorPorPagar = dblValorFaturado - dblValorcomparticipacoes - dblValorPago
                End If
            Else
                blnTemDocumento = False
                dblValorFaturado = 0
                dblPorFaturar = CDbl(RepositorioHistoricosOticas.LerValorQuery(ctx, "Select isnull(sum(ValorIncidencia+valoriva),0) As resultado from " & strTabela & " DV inner join tbDocumentosVendasLinhas DVL On DV.ID=dvl.IDDocumentoVenda where dv.idestado=" & lngIDEstadoEfetivoSV & " And dvl.iddocumentovenda=" & documentoVendaServico.ID, False))

                strDataAdiantamento = RepositorioHistoricosOticas.LerValorQuery(ctx, "Select max(convert(nvarchar(10), dv.datadocumento, 105)) As resultado from " & strTabela & " DV inner join tbDocumentosVendasLinhas DVL On DV.ID=dvl.IDDocumentoVenda inner join tbtiposdocumento TD On DV.IDTipoDocumento=TD.ID inner join tbSistemaTiposDocumentoFiscal TDF On TD.IDSistemaTiposDocumentoFiscal=TDF.ID where DV.idestado=" & lngIDEstadoDV & " And TDF.Tipo='FR' and TD.Adiantamento=1 and DVL.iddocumentoorigem=" & documentoVendaServico.ID, False)

                dblValorAdiantamento = CDbl(RepositorioHistoricosOticas.LerValorQuery(ctx,
                        "SELECT ISNULL(SUM(DVL.ValorIncidencia + DVL.ValorIVA), 0) AS resultado" &
                            " FROM " & strTabela & " AS DV " &
                                " INNER JOIN tbDocumentosVendasLinhas AS DVL ON DV.ID = DVL.IDDocumentoVenda" &
                                " INNER JOIN tbTiposDocumento AS TD ON DV.IDTipoDocumento = TD.ID" &
                                " INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF ON TDF.ID = TD.IDSistemaTiposDocumentoFiscal" &
                            " WHERE DV.IDEstado =" & lngIDEstadoDV & " AND DVL.iddocumentoorigem =" & documentoVendaServico.ID &
                            " AND TD.Adiantamento = 1 AND TDF.Tipo = '" & TiposDocumentosFiscal.FaturaRecibo & "'", True))

                strDataPago = ""
                dblValorPago = 0

                If documentoVendaServico.CodigoTipoEstado = TiposEstados.Anulado Then
                    dblValorPorPagar = 0
                    dblPorFaturar = 0
                Else
                    dblValorPorPagar = dblValorTotal - dblValorAdiantamento
                End If
            End If

            ' ---- FINANCEIRO ----
            HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaHistorico.Financeiro,
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Icone = "f3icon-moedas",
                    .Ordem = 1}

            HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = Traducao.EstruturaHistorico.PorFaturar,
                    .Valor = FormatNumber(dblPorFaturar, casasDecTot),
                    .Icone = simbMoeda,
                    .Ordem = 1}
            HS.HistoricosSecoesElementos.Add(HSE)

            HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = Traducao.EstruturaHistorico.Faturado,
                    .Valor = FormatNumber(dblValorFaturado, casasDecTot),
                    .AcaoCaminho = acaoCaminhoFaturado,
                    .AcaoIndex = acaoIndexFaturado,
                    .Icone = simbMoeda,
                    .Ordem = 2}

            If Not IsDate(strDataFaturado) Then
                HSE.Rodape1 = Operadores.EspacoEmBranco
                HSE.Rodape2 = "--/--/----"
                HSE.Rodape3 = ""
            Else
                HSE.Rodape1 = Traducao.EstruturaHistorico.UltimoFaturado
                HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataFaturado)
                HSE.Rodape3 = lojaDesc
            End If
            HS.HistoricosSecoesElementos.Add(HSE)
            historico.HistoricosSecoes.Add(HS)

            ' ---- TESOURARIA ----
            HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaHistorico.Tesouraria,
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Icone = "f3icon-eur",
                    .Ordem = 2}

            HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = "Adiantamento",
                    .Valor = FormatNumber(dblValorAdiantamento, casasDecTot),
                    .Icone = simbMoeda,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "ServicosAbreRecebimentos(this)",
                    .Ordem = 1}

            If strDataAdiantamento = "" Then
                HSE.Rodape1 = Operadores.EspacoEmBranco
                HSE.Rodape2 = "--/--/----"
                HSE.Rodape3 = ""
            Else
                HSE.Rodape1 = "Último Adiantamento"
                HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataAdiantamento)
                HSE.Rodape3 = lojaDesc
            End If
            HS.HistoricosSecoesElementos.Add(HSE)

            HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = "Pago",
                    .Valor = FormatNumber(dblValorPago, casasDecTot),
                    .Icone = simbMoeda,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "ServicosAbreRecebimentos(this)",
                    .Ordem = 2}

            If strDataPago = "" Then
                HSE.Rodape1 = Operadores.EspacoEmBranco
                HSE.Rodape2 = "--/--/----"
                HSE.Rodape3 = ""
            Else
                HSE.Rodape1 = Traducao.EstruturaHistorico.UltimoPagamento
                HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataPago)
                HSE.Rodape3 = lojaDesc
            End If
            HS.HistoricosSecoesElementos.Add(HSE)

            HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = "Por Pagar",
                    .Valor = FormatNumber(dblValorPorPagar, casasDecTot),
                    .Icone = simbMoeda,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "ServicosAbreAdiantamentos(this)",
                    .Ordem = 3}

            HS.HistoricosSecoesElementos.Add(HSE)
            historico.HistoricosSecoes.Add(HS)
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna os documentos associados ao servico (FA // FT // FR // FS // FRA)
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="documentoVendaServico"></param>
        ''' <returns></returns>
        Private Shared Function RetornaDocumentosAssociadosAoServico(ctx As BD.Dinamica.Aplicacao,
                                                                     ByVal documentoVendaServico As tbDocumentosVendas) As List(Of tbDocumentosVendas)

            Dim documentosAssociados As New List(Of tbDocumentosVendas)
            Dim documento As String = documentoVendaServico.Documento

            If Not String.IsNullOrEmpty(documento) AndAlso
                documentoVendaServico.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Rascunho AndAlso
                Not documento.EndsWith("/") Then

                'documentos em que o documento e origem - NCs
                Dim lista As New List(Of Long)

                lista = ctx.tbDocumentosVendasLinhas.
                                Where(Function(w) w.tbTiposDocumento.tbSistemaModulos.Codigo = SistemaCodigoModulos.Vendas AndAlso (w.IDDocumentoOrigem = documentoVendaServico.ID OrElse w.IDDocumentoOrigemInicial = documentoVendaServico.ID) OrElse
                                (Not String.IsNullOrEmpty(w.DocumentoOrigem) AndAlso Not String.IsNullOrEmpty(documento) AndAlso w.DocumentoOrigem = documento)).
                                Select(Function(s) s.IDDocumentoVenda).Distinct().ToList()

                documentosAssociados.AddRange(ctx.tbDocumentosVendas.
                                              Where(Function(w) lista.Contains(w.ID)).ToList())

                If documentosAssociados.Any Then
                    Return documentosAssociados.OrderByDescending(Function(o) o.DataDocumento).ThenByDescending(Function(o) o.DataCriacao).ToList()
                End If
            End If

            Return New List(Of tbDocumentosVendas)
        End Function
#End Region
    End Class
End Namespace
