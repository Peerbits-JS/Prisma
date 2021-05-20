Imports System.Data.SqlClient
Imports F3M
Imports F3M.Core.Business.Documents.Models.PurchaseDocuments
Imports F3M.Core.Business.Documents.Models.SaleDocuments
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum

Namespace Repositorio.Historicos
    Public Class RepositorioHistoricosOticas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, Object, F3M.Historicos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Shared Function RetornaHist(inModelo As Object, Optional inObjFiltro As ClsF3MFiltro = Nothing) As F3M.Historicos
            Dim hist As New F3M.Historicos

            If inModelo IsNot Nothing Then
                hist = RetornaHist(inModelo.ID, inModelo.GetType)
            End If

            Return hist
        End Function

        Public Shared Function RetornaHist(inModID As Long, inTipo As Type, Optional inObjFiltro As ClsF3MFiltro = Nothing) As F3M.Historicos
            Dim hist As New F3M.Historicos

            If ClsUtilitarios.RetornaZeroSeVazio(inModID) > 0 Then
                ' Contexto da App
                Using ctx As New BD.Dinamica.Aplicacao
                    Select Case inTipo.Name
                        ' ---------- Por Defeito ----------
                        ' Fornecedores
                        Case GetType(Oticas.Fornecedores).Name
                            PreencheHistForn(ctx, inModID, hist, inObjFiltro)
                            'RepositorioHistoricos.RetornaHSPredef(Of tbFornecedores)(ctx, inModID, hist)
                        ' Doc Stocks
                        Case GetType(DocumentosStock).Name
                            RepositorioHistoricos.RetornaHSPredef(Of tbDocumentosStock)(ctx, inModID, hist)
                        ' Medicos Tecnicos
                        Case GetType(MedicosTecnicos).Name
                            RepositorioHistoricos.RetornaHSPredef(Of tbMedicosTecnicos)(ctx, inModID, hist)
                        ' Entidades
                        Case GetType(Entidades).Name
                            RepositorioHistoricos.RetornaHSPredef(Of tbEntidades)(ctx, inModID, hist)

                        ' ---------- Especifico ----------
                        ' Artigos
                        Case GetType(Oticas.Artigos).Name
                            RepositorioHistArtigos.RetornaHistorico(ctx, hist, inModID, inObjFiltro)
                        ' Clientes
                        Case GetType(Oticas.Clientes).Name
                            PreencheHistCli(ctx, inModID, hist, inObjFiltro)
                        ' Doc Vendas
                        Case GetType(DocumentosVendas).Name
                            RepositorioHistDocumentosVenda.RetornaHistorico(ctx, hist, inModID, inObjFiltro)
                        ' Doc Revendas
                        Case GetType(SaleDocuments).Name
                            RepositorioHistDocumentosRevenda.RetornaHistorico(ctx, hist, inModID, inObjFiltro)
                        ' Servicos
                        Case GetType(DocumentosVendasServicos).Name
                            RepositorioHistServicos.RetornaHistorico(ctx, hist, inModID, inObjFiltro)
                        ' Doc Compras
                        Case GetType(DocumentosCompras).Name, GetType(PurchaseDocuments).Name
                            PreencheHistDocComp(ctx, inModID, hist, inObjFiltro)
                        ' Doc Pag Compras
                        Case GetType(DocumentosPagamentosCompras).Name
                            PreencheHistDocPagComp(ctx, inModID, hist, inObjFiltro)
                            'Contagem de stocks
                        Case GetType(DocumentosStockContagem).Name
                            RepositorioHistoricos.RetornaHSPredef(Of tbDocumentosStockContagem)(ctx, inModID, hist)
                            'InventarioAT
                        Case GetType(InventarioAT).Name
                            RepositorioHistoricos.RetornaHSPredef(Of tbComunicacaoAutoridadeTributaria)(ctx, inModID, hist)
                            'Substituicao de artigos
                        Case GetType(DocumentosVendasServicosSubstituicao).Name
                            RepositorioHistSubstituicaoArtigos.RetornaHistorico(ctx, hist, inModID, inObjFiltro)
                    End Select
                End Using
            End If

            Return hist
        End Function

        ' CLIENTES
        Private Shared Sub PreencheHistCli(inCtx As BD.Dinamica.Aplicacao, inModID As Long,
                                           ByRef inHist As F3M.Historicos, inObjFiltro As ClsF3MFiltro)
            Dim cli As tbClientes = inCtx.tbClientes.Find(inModID)

            If cli IsNot Nothing Then
                Dim HS As F3M.HistoricosSecoes = Nothing
                Dim HSE As F3M.HistoricosSecoesElementos = Nothing
                Dim strTabela As String = GetType(tbClientes).Name
                Dim strTabelaDV As String = GetType(tbDocumentosVendas).Name
                Dim strCliNome As String = cli.Nome

                Dim lstDVs As List(Of tbDocumentosVendas) = inCtx.tbDocumentosVendas.
                    Where(Function(w) w.IDEntidade = inModID).
                    OrderByDescending(Function(o) o.DataDocumento).ToList
                Dim dv As tbDocumentosVendas = If(lstDVs IsNot Nothing AndAlso lstDVs.Count > 0, lstDVs(0), Nothing)
                Dim dvDataDoc As Date? = dv?.DataDocumento

                Dim lojaDesc As String = LerValorQuery(inCtx, String.Concat(
                    "select l.descricao as resultado",
                        " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l",
                        " inner join ", strTabela, " d on l.id=d.idloja",
                        " where d.id=", inModID))
                Dim lojaDescDV As String = LerValorQuery(inCtx, String.Concat(
                    "select l.descricao as resultado",
                        " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l",
                        " inner join ", strTabelaDV, " d on l.id=d.idloja",
                        " where d.identidade=", inModID))

                Dim casasDecTot As Short? = If(cli?.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
                Dim simbMoeda As String = If(cli?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)

                Dim lngIDEstadoDV As Long? = inCtx.tbEstados.Where(
                    Function(f) f.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.DocumentosVenda AndAlso
                        f.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo)?.FirstOrDefault?.ID

                dblTotalVendas = CDbl(LerValorQuery(inCtx, String.Concat(
                    "SELECT ISNULL(SUM(CASE WHEN natureza='R' then totalmoedareferencia else -totalmoedareferencia end ),0) as resultado FROM ",
                        "(SELECT DISTINCT DV.id, SN.Codigo as natureza, dv.totalmoedareferencia from ", strTabelaDV, " DV",
                        " INNER JOIN ", GetType(tbTiposDocumento).Name, " TD on DV.IDTipoDocumento=TD.ID",
                        " INNER JOIN ", GetType(tbSistemaTiposDocumento).Name, " STD on TD.IDSistemaTiposDocumento=STD.ID",
                        " INNER JOIN ", GetType(tbEstados).Name & " TE on DV.IDTipoDocumento=TD.ID" &
                        " INNER JOIN ", GetType(tbSistemaTiposEstados).Name, " STE on DV.IDEstado=STE.ID",
                        " INNER JOIN ", GetType(tbSistemaNaturezas).Name, " SN on TD.IDSistemaNaturezas=SN.ID",
                        " WHERE STD.tipo='", TiposSistemaTiposDocumento.VendasFinanceiro, "'",
                        " AND TD.Adiantamento=0 AND STE.Codigo='", TiposEstados.Efetivo, "'",
                        " AND DV.IDEntidade=", inModID, ") t"), True))

                dblTotalVendas = FormatNumber(dblTotalVendas, casasDecTot)
                dblSaldo = CDbl(LerValorQuery(inCtx, "SELECT ISNULL(SUM(CASE WHEN natureza='R' then totalmoedareferencia else -totalmoedareferencia end ),0) as resultado from tbccentidades where identidade=" & inModID, True))
                dblTotalComparticipacoes = CDbl(LerValorQuery(inCtx, String.Concat(
                    "SELECT ISNULL(SUM(CASE WHEN Natureza ='R' then TotalEntidade1 else -TotalEntidade1 end),0) as resultado FROM",
                        "(SELECT DISTINCT DV.id, dv.TotalEntidade1, sn.codigo as Natureza from ", strTabelaDV, " DV",
                            " INNER JOIN ", GetType(tbTiposDocumento).Name, " TD on DV.IDTipoDocumento=TD.ID",
                            " INNER JOIN ", GetType(tbSistemaTiposDocumento).Name, " STD on TD.IDSistemaTiposDocumento=STD.ID",
                            " INNER JOIN ", GetType(tbEstados).Name & " TE on DV.IDTipoDocumento=TD.ID" &
                            " INNER JOIN ", GetType(tbSistemaTiposEstados).Name, " STE on DV.IDEstado=STE.ID",
                            " INNER JOIN ", GetType(tbSistemaNaturezas).Name, " SN on TD.IDSistemaNaturezas=SN.ID",
                            " WHERE STD.tipo='", TiposSistemaTiposDocumento.VendasFinanceiro, "'",
                            " AND STE.Codigo='", TiposEstados.Efetivo, "'",
                            " AND DV.IDEntidade=", inModID, ") t"), True))

                ' ---- FINANCEIRO ----
                HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaHistorico.Financeiro,
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Icone = "f3icon-moedas",
                    .Ordem = 10}

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 1,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = Traducao.EstruturaHistorico.TotalVendas,
                    .Valor = FormatNumber(dblTotalVendas, casasDecTot),
                    .Icone = simbMoeda}

                If dvDataDoc IsNot Nothing Then
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultima
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(dvDataDoc)
                    HSE.Rodape3 = lojaDescDV
                Else
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                End If
                HS.HistoricosSecoesElementos.Add(HSE)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 2,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = "Saldo e Conta Corrente",
                    .Valor = FormatNumber(dblSaldo, casasDecTot),
                    .Icone = simbMoeda,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "$('#contacorrente').trigger('click')"}

                strDataFaturado = LerValorQuery(inCtx,
                    "select convert(nvarchar(10), max(datadocumento), 105) as resultado from tbccentidades" &
                        " where identidade=" & inModID, False)
                If strDataFaturado = "" Then
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                Else
                    HSE.Rodape1 = "Último Movimento"
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataFaturado)
                    HSE.Rodape3 = lojaDescDV
                End If

                HS.HistoricosSecoesElementos.Add(HSE)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 3,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Titulo = "Comparticipados",
                    .Valor = FormatNumber(dblTotalComparticipacoes, casasDecTot),
                    .Icone = simbMoeda}

                If dvDataDoc IsNot Nothing Then
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(strDataFaturado)
                    HSE.Rodape3 = lojaDescDV
                Else
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                End If

                HS.HistoricosSecoesElementos.Add(HSE)
                inHist.HistoricosSecoes.Add(HS)

                'Dim lngIDTipoServico As Long = inCtx.tbTiposDocumento.
                '    Where(Function(f) f.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico)?.FirstOrDefault?.ID

                ' ---- DOCUMENTOS ----
                Dim lstDVSs As List(Of tbDocumentosVendas) = lstDVs.Where(Function(w) w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico).ToList
                Dim dvsID As String = String.Empty
                Dim dvsDataDoc As Date? = Nothing

                If lstDVSs IsNot Nothing AndAlso lstDVSs.Count > 0 Then
                    Dim tbDV As tbDocumentosVendas = lstDVSs(0)
                    dvsID = tbDV.ID
                    dvsDataDoc = tbDV.DataDocumento
                End If

                HS = New F3M.HistoricosSecoes With {
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Titulo = "Documentos",
                    .Ordem = 20,
                    .Icone = "f3icon-file-text-o"}

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 1,
                    .Tipo = RepositorioHistoricos.TipoElemento.Numero,
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.Servico,
                    .Valor = lstDVSs.Count,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "ClientesEspGeraServico(this)",
                    .ArgExtraAcao = "getlstdocsservicos",
                    .Icone = "f3icon-glasses",
                    .AcaoCaminhoRodape = String.Empty,
                    .Comentario = Traducao.EstruturaHistorico.CriarNovo}

                If dvsDataDoc IsNot Nothing Then
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(dvsDataDoc)
                    HSE.Rodape3 = lojaDescDV
                Else
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                End If
                HS.HistoricosSecoesElementos.Add(HSE)

                Dim lstDVNSs As List(Of tbDocumentosVendas) = lstDVs.Where(Function(w) w.tbTiposDocumento.IDSistemaTiposDocumento = 14 AndAlso w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal <> 49).ToList
                Dim dvID As String = String.Empty
                Dim dvnsDataDoc As Date? = Nothing

                If lstDVNSs IsNot Nothing AndAlso lstDVNSs.Count > 0 Then
                    Dim tbDV As tbDocumentosVendas = lstDVNSs(0)
                    dvID = tbDV.ID
                    dvnsDataDoc = tbDV.DataDocumento
                End If

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 3,
                    .Tipo = RepositorioHistoricos.TipoElemento.Numero,
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.DocumentosDeVenda,
                    .Valor = lstDVNSs.Count,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "ClientesEspGeraDocVenda(this)",
                    .ArgExtraAcao = "getlstdocsvendas",
                    .Icone = "f3icon-doc-finance",
                    .AcaoCaminhoRodape = "",
                    .Comentario = Traducao.EstruturaHistorico.CriarNovo}

                If dvnsDataDoc IsNot Nothing Then
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(dvnsDataDoc)
                    HSE.Rodape3 = lojaDescDV
                Else
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = String.Empty
                End If
                HS.HistoricosSecoesElementos.Add(HSE)
                inHist.HistoricosSecoes.Add(HS)

                ' ---- SERVICO ----
                HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.Servico,
                    .Ordem = 40,
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Icone = "f3icon-glasses"}

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 1,
                    .Tipo = RepositorioHistoricos.TipoElemento.Numero}

                strWhere = " where d.identidade=" & inModID & " And d.CodigoTipoEstado='" & TiposEstados.Efetivo & "' and isnull(d.Adiantamento,0)=0 and isnull(d.TipoFiscal,'') not in ('OR', 'PF', 'SV') and sa.codigo='LO' "
                strSelect = " select sum(case when isnull(TipoFiscal,'') IN ('" & TiposDocumentosFiscal.NotaCredito & "', '" & TiposDocumentosFiscal.NotaDebito & "')" &
                    " then -isnull(l.Quantidade,0) else isnull(l.Quantidade,0) end) as resultado "
                strFrom = " from tblojas o inner join " & strTabelaDV & " d on o.id=d.idloja inner join tbdocumentosvendaslinhas l on d.id=l.IDDocumentoVenda inner join tbArtigos a on l.IDArtigo=a.id inner join tbSistemaClassificacoesTiposArtigos sa on a.IDSistemaClassificacao=sa.id  "

                HSE.Titulo = "L. Oftálmicas"
                HSE.Valor = LerValorQuery(inCtx, strSelect & strFrom & strWhere)

                If String.IsNullOrWhiteSpace(HSE.Valor) Or HSE.Valor = "0" Then
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                Else
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(
                        LerValorQuery(inCtx, "select max(d.datadocumento) as resultado " & strFrom & strWhere))
                    HSE.Rodape3 = LerValorQuery(inCtx, "select top 1 o.descricao as resultado " & strFrom & strWhere)
                End If

                HS.HistoricosSecoesElementos.Add(HSE)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 5,
                    .Tipo = RepositorioHistoricos.TipoElemento.Numero,
                    .Titulo = "Lentes de Contato"}

                strWhere = " where d.identidade=" & inModID & " And d.CodigoTipoEstado='" & TiposEstados.Efetivo & "' and isnull(d.Adiantamento,0)=0 and isnull(d.TipoFiscal,'') not in ('OR', 'PF', 'SV') and sa.codigo='LC' "
                strSelect = " select sum(case when isnull(TipoFiscal,'') in ('" & TiposDocumentosFiscal.NotaCredito & "', '" & TiposDocumentosFiscal.NotaDebito & "')" &
                    " then -isnull(l.Quantidade,0) else isnull(l.Quantidade,0) end) as resultado "
                strFrom = " from tblojas o inner join " & strTabelaDV & " d on o.id=d.idloja inner join tbdocumentosvendaslinhas l on d.id=l.IDDocumentoVenda inner join tbArtigos a on l.IDArtigo=a.id inner join tbSistemaClassificacoesTiposArtigos sa on a.IDSistemaClassificacao=sa.id  "

                HSE.Valor = LerValorQuery(inCtx, strSelect & strFrom & strWhere)

                If String.IsNullOrWhiteSpace(HSE.Valor) Or HSE.Valor = "0" Then
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                Else
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(
                        LerValorQuery(inCtx, "select max(d.datadocumento) as resultado " & strFrom & strWhere))
                    HSE.Rodape3 = LerValorQuery(inCtx, "select top 1 o.descricao as resultado " & strFrom & strWhere)
                End If
                HS.HistoricosSecoesElementos.Add(HSE)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 6,
                    .Tipo = RepositorioHistoricos.TipoElemento.Numero,
                    .Titulo = "Aros"}

                strWhere = " where d.identidade=" & inModID & " And d.CodigoTipoEstado='" & TiposEstados.Efetivo & "' and isnull(d.Adiantamento,0)=0 and isnull(d.TipoFiscal,'') not in ('OR', 'PF', 'SV') and sa.codigo='AR' "
                strSelect = " select sum(case when isnull(TipoFiscal,'') in ('" & TiposDocumentosFiscal.NotaCredito & "', '" & TiposDocumentosFiscal.NotaDebito & "')" &
                    " then -isnull(l.Quantidade,0) else isnull(l.Quantidade,0) end) as resultado "
                strFrom = " from tblojas o inner join " & strTabelaDV & " d on o.id=d.idloja" &
                    " INNER JOIN tbDocumentosvendaslinhas l on d.id=l.IDDocumentoVenda" &
                    " INNER JOIN tbArtigos a on l.IDArtigo=a.id" &
                    " INNER JOIN  tbSistemaClassificacoesTiposArtigos sa on a.IDSistemaClassificacao=sa.id  "

                HSE.Valor = LerValorQuery(inCtx, strSelect & strFrom & strWhere)

                If String.IsNullOrWhiteSpace(HSE.Valor) Or HSE.Valor = "0" Then
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                Else
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(
                        LerValorQuery(inCtx, "select max(d.datadocumento) as resultado " & strFrom & strWhere))
                    HSE.Rodape3 = LerValorQuery(inCtx, "select top 1 o.descricao as resultado " & strFrom & strWhere)
                End If

                HS.HistoricosSecoesElementos.Add(HSE)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Ordem = 6,
                    .Tipo = 2,
                    .Titulo = "Óculos de Sol"
                }
                strWhere = " where d.identidade=" & inModID & " And d.CodigoTipoEstado='" & TiposEstados.Efetivo & "' and isnull(d.Adiantamento,0)=0 and isnull(d.TipoFiscal,'') not in ('OR', 'PF', 'SV') and sa.codigo='OS' "
                strSelect = " select sum(case when  isnull(TipoFiscal,'') in ('" & TiposDocumentosFiscal.NotaCredito & "', '" & TiposDocumentosFiscal.NotaDebito & "')" &
                    " then -isnull(l.Quantidade,0) else isnull(l.Quantidade,0) end) as resultado "
                strFrom = " from tblojas o inner join " & strTabelaDV & " d on o.id=d.idloja inner join tbdocumentosvendaslinhas l on d.id=l.IDDocumentoVenda inner join tbArtigos a on l.IDArtigo=a.id inner join tbSistemaClassificacoesTiposArtigos sa on a.IDSistemaClassificacao=sa.id  "

                HSE.Valor = LerValorQuery(inCtx, strSelect & strFrom & strWhere)

                If String.IsNullOrWhiteSpace(HSE.Valor) Or HSE.Valor = "0" Then
                    HSE.Rodape1 = Operadores.EspacoEmBranco
                    HSE.Rodape2 = "--/--/----"
                    HSE.Rodape3 = ""
                Else
                    HSE.Rodape1 = Traducao.EstruturaHistorico.Ultimo
                    HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(
                        LerValorQuery(inCtx, "select max(d.datadocumento) as resultado " & strFrom & strWhere))
                    HSE.Rodape3 = LerValorQuery(inCtx, "select top 1 o.descricao as resultado " & strFrom & strWhere)
                End If

                HS.HistoricosSecoesElementos.Add(HSE)
                inHist.HistoricosSecoes.Add(HS)

                ' ---- CLIENTE ----
                HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaClientes.CLIENTE,
                    .Ordem = 50,
                    .Icone = "f3icon-clientes"}

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Tipo = RepositorioHistoricos.TipoElemento.Lista
                }

                HSEL = New F3M.HistoricosSecoesElementosListas With {
                    .Titulo = "Cliente desde"
                }

                strValor = LerValorQuery(inCtx, "select datediff(yy,datacriacao,getdate()) as resultado from tbclientes where id=" & inModID)
                If strValor <> "" Then
                    strValor = " (" & strValor & " anos)"
                End If
                HSEL.Valor = LerValorQuery(inCtx, "select convert(nvarchar(10), datacriacao, 105) as resultado from tbclientes where id=" & inModID) & strValor
                HSE.HistoricosSecoesElementosListas.Add(HSEL)

                HSEL = New F3M.HistoricosSecoesElementosListas With {
                    .Titulo = OticasTraducao.EstruturaMedicosTecnicos.Entidade1.ToUpper
                }
                Dim IDAux As Long? = cli.IDEntidade1
                If IDAux IsNot Nothing Then
                    strNome = LerValorQuery(inCtx, "select codigo as resultado from tbentidades where id=" & IDAux)
                    HSEL.Valor = strNome
                    HSEL.AcaoCaminho = "/TabelasAuxiliares/Entidades"
                    HSEL.AcaoIndex = IDAux.ToString
                    HSEL.AcaoDescricao = Traducao.EstruturaAplicacaoTermosBase.Entidades
                    HSEL.AcaoIcone = "f3icon-shield"
                End If
                HSE.HistoricosSecoesElementosListas.Add(HSEL)

                HSEL = New F3M.HistoricosSecoesElementosListas With {
                    .Titulo = OticasTraducao.EstruturaMedicosTecnicos.Entidade2.ToUpper
                }
                IDAux = cli.IDEntidade2
                If IDAux IsNot Nothing Then
                    strNome = LerValorQuery(inCtx, "select codigo as resultado from tbentidades where id=" & IDAux)
                    HSEL.Valor = strNome
                    HSEL.AcaoCaminho = "/TabelasAuxiliares/Entidades"
                    HSEL.AcaoIndex = IDAux.ToString
                    HSEL.AcaoDescricao = Traducao.EstruturaAplicacaoTermosBase.Entidades
                    HSEL.AcaoIcone = "f3icon-shield"
                End If
                HSE.HistoricosSecoesElementosListas.Add(HSEL)

                HSEL = New F3M.HistoricosSecoesElementosListas With {
                    .Titulo = OticasTraducao.EstruturaMedicosTecnicos.Medico.ToUpper
                }
                IDAux = cli.IDMedicoTecnico
                If IDAux IsNot Nothing Then
                    strNome = LerValorQuery(inCtx, "select codigo as resultado from tbmedicostecnicos where id=" & IDAux)
                    HSEL.Valor = strNome
                    HSEL.AcaoCaminho = "/TabelasAuxiliares/MedicosTecnicos"
                    HSEL.AcaoIndex = IDAux.ToString
                    HSEL.AcaoDescricao = Traducao.EstruturaAplicacaoTermosBase.MedicosTecnicos
                    HSEL.AcaoIcone = "f3icon-shield"
                End If
                HSE.HistoricosSecoesElementosListas.Add(HSEL)

                HS.HistoricosSecoesElementos.Add(HSE)
                inHist.HistoricosSecoes.Add(HS)

                ' ---- GABINETE ----
                If (ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.Consultas)) Then
                    HS = New HistoricosSecoes With {
                        .Titulo = "Gabinete",
                        .Ordem = 45,
                        .Icone = "f3icon-user-md"}

                    HSE = New F3M.HistoricosSecoesElementos With {
                        .Tipo = RepositorioHistoricos.TipoElemento.Numero,
                        .Titulo = "Nº de consultas",
                        .Valor = LerValorQuery(inCtx, "SELECT COUNT(*) as resultado  FROM tbExames WHERE IDCliente=" & inModID),
                        .AcaoCaminho = "FUNC",
                        .AcaoIndex = "ClientesEspOpenAppointments(this)"}

                    Dim t As tbExames = inCtx.tbExames.Where(Function(entity) entity.IDCliente = inModID).OrderByDescending(Function(entity) entity.DataExame).FirstOrDefault()
                    If t IsNot Nothing Then
                        HSE.Rodape1 = Traducao.EstruturaHistorico.Ultima
                        HSE.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(t.DataExame)
                        HSE.Rodape3 = t.tbLojas.Descricao

                    Else
                        HSE.Rodape1 = Operadores.EspacoEmBranco
                        HSE.Rodape2 = "--/--/----"
                        HSE.Rodape3 = String.Empty
                    End If

                    HS.HistoricosSecoesElementos.Add(HSE)
                    inHist.HistoricosSecoes.Add(HS)
                End If

                ' ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(cli, inHist, 60)
            End If
        End Sub

        Private Shared Sub PreencheHistForn(inCtx As BD.Dinamica.Aplicacao, inModID As Long, ByRef inHist As F3M.Historicos, inObjFiltro As ClsF3MFiltro)
            Dim fornecedor As tbFornecedores = inCtx.tbFornecedores.Find(inModID)

            If fornecedor IsNot Nothing Then
                Dim podeVerPrecoCusto As Boolean = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True)

                If podeVerPrecoCusto Then
                    ' ---- FINANCEIRO ----
                    PreencheHistoricoFinanceiroFornecedor(inCtx, fornecedor, inHist, inModID)
                End If

                ' ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(fornecedor, inHist, 6)
            End If
        End Sub

        Private Shared Sub PreencheHistoricoFinanceiroFornecedor(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef fornecedor As tbFornecedores, ByRef historico As F3M.Historicos, ByVal idEntidade As Long)
            Dim seccaoHistorico As HistoricosSecoes
            Dim elementoSeccaoHistorico As HistoricosSecoesElementos

            Dim nomeTabelaDocumentosCompras As String = GetType(tbDocumentosCompras).Name

            Dim casasDecimaisTotais As Short? = If(fornecedor?.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
            Dim simboloMoeda As String = If(fornecedor?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)

            Dim totalCompras As Double = CDbl(LerValorQuery(inCtx, String.Concat(
            "SELECT ISNULL(SUM(CASE WHEN natureza='R' then -totalmoedareferencia else totalmoedareferencia end ),0) as resultado FROM ",
                "(SELECT DISTINCT DV.id, SN.Codigo as natureza, dv.totalmoedareferencia from ", nomeTabelaDocumentosCompras, " DV",
                " INNER JOIN ", GetType(tbTiposDocumento).Name, " TD on DV.IDTipoDocumento=TD.ID",
                " INNER JOIN ", GetType(tbSistemaTiposDocumento).Name, " STD on TD.IDSistemaTiposDocumento=STD.ID",
                " INNER JOIN ", GetType(tbEstados).Name & " TE on DV.IDTipoDocumento=TD.ID" &
                " INNER JOIN ", GetType(tbSistemaTiposEstados).Name, " STE on DV.IDEstado=STE.ID",
                " INNER JOIN ", GetType(tbSistemaNaturezas).Name, " SN on TD.IDSistemaNaturezas=SN.ID",
                " WHERE STD.tipo='", TiposSistemaTiposDocumento.ComprasFinanceiro, "'",
                " AND STE.Codigo='", TiposEstados.Efetivo, "'",
                " AND DV.IDEntidade=", idEntidade, ") t"), True))

            seccaoHistorico = New HistoricosSecoes With {
                .Titulo = Traducao.EstruturaHistorico.Financeiro,
                .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                .Icone = "f3icon-moedas",
                .Ordem = 1
            }

            elementoSeccaoHistorico = New HistoricosSecoesElementos With {
                .Ordem = 1,
                .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                .Titulo = Traducao.EstruturaHistorico.TotalCompras,
                .Valor = FormatNumber(totalCompras, casasDecimaisTotais),
                .Icone = simboloMoeda
            }

            Dim ultimoDocumentoCompra As tbDocumentosCompras =
                inCtx.tbDocumentosCompras.
                    Where(Function(w) w.IDEntidade = idEntidade).
                    OrderByDescending(Function(o) o.DataDocumento).
                    FirstOrDefault

            Dim dataUltimoDocumentoCompra As Date? = ultimoDocumentoCompra?.DataDocumento

            Dim descLojaDocumentoCompra As String = LerValorQuery(inCtx, String.Concat(
                "select l.descricao as resultado",
                " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l",
                " inner join ", nomeTabelaDocumentosCompras, " d on l.id=d.idloja",
                " where d.identidade=", idEntidade
            ))

            If dataUltimoDocumentoCompra IsNot Nothing Then
                elementoSeccaoHistorico.Rodape1 = Traducao.EstruturaHistorico.Ultima
                elementoSeccaoHistorico.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(dataUltimoDocumentoCompra)
                elementoSeccaoHistorico.Rodape3 = descLojaDocumentoCompra
            Else
                elementoSeccaoHistorico.Rodape1 = Operadores.EspacoEmBranco
                elementoSeccaoHistorico.Rodape2 = "--/--/----"
                elementoSeccaoHistorico.Rodape3 = ""
            End If

            seccaoHistorico.HistoricosSecoesElementos.Add(elementoSeccaoHistorico)

            Dim saldoContaCorrente As Double = CDbl(LerValorQuery(inCtx, String.Concat(
                "SELECT ISNULL(SUM(CASE WHEN natureza='R' then -totalmoedareferencia else totalmoedareferencia end ),0) as resultado ",
                " from tbccfornecedores where identidade=", idEntidade), True))

            elementoSeccaoHistorico = New HistoricosSecoesElementos With {
                .Ordem = 2,
                .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                .Titulo = "Saldo e Conta Corrente",
                .Valor = FormatNumber(saldoContaCorrente, casasDecimaisTotais),
                .Icone = simboloMoeda,
                .AcaoCaminho = "FUNC",
                .AcaoIndex = "$('#contacorrente').trigger('click')"
            }

            Dim dataUltimoMovimento = LerValorQuery(inCtx,
                "select max(convert(nvarchar(10), datadocumento, 105)) as resultado from tbccfornecedores" &
                " where identidade=" & idEntidade, False)

            If dataUltimoMovimento = "" Then
                elementoSeccaoHistorico.Rodape1 = Operadores.EspacoEmBranco
                elementoSeccaoHistorico.Rodape2 = "--/--/----"
                elementoSeccaoHistorico.Rodape3 = ""
            Else
                elementoSeccaoHistorico.Rodape1 = "Último Movimento"
                elementoSeccaoHistorico.Rodape2 = RepositorioHistoricos.RetornaDataFormatada(dataUltimoMovimento)
                elementoSeccaoHistorico.Rodape3 = descLojaDocumentoCompra
            End If

            seccaoHistorico.HistoricosSecoesElementos.Add(elementoSeccaoHistorico)

            historico.HistoricosSecoes.Add(seccaoHistorico)
        End Sub

        ' DOC COMPRAS
        Private Shared Sub PreencheHistDocComp(inCtx As BD.Dinamica.Aplicacao, inModID As Long,
                                               ByRef inHist As F3M.Historicos, inObjFiltro As ClsF3MFiltro)
            Dim dc As tbDocumentosCompras = inCtx.tbDocumentosCompras.Find(inModID)

            If dc IsNot Nothing Then
                Dim HS As F3M.HistoricosSecoes = Nothing
                Dim HSE As F3M.HistoricosSecoesElementos = Nothing
                Dim strTabela As String = GetType(tbDocumentosCompras).Name

                Dim lojaDesc As String = LerValorQuery(inCtx,
                    "select l.descricao as resultado" &
                        " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l" &
                        " inner join " & strTabela & " d on l.id=d.idloja" &
                        " where d.id=" & inModID)

                Dim casasDecTot As Short? = If(dc?.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
                Dim simbMoeda As String = If(dc?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)
                If ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "VerPrecoCusto", True) = True Then

                    HS = New F3M.HistoricosSecoes With {
                        .Titulo = Traducao.EstruturaHistorico.Tesouraria,
                        .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                        .Icone = "f3icon-eur",
                        .Ordem = 1}

                    dblValor = If(dc?.ValorPago, 0)

                    HSE = New F3M.HistoricosSecoesElementos With {
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.Pago,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Valor = FormatNumber(dblValor, casasDecTot),
                    .Icone = simbMoeda}

                    HS.HistoricosSecoesElementos.Add(HSE)

                    dblValor = CDbl(LerValorQuery(inCtx, "select (case when codigotipoestado='" & TiposEstados.Anulado & "' then 0 else ValorPendente end) as resultado from tbDocumentosComprasPendentes p with (nolock) inner join tbDocumentoscompras d with (nolock) on p.IDDocumentoCompra=d.id where p.iddocumentocompra=" & inModID, True))

                    HSE = New F3M.HistoricosSecoesElementos With {
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.PorPagar,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Valor = FormatNumber(dblValor, casasDecTot),
                    .Icone = simbMoeda}
                    HS.HistoricosSecoesElementos.Add(HSE)

                    dblValor = If(dc?.TotalMoedaDocumento, 0)

                    HSE = New F3M.HistoricosSecoesElementos With {
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.TotalDocumento,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Valor = FormatNumber(dblValor, casasDecTot),
                    .Icone = simbMoeda}
                    HS.HistoricosSecoesElementos.Add(HSE)
                    inHist.HistoricosSecoes.Add(HS)
                End If
                ' ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(dc, inHist, 3)
            End If
        End Sub
        ' DOC PAG COMPRAS
        Private Shared Sub PreencheHistDocPagComp(inCtx As BD.Dinamica.Aplicacao, inModID As Long,
                                               ByRef inHist As F3M.Historicos, inObjFiltro As ClsF3MFiltro)
            Dim dcp As tbPagamentosCompras = inCtx.tbPagamentosCompras.Find(inModID)

            If dcp IsNot Nothing Then
                Dim HS As F3M.HistoricosSecoes = Nothing
                Dim HSE As F3M.HistoricosSecoesElementos = Nothing
                Dim strTabela As String = GetType(tbDocumentosCompras).Name

                Dim lojaDesc As String = LerValorQuery(inCtx,
                    "select l.descricao as resultado" &
                        " from [" & ChavesWebConfig.BD.NomeBDGeral & "].dbo.tblojas l" &
                        " inner join " & strTabela & " d on l.id=d.idloja" &
                        " where d.id=" & inModID)

                Dim casasDecTot As Short? = If(dcp?.tbMoedas?.CasasDecimaisTotais, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
                Dim simbMoeda As String = If(dcp?.tbMoedas?.Simbolo, ClsF3MSessao.RetornaParametros.MoedaReferencia.Simbolo)

                HS = New F3M.HistoricosSecoes With {
                    .Titulo = Traducao.EstruturaHistorico.Tesouraria,
                    .Tipo = RepositorioHistoricos.TipoSeccao.Colunas,
                    .Icone = "f3icon-eur",
                    .Ordem = 1}

                dblValor = If(dcp?.TotalMoedaDocumento, 0)

                HSE = New F3M.HistoricosSecoesElementos With {
                    .Titulo = Traducao.EstruturaAplicacaoTermosBase.TotalMoedaDocumento,
                    .Tipo = RepositorioHistoricos.TipoElemento.Moeda,
                    .Valor = FormatNumber(dblValor, casasDecTot),
                    .Icone = simbMoeda,
                    .AcaoCaminho = "FUNC",
                    .AcaoIndex = "DocumentosPagamentosComprasCliquePagamentos(this)"}
                HS.HistoricosSecoesElementos.Add(HSE)
                inHist.HistoricosSecoes.Add(HS)
                ' ---- CRONOLOGIA ----
                RepositorioHistoricos.RetornaHSPredef(dcp, inHist, 3)
            End If
        End Sub

        Protected Friend Shared Function LerValorQuery(inCtx As BD.Dinamica.Aplicacao, strQry As String, Optional blnNumerico As Boolean = False) As String
            Try
                Dim strRes As String = String.Empty
                If blnNumerico Then
                    strRes = "0"
                End If
                Using dsListaVistas As New DataSet
                    Using sqlConnBD As New SqlConnection(inCtx.Database.Connection.ConnectionString)
                        sqlConnBD.Open()
                        Using sqlcmdVistas As New SqlCommand(strQry, sqlConnBD)
                            sqlcmdVistas.CommandType = CommandType.Text
                            Dim adapterVistas As New SqlDataAdapter(sqlcmdVistas)
                            adapterVistas.Fill(dsListaVistas)
                            If dsListaVistas.Tables(0).Rows.Count > 0 Then
                                Dim row As DataRow = dsListaVistas.Tables(0).Rows(0)
                                If row!Resultado.ToString <> "" Then
                                    strRes = row!Resultado
                                End If
                            End If
                        End Using
                    End Using
                End Using
                Return strRes
            Catch
                Throw
            End Try
        End Function

#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace