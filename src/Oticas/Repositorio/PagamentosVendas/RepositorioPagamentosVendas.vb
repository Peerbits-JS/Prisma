Imports System.Data.Entity
Imports System.Data.SqlClient
Imports F3M.Core.Business.Documents.Models.Payments
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports F3M.Repositorios.Administracao
Imports Oticas.Repositorio.Documentos

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioPagamentosVendas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbPagamentosVendas, PagamentosVendas)

        Private Const Numerario As String = "NU"
        Private Const Opcao_Pagamentos As String = "pagamentos"
        Dim EMultiEmpresa As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
#End Region

#Region "ESCRITA"

        Public Sub AdicionaPagamentoComparticipacao(inCtx As BD.Dinamica.Aplicacao, inModelo As PagamentosVendas, ByVal IDMoeda As Long, ByVal IDDocumentoVenda As Long)
            Try
                Dim Moeda As Moedas = inCtx.tbMoedas.Where(Function(w) w.ID = IDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()
                Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                Dim blnAtualizaCX As Boolean = True
                Dim strOpcao As String = "pagamentos"

                GravaPagamentoVendas_FROM_NA(inCtx, inModelo, Moeda, CDTotaisMoedaRef, IDDocumentoVenda)

                GravaDocumentosVendaFormasPagamento(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                GravaRecibos(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                AtualizaMapaCaixa(inCtx, inModelo, "pagamentos")
            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        Public Sub AdicionaPagamento_CLI_DIFF(inCtx As BD.Dinamica.Aplicacao, inModelo As PagamentosVendas, ByVal IDMoeda As Long, ByVal IDDocumentoVenda As Long)
            Try
                Dim Moeda As Moedas = inCtx.tbMoedas.Where(Function(w) w.ID = IDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()
                Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                Dim blnAtualizaCX As Boolean = True
                Dim strOpcao As String = "pagamentos"

                GravaPagamentoVendas_(inCtx, inModelo, Moeda, CDTotaisMoedaRef, IDDocumentoVenda)

                GravaDocumentosVendaFormasPagamento(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                GravaRecibos(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                AtualizaMapaCaixa(inCtx, inModelo, "pagamentos")
            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        Private Sub GravaPagamentoVendas_(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas,
                                           ByVal inCDTotaisMoedaRef As Byte, ByVal IDDocumentoVenda As Long)

            Dim intOrdem As Short = 0

            inModelo.ListOfFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.Valor > 0).ToList()

            If inCtx.tbPagamentosVendas.Count <> 0 Then
                inModelo.Numero = inCtx.tbPagamentosVendas.Select(Function(f) f.Numero).Max() + 1

            Else
                inModelo.Numero = 1
            End If

            With inModelo
                .Data = DateAndTime.Now()
                .IDMoeda = inMoeda.ID
                .TaxaConversao = inMoeda.TaxaConversao
                .TotalMoeda = inModelo.TotalMoeda
                .TotalMoedaReferencia = inModelo.TotalMoeda
                .ValorEntregue = inModelo.TotalMoeda
                .TotalPagar = inModelo.TotalMoeda
                .Troco = CDbl(0)
                .CodigoTipoEstado = TiposEstados.Efetivo
            End With

            Dim e As tbPagamentosVendas = GravaObjContexto(inCtx, inModelo, AcoesFormulario.Adicionar)
            inCtx.SaveChanges()
            inModelo.ID = e.ID

            'GRAVA FORMAS DE PAGAMENTO
            For Each lin In inModelo.ListOfFormasPagamento
                Dim PagamentosVendasFormaPagamento As New tbPagamentosVendasFormasPagamento
                Mapear(lin, PagamentosVendasFormaPagamento)

                With PagamentosVendasFormaPagamento
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = lin.TotalMoeda
                    .TotalMoedaReferencia = lin.TotalMoedaReferencia

                    intOrdem += 1
                    .Ordem = intOrdem
                    .Valor = lin.TotalMoeda
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasFormasPagamento)(inCtx, PagamentosVendasFormaPagamento, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            Next


            'GRAVA VENDAS LINHAS
            intOrdem = 0
            For Each lin In inModelo.ListOfPendentes
                Dim PagamentoVendasLinha As New tbPagamentosVendasLinhas

                Mapear(lin, PagamentoVendasLinha)

                With PagamentoVendasLinha
                    .ID = 0
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = lin.ValorPago
                    .TotalMoedaReferencia = CalculaCambio(lin.ValorPago, inMoeda.TaxaConversao)
                    intOrdem += 1
                    .Ordem = intOrdem

                    .TotalMoedaDocumento = .TotalMoedaDocumento
                    .ValorPendente = .ValorPendente
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasLinhas)(inCtx, PagamentoVendasLinha, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()

                AtualizaValorPagoDocVenda_Principal(inCtx, lin.TotalMoedaDocumento, lin.ValorPago, lin.IDDocumentoVenda, inCDTotaisMoedaRef)
            Next

            Dim dblValorPago As Double = Math.Round(inModelo.ListOfPendentes.Where(Function(f) f.CodigoSistemaNaturezas = TiposNaturezas.Debito).Sum(Function(f) f.ValorPago), inMoeda.CasasDecimaisTotais)

            AtualizaValorPagoDocVenda_Principal(inCtx, 0, dblValorPago, IDDocumentoVenda, inCDTotaisMoedaRef)

            AtualizaValorPendente_FROM_NA(inCtx, dblValorPago, IDDocumentoVenda, inCDTotaisMoedaRef)
        End Sub

        Public Overrides Sub AdicionaObj(ByRef inModelo As PagamentosVendas, inFiltro As ClsF3MFiltro)
            Using ctx As New BD.Dinamica.Aplicacao
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                    Try
                        Dim Opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Opcao", GetType(String)) 'pagamentos || adiantamentos
                        Dim IDMoeda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMoeda", GetType(Long))
                        Dim Moeda As Moedas = ctx.tbMoedas.Where(Function(w) w.ID = IDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()
                        Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais

                        ValorDasNCs(inModelo)

                        If Opcao = "adiantamentos" Then GravaAdiantamentos(ctx, inModelo, inFiltro, CDTotaisMoedaRef)

                        GravaPagamentoVendas(ctx, inModelo, Moeda, CDTotaisMoedaRef, Opcao)

                        If Opcao <> "adiantamentos" Then AtualizaPendentes(ctx, inModelo, Moeda) 'pagamentos

                        GravaDocumentosVendaFormasPagamento(ctx, inModelo, Moeda, CDTotaisMoedaRef)

                        GravaRecibos(ctx, inModelo, Moeda, CDTotaisMoedaRef)

                        trans.Commit()

                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Protected Friend Sub AdicionaPagamento_FROMDOCSVENDAS(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As PagamentosVendas, ByVal inIDMoeda As Long, ByVal IDDocumentoVenda As Long, ByVal IDDocumentoVendaPendente As Long)
            Dim Opcao As String = "pagamentos"
            Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
            Dim Moeda As Moedas = inCtx.tbMoedas.Where(Function(w) w.ID = inIDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()

            GravaPagamentoVendas(inCtx, inModelo, Moeda, CDTotaisMoedaRef, Opcao)

            AtualizaPendenteWithTransaction(inCtx, IDDocumentoVendaPendente)

            GravaDocumentosVendaFormasPagamento(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

            AtualizaMapaCaixa(inCtx, inModelo, "documentos")
        End Sub

        Private Sub GravaPagamentoVendas(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte, ByVal inOpcao As String)
            Dim TotalEntregueAUX As Double = inModelo.ValorEntregue
            Dim intOrdem As Short = 0

            inModelo.ListOfPendentes = inModelo.ListOfPendentes.Where(Function(f) f.LinhaSelecionada).ToList()
            inModelo.ListOfFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.Valor > 0).ToList()

            If inCtx.tbPagamentosVendas.Count <> 0 Then
                inModelo.Numero = inCtx.tbPagamentosVendas.Select(Function(f) f.Numero).Max() + 1

            Else
                inModelo.Numero = 1
            End If

            With inModelo
                .Data = DateAndTime.Now()
                .IDMoeda = inMoeda.ID
                .TaxaConversao = inMoeda.TaxaConversao
                .TotalMoeda = .TotalPagar
                .TotalMoedaReferencia = CalculaCambio(inModelo.TotalPagar, inMoeda.TaxaConversao)
                .CodigoTipoEstado = TiposEstados.Efetivo
            End With

            Dim e As tbPagamentosVendas = GravaObjContexto(inCtx, inModelo, AcoesFormulario.Adicionar)
            inCtx.SaveChanges()
            inModelo.ID = e.ID


            'GRAVA FORMAS DE PAGAMENTO
            For Each lin In inModelo.ListOfFormasPagamento
                Dim PagamentosVendasFormaPagamento As New tbPagamentosVendasFormasPagamento
                Mapear(lin, PagamentosVendasFormaPagamento)

                With PagamentosVendasFormaPagamento
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = lin.Valor
                    .TotalMoedaReferencia = CalculaCambio(.Valor, inMoeda.TaxaConversao)
                    intOrdem += 1
                    .Ordem = intOrdem
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasFormasPagamento)(inCtx, PagamentosVendasFormaPagamento, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            Next

            'GRAVA VENDAS LINHAS
            intOrdem = 0
            For Each lin In inModelo.ListOfPendentes.OrderByDescending(Function(o) o.CodigoSistemaNaturezas.Contains(TiposNaturezas.Debito))
                If lin.CodigoSistemaNaturezas <> TiposNaturezas.Credito Then
                    If TotalEntregueAUX < lin.ValorPago Then lin.ValorPago = TotalEntregueAUX
                End If

                If lin.ValorPago > 0 Then
                    Dim PagamentoVendasLinha As New tbPagamentosVendasLinhas

                    Mapear(lin, PagamentoVendasLinha)

                    With PagamentoVendasLinha
                        .ID = 0
                        .IDPagamentoVenda = inModelo.ID
                        .IDMoeda = inMoeda.ID
                        .TaxaConversao = inMoeda.TaxaConversao
                        .TotalMoeda = lin.ValorPago
                        .TotalMoedaReferencia = CalculaCambio(lin.ValorPago, inMoeda.TaxaConversao)
                        intOrdem += 1
                        .Ordem = intOrdem

                        .TotalMoedaDocumento = If(inOpcao = "adiantamentos", .TotalMoeda, .TotalMoedaDocumento)
                        .ValorPendente = If(inOpcao = "adiantamentos", .TotalMoeda, .ValorPendente)
                    End With

                    GravaEntidadeLinha(Of tbPagamentosVendasLinhas)(inCtx, PagamentoVendasLinha, AcoesFormulario.Adicionar, Nothing)
                    inCtx.SaveChanges()

                    TotalEntregueAUX = TotalEntregueAUX - lin.ValorPago

                    AtualizaValorPagoDocVenda_Principal(inCtx, lin.TotalMoedaDocumento, lin.ValorPago, lin.IDDocumentoVenda, inCDTotaisMoedaRef)

                    If inOpcao <> "adiantamentos" Then
                        AtualizaValorPagoDocVendaOrigem_FROM_PAGAR(inCtx, lin.IDDocumentoVenda, lin.ValorPago, inCDTotaisMoedaRef)
                    End If
                End If

            Next
        End Sub

        Private Sub AtualizaPendentes(inCtx As BD.Dinamica.Aplicacao, modelo As PagamentosVendas, Moeda As Moedas)
            Dim TotalAPagar As Double = modelo.TotalPagar
            Dim TotalEntregue As Double = modelo.ValorEntregue
            Dim TotalEntregueAux As Double = TotalEntregue
            Dim idsPagamentosVendasLinha() As Long = modelo.ListOfPendentes.Select(Function(f) f.IDDocumentoVenda).ToArray()

            If modelo.ListOfPendentes.Count <> 0 AndAlso modelo.ValorEntregue <> 0 AndAlso (TotalAPagar <> 0 OrElse SumValorPagoNCs(modelo) > 0) Then
                Dim ListOfDocsVendasPendentes As List(Of tbDocumentosVendasPendentes) = BDContexto.tbDocumentosVendasPendentes.Where(Function(f) idsPagamentosVendasLinha.Contains(f.IDDocumentoVenda)).ToList()

                For Each lin In ListOfDocsVendasPendentes.OrderByDescending(Function(o) o.tbSistemaNaturezas.Codigo.Contains(TiposNaturezas.Debito))
                    Dim linhaModelo As DocumentosVendasPendentes = (From x In modelo.ListOfPendentes Where x.ID = lin.ID).FirstOrDefault()

                    If linhaModelo.CodigoSistemaNaturezas = TiposNaturezas.Credito Then
                        lin.ValorPendente = Math.Round(CDbl(linhaModelo.ValorPendenteAux - linhaModelo.ValorPago), Moeda.CasasDecimaisTotais)

                        TotalEntregueAux = Math.Round(CDbl(TotalEntregueAux - linhaModelo.ValorPago), Moeda.CasasDecimaisTotais)

                        GravaAux(inCtx, lin)

                    Else
                        Dim dblValorPago As Double = linhaModelo.ValorPago

                        If TotalEntregueAux >= dblValorPago Then

                            TotalEntregueAux = Math.Round(CDbl(TotalEntregueAux - dblValorPago), Moeda.CasasDecimaisTotais)

                            lin.ValorPendente = Math.Round(CDbl(lin.ValorPendente - dblValorPago), Moeda.CasasDecimaisTotais)

                            GravaAux(inCtx, lin)

                        ElseIf TotalEntregueAux >= 0 Then
                            '
                            lin.ValorPendente = Math.Round(CDbl(lin.ValorPendente - TotalEntregueAux), Moeda.CasasDecimaisTotais)

                            GravaAux(inCtx, lin)

                            Exit Sub

                        End If
                    End If
                Next
            End If
        End Sub
#End Region

#Region "FUNÇÕES AUXILIARES"
        Private Sub GravaAux(ctx As BD.Dinamica.Aplicacao, ByVal lin As tbDocumentosVendasPendentes)
            Dim t1 As New DocumentosVendasPendentes
            Mapear(lin, t1)

            Dim t2 As New tbDocumentosVendasPendentes
            Mapear(t1, t2)

            GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, t2, AcoesFormulario.Alterar, Nothing)
            ctx.SaveChanges()
        End Sub
#End Region

        Public Function GetPagamentosVendas(IDDocumentoVenda As Long) As List(Of PagamentosVendas)
            Dim ListOfPagamentosVendas As List(Of PagamentosVendas) = (From x In BDContexto.tbPagamentosVendas
                                                                       Group Join cc In BDContexto.tbContasCaixa On x.IDContaCaixa Equals cc.ID
                                                                       Into _cc = Group From cc In _cc.DefaultIfEmpty
                                                                       Join y In BDContexto.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals x.ID
                                                                       Join z In BDContexto.tbDocumentosVendas On z.ID Equals y.IDDocumentoVenda
                                                                       Where y.IDDocumentoVenda = IDDocumentoVenda
                                                                       Select New PagamentosVendas With {
                                                                           .ID = x.ID, .Data = x.Data, .CodigoTipoEstado = x.CodigoTipoEstado,
                                                                           .Documento = z.Documento, .IDContaCaixa = x.IDContaCaixa, .DescricaoContaCaixa = cc.Descricao,
                                                                           .ValorEntregue = x.ValorEntregue, .Troco = x.Troco
                                                                       }).Distinct.ToList()

            If ListOfPagamentosVendas.Count > 0 Then
                For Each lin In ListOfPagamentosVendas
                    Dim DocumentoRecibo As String = (From x In BDContexto.tbRecibos
                                                     Where x.IDPagamentoVenda = lin.ID
                                                     Select x.Documento).FirstOrDefault()

                    If Not DocumentoRecibo Is Nothing Then lin.Documento = DocumentoRecibo
                Next

            Else
                Using rp As New RepositorioPagamentosVendas
                    ListOfPagamentosVendas = rp.GetPagamentosVendasServicos(IDDocumentoVenda)
                End Using
            End If

            Return ListOfPagamentosVendas.OrderBy(Function(o) o.Data).ThenBy(Function(t) t.DataCriacao).ToList()
        End Function

        Public Function GetPagamentosVendasServicos(ByVal IDDocumentoVendaServico As Long) As List(Of PagamentosVendas)
            Try
                Dim ListOfPagamentosVendas As List(Of PagamentosVendas) = (From x In BDContexto.tbPagamentosVendas
                                                                           Group Join cc In BDContexto.tbContasCaixa On x.IDContaCaixa Equals cc.ID
                                                                           Into _cc = Group From cc In _cc.DefaultIfEmpty
                                                                           Join y In BDContexto.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals x.ID
                                                                           Join t In BDContexto.tbDocumentosVendasLinhas On t.IDDocumentoVenda Equals y.IDDocumentoVenda
                                                                           Join j In BDContexto.tbDocumentosVendas On j.ID Equals y.IDDocumentoVenda
                                                                           Join z In BDContexto.tbDocumentosVendas On z.ID Equals t.IDDocumentoOrigem
                                                                           Where z.ID = IDDocumentoVendaServico
                                                                           Select New PagamentosVendas With {
                                                                               .ID = x.ID, .Data = x.Data, .CodigoTipoEstado = x.CodigoTipoEstado,
                                                                               .IDContaCaixa = x.IDContaCaixa, .DescricaoContaCaixa = cc.Descricao,
                                                                               .ValorEntregue = x.ValorEntregue, .Troco = x.Troco
                                                                           }).Distinct.ToList()

                'ADD RANGE PAYMENTS FROM NCDA's
                ListOfPagamentosVendas.AddRange((From x In BDContexto.tbDocumentosVendas
                                                 Join y In BDContexto.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                                 Join t In BDContexto.tbDocumentosVendasLinhas On t.IDDocumentoOrigem Equals y.IDDocumentoVenda
                                                 Join j In BDContexto.tbDocumentosVendas.Include("tbTiposDocumento") On j.ID Equals t.IDDocumentoVenda
                                                 Join z In BDContexto.tbPagamentosVendasLinhas On z.IDDocumentoVenda Equals j.ID
                                                 Join p In BDContexto.tbPagamentosVendas On p.ID Equals z.IDPagamentoVenda
                                                 Group Join cc In BDContexto.tbContasCaixa On p.IDContaCaixa Equals cc.ID
                                                 Into _cc = Group From cc In _cc.DefaultIfEmpty
                                                 Where y.IDDocumentoOrigem = IDDocumentoVendaServico AndAlso j.tbTiposDocumento.GereCaixasBancos
                                                 Select New PagamentosVendas With {
                                                     .ID = p.ID, .Documento = j.Documento, .Data = p.Data, .CodigoTipoEstado = p.CodigoTipoEstado,
                                                     .IDContaCaixa = p.IDContaCaixa, .DescricaoContaCaixa = cc.Descricao,
                                                     .ValorEntregue = p.ValorEntregue, .Troco = p.Troco
                                                 }).Distinct.ToList())

                'HERE PERFORMANCE
                For Each lin In ListOfPagamentosVendas 'RC's
                    If (String.IsNullOrEmpty(lin.Documento)) Then

                        Dim DocumentoRecibo As String = (From x In BDContexto.tbRecibos
                                                         Where x.IDPagamentoVenda = lin.ID
                                                         Select x.Documento).FirstOrDefault()

                        If Not DocumentoRecibo Is Nothing Then
                            lin.Documento = DocumentoRecibo

                        Else 'FA's
                            lin.Documento = (From x In BDContexto.tbPagamentosVendas
                                             Join y In BDContexto.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals x.ID
                                             Join t In BDContexto.tbDocumentosVendasLinhas On t.IDDocumentoVenda Equals y.IDDocumentoVenda
                                             Join j In BDContexto.tbDocumentosVendas On j.ID Equals y.IDDocumentoVenda
                                             Join z In BDContexto.tbDocumentosVendas On z.ID Equals t.IDDocumentoOrigem
                                             Where z.ID = IDDocumentoVendaServico AndAlso x.ID = lin.ID
                                             Select j.Documento).FirstOrDefault()
                        End If
                    End If
                Next

                Return ListOfPagamentosVendas.OrderBy(Function(o) o.Data).ThenBy(Function(t) t.DataCriacao).ToList()

            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Public Function GetPagamentoVenda(IDPagamentoVenda As Long) As PagamentosVendas
            Try
                Dim tbPV As tbPagamentosVendas = BDContexto.tbPagamentosVendas.Find(IDPagamentoVenda)
                Dim pv As New PagamentosVendas

                If tbPV IsNot Nothing Then
                    With pv
                        .ID = tbPV.ID
                        .ValorEntregue = tbPV.ValorEntregue
                        .TotalPagar = tbPV.TotalMoeda
                        .Troco = tbPV.Troco
                        .CodigoTipoEstado = tbPV.CodigoTipoEstado
                        .IDMoeda = tbPV.IDMoeda
                        .ListOfPendentes = GetPagamentosVendasLinhas(IDPagamentoVenda)
                        .ListOfFormasPagamento = GetFormasPagamento(IDPagamentoVenda)
                        .Recibo = GetRecibos(IDPagamentoVenda)
                    End With
                End If

                Return pv
            Catch
                Throw
            End Try
        End Function

        Public Function GetPagamentoVenda(ctx As BD.Dinamica.Aplicacao, IDPagamentoVenda As Long) As PagamentosVendas
            Dim tbPV As tbPagamentosVendas = ctx.tbPagamentosVendas.Find(IDPagamentoVenda)
            Dim pv As New PagamentosVendas

            If tbPV IsNot Nothing Then
                With pv
                    .ID = tbPV.ID
                    .ValorEntregue = tbPV.ValorEntregue
                    .TotalPagar = tbPV.TotalMoeda
                    .Troco = tbPV.Troco
                    .CodigoTipoEstado = tbPV.CodigoTipoEstado
                    .IDMoeda = tbPV.IDMoeda
                    .ListOfPendentes = GetPagamentosVendasLinhas(ctx, IDPagamentoVenda)
                    .ListOfFormasPagamento = GetFormasPagamento(ctx, IDPagamentoVenda)
                    .Recibo = GetRecibos(ctx, IDPagamentoVenda)
                End With
            End If

            Return pv
        End Function

        Public Function GetPagamentosVendasLinhas(IDPagamentoVenda As Long) As List(Of DocumentosVendasPendentes)
            Return GetPagamentosVendasLinhas(BDContexto, IDPagamentoVenda)
        End Function

        Public Function GetPagamentosVendasLinhas(ctx As BD.Dinamica.Aplicacao, IDPagamentoVenda As Long) As List(Of DocumentosVendasPendentes)
            Return (From x In ctx.tbPagamentosVendasLinhas
                    Join y In ctx.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                    Join z In ctx.tbDocumentosVendasPendentes On z.IDDocumentoVenda Equals y.ID
                    Where x.IDPagamentoVenda = IDPagamentoVenda
                    Select New DocumentosVendasPendentes With {
                        .ID = x.ID, .Documento = x.Documento, .NomeFiscal = y.NomeFiscal,
                        .IDDocumentoVenda = x.IDDocumentoVenda,
                        .DataDocumento = x.DataDocumento, .DataVencimento = x.DataVencimento,
                        .TotalMoedaDocumento = x.TotalMoedaDocumento,
                        .GereContaCorrente = x.tbDocumentosVendas.tbTiposDocumento.GereContaCorrente,
                        .GeraPendente = x.tbDocumentosVendas.tbTiposDocumento.GeraPendente,
                        .GereCaixasBancos = x.tbDocumentosVendas.tbTiposDocumento.GereCaixasBancos,
                        .ValorPendente = x.ValorPendente, .ValorPago = x.ValorPago,
                        .CodigoSistemaNaturezas = z.tbSistemaNaturezas.Codigo, .DescricaoSistemaNaturezas = If(z.tbSistemaNaturezas.Descricao = "APagar", "C", "D"),
                        .IDTipoDocumento = x.IDTipoDocumento
                        }).ToList()
        End Function

        Public Function GetRecibos(IDPagamentoVenda As Long) As Recibos
            Return GetRecibos(BDContexto, IDPagamentoVenda)
        End Function

        Public Function GetRecibos(ctx As BD.Dinamica.Aplicacao, IDPagamentoVenda As Long) As Recibos
            Return (From x In ctx.tbRecibos
                    Where x.IDPagamentoVenda = IDPagamentoVenda
                    Select New Recibos With {
                        .ID = x.ID, .Documento = x.Documento, .DataDocumento = x.DataDocumento, .CodigoTipoEstado = x.CodigoTipoEstado}).FirstOrDefault()
        End Function

        Public Function GetFormasPagamento(IDPagamentoVenda As Long) As List(Of PagamentosVendasFormasPagamento)
            Return GetFormasPagamento(BDContexto, IDPagamentoVenda)
        End Function
        Public Function GetFormasPagamento(ctx As BD.Dinamica.Aplicacao, IDPagamentoVenda As Long) As List(Of PagamentosVendasFormasPagamento)
            Dim ListOfFormasPagamento As List(Of FormasPagamento) = ctx.tbFormasPagamento.Where(Function(f) f.Ativo = True).Select(Function(f) New FormasPagamento With {.ID = f.ID, .Descricao = f.Descricao, .CodigoSistemaTipoFormaPagamento = f.tbSistemaTiposFormasPagamento.Codigo}).ToList()
            Dim ArrPagamentosVendasFormPag() As Long = ctx.tbPagamentosVendasFormasPagamento.Where(Function(f) f.IDPagamentoVenda = IDPagamentoVenda).Select(Function(f) f.IDFormaPagamento).ToArray

            Dim ListOfPagamentosVendasFormPag As List(Of PagamentosVendasFormasPagamento) = ctx.tbPagamentosVendasFormasPagamento.Where(Function(f) f.IDPagamentoVenda = IDPagamentoVenda).Select(Function(f) New PagamentosVendasFormasPagamento With {
                                                                                                                                                                                     .ID = f.ID, .IDFormaPagamento = f.IDFormaPagamento, .CodigoSistemaTipoFormaPagamento = f.tbFormasPagamento.tbSistemaTiposFormasPagamento.Codigo,
                                                                                                                                                                                     .DescricaoFormaPagamento = f.tbFormasPagamento.Descricao, .Valor = f.Valor}).ToList()

            For Each lin In ListOfFormasPagamento
                If Not ArrPagamentosVendasFormPag.Contains(lin.ID) Then

                    Dim PagamentoVendasFormasPagamento As New PagamentosVendasFormasPagamento

                    With PagamentoVendasFormasPagamento
                        .IDFormaPagamento = lin.ID
                        .CodigoSistemaTipoFormaPagamento = lin.CodigoSistemaTipoFormaPagamento
                        .DescricaoFormaPagamento = lin.Descricao
                        .Valor = 0
                    End With

                    ListOfPagamentosVendasFormPag.Add(PagamentoVendasFormasPagamento)
                End If
            Next

            Return ListOfPagamentosVendasFormPag.OrderByDescending(Function(f) f.CodigoSistemaTipoFormaPagamento.Contains("NU")).ToList()
        End Function

        Public Function isValid(inModelo As PagamentosVendas, inFiltro As ClsF3MFiltro) As Boolean
            Dim Opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Opcao", GetType(String)) 'pagamentos || adiantamentos
            Dim IDMoeda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMoeda", GetType(Long)) 'Moeda 
            Dim Moeda As Moedas = (From x In BDContexto.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            If Opcao = "adiantamentos" Then
                Dim dblValorPendente As Double = inModelo.ListOfPendentes(0).ValorPendenteAux
                Dim IDDocumentoVenda As Long = inModelo.ListOfPendentes(0).IDDocumentoVenda

                Dim dblRealValorPendente As Double = (From x In BDContexto.tbDocumentosVendas
                                                      Where x.ID = IDDocumentoVenda
                                                      Select Math.Round(CDbl(x.TotalClienteMoedaDocumento - x.ValorPago), Moeda.CasasDecimaisTotais)).FirstOrDefault()

                If (dblRealValorPendente <> dblValorPendente) Then
                    Return False
                End If

            ElseIf Opcao = "pagamentos" Then
                Dim idsPagamentosVendasLinha() As Long = inModelo.ListOfPendentes.Select(Function(f) f.IDDocumentoVenda And f.LinhaSelecionada = True).ToArray()
                Dim ListOfDocsVendasPendentes As List(Of tbDocumentosVendasPendentes) = BDContexto.tbDocumentosVendasPendentes.Where(Function(f) idsPagamentosVendasLinha.Contains(f.IDDocumentoVenda)).ToList()

                For Each lin In ListOfDocsVendasPendentes
                    Dim linhaModelo As DocumentosVendasPendentes = (From x In inModelo.ListOfPendentes Where x.ID = lin.ID).FirstOrDefault()

                    If linhaModelo IsNot Nothing Then
                        If linhaModelo.ValorPendenteAux <> lin.ValorPendente Then Return False
                    End If

                Next
            End If

            Return True
        End Function

        Private Sub GravaDocumentosVendaFormasPagamento(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte)
            Dim CasasDecimaisMoeda As Byte = inMoeda.CasasDecimaisTotais
            Dim intOrdem As Short = 0

            'If inModelo.ListOfPendentes.Where(Function(f) f.GeraPendente = False).Count() > 0 Then 'TODO MAF
            If inModelo.ListOfPendentes.Where(Function(f) f.GereContaCorrente = False OrElse f.GereCaixasBancos = True).Count() > 0 Then

                inModelo.ListOfPendentes.ForEach(Sub(f)
                                                     f.ValorEmFaltaAux = f.ValorPago
                                                 End Sub)

                'GRAVA NÃO NUMERARIOS
                Dim valorEntregueAux As Double = 0
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    For Each linAux In inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0)
                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)


                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0


                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravaDocs(inCtx, valor, 0, lin, linAux, inMoeda, inCDTotaisMoedaRef, intOrdem)
                    Next
                Next

                'GRAVA NUMERARIOS
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    Dim ListOfDocumentosVendasPendentes As List(Of DocumentosVendasPendentes) = inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0).ToList()
                    Dim count As Integer = ListOfDocumentosVendasPendentes.Count()

                    For i As Integer = 0 To count - 1
                        Dim linAux As DocumentosVendasPendentes = ListOfDocumentosVendasPendentes(i)

                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0

                        Dim troco As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)

                            If i = count - 1 Then
                                troco = valorEntregueAux
                            End If

                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0

                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravaDocs(inCtx, valor, troco, lin, linAux, inMoeda, inCDTotaisMoedaRef, intOrdem)

                    Next
                Next
            End If
        End Sub

        Private Sub GravaDocs(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inValor As Double, ByVal inTroco As Double,
                              ByVal PVFP As PagamentosVendasFormasPagamento, ByVal PVL As DocumentosVendasPendentes, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte,
                              ByRef intOrdem As Short)
            Try
                Dim tbDocumentosVendasFormPag As New tbDocumentosVendasFormasPagamento
                Dim DocumentoVendasFormaPagamento As New DocumentosVendasFormasPagamento

                With DocumentoVendasFormaPagamento
                    .IDDocumentoVenda = PVL.IDDocumentoVenda
                    .IDFormaPagamento = PVFP.IDFormaPagamento
                    .Valor = Math.Round(inValor, inCDTotaisMoedaRef)
                    .ValorEntregue = PVFP.Valor
                    .Troco = inTroco

                    .TotalMoeda = inValor
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoedaReferencia = CalculaCambio(inValor, inMoeda.TaxaConversao)
                    .CodigoFormaPagamento = PVFP.CodigoSistemaTipoFormaPagamento
                    intOrdem += 1
                    .Ordem = intOrdem
                End With

                Mapear(DocumentoVendasFormaPagamento, tbDocumentosVendasFormPag)

                GravaEntidadeLinha(Of tbDocumentosVendasFormasPagamento)(inCtx, tbDocumentosVendasFormPag, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()

            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        Public Sub GravaRecibos(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte)
            If inModelo.ListOfPendentes.Where(Function(f) f.GereContaCorrente = True).Count() > 0 Then
                Dim Cliente As New Clientes
                Dim tbRecibo As New tbRecibos
                Dim Moedas As New tbMoedas

                Using rp As New RepositorioClientes
                    Cliente = rp.GetClienteWithTransaction(inModelo.IDEntidade, inCtx)
                End Using

                Moedas = BDContexto.tbMoedas.Find(inModelo.IDMoeda)

                ' !? VndFinanceiro !?
                Dim TipoDocumento As TiposDocumento = (From TD In inCtx.tbTiposDocumento
                                                       Where TD.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.ReciboVendas _
                                                            And TD.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.ContaCorrenteLiquidacaoClt _
                                                            And TD.Ativo = True
                                                       Select New TiposDocumento With {.ID = TD.ID, .Codigo = TD.Codigo}).FirstOrDefault

                Dim TipoDocumentoSeries As tbTiposDocumentoSeries
                If EMultiEmpresa Then

                    Dim IDLojaSedeByIDLojaEmSessao As Long
                    Using rpLojas As New RepositorioLojas
                        IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                    End Using

                    TipoDocumentoSeries = (From TDS In inCtx.tbTiposDocumentoSeries
                                           Where TDS.IDTiposDocumento = TipoDocumento.ID AndAlso TDS.AtivoSerie AndAlso TDS.IDLoja = IDLojaSedeByIDLojaEmSessao).FirstOrDefault()

                Else
                    TipoDocumentoSeries = (From TDS In inCtx.tbTiposDocumentoSeries
                                           Where TDS.IDTiposDocumento = TipoDocumento.ID AndAlso TDS.AtivoSerie AndAlso TDS.SugeridaPorDefeito).FirstOrDefault()
                End If

                If TipoDocumentoSeries Is Nothing Then
                    Throw New Exception(Traducao.EstruturaErros.NaoEstaDefinidaSerieParaTipoDoc_X_NestaLoja.Replace("{0}", Traducao.EstruturaTiposDocumento.Recibo))
                End If


                Dim CodigoSerie As String = String.Empty
                Dim strDocOrigem As String = String.Empty
                Dim lngIDDocOrigem As Long = 0

                Dim blnManual As Boolean = False
                Dim blnReposicao As Boolean = False

                With TipoDocumentoSeries
                    CodigoSerie = .CodigoSerie
                    lngIDDocOrigem = .IDSistemaTiposDocumentoOrigem
                    strDocOrigem = inCtx.tbSistemaTiposDocumentoOrigem.Where(Function(f) f.ID = lngIDDocOrigem).FirstOrDefault.Codigo
                End With

                If strDocOrigem = F3M.Modelos.Constantes.TiposDocumentosOrigem.Manual Then
                    blnManual = True
                    blnReposicao = False

                ElseIf strDocOrigem = F3M.Modelos.Constantes.TiposDocumentosOrigem.Reposicao Then
                    blnManual = False
                    blnReposicao = True

                Else
                    blnManual = False
                    blnReposicao = False
                End If

                With tbRecibo
                    .IDPagamentoVenda = inModelo.ID
                    .IDTipoDocumento = TipoDocumento.ID
                    .IDTiposDocumentoSeries = TipoDocumentoSeries.ID

                    Dim rec As New F3M.CabecalhoDocumento
                    With rec
                        .IDTipoDocumento = TipoDocumento.ID
                        .IDTiposDocumentoSeries = TipoDocumentoSeries.ID
                        .NumeroDocumento = 0
                        .NumeroInterno = 0
                    End With
                    RepositorioDocumentos.DefineNumeroDocumento(Of tbRecibos, tbTiposDocumentoSeries)(inCtx, rec, TipoDocumentoSeries, False, 0)
                    .NumeroDocumento = rec.NumeroDocumento

                    .Documento = TipoDocumento.Codigo & " " & TipoDocumentoSeries.CodigoSerie & "/" & .NumeroDocumento
                    .DataDocumento = CType(DateAndTime.Now().ToShortDateString(), DateTime)
                    .DataAssinatura = DateTime.Now()
                    .DataVencimento = DateAndTime.Now()
                    .IDEntidade = Cliente.ID
                    .IDTipoEntidade = Cliente.IDTipoEntidade
                    .CodigoEntidade = "R" & Cliente.Codigo
                    .CodigoMoeda = Moedas.tbSistemaMoedas.Codigo
                    .NomeFiscal = Cliente.Nome
                    .MoradaFiscal = Cliente.MoradaFiscal
                    .IDCodigoPostalFiscal = Cliente.IDCodigoPostalFiscal
                    .IDConcelhoFiscal = Cliente.IDConcelhoFiscal
                    .IDDistritoFiscal = Cliente.IDDistritoFiscal
                    .CodigoPostalFiscal = Cliente.CodigoPostalFiscal
                    .DescricaoCodigoPostalFiscal = Cliente.DescricaoCodigoPostalFiscal
                    .DescricaoConcelhoFiscal = Cliente.DescricaoConcelhoFiscal
                    .DescricaoDistritoFiscal = Cliente.DescricaoDistritoFiscal

                    'seo NContribuinte for 999999990 vai substituido por "Consumidor Final"
                    If Cliente.NContribuinte IsNot Nothing AndAlso Cliente.NContribuinte.Replace(" ", "") = CamposGenericos.NIFDesconhecido Then
                        .ContribuinteFiscal = Traducao.EstruturaAplicacaoTermosBase.ConsumidorFinal

                    Else
                        .ContribuinteFiscal = Cliente.NContribuinte
                    End If

                    'preenche a propriedade SiglaPaisFiscal em todas as linhas
                    .SiglaPaisFiscal = Cliente.SiglaPais
                    inModelo.ListOfPendentes.ForEach(Sub(s)
                                                         s.SiglaPaisFiscal = .SiglaPaisFiscal
                                                     End Sub)

                    .TotalMoedaDocumento = inModelo.TotalPagar
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoedaReferencia = CalculaCambio(inModelo.TotalPagar, inMoeda.TaxaConversao)
                    .ValorImposto = CDbl(0)

                    .CodigoTipoEstado = TiposEstados.Efetivo
                    .DataHoraEstado = DateAndTime.Now()
                    .UtilizadorEstado = F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorNome

                    'HERE CERTIFICACAO!
                    Dim IDEmp As Long = CLng(ClsF3MSessao.RetornaLojaID)
                    Dim Emp As ParametrosLoja = (From x In BDContexto.tbParametrosLoja
                                                 Where x.IDLoja = IDEmp
                                                 Select New ParametrosLoja With {.ID = x.ID, .CodigoPostal = x.CodigoPostal,
                                                                                       .Localidade = x.Localidade, .NIF = x.NIF,
                                                                                       .DesignacaoComercial = x.DesignacaoComercial,
                                                                                       .Morada = x.Morada}).FirstOrDefault()

                    .CodigoPostalLoja = Emp.CodigoPostal
                    .LocalidadeLoja = Emp.Localidade
                    .SiglaLoja = ClsF3MSessao.RetornaParametros.SiglaPais()
                    .NIFLoja = Emp.NIF
                    .DesignacaoComercialLoja = Emp.DesignacaoComercial
                    .MoradaLoja = Emp.Morada
                    'END CERTIFICACAO!

                    Dim str1 = String.Empty

                    Using rpDV As New RepositorioDocumentosVendas
                        str1 = rpDV.TextoMensagemAssinatura(inCtx, True, ClsF3MSessao.RetornaEmpresaDemonstracao, False, blnManual, blnReposicao, "", "", .IDTipoDocumento, "")
                    End Using
                    .MensagemDocAT = str1
                    str1 = ClsUtilitarios.ValorExtenso(.TotalMoedaReferencia, ClsF3MSessao.RetornaParametros.MoedaReferencia.DescricaoInteira, ClsF3MSessao.RetornaParametros.MoedaReferencia.DescricaoDecimal)
                    .ValorExtenso = str1
                    .TipoFiscal = TiposDocumentosFiscal.ReciboVendas
                    .CodigoDocOrigem = TiposDocumentosOrigem.EsteSistema
                End With

                GravaEntidadeLinha(Of tbRecibos)(inCtx, tbRecibo, AcoesFormulario.Adicionar, Nothing)

                inCtx.SaveChanges()

                inModelo.IDRecibo = tbRecibo.ID

                GravaRecibosLinhas(inCtx, inModelo, inMoeda, inCDTotaisMoedaRef, tbRecibo)

                GravarRecibosFormasPagamento(inCtx, inModelo, inMoeda, inCDTotaisMoedaRef)

                'A T R I B U I R   A O   M O D E L O
                Dim Recibo As New Recibos
                Mapear(tbRecibo, Recibo)
                inModelo.Recibo = Recibo

                inCtx.sp_AtualizaCCEntidades(inModelo.IDRecibo, TipoDocumento.ID, AcoesFormulario.Adicionar, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, inModelo.IDEntidade)

                inCtx.sp_ControloDocumentos(inModelo.IDRecibo, TipoDocumento.ID, TipoDocumentoSeries.ID, AcoesFormulario.Adicionar, "tbRecibos", F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorNome)

                'QRCODE
                If RepositorioDocumentos.SeGeraQRCode(Of tbRecibos)(tbRecibo) Then
                    Dim assinatura = "0"
                    RepositorioDocumentos.TrataQRCode(Of tbRecibos, tbRecibosLinhasTaxas)(tbRecibo, Nothing, tbRecibo.tbTiposDocumentoSeries.ATCodValidacaoSerie, True, assinatura)
                End If
                inCtx.SaveChanges()

                Using rp1 As New RepositorioPagamentosVendas
                    rp1.AtualizaMapaCaixa(inCtx, inModelo, "pagamentos")
                End Using
            Else

                Using rp1 As New RepositorioPagamentosVendas
                    rp1.AtualizaMapaCaixa(inCtx, inModelo, "documentos")
                End Using
            End If
        End Sub

        Private Sub GravaRecibosLinhas(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte, Recibo As tbRecibos)
            Dim intOrdem As Short = 0
            Dim intOrdemTaxas As Short = 0
            Dim CDTotaisMoeda As Byte = inMoeda.CasasDecimaisTotais
            Dim dblValorImposto As Double = 0

            Dim myList As List(Of DocumentosVendasPendentes) = inModelo.ListOfPendentes.Where(Function(f) f.GereContaCorrente = True).ToList()

            If Not myList Is Nothing Then
                For Each lin In myList
                    Dim ReciboLinhas As New tbRecibosLinhas

                    Mapear(lin, ReciboLinhas)

                    Dim dblRazao As Double = 1
                    If lin.TotalMoedaDocumento > 0 Then
                        dblRazao = (lin.ValorPago / lin.TotalMoedaDocumento)
                    End If

                    With ReciboLinhas
                        .ID = 0
                        .IDRecibo = inModelo.IDRecibo
                        .IDDocumentoVenda = lin.IDDocumentoVenda
                        .TotalMoedaDocumento = inCtx.tbDocumentosVendas.Where(Function(d) d.ID = lin.IDDocumentoVenda).FirstOrDefault.TotalMoedaDocumento
                        .IDMoeda = inMoeda.ID
                        .TaxaConversao = inMoeda.TaxaConversao
                        .TotalMoedaReferencia = CalculaCambio(ReciboLinhas.TotalMoedaDocumento, inMoeda.TaxaConversao)
                        .ValorIncidencia = Math.Round(dblRazao * inCtx.tbDocumentosVendasLinhas.Where(Function(d) d.IDDocumentoVenda = lin.IDDocumentoVenda).Sum(Function(s) s.ValorIncidencia).Value, CDTotaisMoeda)
                        .ValorIva = Math.Round(dblRazao * inCtx.tbDocumentosVendasLinhas.Where(Function(d) d.IDDocumentoVenda = lin.IDDocumentoVenda).Sum(Function(s) s.ValorIVA).Value, CDTotaisMoeda)
                        .ValorPago = lin.ValorPago
                        .DocumentoOrigem = lin.Documento
                        .DataDocOrigem = lin.DataDocumento
                        intOrdem += 1
                        .Ordem = intOrdem
                    End With

                    GravaEntidadeLinha(Of tbRecibosLinhas)(inCtx, ReciboLinhas, AcoesFormulario.Adicionar, Nothing)
                    inCtx.SaveChanges()

                    GravaRecibosLinhasTaxas(inCtx, lin, ReciboLinhas, inMoeda, inCDTotaisMoedaRef, intOrdemTaxas, dblValorImposto)
                    Recibo.tbRecibosLinhas.Add(ReciboLinhas)
                Next

                'ATUALIZA O VALOR DE IMPOSTO
                With Recibo
                    .ValorImposto = dblValorImposto
                    .CodigoEntidade = "R" & .ID
                End With

                With inCtx
                    .tbRecibos.Attach(Recibo)
                    .Entry(Recibo).[Property](Function(x) x.ValorImposto).IsModified = True
                    .Entry(Recibo).[Property](Function(x) x.CodigoEntidade).IsModified = True
                    .SaveChanges()
                End With
            End If
        End Sub

        Private Sub GravaRecibosLinhasTaxas(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inDocumento As DocumentosVendasPendentes,
                                            ByVal inRecibosLinha As tbRecibosLinhas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte,
                                            ByRef intOrdem As Short, ByRef dblValorImposto As Double)

            Dim dblRazao As Double = 0, dblValor As Double = 0
            Dim dblIncidencia As Double = 0
            Dim dblIva As Double = 0
            Dim intI As Integer = 0

            Dim query As List(Of DocumentosVendasLinhas) = (From t In inCtx.tbDocumentosVendasLinhas
                                                            Where t.IDDocumentoVenda = inDocumento.IDDocumentoVenda
                                                            Group t By t.IDDocumentoVenda, t.IDTaxaIva, t.TaxaIva, t.tbIVA.tbSistemaTiposIVA.Codigo, t.MotivoIsencaoIva, t.CodigoRegiaoIva, t.CodigoTaxaIva, t.CodigoMotivoIsencaoIva Into Group
                                                            Select New DocumentosVendasLinhas With {.ValorIncidencia = If(Group.Sum(Function(f) f.ValorIncidencia), 0), .ValorIVA = If(Group.Sum(Function(f) f.ValorIVA), 0),
                                                                                                    .IDDocumentoVenda = IDDocumentoVenda, .IDTaxaIva = IDTaxaIva, .TaxaIva = TaxaIva, .TipoTaxa = Codigo, .CodigoTipoIva = Codigo, .CodigoRegiaoIva = CodigoRegiaoIva, .CodigoTaxaIva = CodigoTaxaIva,
                                                                                                    .MotivoIsencaoIva = MotivoIsencaoIva, .CodigoMotivoIsencaoIva = CodigoMotivoIsencaoIva}).ToList()


            If inDocumento.TotalMoedaDocumento > 0 Then dblRazao = (inDocumento.ValorPago / inDocumento.TotalMoedaDocumento)

            Dim strCodigoNatureza = (From t In inCtx.tbTiposDocumento Where t.ID = inDocumento.IDTipoDocumento).Select(Function(z) z.tbSistemaNaturezas.Codigo).FirstOrDefault

            For Each lin In query
                Dim RecibosLinhasTaxas As New tbRecibosLinhasTaxas

                With RecibosLinhasTaxas
                    .CodigoRegiaoIva = lin.CodigoRegiaoIva
                    .IDReciboLinha = inRecibosLinha.ID
                    .TaxaIva = lin.TaxaIva
                    dblValor = Math.Round(CDbl(lin.ValorIncidencia * dblRazao), inMoeda.CasasDecimaisTotais)
                    .ValorIncidencia = Math.Round(dblValor, inCDTotaisMoedaRef)
                    dblValor = lin.ValorIVA * dblRazao
                    .ValorIva = Math.Round(dblValor, inCDTotaisMoedaRef)
                    .ValorImposto = Math.Round(dblValor, inCDTotaisMoedaRef)
                    .CodigoTaxaIva = lin.CodigoTaxaIva
                    .TipoTaxa = lin.TipoTaxa
                    .CodigoTipoIva = lin.CodigoTipoIva
                    .CodigoMotivoIsencaoIva = lin.CodigoMotivoIsencaoIva
                    .MotivoIsencaoIva = lin.MotivoIsencaoIva
                    .CodigoRegiaoIva = lin.CodigoRegiaoIva
                    intOrdem += 1
                    .Ordem = intOrdem

                    dblIncidencia += Math.Round(CDbl(.ValorIncidencia), inCDTotaisMoedaRef)
                    dblIva += Math.Round(CDbl(.ValorIva), inCDTotaisMoedaRef)

                    intI += 1
                    If intI = query.Count Then 'ultima linha
                        If dblIncidencia <> inRecibosLinha.ValorIncidencia Then
                            .ValorIncidencia += Math.Round(CDbl(inRecibosLinha.ValorIncidencia - dblIncidencia), inCDTotaisMoedaRef)
                        End If
                        If dblIva <> inRecibosLinha.ValorIva Then
                            .ValorIva += Math.Round(CDbl(inRecibosLinha.ValorIva - dblIva), inCDTotaisMoedaRef)
                        End If
                    End If

                    If strCodigoNatureza = TiposNaturezas.Debito Then
                        dblValorImposto += .ValorIva
                    Else
                        dblValorImposto -= .ValorIva
                    End If
                End With

                GravaEntidadeLinha(Of tbRecibosLinhasTaxas)(inCtx, RecibosLinhasTaxas, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()

                inRecibosLinha.tbRecibosLinhasTaxas.Add(RecibosLinhasTaxas)
            Next
        End Sub

        Private Sub GravarRecibosFormasPagamento(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte)
            If inModelo.TotalPagar > 0 Then
                Dim CasasDecimaisMoeda As Byte = inMoeda.CasasDecimaisTotais
                Dim intOrdem As Short = 0

                inModelo.ListOfPendentes.ForEach(Sub(f)
                                                     f.ValorEmFaltaAux = f.ValorPago
                                                 End Sub)

                'GRAVA NÃO NUMERARIOS
                Dim valorEntregueAux As Double = 0
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    For Each linAux In inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0)
                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)


                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0


                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravarReciboFormaPagamento(inCtx, valor, 0, lin, linAux, inMoeda, inCDTotaisMoedaRef, inModelo.IDRecibo, intOrdem)
                    Next
                Next

                'GRAVA NUMERARIOS
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    Dim ListOfDocumentosVendasPendentes As List(Of DocumentosVendasPendentes) = inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0).ToList()
                    Dim count As Integer = ListOfDocumentosVendasPendentes.Count()

                    For i As Integer = 0 To count - 1
                        Dim linAux As DocumentosVendasPendentes = ListOfDocumentosVendasPendentes(i)

                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0
                        Dim troco As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)

                            If i = count - 1 Then
                                troco = valorEntregueAux
                            End If

                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0

                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravarReciboFormaPagamento(inCtx, valor, troco, lin, linAux, inMoeda, inCDTotaisMoedaRef, inModelo.IDRecibo, intOrdem)
                    Next
                Next
            End If
        End Sub

        Private Sub GravarReciboFormaPagamento(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inValor As Double, ByVal inTroco As Double, ByVal PVFP As PagamentosVendasFormasPagamento,
                                               ByVal PVL As DocumentosVendasPendentes, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte, ByVal IDRecibo As Long, ByRef intOrdem As Short)
            Dim t As New tbRecibosFormasPagamento

            With t
                .IDRecibo = IDRecibo
                .IDFormaPagamento = PVFP.IDFormaPagamento
                .Troco = inTroco
                .Valor = Math.Round(inValor, inCDTotaisMoedaRef)
                .ValorEntregue = PVFP.Valor
                .TotalMoeda = inValor
                .IDMoeda = inMoeda.ID
                .TaxaConversao = inMoeda.TaxaConversao
                .TotalMoedaReferencia = CalculaCambio(inValor, inMoeda.TaxaConversao)
                .CodigoFormaPagamento = PVFP.CodigoSistemaTipoFormaPagamento
                intOrdem += 1
                .Ordem = intOrdem
            End With

            GravaEntidadeLinha(Of tbRecibosFormasPagamento)(inCtx, t, AcoesFormulario.Adicionar, Nothing)

            inCtx.SaveChanges()
        End Sub

        Private Sub GravaAdiantamentos(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As PagamentosVendas, ByVal inFiltro As ClsF3MFiltro, ByVal inCDTotaisMoedaRef As Byte)
            Dim IDDocumentoVenda_Principal As Long = inModelo.ListOfPendentes(0).IDDocumentoVenda
            Dim DocumentoVenda As New DocumentosVendas

            Dim NewTipoDocumentoAndSerie = Nothing
            If EMultiEmpresa Then

                Dim IDLojaSedeByIDLojaEmSessao As Long
                Using rpLojas As New RepositorioLojas
                    IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                End Using

                NewTipoDocumentoAndSerie = (From x In inCtx.tbTiposDocumento
                                            Join y In inCtx.tbTiposDocumentoSeries On y.IDTiposDocumento Equals x.ID
                                            Where x.Ativo = True AndAlso
                                                y.AtivoSerie AndAlso
                                                x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo AndAlso
                                                x.Adiantamento = True AndAlso
                                                y.IDLoja = IDLojaSedeByIDLojaEmSessao
                                            Select New With {.IDTipoDoc_FA = x.ID, .IDSerie_FA = y.ID}).FirstOrDefault()

            Else
                NewTipoDocumentoAndSerie = (From x In inCtx.tbTiposDocumento
                                            Join y In inCtx.tbTiposDocumentoSeries On y.IDTiposDocumento Equals x.ID
                                            Where x.Ativo = True AndAlso
                                                x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo AndAlso
                                                x.Adiantamento = True AndAlso
                                                y.SugeridaPorDefeito = True
                                            Select New With {.IDTipoDoc_FA = x.ID, .IDSerie_FA = y.ID}).FirstOrDefault()
            End If

            If NewTipoDocumentoAndSerie Is Nothing Then
                Throw New Exception(Traducao.EstruturaErros.NaoEstaDefinidaSerieParaTipoDoc_X_NestaLoja.Replace("{0}", Traducao.EstruturaTiposDocumento.FaturaAdiantamento))
            End If

            Dim NewIDEstado As Long = (From x In inCtx.tbEstados
                                       Where x.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo _
                                       And x.tbSistemaTiposEstados.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.DocumentosVenda
                                       Select x.ID).FirstOrDefault()

            Using rp As New RepositorioDocumentosVendas
                DocumentoVenda = rp.Importar(inFiltro)

                DocumentoVenda.DocumentosVendasLinhas.ForEach(Sub(lin)
                                                                  With lin
                                                                      .Desconto1 = CDbl(0)
                                                                      .Desconto2 = CDbl(0)
                                                                      .ValorDescontoLinha = CDbl(0)
                                                                      .ValorDescontoCabecalho = CDbl(0)
                                                                  End With
                                                              End Sub)

                With DocumentoVenda
                    .ID = 0
                    .TipoFiscal = TiposDocumentosFiscal.FaturaRecibo
                    .DataDocumento = CType(DateTime.Now.ToShortDateString(), DateTime)
                    .DataAssinatura = DateAndTime.Now().Date
                    .IDEstado = NewIDEstado
                    .AcaoFormulario = AcoesFormulario.Adicionar
                    .IDTipoDocumento = NewTipoDocumentoAndSerie.IDTipoDoc_FA 'IDTipoDoc_FA
                    .IDTiposDocumentoSeries = NewTipoDocumentoAndSerie.IDSerie_FA 'IDSerie_FA
                    .TotalMoedaDocumento = inModelo.ListOfPendentes(0).ValorPago
                    .TotalMoedaReferencia = .TotalMoedaDocumento
                    .ValorPago = .TotalMoedaDocumento
                    .Adiantamento = True
                    .Observacoes = ""
                End With

                GeraDocsVendasLinhasByTaxasIVA(inCtx, inModelo, inFiltro, DocumentoVenda)

                rp.GeraDocVendaWithTransaction(inCtx, DocumentoVenda, inFiltro, inModelo)
                rp.GeraDocVendaPendenteWithTransaction(inCtx, DocumentoVenda, 0)
            End Using

            Using rp As New RepositorioDocumentosVendasPendentes
                Dim IDDocVendaPendente = (From x In inCtx.tbDocumentosVendasPendentes
                                          Where x.IDDocumentoVenda = DocumentoVenda.ID
                                          Select x.ID).FirstOrDefault()

                With inModelo.ListOfPendentes(0)
                    .ID = IDDocVendaPendente
                    .IDDocumentoVenda = DocumentoVenda.ID
                    .Documento = DocumentoVenda.Documento
                End With
            End Using

            inModelo.Adiantamento = DocumentoVenda

            AtualizaValorPagoDocVenda_Principal(inCtx, DocumentoVenda.TotalMoedaDocumento, inModelo.ValorEntregue, IDDocumentoVenda_Principal, inCDTotaisMoedaRef)
        End Sub

        Private Sub AtualizaValorPagoDocVenda_Principal(inCtx As BD.Dinamica.Aplicacao, ByVal inTotalMoedaDocumento As Double, ByVal inValorEntregue As Double, inID As Long, ByVal inCDTotaisMoedaRef As Byte)
            Dim DocumentosVendas As New tbDocumentosVendas
            Dim dblValorPago As Double = inValorEntregue
            DocumentosVendas = inCtx.tbDocumentosVendas.Where(Function(f) f.ID = inID).FirstOrDefault()

            If inValorEntregue > inTotalMoedaDocumento Then dblValorPago = inTotalMoedaDocumento

            With DocumentosVendas
                .ValorPago = Math.Round(CDbl(dblValorPago + DocumentosVendas.ValorPago), inCDTotaisMoedaRef)
            End With

            With inCtx
                .tbDocumentosVendas.Attach(DocumentosVendas)
                .Entry(DocumentosVendas).[Property](Function(x) x.ValorPago).IsModified = True
                .SaveChanges()
            End With
        End Sub

        Private Sub GeraDocsVendasLinhasByTaxasIVA(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As PagamentosVendas, ByVal inFiltro As ClsF3MFiltro, ByRef DocumentoVenda As DocumentosVendas)
            Dim intOrdem As Short = 1
            Dim IDMoeda As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMoeda", GetType(Long)) 'Moeda 
            Dim Moeda As Moedas = (From x In inCtx.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .CasasDecimaisTotais = x.CasasDecimaisTotais, .CasasDecimaisPrecosUnitarios = x.CasasDecimaisPrecosUnitarios}).FirstOrDefault()

            Dim docsLinhasGroupBYTaxaIVA = From x In DocumentoVenda.DocumentosVendasLinhas
                                           Order By x.ID
                                           Group By TaxasIVA = x.IDTaxaIva
                         Into MyTaxasIVA = Group
                                           Order By TaxasIVA

            With DocumentoVenda
                .IDEntidade1 = Nothing
                .Entidade1Automatica = False
                .DocumentosVendasLinhas = New List(Of DocumentosVendasLinhas)
            End With

            For intCiclo As Integer = 0 To docsLinhasGroupBYTaxaIVA.Count - 1
                Dim lin = docsLinhasGroupBYTaxaIVA(intCiclo)

                Dim sumTaxasIVA As Double = Math.Round(CDbl(lin.MyTaxasIVA.Sum(Function(f) (f.PrecoUnitarioEfetivo) * f.Quantidade)), Moeda.CasasDecimaisTotais)

                '(VALOR PAGO / TOTAL DOC) * SUM(TAXA)
                sumTaxasIVA = Math.Round(CDbl(((CDbl(inModelo.ListOfPendentes(0).ValorPago) / inModelo.ListOfPendentes(0).TotalMoedaDocumento) * sumTaxasIVA)), Moeda.CasasDecimaisTotais)

                Dim IDTaxaIVA As Long = lin.MyTaxasIVA(0).IDTaxaIva
                Dim strTiposIVADescricao As String = inCtx.tbIVA.Where(Function(f) f.ID = IDTaxaIVA).FirstOrDefault().tbSistemaTiposIVA.Descricao
                Dim strTiposIVACodigo As String = inCtx.tbIVA.Where(Function(f) f.ID = IDTaxaIVA).FirstOrDefault().tbSistemaTiposIVA.Codigo

                Dim MotivoIsencao As SistemaCodigosIVA = inCtx.tbIVA.Where(Function(f) f.ID = IDTaxaIVA).Select(Function(s) New SistemaCodigosIVA With {.Codigo = s.tbSistemaCodigosIVA.Codigo, .Descricao = s.tbSistemaCodigosIVA.Descricao}).FirstOrDefault()

                Dim newLine As New DocumentosVendasLinhas

                Mapear(lin.MyTaxasIVA(0), newLine)

                'MAF - QUANDO SE ADIANTAVA 100€ E ELE GERAVA A FA DE 99.99€, QUANDO TINHA 3 TAXAS DE IVA E O PRECO UNITÁRIO DE CADA TAXAS ERA TIPO 8.449
                If intCiclo = docsLinhasGroupBYTaxaIVA.Count - 1 Then
                    Dim dblSomaPagoAteAgora As Double = Math.Round(CDbl(DocumentoVenda.DocumentosVendasLinhas.Sum(Function(f) f.PrecoTotal) + sumTaxasIVA), Moeda.CasasDecimaisTotais)
                    Dim dblDiferenca As Double = Math.Round(CDbl(inModelo.TotalPagar - dblSomaPagoAteAgora), Moeda.CasasDecimaisTotais)
                    If dblDiferenca <> 0 Then
                        sumTaxasIVA = Math.Round(sumTaxasIVA + dblDiferenca, Moeda.CasasDecimaisTotais)
                    End If
                End If

                ' L I N H A 
                With newLine
                    'CRUD
                    .ID = 0 : .AcaoCRUD = AcoesFormulario.Adicionar : .Ordem = intOrdem : .IDEstado = 5

                    'CAMPANHA
                    .Campanha = Nothing : .IDCampanha = Nothing

                    Dim strCodigoArtigo As String = "DV-" & strTiposIVACodigo

                    Dim Artigo As Oticas.Artigos = (From x In inCtx.tbArtigos
                                                    Where x.Codigo = strCodigoArtigo
                                                    Select New Oticas.Artigos With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao, .IDMarca = x.IDMarca, .DescricaoMarca = x.tbMarcas.Descricao}).FirstOrDefault()
                    'ARTIGO
                    .IDArtigo = Artigo.ID : .CodigoArtigo = Artigo.Codigo : .Descricao = "ADIANTAMENTO À TAXA " + strTiposIVADescricao.ToUpper() : .IDMarca = Artigo.IDMarca : .DescricaoMarca = Artigo.DescricaoMarca

                    'DESCONTOS
                    .Desconto1 = CDbl(0) : .Desconto2 = CDbl(0) : .ValorDescontoLinha = CDbl(0) : .ValorDescontoCabecalho = CDbl(0)

                    'PREÇO
                    .Quantidade = 1 : .PrecoUnitario = sumTaxasIVA : .PrecoUnitarioEfetivo = sumTaxasIVA : .PrecoTotal = sumTaxasIVA : .TotalComDescontoLinha = sumTaxasIVA : .TotalComDescontoCabecalho = sumTaxasIVA : .TotalFinal = sumTaxasIVA : .TotalSemDescontoLinha = sumTaxasIVA

                    'PREÇO
                    .CodigoMotivoIsencaoIva = MotivoIsencao.Codigo : .MotivoIsencaoIva = MotivoIsencao.Descricao

                    'ENTIDADES
                    .ValorEntidade1 = CDbl(0) : .ValorEntidade2 = CDbl(0) : .ValorUnitarioEntidade1 = CDbl(0) : .ValorUnitarioEntidade2 = CDbl(0)

                    'A D D   T O   C A B E C A L H O
                    DocumentoVenda.DocumentosVendasLinhas.Add(newLine)
                    'E N D   L I N H A

                    'C A B E C A L H O
                    With DocumentoVenda
                        'DESCONTOS
                        .PercentagemDesconto = CDbl(0) : .ValorDesconto = CDbl(0)
                    End With


                    intOrdem += 1
                End With
            Next

            Using rp As New RepositorioDocumentosVendas
                rp.Calcula(inFiltro, DocumentoVenda, inCtx)
            End Using
        End Sub

        ''' <summary>
        '''Atualiza o Mapa de Caixa executando o SP sp_AtualizaMapaCaixa
        ''' </summary>
        ''' <param name="inCtx">BD Context</param>
        ''' <param name="inModelo">Modelo (PagamentosVendas)</param>
        ''' <param name="inOpcao">adiantamentos || pagamentos</param>
        ''' <remarks></remarks>
        Public Sub AtualizaMapaCaixa(inCtx As BD.Dinamica.Aplicacao, inModelo As PagamentosVendas, ByVal inOpcao As String)
            Dim IDTipoDocumento As Long = 0
            Dim IDDocumento As Long = 0

            With inModelo
                Select Case inOpcao
                    Case "adiantamentos"
                        IDTipoDocumento = .Adiantamento.IDTipoDocumento 'ADIANTEMENTO -> IDTIPODOCUMENTO ( FA )
                        IDDocumento = .Adiantamento.ID 'ADIANTAMENTO -> NOVO IDDocumentoVenda!

                    Case "pagamentos"
                        IDTipoDocumento = .Recibo.IDTipoDocumento
                        IDDocumento = .IDRecibo

                    Case "documentos"
                        Dim intI As Integer

                        For intI = 0 To inModelo.ListOfPendentes.Count - 1
                            IDTipoDocumento = inModelo.ListOfPendentes(intI).IDTipoDocumento
                            IDDocumento = inModelo.ListOfPendentes(intI).IDDocumentoVenda
                        Next
                        If .Adiantamento IsNot Nothing Then
                            IDTipoDocumento = .Adiantamento.IDTipoDocumento
                            IDDocumento = .Adiantamento.ID
                        End If
                End Select
            End With

            If inModelo.IDContaCaixa > 0 Then
                inCtx.sp_AtualizaMapaCaixa(IDDocumento, IDTipoDocumento, AcoesFormulario.Adicionar, ClsF3MSessao.RetornaUtilizadorID, inModelo.IDContaCaixa)
            End If
        End Sub

        ' TODO!!!!!!!!!!
        ''' <summary>
        '''Anular o pagamento de Venda
        ''' </summary>
        ''' <param name="inIDPagamentoVenda">IDPagamentoVenda (LONG)</param>
        ''' <remarks></remarks>
        Protected Friend Sub Anula(ByVal inIDPagamentoVenda As Long)
            Dim ID_ESTADO_ANULADO_DV As Long = (From x In BDContexto.tbEstados
                                                Where x.tbSistemaTiposEstados.Codigo = TiposEstados.Anulado AndAlso
                                                    x.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.DocumentosVenda
                                                Select x.ID).FirstOrDefault()

            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try

                            If VerificaPagamentosLinhasNCDA(inIDPagamentoVenda) AndAlso HasNCDA(inIDPagamentoVenda) Then
                                Dim IDNCDA As Long = 0
                                'ANULA NCDA
                                Using rpDocu As New RepositorioDocumentosVendas
                                    Dim IDDocumentoVendaServico As Long = GetIDDocumentoVendaServicoByIDPagamento(ctx, inIDPagamentoVenda)
                                    IDNCDA = rpDocu.GetNCDAByIDDocumentoVendaServico(IDDocumentoVendaServico)
                                End Using

                                If IDNCDA <> 0 Then
                                    AnulaNCDA(ctx, IDNCDA, ID_ESTADO_ANULADO_DV)
                                    'AnulaPagamentoVendaWithNCDA(ctx, inIDPagamentoVenda, ID_ESTADO_ANULADO_DV)
                                    AnulaPagamentoVenda(ctx, inIDPagamentoVenda, ID_ESTADO_ANULADO_DV)
                                End If

                            Else
                                AnulaPagamentoVenda(ctx, inIDPagamentoVenda, ID_ESTADO_ANULADO_DV)
                            End If

                            trans.Commit()

                        Catch ex As Exception
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                Throw ex
            End Try
        End Sub
        'END TODO!!!!!!!!!!
        Protected Friend Sub AnulaPagamentoVenda(ctx As BD.Dinamica.Aplicacao,
                                                 IDPagamentoVenda As Long,
                                                 IDEstadoAnulado As Long)

            Dim PagamentoVenda As PagamentosVendas = GetPagamentoVenda(ctx, IDPagamentoVenda)

            Dim Moeda As Moedas = (From x In ctx.tbMoedas
                                   Where x.ID = PagamentoVenda.IDMoeda
                                   Select New Moedas With {.ID = x.ID, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            Dim blnExisteAlgumaNA As Boolean = (From x In PagamentoVenda.ListOfPendentes
                                                Join y In ctx.tbTiposDocumento On y.ID Equals x.IDTipoDocumento
                                                Join z In ctx.tbSistemaTiposDocumentoFiscal On z.ID Equals y.IDSistemaTiposDocumentoFiscal
                                                Where (y.Adiantamento = True And z.Tipo = TiposDocumentosFiscal.NotaCredito)
                                                Select x).ToList().Count > 0



            If blnExisteAlgumaNA Then

                For Each lin In PagamentoVenda.ListOfPendentes

                    Dim DocumentoVenda As New tbDocumentosVendas
                    DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = lin.IDDocumentoVenda).FirstOrDefault()

                    With DocumentoVenda
                        .ValorPago = CDbl(0)
                        .IDEstado = IDEstadoAnulado : .CodigoTipoEstado = TiposEstados.Anulado : .DataHoraEstado = DateAndTime.Now()
                        .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                    End With

                    With ctx
                        GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                        .SaveChanges()
                    End With

                    ctx.sp_AtualizaMapaCaixa(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, 0)
                    ctx.sp_AtualizaCCEntidades(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)

                    If DocumentoVenda.tbTiposDocumento.GereStock Then
                        With DocumentoVenda
                            ctx.sp_AtualizaStock(.ID, .IDTipoDocumento, AcoesFormulario.Remover, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, True, False)
                        End With
                    End If

                    Dim DocumentoVendaPendente As New tbDocumentosVendasPendentes
                    DocumentoVendaPendente = (From x In ctx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = lin.IDDocumentoVenda).FirstOrDefault()

                    With DocumentoVendaPendente
                        .ValorPendente = Math.Round(CDbl(.TotalClienteMoedaDocumento), Moeda.CasasDecimaisTotais)
                    End With

                    With ctx
                        GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, DocumentoVendaPendente, AcoesFormulario.Alterar, Nothing)
                        .SaveChanges()
                    End With

                    Dim E_NA As Boolean = (From x In ctx.tbTiposDocumento
                                           Where x.ID = lin.IDTipoDocumento AndAlso
                                               (x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito AndAlso x.Adiantamento = True)
                                           Select x).Count > 0

                    If Not E_NA Then
                        Dim ListOfRecibos As New List(Of tbRecibos)
                        ListOfRecibos = (From x In ctx.tbRecibos
                                         Join y In ctx.tbRecibosLinhas On y.IDRecibo Equals x.ID
                                         Where y.IDDocumentoVenda = lin.IDDocumentoVenda
                                         Select x).ToList()

                        For Each lin2 In ListOfRecibos
                            With lin2
                                .CodigoTipoEstado = TiposEstados.Anulado : .DataHoraEstado = DateAndTime.Now() : .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                            End With

                            'QRCODE
                            If RepositorioDocumentos.SeGeraQRCode(Of tbRecibos)(lin2) Then
                                Dim assinatura = "0"
                                RepositorioDocumentos.TrataQRCode(Of tbRecibos, tbRecibosLinhasTaxas)(lin2, Nothing, lin2.tbTiposDocumentoSeries.ATCodValidacaoSerie, True, assinatura)
                            End If

                            With ctx
                                GravaEntidadeLinha(Of tbRecibos)(ctx, lin2, AcoesFormulario.Alterar, Nothing)
                                .SaveChanges()
                            End With
                            ctx.sp_AtualizaMapaCaixa(lin2.ID, lin2.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, 0)
                            ctx.sp_AtualizaCCEntidades(lin2.ID, lin2.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)
                        Next


                        'ATUALIZA O PAGAMENTO
                        Dim tbPagamentoVenda12 As New List(Of tbPagamentosVendas)
                        tbPagamentoVenda12 = (From x In ctx.tbPagamentosVendas
                                              Join y In ctx.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals x.ID
                                              Where y.IDDocumentoVenda = lin.IDDocumentoVenda
                                              Select x).ToList()

                        For Each lin2 In tbPagamentoVenda12
                            With lin2
                                .CodigoTipoEstado = TiposEstados.Anulado
                            End With

                            With ctx
                                GravaEntidadeLinha(Of tbPagamentosVendas)(ctx, lin2, AcoesFormulario.Alterar, Nothing)
                                .SaveChanges()
                            End With

                            'AtualizaValorPagoDocVendaOrigem_FROM_ANULAR(ctx, lin.IDDocumentoVenda, lin2.ID, Moeda.CasasDecimaisTotais)
                        Next

                        AtualizaValorPagoDocVendaOrigem_FROM_ANULAR_ComNAS(ctx, lin.IDDocumentoVenda, Moeda.CasasDecimaisTotais)

                        If DocumentoVenda.tbTiposDocumento.GereStock AndAlso DocumentoVenda.tbTiposDocumento.GeraPendente = False Then
                            With DocumentoVenda
                                'ATUALIZA O STOCK
                                ctx.sp_AtualizaStock(.ID, .IDTipoDocumento, AcoesFormulario.Remover, "tbDocumentosVendas",
                                                                     "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, True, False)
                            End With
                        End If
                    End If
                Next

            Else
                For Each lin In PagamentoVenda.ListOfPendentes

                    Dim DocumentoVenda As New tbDocumentosVendas
                    Dim dblValorJaPago As Nullable(Of Double) = 0
                    Dim E_NA As Boolean = False

                    DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = lin.IDDocumentoVenda).FirstOrDefault()

                    Dim IDDocumentoOrigem As Nullable(Of Long) = (From x In ctx.tbDocumentosVendasLinhas Where x.IDDocumentoVenda = DocumentoVenda.ID).FirstOrDefault().IDDocumentoOrigem

                    If Not IDDocumentoOrigem Is Nothing _
                                        AndAlso (DocumentoVenda.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo _
                                        And DocumentoVenda.tbTiposDocumento.Adiantamento = True) Then 'ADIANTAMENTOS GERADO FROM SERVIÇOS

                        dblValorJaPago = (From x In ctx.tbPagamentosVendasLinhas
                                          Join y In ctx.tbPagamentosVendas On y.ID Equals x.IDPagamentoVenda
                                          Join z In ctx.tbDocumentosVendasLinhas On z.IDDocumentoVenda Equals x.IDDocumentoVenda
                                          Where z.IDDocumentoOrigem = IDDocumentoOrigem AndAlso
                                              x.IDPagamentoVenda <> IDPagamentoVenda AndAlso
                                              y.CodigoTipoEstado <> TiposEstados.Anulado
                                          Select x Distinct).Sum(Function(s) s.ValorPago)

                        If dblValorJaPago Is Nothing Then dblValorJaPago = CDbl(0)


                        With DocumentoVenda
                            .ValorPago = 0
                            .IDEstado = IDEstadoAnulado
                            .CodigoTipoEstado = TiposEstados.Anulado
                            .DataHoraEstado = DateAndTime.Now()
                            .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                        End With

                        With ctx
                            GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                            .SaveChanges()
                            .sp_AtualizaMapaCaixa(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, 0)
                            .sp_AtualizaCCEntidades(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)
                        End With

                        DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = IDDocumentoOrigem).FirstOrDefault()
                        With DocumentoVenda
                            .ValorPago = dblValorJaPago
                        End With

                        With ctx
                            GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                            .SaveChanges()
                        End With

                        'ATUALIZA O PENDENTE
                        Dim DocumentoVendaPendente As New tbDocumentosVendasPendentes
                        DocumentoVendaPendente = (From x In ctx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = lin.IDDocumentoVenda).FirstOrDefault()

                        With DocumentoVendaPendente
                            .ValorPendente = Math.Round(CDbl(.TotalClienteMoedaDocumento), Moeda.CasasDecimaisTotais)
                        End With

                        With ctx
                            GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, DocumentoVendaPendente, AcoesFormulario.Alterar, Nothing)
                            .SaveChanges()
                        End With

                    Else
                        dblValorJaPago = (From x In ctx.tbPagamentosVendasLinhas
                                          Join y In ctx.tbPagamentosVendas On y.ID Equals x.IDPagamentoVenda
                                          Where x.IDDocumentoVenda = lin.IDDocumentoVenda AndAlso
                                              x.IDPagamentoVenda <> IDPagamentoVenda AndAlso
                                              y.CodigoTipoEstado <> TiposEstados.Anulado
                                          Select x Distinct).Sum(Function(s) s.ValorPago)

                        If dblValorJaPago Is Nothing Then dblValorJaPago = CDbl(0)

                        With DocumentoVenda
                            .ValorPago = Math.Round(CDbl(dblValorJaPago), Moeda.CasasDecimaisTotais)

                            E_NA = (From x In ctx.tbTiposDocumento
                                    Where x.ID = lin.IDTipoDocumento And (x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito And x.Adiantamento = True)
                                    Select x).Count > 0

                            'SE TIVER NA ENTÃO ANULA TUDO E MAIS ALGUMA COISA!
                            If Not lin.GeraPendente OrElse E_NA Then 'REC || NA
                                .IDEstado = IDEstadoAnulado
                                .CodigoTipoEstado = TiposEstados.Anulado
                                .DataHoraEstado = DateAndTime.Now()
                                .UtilizadorEstado = F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorNome
                            End If
                        End With

                        With ctx
                            GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                            .SaveChanges()
                        End With

                        If Not lin.GeraPendente OrElse E_NA Then
                            ctx.sp_AtualizaMapaCaixa(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, 0)
                        End If

                        If lin.GeraPendente = False Then
                            ctx.sp_AtualizaCCEntidades(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)
                        End If

                        If DocumentoVenda.tbTiposDocumento.GereStock AndAlso DocumentoVenda.tbTiposDocumento.GeraPendente = False Then
                            With DocumentoVenda
                                'ATUALIZA O STOCK
                                ctx.sp_AtualizaStock(
                                .ID,
                                .IDTipoDocumento,
                                AcoesFormulario.Remover, "tbDocumentosVendas",
                                "tbDocumentosVendasLinhas",
                                "", "IDDocumentoVenda",
                                "",
                                ClsF3MSessao.RetornaUtilizadorNome,
                                True,
                                False)
                            End With
                        End If

                        Dim DocumentoVendaPendente As New tbDocumentosVendasPendentes
                        DocumentoVendaPendente = (From x In ctx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = lin.IDDocumentoVenda).FirstOrDefault()

                        With DocumentoVendaPendente
                            .ValorPendente = Math.Round(CDbl(.TotalClienteMoedaDocumento - dblValorJaPago), Moeda.CasasDecimaisTotais)
                        End With

                        With ctx
                            GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, DocumentoVendaPendente, AcoesFormulario.Alterar, Nothing)
                            .SaveChanges()
                        End With

                        AtualizaValorPagoDocVendaOrigem_FROM_ANULAR(ctx, lin.IDDocumentoVenda, Moeda.CasasDecimaisTotais)
                    End If
                Next

                If Not PagamentoVenda.Recibo Is Nothing Then 'ADIANTAMENTOS
                    'ATUALIZA O RECIBO
                    Dim Recibo As New tbRecibos
                    Recibo = (From x In ctx.tbRecibos Where x.ID = PagamentoVenda.Recibo.ID).FirstOrDefault()

                    With Recibo
                        .CodigoTipoEstado = TiposEstados.Anulado
                        .DataHoraEstado = DateAndTime.Now()
                        .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                    End With

                    'QRCODE
                    If RepositorioDocumentos.SeGeraQRCode(Of tbRecibos)(Recibo) Then
                        Dim assinatura = "0"
                        RepositorioDocumentos.TrataQRCode(Of tbRecibos, tbRecibosLinhasTaxas)(Recibo, Nothing, Recibo.tbTiposDocumentoSeries.ATCodValidacaoSerie, True, assinatura)
                    End If

                    With ctx
                        GravaEntidadeLinha(Of tbRecibos)(ctx, Recibo, AcoesFormulario.Alterar, Nothing)
                        .SaveChanges()
                        'SPS
                        .sp_AtualizaMapaCaixa(Recibo.ID, Recibo.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, 0)
                        .sp_AtualizaCCEntidades(Recibo.ID, Recibo.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, Recibo.IDEntidade)
                    End With
                End If

                'ATUALIZA O PAGAMENTO
                Dim tbPagamentoVenda As New tbPagamentosVendas
                tbPagamentoVenda = (From x In ctx.tbPagamentosVendas Where x.ID = IDPagamentoVenda).FirstOrDefault()

                With tbPagamentoVenda
                    .CodigoTipoEstado = TiposEstados.Anulado
                End With

                With ctx
                    GravaEntidadeLinha(Of tbPagamentosVendas)(ctx, tbPagamentoVenda, AcoesFormulario.Alterar, Nothing)
                    .SaveChanges()
                End With
            End If
        End Sub

        ''' <summary>
        ''' funcao que verifica se o pagamento ainda esta efetivo e nao anulado
        ''' </summary>
        ''' <param name="inIDPagamentoVenda"></param>
        ''' <returns>True || False</returns>
        ''' <remarks></remarks>
        Protected Friend Function VerificaPagEstadoEfetivo(ByVal inIDPagamentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbPagamentosVendas
                    Where x.ID = inIDPagamentoVenda And x.CodigoTipoEstado = TiposEstados.Efetivo
                    Select x.CodigoTipoEstado).Count > 0
        End Function

        ''' <summary>
        '''funcao que verifica se existe a FA na NA
        ''' </summary>
        ''' <param name="IDPagamentoVenda">IDPagamentoVenda</param>
        ''' ''' <returns>True || False</returns>
        ''' <remarks></remarks>
        Public Function VerificaFAnaNA(ByVal IDPagamentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbPagamentosVendas
                    Join y In BDContexto.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals x.ID
                    Join z In BDContexto.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals z.IDAdiantamentoOrigem
                    Join t In BDContexto.tbDocumentosVendas On t.ID Equals y.IDDocumentoVenda
                    Join m In BDContexto.tbDocumentosVendas On m.ID Equals z.IDDocumentoVenda
                    Where x.ID = IDPagamentoVenda And t.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo _
                                    And m.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo
                    Select z).ToList().Count = 0
        End Function

        Protected Friend Function VerificaSE_NA(ByVal inIDPagamentoVenda As Long) As PagamentosVendas
            Dim PagamentoVenda As New Oticas.PagamentosVendas
            PagamentoVenda = GetPagamentoVenda(inIDPagamentoVenda)

            Dim blnExistemNA = (From x In PagamentoVenda.ListOfPendentes
                                Join y In BDContexto.tbTiposDocumento On y.ID Equals x.IDTipoDocumento
                                Join z In BDContexto.tbSistemaTiposDocumentoFiscal On z.ID Equals y.IDSistemaTiposDocumentoFiscal
                                Where y.Adiantamento = True And z.Tipo = TiposDocumentosFiscal.NotaCredito
                                Select x).ToList().Count > 0

            If blnExistemNA Then Return PagamentoVenda

            Return Nothing
        End Function

        ''' <summary>
        '''Verifica se existem Linhas selecionadas e c/o Valor pago = 0 || TRUE --> VALIDO
        ''' </summary>
        ''' <param name="inModelo">inModelo (PAGAMENTOSVENDAS)</param>
        '''  <param name="inFiltro">inFiltro (ClsF3MFiltro)</param>
        ''' <remarks></remarks>
        Public Function isLinhasValidas(inModelo As PagamentosVendas, inFiltro As ClsF3MFiltro) As Boolean
            Return (From x In inModelo.ListOfPendentes Where x.LinhaSelecionada = True And x.ValorPago <= 0).Count() = 0
        End Function

        ''' <summary>
        ''' funcao que atualiza o ValorPago do documento de venda origem (FROM SERVICOS) quando a operacao e PAGAR
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inIDDocumentoVenda"></param>
        ''' <param name="inDblValorPago"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <remarks></remarks>
        Private Sub AtualizaValorPagoDocVendaOrigem_FROM_PAGAR(inCtx As BD.Dinamica.Aplicacao, ByVal inIDDocumentoVenda As Long, ByVal inDblValorPago As Double, ByVal inCDTotaisMoedaRef As Byte)
            Dim DocumentoOrigem As tbDocumentosVendas = (From x In inCtx.tbDocumentosVendas
                                                         Join y In inCtx.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                                         Join z In inCtx.tbDocumentosVendas On z.ID Equals y.IDDocumentoOrigem
                                                         Where x.ID = inIDDocumentoVenda
                                                         Select z).FirstOrDefault()

            If Not DocumentoOrigem Is Nothing AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = "VndServico" AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumentoFiscal Is Nothing Then

                With DocumentoOrigem
                    .ValorPago = Math.Round(CDbl(DocumentoOrigem.ValorPago + inDblValorPago), inCDTotaisMoedaRef)
                End With

                With inCtx
                    .tbDocumentosVendas.Attach(DocumentoOrigem)
                    .Entry(DocumentoOrigem).[Property](Function(x) x.ValorPago).IsModified = True
                    .SaveChanges()
                End With
            End If
        End Sub

        ''' <summary>
        ''' funcao que atualiza o ValorPago do documento de venda origem (FROM SERVICOS) quando a operacao e ANULAR
        ''' </summary>
        ''' <param name="inCtx">DBContext</param>
        ''' <param name="inIDDocumentoVenda"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <remarks></remarks>
        Private Sub AtualizaValorPagoDocVendaOrigem_FROM_ANULAR(inCtx As BD.Dinamica.Aplicacao, ByVal inIDDocumentoVenda As Long, ByVal inCDTotaisMoedaRef As Byte)
            Dim DocumentoOrigem As tbDocumentosVendas = (From x In inCtx.tbDocumentosVendas
                                                         Join y In inCtx.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                                         Join z In inCtx.tbDocumentosVendas On z.ID Equals y.IDDocumentoOrigem
                                                         Where x.ID = inIDDocumentoVenda
                                                         Select z).FirstOrDefault()

            If Not DocumentoOrigem Is Nothing AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = "VndServico" AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumentoFiscal Is Nothing Then

                'QUERY MADE BY PC ON 05/03/2018
                Dim strSqlQuery As String = ""
                strSqlQuery &= " SELECT SUM(valorpago) "
                strSqlQuery &= " FROM "
                strSqlQuery &= "    (SELECT DISTINCT D.Id, (case when SN.Codigo='R' then D.ValorPago else -D.ValorPago end) as valorpago, D.idTipodocumento, SN.Codigo "
                strSqlQuery &= " FROM [dbo].[tbPagamentosVendasLinhas] PL        "
                strSqlQuery &= "    INNER Join [dbo].[tbPagamentosVendas] AS P ON PL.[IDPagamentoVenda] = P.[ID] "
                strSqlQuery &= "    INNER Join [dbo].[tbDocumentosVendasLinhas] AS DL ON DL.[IDDocumentoVenda] = PL.[IDDocumentoVenda] "
                strSqlQuery &= "    INNER Join [dbo].[tbDocumentosVendas] AS D ON D.[ID] = dl.[IDDocumentoVenda]  "
                strSqlQuery &= "    INNER Join [dbo].[tbTiposDocumento] AS TD ON TD.[ID] = D.IDTipoDocumento  "
                strSqlQuery &= "    INNER Join [dbo].[tbSistemaNaturezas] AS SN ON SN.[ID] = TD.IDSistemaNaturezas "
                strSqlQuery &= "    INNER Join [dbo].[tbSistemaTiposDocumentoFiscal] AS TDF ON TDF.[ID] = TD.IDSistemaTiposDocumentoFiscal  "
                strSqlQuery &= " WHERE DL.IDDocumentoOrigem = " & DocumentoOrigem.ID & " AND D.CodigotipoEstado ='" & TiposEstados.Efetivo & "' "
                strSqlQuery &= " AND TD.Adiantamento=0 "
                strSqlQuery &= " ) T "

                Dim dblValorPago As Nullable(Of Double) = inCtx.Database.SqlQuery(Of Nullable(Of Double))(strSqlQuery).DefaultIfEmpty(0).Sum()

                With DocumentoOrigem
                    .ValorPago = Math.Round(CDbl(dblValorPago), inCDTotaisMoedaRef)
                End With

                With inCtx
                    .tbDocumentosVendas.Attach(DocumentoOrigem)
                    .Entry(DocumentoOrigem).[Property](Function(x) x.ValorPago).IsModified = True
                    .SaveChanges()
                End With
            End If
        End Sub

        ''' <summary>
        ''' funcao que atualiza o ValorPago do documento de venda origem (FROM SERVICOS) quando a operacao e ANULAR e tem NAS
        ''' </summary>
        ''' <param name="inCtx">DBContext</param>
        ''' <param name="inIDDocumentoVenda"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <remarks></remarks>
        Private Sub AtualizaValorPagoDocVendaOrigem_FROM_ANULAR_ComNAS(inCtx As BD.Dinamica.Aplicacao, ByVal inIDDocumentoVenda As Long, ByVal inCDTotaisMoedaRef As Byte)
            Dim DocumentoOrigem As tbDocumentosVendas = (From x In inCtx.tbDocumentosVendas
                                                         Join y In inCtx.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                                         Join z In inCtx.tbDocumentosVendas On z.ID Equals y.IDDocumentoOrigem
                                                         Where x.ID = inIDDocumentoVenda
                                                         Select z).FirstOrDefault()

            If Not DocumentoOrigem Is Nothing AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = "VndServico" AndAlso
                DocumentoOrigem.tbTiposDocumento.tbSistemaTiposDocumentoFiscal Is Nothing Then

                'QUERY MADE BY PC ON 05/03/2018
                Dim strSqlQuery As String = " "
                strSqlQuery &= " SELECT D.ValorPago "
                strSqlQuery &= " FROM [dbo].[tbPagamentosVendasLinhas] PL        "
                strSqlQuery &= "    INNER Join [dbo].[tbPagamentosVendas] AS P ON PL.[IDPagamentoVenda] = P.[ID] "
                strSqlQuery &= "    INNER Join [dbo].[tbDocumentosVendasLinhas] AS DL ON DL.[IDDocumentoVenda] = PL.[IDDocumentoVenda] "
                strSqlQuery &= "    INNER Join [dbo].[tbDocumentosVendas] AS D ON D.[ID] = dl.[IDDocumentoVenda] "
                strSqlQuery &= "    INNER Join [dbo].[tbTiposDocumento] AS TD ON TD.[ID] = D.IDTipoDocumento "
                strSqlQuery &= "    INNER Join [dbo].[tbSistemaTiposDocumentoFiscal] AS TDF ON TDF.[ID] = TD.IDSistemaTiposDocumentoFiscal "
                strSqlQuery &= " WHERE DL.IDDocumentoOrigem =" & DocumentoOrigem.ID & " AND D.CodigotipoEstado ='" & TiposEstados.Efetivo & "'"
                strSqlQuery &= "    AND TDF.Tipo ='" & TiposDocumentosFiscal.FaturaRecibo & "' AND TD.Adiantamento=1 "

                Dim dblValorPago As Nullable(Of Double) = inCtx.Database.SqlQuery(Of Nullable(Of Double))(strSqlQuery).DefaultIfEmpty(0).Sum()

                With DocumentoOrigem
                    .ValorPago = Math.Round(CDbl(dblValorPago), inCDTotaisMoedaRef)
                End With

                With inCtx
                    .tbDocumentosVendas.Attach(DocumentoOrigem)
                    .Entry(DocumentoOrigem).[Property](Function(x) x.ValorPago).IsModified = True
                    .SaveChanges()
                End With
            End If
        End Sub

        ''' <summary>
        ''' funcao que verifica se existem NC's e soma-as ao valor entregue
        ''' </summary>
        ''' <param name="inModelo"></param>
        ''' <remarks></remarks>
        Private Sub ValorDasNCs(ByRef inModelo As PagamentosVendas)
            If inModelo.ListOfPendentes.Count > 0 Then
                inModelo.ValorEntregue += SumValorPagoNCs(inModelo)
            End If
        End Sub

        Private Function SumValorPagoNCs(ByVal inModelo As PagamentosVendas) As Double
            Return (From x In inModelo.ListOfPendentes
                    Where x.CodigoSistemaNaturezas = TiposNaturezas.Credito
                    Select x.ValorPago).DefaultIfEmpty(0).Sum()
        End Function


        ''' <summary>
        ''' grava especifico quando vai fazer a fatura vindo dos servicos
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="inMoeda"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <remarks></remarks>
        Private Sub GravaPagamentoVendas_FROM_NA(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas,
                                           ByVal inCDTotaisMoedaRef As Byte, ByVal IDDocumentoVenda As Long)

            Dim intOrdem As Short = 0

            inModelo.ListOfFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.Valor > 0).ToList()

            If inCtx.tbPagamentosVendas.Count <> 0 Then
                inModelo.Numero = inCtx.tbPagamentosVendas.Select(Function(f) f.Numero).Max() + 1

            Else
                inModelo.Numero = 1
            End If

            With inModelo
                .Data = DateAndTime.Now()
                .IDMoeda = inMoeda.ID
                .TaxaConversao = inMoeda.TaxaConversao
                .TotalMoeda = CDbl(0)
                .TotalMoedaReferencia = CDbl(0)
                .ValorEntregue = CDbl(0)
                .TotalPagar = CDbl(0)
                .Troco = CDbl(0)
                .CodigoTipoEstado = TiposEstados.Efetivo
            End With

            Dim e As tbPagamentosVendas = GravaObjContexto(inCtx, inModelo, AcoesFormulario.Adicionar)
            inCtx.SaveChanges()
            inModelo.ID = e.ID


            'GRAVA FORMAS DE PAGAMENTO
            For Each lin In inModelo.ListOfFormasPagamento
                Dim PagamentosVendasFormaPagamento As New tbPagamentosVendasFormasPagamento
                Mapear(lin, PagamentosVendasFormaPagamento)

                With PagamentosVendasFormaPagamento
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = CDbl(0)
                    .TotalMoedaReferencia = CDbl(0)

                    intOrdem += 1
                    .Ordem = intOrdem
                    .Valor = CDbl(0)
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasFormasPagamento)(inCtx, PagamentosVendasFormaPagamento, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            Next

            'GRAVA VENDAS LINHAS
            intOrdem = 0
            For Each lin In inModelo.ListOfPendentes
                Dim PagamentoVendasLinha As New tbPagamentosVendasLinhas

                Mapear(lin, PagamentoVendasLinha)

                With PagamentoVendasLinha
                    .ID = 0
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = lin.ValorPago
                    .TotalMoedaReferencia = CalculaCambio(lin.ValorPago, inMoeda.TaxaConversao)
                    intOrdem += 1
                    .Ordem = intOrdem

                    .TotalMoedaDocumento = .TotalMoedaDocumento
                    .ValorPendente = .ValorPendente
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasLinhas)(inCtx, PagamentoVendasLinha, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()

                AtualizaValorPagoDocVenda_Principal(inCtx, lin.TotalMoedaDocumento, lin.ValorPago, lin.IDDocumentoVenda, inCDTotaisMoedaRef)
            Next

            Dim dblValorPago As Double = Math.Round(inModelo.ListOfPendentes.Where(Function(f) f.CodigoSistemaNaturezas = TiposNaturezas.Debito).Sum(Function(f) f.ValorPago), inMoeda.CasasDecimaisTotais)

            AtualizaValorPagoDocVenda_Principal(inCtx, 0, dblValorPago, IDDocumentoVenda, inCDTotaisMoedaRef)

            AtualizaValorPendente_FROM_NA(inCtx, dblValorPago, IDDocumentoVenda, inCDTotaisMoedaRef)
        End Sub

        ''' <summary>
        ''' funcao que atualiza o valor pendente da fatura principal
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inValorPendente"></param>
        ''' <param name="inID"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <remarks></remarks>
        Private Sub AtualizaValorPendente_FROM_NA(inCtx As BD.Dinamica.Aplicacao, ByVal inValorPendente As Double, inID As Long, ByVal inCDTotaisMoedaRef As Byte)
            Dim DocumentosVendas As New tbDocumentosVendasPendentes

            DocumentosVendas = inCtx.tbDocumentosVendasPendentes.Where(Function(f) f.IDDocumentoVenda = inID).FirstOrDefault()

            With DocumentosVendas
                .ValorPendente = Math.Round(CDbl(.ValorPendente - inValorPendente), inCDTotaisMoedaRef)
                'Dim decValorPendente As Decimal = CDec(.ValorPendente)
                'Dim decResult As Decimal = Math.Round(decValorPendente - inValorPendente, inCDTotaisMoedaRef)
                '.ValorPendente = decResult
            End With

            With inCtx
                .tbDocumentosVendasPendentes.Attach(DocumentosVendas)
                .Entry(DocumentosVendas).[Property](Function(x) x.ValorPendente).IsModified = True
                .SaveChanges()
            End With
        End Sub

        'HERE GENERICO
        Private Function CalculaCambio(ByVal inValorMoedaAConverter As Double, ByVal inTaxaConversao As Double) As Double

            Dim MoedaReferencia As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia
            Return Math.Round(CDbl(inValorMoedaAConverter / inTaxaConversao * MoedaReferencia.TaxaConversao), MoedaReferencia.CasasDecimaisTotais)
        End Function

        'CALCULOS
        Protected Friend Sub Calcula(inObjetoFiltro As ClsF3MFiltro, inModelo As Oticas.PagamentosVendas)
            Dim CasasDecimaisTotais As Byte = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "CasasDecimaisTotais", GetType(Byte))
            Calcula(inObjetoFiltro, inModelo, CasasDecimaisTotais)
        End Sub

        Protected Friend Sub Calcula(inObjetoFiltro As ClsF3MFiltro, inModelo As Oticas.PagamentosVendas, ByVal CasasDecimaisTotais As Byte)
            Dim CampoAlterado As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "CampoAlterado", GetType(String))
            Dim CampoValor As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "CampoValor", GetType(Boolean))
            Dim idLinha As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "idLinha", GetType(Long))

            Dim idFormPag As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "idFormPag", GetType(Long))
            Dim Opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjetoFiltro, "Opcao", GetType(String))

            If inModelo.ListOfPendentes Is Nothing Then
                inModelo.ListOfPendentes = New List(Of DocumentosVendasPendentes)
            End If

            Using rp As New RepositorioFormasPagamento
                inModelo.ListOfFormasPagamento.ForEach(Sub(f)
                                                           f.CodigoSistemaTipoFormaPagamento = rp.GetFormaPagamento(f.IDFormaPagamento).CodigoSistemaTipoFormaPagamento
                                                       End Sub)
            End Using

            Select Case CampoAlterado
                Case "CheckboxHandsontable"
                    inModelo.ListOfPendentes.ForEach(Sub(f)
                                                         f.LinhaSelecionada = CampoValor
                                                         f.ValorPago = If(CampoValor, f.ValorPendente, CDbl(0))
                                                     End Sub)

                Case "LinhaSelecionada"
                    With inModelo.ListOfPendentes.Where(Function(w) w.ID = idLinha).FirstOrDefault()
                        .LinhaSelecionada = CampoValor
                        .ValorPago = If(CampoValor, .ValorPendente, 0)
                    End With

                Case "ValorPago"
                    With inModelo.ListOfPendentes.Where(Function(w) w.ID = idLinha).FirstOrDefault()
                        If .ValorPago <> 0 Then
                            .ValorPago = If(.ValorPago > .ValorPendente, .ValorPendente, .ValorPago)

                        Else
                            If Opcao = Opcao_Pagamentos Then
                                .LinhaSelecionada = False
                            End If
                        End If
                    End With

                Case "FormPag"
                    CalculaFROM_FormaPagamento(inModelo, idFormPag, CasasDecimaisTotais)

                Case "Distribuicao"
                    CalculaFROM_Distribuicao(inModelo, idFormPag, CasasDecimaisTotais)

            End Select

            CalculaTOTAIS(inModelo, CasasDecimaisTotais)
        End Sub

        Private Sub CalculaFROM_FormaPagamento(inModelo As Oticas.PagamentosVendas, ByVal inIdFormPag As Long, inCasasDecimaisTotais As Byte)
            Dim dblTOTAL_A_PAGAR = Math.Round(CDbl(inModelo.ListOfPendentes.Where(Function(w) w.LinhaSelecionada = True).Sum(Function(f) f.ValorPago)), inCasasDecimaisTotais)
            Dim dblTOTAL_ENTREGUE As Double = Math.Round(inModelo.ListOfFormasPagamento.Sum(Function(f) f.Valor), inCasasDecimaisTotais)
            Dim dblTOTAL_ENTREGUE_NAO_NUMERARIO As Double = Math.Round(inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> "NU").Sum(Function(s) s.Valor), inCasasDecimaisTotais)

            Dim PagVendaFormaPag As PagamentosVendasFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.IDFormaPagamento = inIdFormPag).FirstOrDefault()

            If dblTOTAL_A_PAGAR > 0 Then
                If PagVendaFormaPag.CodigoSistemaTipoFormaPagamento <> Numerario Then
                    If dblTOTAL_ENTREGUE_NAO_NUMERARIO >= dblTOTAL_A_PAGAR Then

                        For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = Numerario)
                            lin.Valor = 0
                        Next

                        dblTOTAL_ENTREGUE = Math.Round(inModelo.ListOfFormasPagamento.Sum(Function(f) f.Valor), inCasasDecimaisTotais)
                        Dim dblTOTAL_ENTREGUE_EXCEPTO_FP As Double = Math.Round(dblTOTAL_ENTREGUE - PagVendaFormaPag.Valor, inCasasDecimaisTotais)
                        PagVendaFormaPag.Valor = dblTOTAL_A_PAGAR - dblTOTAL_ENTREGUE_EXCEPTO_FP
                    End If


                ElseIf PagVendaFormaPag.CodigoSistemaTipoFormaPagamento = Numerario Then
                    If dblTOTAL_ENTREGUE_NAO_NUMERARIO >= dblTOTAL_A_PAGAR Then

                        For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = Numerario)
                            lin.Valor = 0
                        Next

                    End If
                End If
            End If
        End Sub

        Private Sub CalculaFROM_Distribuicao(inModelo As Oticas.PagamentosVendas, ByVal inIdFormPag As Long, inCasasDecimaisTotais As Byte)
            Dim dblTOTAL_A_PAGAR As Double = 0
            For Each lin In inModelo.ListOfPendentes.Where(Function(w) w.LinhaSelecionada = True)
                If lin.CodigoSistemaNaturezas = TiposNaturezas.Debito Then
                    dblTOTAL_A_PAGAR = Math.Round(dblTOTAL_A_PAGAR + lin.ValorPago, inCasasDecimaisTotais)

                ElseIf lin.CodigoSistemaNaturezas = TiposNaturezas.Credito Then
                    dblTOTAL_A_PAGAR = Math.Round(dblTOTAL_A_PAGAR - lin.ValorPago, inCasasDecimaisTotais)
                End If
            Next
            If dblTOTAL_A_PAGAR < 0 Then dblTOTAL_A_PAGAR = 0

            Dim dblTOTAL_ENTREGUE As Double = Math.Round(inModelo.ListOfFormasPagamento.Sum(Function(f) f.Valor), inCasasDecimaisTotais)

            If dblTOTAL_ENTREGUE < dblTOTAL_A_PAGAR Then
                Dim PagVendaFormaPag As PagamentosVendasFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.IDFormaPagamento = inIdFormPag).FirstOrDefault()
                Dim dblTOTAL_ENTREGUE_EXCEPTO_FP As Double = Math.Round(dblTOTAL_ENTREGUE - PagVendaFormaPag.Valor, inCasasDecimaisTotais)

                PagVendaFormaPag.Valor = Math.Round(dblTOTAL_A_PAGAR - dblTOTAL_ENTREGUE_EXCEPTO_FP, inCasasDecimaisTotais)
            End If
        End Sub

        Private Sub CalculaTOTAIS(inModelo As Oticas.PagamentosVendas, inCasasDecimaisTotais As Byte)
            Dim dblTotalPagar As Double = 0
            For Each lin In inModelo.ListOfPendentes.Where(Function(w) w.LinhaSelecionada = True)
                If lin.CodigoSistemaNaturezas = TiposNaturezas.Debito Then
                    dblTotalPagar = Math.Round(dblTotalPagar + lin.ValorPago, inCasasDecimaisTotais)

                ElseIf lin.CodigoSistemaNaturezas = TiposNaturezas.Credito Then
                    dblTotalPagar = Math.Round(dblTotalPagar - lin.ValorPago, inCasasDecimaisTotais)
                End If
            Next
            If dblTotalPagar < 0 Then dblTotalPagar = 0

            'T R O C O
            Dim dblTOTAL_NUMERARIO As Double = inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = Numerario).Sum(Function(f) f.Valor)
            Dim dblTOTAL_NAO_NUMERARIO As Double = inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> Numerario).Sum(Function(f) f.Valor)

            If dblTOTAL_NAO_NUMERARIO > dblTotalPagar Then
                dblTOTAL_NAO_NUMERARIO = CDbl(0)
                inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> Numerario).ToList().ForEach(Sub(f)
                                                                                                                                      f.Valor = CDbl(0)
                                                                                                                                  End Sub)
            End If

            inModelo.TotalPagar = dblTotalPagar
            inModelo.ValorEntregue = Math.Round(inModelo.ListOfFormasPagamento.Sum(Function(f) f.Valor), inCasasDecimaisTotais)

            Dim dblTROCO As Double = If((dblTOTAL_NUMERARIO - (inModelo.TotalPagar - dblTOTAL_NAO_NUMERARIO)) < 0, 0, (dblTOTAL_NUMERARIO - (inModelo.TotalPagar - dblTOTAL_NAO_NUMERARIO)))
            inModelo.Troco = Math.Round(dblTROCO, inCasasDecimaisTotais)
        End Sub
        'END CALCULOS

        Private Sub AtualizaPendenteWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByVal IDDocumentoVendaPendente As Long)
            Dim DocVendaPendente As tbDocumentosVendasPendentes = inCtx.tbDocumentosVendasPendentes.Where(Function(f) f.ID = IDDocumentoVendaPendente).FirstOrDefault()

            With DocVendaPendente
                .ValorPendente = CDbl(0)
            End With

            With inCtx
                .tbDocumentosVendasPendentes.Attach(DocVendaPendente)
                .Entry(DocVendaPendente).[Property](Function(x) x.ValorPendente).IsModified = True
                .SaveChanges()
            End With
        End Sub

        Protected Friend Function GetValorPago(IDDocumentoVendaServico As Long) As Double
            Return (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVendaServico Select x.ValorPago).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que valida se estamos a apagar um pagamento dentro dos dias certos
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function ValidaDiasParaAnular(IDPagamentoVenda As Long) As Boolean
            Dim pagamentoVenda As tbPagamentosVendas = BDContexto.tbPagamentosVendas.FirstOrDefault(Function(f) f.ID = IDPagamentoVenda)

            If Not pagamentoVenda Is Nothing Then
                Dim NumDiasAnular As Long = DateDiff("d", CDate(pagamentoVenda.Data.ToShortDateString), DateTime.Now.Date)
                If NumDiasAnular < 0 OrElse NumDiasAnular > ClsF3MSessao.RetornaParametros.NumDiasAnular Then
                    Return False
                End If
            End If

            Return True
        End Function

#Region "NOTAS DE CRÉDITO A DINHEIRO DE ADIANTEMENTOS"
        ''' <summary>
        ''' Funcao que preenche e gera os pagamentos para a ncda
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="GerouNC"></param>
        ''' <param name="IDDocumentoVendaOrigem"></param>
        ''' <param name="inValorNC"></param>
        Protected Friend Sub PreencheGeraPagamentos_NCDA(ctx As BD.Dinamica.Aplicacao,
                                                ByRef inModelo As DocumentosVendas,
                                                ByVal GerouNC As Boolean,
                                                ByVal IDDocumentoVendaOrigem As Long,
                                                ByVal inValorNC As Double)

            'ID DOC VENDA 
            Dim IDDocumentoVenda As Long = inModelo.ID
            'MOEDA DO DOC
            Dim IDMoeda As Long = inModelo.IDMoeda
            Dim Moeda As Moedas = (From x In BDContexto.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .TaxaConversao = x.TaxaConversao, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            'MOEDA REFERENCIA
            Dim MoedaReferencia As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia

            Dim PagamentoVenda As New PagamentosVendas
            With PagamentoVenda
                .Data = DateAndTime.Now()
                .Descricao = Traducao.EstruturaTiposDocumento.Comparticipacao 'Comparticipação
                .IDEntidade = inModelo.IDEntidade
                .IDLoja = inModelo.IDLoja
                .IDMoeda = Moeda.ID
                .TaxaConversao = Moeda.TaxaConversao
                .TotalMoeda = inValorNC
                .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                .TotalPagar = inValorNC
                .Troco = CDbl(0)
                .ValorEntregue = inValorNC
                .CodigoTipoEstado = TiposEstados.Efetivo

                If inModelo.PagamentosVendas IsNot Nothing Then
                    .IDContaCaixa = inModelo.PagamentosVendas.IDContaCaixa
                End If
            End With

            'PENDENTES
            PagamentoVenda.ListOfPendentes = New List(Of DocumentosVendasPendentes)

            Using rp As New RepositorioDocumentosVendasPendentes
                Dim DocVendaPendente As New DocumentosVendasPendentes
                Mapear(inModelo.NotaCredito, DocVendaPendente)

                With DocVendaPendente
                    .ID = DocVendaPendente.ID
                    .IDDocumentoVenda = DocVendaPendente.ID
                    .IDMoeda = Moeda.ID
                    .TaxaConversao = Moeda.TaxaConversao
                    .ValorPendente = inValorNC
                    .ValorPendenteAux = .ValorPendente
                    .ValorPago = .ValorPendente
                    .LinhaSelecionada = True
                    .GereContaCorrente = True
                    .TotalMoedaDocumento = inValorNC
                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                    .CodigoSistemaNaturezas = TiposNaturezas.Credito
                End With

                PagamentoVenda.ListOfPendentes.Add(DocVendaPendente)
            End Using

            'FORMAS DE PAGAMENTO
            Dim PagamentoVendaFormPag As New PagamentosVendasFormasPagamento
            With PagamentoVendaFormPag
                .AcaoCRUD = AcoesFormulario.Adicionar
                .IDFormaPagamento = 1 'HERE FK
                .CodigoSistemaTipoFormaPagamento = "NU" 'HERE FK
                .DescricaoFormaPagamento = "Numerário" 'HERE FK
                .Valor = inValorNC
                .IDDocumentoVenda = IDDocumentoVenda
                .IDPagamentoVenda = PagamentoVenda.ID
                .IDMoeda = Moeda.ID
                .TaxaConversao = Moeda.TaxaConversao
                .TotalMoeda = inValorNC
                .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                .Ordem = 1
            End With
            PagamentoVenda.ListOfFormasPagamento = New List(Of PagamentosVendasFormasPagamento) From {PagamentoVendaFormPag}

            AdicionaPagamento_FROM_NCDA(ctx, PagamentoVenda, inModelo.IDMoeda, IDDocumentoVenda, IDDocumentoVendaOrigem)
        End Sub

        ''' <summary>
        ''' Funcao que preenche e gera os pagamentos para a ncda
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="GerouNC"></param>
        ''' <param name="IDDocumentoVendaOrigem"></param>
        ''' <param name="inValorNC"></param>
        Protected Friend Sub PreencheGeraPagamentos_NCDA_CLI_DIFF(ctx As BD.Dinamica.Aplicacao,
                                                ByRef inModelo As DocumentosVendas,
                                                ByVal GerouNC As Boolean,
                                                ByVal IDDocumentoVendaOrigem As Long,
                                                ByVal inValorNC As Double)

            'ID DOC VENDA 
            Dim IDDocumentoVenda As Long = inModelo.ID
            'MOEDA DO DOC
            Dim IDMoeda As Long = inModelo.IDMoeda
            Dim Moeda As Moedas = (From x In BDContexto.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .TaxaConversao = x.TaxaConversao, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            'MOEDA REFERENCIA
            Dim MoedaReferencia As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia

            Dim PagamentoVenda As New PagamentosVendas
            With PagamentoVenda
                .Data = DateAndTime.Now()
                .Descricao = Traducao.EstruturaTiposDocumento.Comparticipacao 'Comparticipação
                .IDEntidade = inModelo.IDEntidade
                .IDLoja = inModelo.IDLoja
                .IDMoeda = Moeda.ID
                .TaxaConversao = Moeda.TaxaConversao
                .TotalMoeda = inValorNC
                .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                .TotalPagar = inValorNC
                .Troco = CDbl(0)
                .ValorEntregue = inValorNC
                .CodigoTipoEstado = TiposEstados.Efetivo

                If inModelo.PagamentosVendas IsNot Nothing Then
                    .IDContaCaixa = inModelo.PagamentosVendas.IDContaCaixa
                End If
            End With

            'PENDENTES
            PagamentoVenda.ListOfPendentes = New List(Of DocumentosVendasPendentes)

            Using rp As New RepositorioDocumentosVendasPendentes
                Dim DocVendaPendente As New DocumentosVendasPendentes
                Mapear(inModelo.NCDA_CLI_DIFF, DocVendaPendente)

                With DocVendaPendente
                    .ID = DocVendaPendente.ID
                    .IDDocumentoVenda = DocVendaPendente.ID
                    .IDMoeda = Moeda.ID
                    .TaxaConversao = Moeda.TaxaConversao
                    .ValorPendente = inValorNC
                    .ValorPendenteAux = .ValorPendente
                    .ValorPago = .ValorPendente
                    .LinhaSelecionada = True
                    .GereContaCorrente = True
                    .TotalMoedaDocumento = inValorNC
                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                    .CodigoSistemaNaturezas = TiposNaturezas.Credito
                End With

                PagamentoVenda.ListOfPendentes.Add(DocVendaPendente)
            End Using

            'FORMAS DE PAGAMENTO
            Dim PagamentoVendaFormPag As New PagamentosVendasFormasPagamento
            With PagamentoVendaFormPag
                .AcaoCRUD = AcoesFormulario.Adicionar
                .IDFormaPagamento = 1 'HERE FK
                .CodigoSistemaTipoFormaPagamento = "NU" 'HERE FK
                .DescricaoFormaPagamento = "Numerário" 'HERE FK
                .Valor = inValorNC
                .IDDocumentoVenda = IDDocumentoVenda
                .IDPagamentoVenda = PagamentoVenda.ID
                .IDMoeda = Moeda.ID
                .TaxaConversao = Moeda.TaxaConversao
                .TotalMoeda = inValorNC
                .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                .Ordem = 1
            End With
            PagamentoVenda.ListOfFormasPagamento = New List(Of PagamentosVendasFormasPagamento) From {PagamentoVendaFormPag}

            AdicionaPagamento_FROM_NCDA_CLI_DIFF(ctx, PagamentoVenda, inModelo.IDMoeda, IDDocumentoVenda, IDDocumentoVendaOrigem)
        End Sub

        ''' <summary>
        ''' Funcao que grava os pagamentos para a ncda
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="IDMoeda"></param>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <param name="IDDocumentoVendaServico"></param>
        Public Sub AdicionaPagamento_FROM_NCDA(inCtx As BD.Dinamica.Aplicacao,
                                               inModelo As PagamentosVendas,
                                               ByVal IDMoeda As Long,
                                               ByVal IDDocumentoVenda As Long,
                                               ByVal IDDocumentoVendaServico As Long)
            Try
                Dim Moeda As Moedas = inCtx.tbMoedas.Where(Function(w) w.ID = IDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()
                Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais

                GravaPagamentoVendas_FROM_NCDA(inCtx, inModelo, Moeda, CDTotaisMoedaRef, IDDocumentoVenda)

                AtualizaValorPagoDocVenda_Principal_FROM_NCDA(inCtx, IDDocumentoVendaServico)

                GravaDocumentosVendaFormasPagamento_FROM_NCDA(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                AtualizaMapaCaixa(inCtx, inModelo, "documentos")
            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        Public Sub AdicionaPagamento_FROM_NCDA_CLI_DIFF(inCtx As BD.Dinamica.Aplicacao,
                                               inModelo As PagamentosVendas,
                                               ByVal IDMoeda As Long,
                                               ByVal IDDocumentoVenda As Long,
                                               ByVal IDDocumentoVendaServico As Long)
            Try
                Dim Moeda As Moedas = inCtx.tbMoedas.Where(Function(w) w.ID = IDMoeda).Select(Function(f) New Moedas With {.ID = f.ID, .TaxaConversao = f.TaxaConversao, .CasasDecimaisTotais = f.CasasDecimaisTotais}).FirstOrDefault()
                Dim CDTotaisMoedaRef As Byte = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais

                GravaPagamentoVendas_FROM_NCDA(inCtx, inModelo, Moeda, CDTotaisMoedaRef, IDDocumentoVenda)

                GravaDocumentosVendaFormasPagamento_FROM_NCDA(inCtx, inModelo, Moeda, CDTotaisMoedaRef)

                AtualizaMapaCaixa(inCtx, inModelo, "documentos")
            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        ''' <summary>
        ''' Funcao que grava os pagamentos da ncda
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="inMoeda"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        ''' <param name="IDDocumentoVenda"></param>
        Private Sub GravaPagamentoVendas_FROM_NCDA(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas,
                                   ByVal inCDTotaisMoedaRef As Byte, ByVal IDDocumentoVenda As Long)

            Dim intOrdem As Short = 0

            inModelo.ListOfFormasPagamento = inModelo.ListOfFormasPagamento.Where(Function(f) f.Valor > 0).ToList()

            If inCtx.tbPagamentosVendas.Count <> 0 Then
                inModelo.Numero = inCtx.tbPagamentosVendas.Select(Function(f) f.Numero).Max() + 1

            Else
                inModelo.Numero = 1
            End If

            With inModelo
                .ValorEntregue = Math.Round(CDbl(inModelo.ListOfFormasPagamento.Sum(Function(s) s.Valor)), inMoeda.CasasDecimaisTotais)
                .Troco = Math.Round(CDbl(inModelo.ListOfFormasPagamento.Sum(Function(s) s.Valor) - inModelo.TotalMoeda), inMoeda.CasasDecimaisTotais)
            End With

            Dim e As tbPagamentosVendas = GravaObjContexto(inCtx, inModelo, AcoesFormulario.Adicionar)
            inCtx.SaveChanges()
            inModelo.ID = e.ID

            'GRAVA FORMAS DE PAGAMENTO
            For Each lin In inModelo.ListOfFormasPagamento
                Dim PagamentosVendasFormaPagamento As New tbPagamentosVendasFormasPagamento
                Mapear(lin, PagamentosVendasFormaPagamento)

                With PagamentosVendasFormaPagamento
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao

                    intOrdem += 1
                    .Ordem = intOrdem
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasFormasPagamento)(inCtx, PagamentosVendasFormaPagamento, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            Next

            'GRAVA VENDAS LINHAS
            intOrdem = 0
            For Each lin In inModelo.ListOfPendentes
                Dim PagamentoVendasLinha As New tbPagamentosVendasLinhas

                Mapear(lin, PagamentoVendasLinha)

                With PagamentoVendasLinha
                    .ID = 0
                    .IDPagamentoVenda = inModelo.ID
                    .IDMoeda = inMoeda.ID
                    .TaxaConversao = inMoeda.TaxaConversao
                    .TotalMoeda = lin.ValorPago
                    .TotalMoedaReferencia = CalculaCambio(lin.ValorPago, inMoeda.TaxaConversao)
                    intOrdem += 1
                    .Ordem = intOrdem

                    .TotalMoedaDocumento = .TotalMoedaDocumento
                    .ValorPendente = .ValorPendente
                End With

                GravaEntidadeLinha(Of tbPagamentosVendasLinhas)(inCtx, PagamentoVendasLinha, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            Next

            Dim dblValorPago As Double = Math.Round(inModelo.ListOfPendentes.Where(Function(f) f.CodigoSistemaNaturezas = TiposNaturezas.Debito).Sum(Function(f) f.ValorPago), inMoeda.CasasDecimaisTotais)
            AtualizaValorPendente_FROM_NA(inCtx, dblValorPago, IDDocumentoVenda, inCDTotaisMoedaRef)
        End Sub

        ''' <summary>
        ''' Funcao que atualiza o valor pago do servico
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inID"></param>
        Private Sub AtualizaValorPagoDocVenda_Principal_FROM_NCDA(inCtx As BD.Dinamica.Aplicacao, inID As Long)
            Dim DocumentosVendas As New tbDocumentosVendas
            DocumentosVendas = inCtx.tbDocumentosVendas.Where(Function(f) f.ID = inID).FirstOrDefault()

            With DocumentosVendas
                .ValorPago = CDbl(0)
            End With

            With inCtx
                .tbDocumentosVendas.Attach(DocumentosVendas)
                .Entry(DocumentosVendas).[Property](Function(x) x.ValorPago).IsModified = True
                .SaveChanges()
            End With
        End Sub

        ''' <summary>
        ''' Funcao que grava os pagamentos da ncda na  tbDocumentosVendasFormasPagamento
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="inMoeda"></param>
        ''' <param name="inCDTotaisMoedaRef"></param>
        Private Sub GravaDocumentosVendaFormasPagamento_FROM_NCDA(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal inModelo As PagamentosVendas, ByVal inMoeda As Moedas, ByVal inCDTotaisMoedaRef As Byte)
            Dim CasasDecimaisMoeda As Byte = inMoeda.CasasDecimaisTotais
            Dim intOrdem As Short = 0

            If inModelo.ListOfPendentes.Any() Then

                inModelo.ListOfPendentes.ForEach(Sub(f)
                                                     f.ValorEmFaltaAux = f.ValorPago
                                                 End Sub)

                'GRAVA NÃO NUMERARIOS
                Dim valorEntregueAux As Double = 0
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento <> TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    For Each linAux In inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0)
                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)


                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0


                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravaDocs(inCtx, valor, 0, lin, linAux, inMoeda, inCDTotaisMoedaRef, intOrdem)
                    Next
                Next

                'GRAVA NUMERARIOS
                For Each lin In inModelo.ListOfFormasPagamento.Where(Function(f) f.CodigoSistemaTipoFormaPagamento = TiposFormaPagamento.Numerario)
                    valorEntregueAux = lin.Valor

                    Dim ListOfDocumentosVendasPendentes As List(Of DocumentosVendasPendentes) = inModelo.ListOfPendentes.Where(Function(f) f.ValorPago > 0 And f.ValorEmFaltaAux > 0).ToList()
                    Dim count As Integer = ListOfDocumentosVendasPendentes.Count()

                    For i As Integer = 0 To count - 1
                        Dim linAux As DocumentosVendasPendentes = ListOfDocumentosVendasPendentes(i)

                        Dim valorLP As Double = linAux.ValorEmFaltaAux
                        Dim valor As Double = 0

                        Dim troco As Double = 0

                        If valorEntregueAux >= valorLP Then
                            valor = valorLP
                            valorEntregueAux = Math.Round(valorEntregueAux - valorLP, CasasDecimaisMoeda)

                            If i = count - 1 Then
                                troco = valorEntregueAux
                            End If

                        ElseIf valorEntregueAux > 0 Then
                            valor = valorEntregueAux
                            valorEntregueAux = 0

                        ElseIf valorEntregueAux <= 0 Then
                            Exit For
                        End If

                        linAux.ValorEmFaltaAux = Math.Round(linAux.ValorEmFaltaAux - valor, CasasDecimaisMoeda)

                        GravaDocs(inCtx, valor, troco, lin, linAux, inMoeda, inCDTotaisMoedaRef, intOrdem)

                    Next
                Next
            End If
        End Sub

        ''' <summary>
        ''' Funcao que retorna os pagamentos da NCDA
        ''' </summary>
        ''' <param name="IDDocumentoVendaNCDA"></param>
        ''' <returns></returns>
        Protected Friend Function GetIDPagamentoByNCDA(ByVal IDDocumentoVendaNCDA As Long) As Long
            Return GetIDPagamentoByNCDA(BDContexto, IDDocumentoVendaNCDA)
        End Function

        ''' <summary>
        ''' Funcao que retorna os pagamentos da NCDA
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="IDDocumentoVendaNCDA"></param>
        ''' <returns></returns>
        Protected Friend Function GetIDPagamentoByNCDA(ctx As BD.Dinamica.Aplicacao, ByVal IDDocumentoVendaNCDA As Long) As Long
            Return (From x In ctx.tbPagamentosVendasLinhas
                    Where x.IDDocumentoVenda = IDDocumentoVendaNCDA AndAlso
                        x.tbPagamentosVendas.CodigoTipoEstado <> TiposEstados.Anulado
                    Select x.IDPagamentoVenda).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que verifica se o pagamento esta associado a uma FA
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function IsFA(ByVal IDPagamentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbDocumentosVendas
                    Join y In BDContexto.tbPagamentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                    Where y.IDPagamentoVenda = IDPagamentoVenda AndAlso
                                         y.tbPagamentosVendas.CodigoTipoEstado <> TiposEstados.Anulado AndAlso
                                         x.tbTiposDocumento.Adiantamento AndAlso
                                         x.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo).Any()
        End Function

        ''' <summary>
        ''' Funcao que verifique se o pagamento esta associado a uma NCDA
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function IsNCDA(ByVal IDPagamentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbDocumentosVendas
                    Join y In BDContexto.tbPagamentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                    Where y.IDPagamentoVenda = IDPagamentoVenda AndAlso
                                         y.tbPagamentosVendas.CodigoTipoEstado <> TiposEstados.Anulado AndAlso
                                         x.tbTiposDocumento.Adiantamento AndAlso
                                         x.tbTiposDocumento.GereCaixasBancos AndAlso
                                         x.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito).Any()
        End Function

        ''' <summary>
        ''' Funcao que verifica se o documento tem alguma NCDA
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function HasNCDA(ByVal IDPagamentoVenda As Long) As Boolean
            Dim IDNCDA As Long = 0

            Dim IDDocumentoVendaServico As Long? = (From x In BDContexto.tbDocumentosVendasLinhas
                                                    Join y In BDContexto.tbPagamentosVendasLinhas On y.IDDocumentoVenda Equals x.IDDocumentoVenda
                                                    Where y.IDPagamentoVenda = IDPagamentoVenda
                                                    Select x.IDDocumentoOrigem).FirstOrDefault()

            If Not IDDocumentoVendaServico Is Nothing AndAlso IDDocumentoVendaServico <> 0 Then
                Using rpDocumentosVendas As New RepositorioDocumentosVendas
                    IDNCDA = rpDocumentosVendas.GetNCDAByIDDocumentoVendaServico(IDDocumentoVendaServico)
                End Using
            End If

            Return IDNCDA <> 0
        End Function

        Protected Friend Function VerificaPagamentosLinhasNCDA(ByVal IDPagamentoVenda As Long) As Boolean
            Dim linhasPagamentoVendas As List(Of tbPagamentosVendasLinhas) = BDContexto.tbPagamentosVendasLinhas.Where(Function(s) s.IDPagamentoVenda = IDPagamentoVenda).ToList()

            Return linhasPagamentoVendas.
                Any(Function(entity) entity.tbDocumentosVendas.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito OrElse
                Not entity.tbDocumentosVendas.tbTiposDocumento.GeraPendente)
        End Function

        ''' <summary>
        ''' Funcao que retorna todos o documento FR /// FS que está associado à NCDA
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function GetPagamentosParaAnularByNCDA(ByVal IDPagamentoVenda As Long) As tbDocumentosVendas
            Dim IDDocumentoVendaServico As Long? = (From x In BDContexto.tbDocumentosVendasLinhas
                                                    Join y In BDContexto.tbPagamentosVendasLinhas On y.IDDocumentoVenda Equals x.IDDocumentoVenda
                                                    Join z In BDContexto.tbDocumentosVendasLinhas On z.IDDocumentoVenda Equals x.IDDocumentoOrigem
                                                    Where y.IDPagamentoVenda = IDPagamentoVenda
                                                    Select z.IDDocumentoOrigem).FirstOrDefault()

            Dim DocAssociadoNCDA = (From x In BDContexto.tbDocumentosVendas
                                    Join y In BDContexto.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                                    Where y.IDDocumentoOrigem = IDDocumentoVendaServico AndAlso
                                        y.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado AndAlso
                                        Not x.tbTiposDocumento.Adiantamento AndAlso
                                        x.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.NotaCredito
                                    Select x).FirstOrDefault()

            Return DocAssociadoNCDA
        End Function

        ''' <summary>
        ''' Funcao que retorna o servico pelo pagamento
        ''' </summary>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function GetIDDocumentoVendaServicoByIDPagamento(ByVal IDPagamentoVenda As Long) As Long
            Return GetIDDocumentoVendaServicoByIDPagamento(BDContexto, IDPagamentoVenda)
        End Function

        ''' <summary>
        ''' Funcao que retorna o servico pelo pagamento
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <returns></returns>
        Protected Friend Function GetIDDocumentoVendaServicoByIDPagamento(ctx As BD.Dinamica.Aplicacao, ByVal IDPagamentoVenda As Long) As Long
            Return (From x In ctx.tbDocumentosVendasLinhas
                    Join y In ctx.tbPagamentosVendasLinhas On y.IDDocumentoVenda Equals x.IDDocumentoVenda
                    Where y.IDPagamentoVenda = IDPagamentoVenda
                    Select x.IDDocumentoOrigem).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que anula a NCDA
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="IDDocumentoVendaNCDA"></param>
        ''' <param name="IDEstadoAnulado"></param>
        Protected Friend Sub AnulaNCDA(ctx As BD.Dinamica.Aplicacao, IDDocumentoVendaNCDA As Long, IDEstadoAnulado As Long)
            Try
                Dim IDPagamentoVendaNCDA As Long = (From x In ctx.tbPagamentosVendasLinhas
                                                    Where x.IDDocumentoVenda = IDDocumentoVendaNCDA AndAlso
                                                            x.tbPagamentosVendas.CodigoTipoEstado <> TiposEstados.Anulado
                                                    Select x.IDPagamentoVenda).FirstOrDefault()

                Dim PagamentoVenda As PagamentosVendas = GetPagamentoVenda(ctx, IDPagamentoVendaNCDA)

                Dim Moeda As Moedas = (From x In ctx.tbMoedas
                                       Where x.ID = PagamentoVenda.IDMoeda
                                       Select New Moedas With {.ID = x.ID, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

                For Each lin As DocumentosVendasPendentes In PagamentoVenda.ListOfPendentes
                    Dim DocumentoVenda As New tbDocumentosVendas
                    DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = lin.IDDocumentoVenda).FirstOrDefault()

                    With DocumentoVenda
                        .ValorPago = CDbl(0)
                        .IDEstado = IDEstadoAnulado : .CodigoTipoEstado = TiposEstados.Anulado
                        .DataHoraEstado = DateAndTime.Now() : .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                    End With

                    With ctx
                        GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                        .SaveChanges()
                    End With

                    'SPs
                    ctx.sp_AtualizaMapaCaixa(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, 0)
                    ctx.sp_AtualizaCCEntidades(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)

                    'ATUALIZA PENDENTE - ?!
                    Dim DocumentoVendaPendente As New tbDocumentosVendasPendentes
                    DocumentoVendaPendente = (From x In ctx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = lin.IDDocumentoVenda).FirstOrDefault()

                    With DocumentoVendaPendente
                        .ValorPendente = Math.Round(CDbl(.TotalClienteMoedaDocumento), Moeda.CasasDecimaisTotais)
                    End With

                    With ctx
                        GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, DocumentoVendaPendente, AcoesFormulario.Alterar, Nothing)
                        .SaveChanges()
                    End With
                Next

                'ATUALIZA O PAGAMENTO
                Dim tbPagamentoVenda As New tbPagamentosVendas
                tbPagamentoVenda = (From x In ctx.tbPagamentosVendas Where x.ID = IDPagamentoVendaNCDA).FirstOrDefault()

                With tbPagamentoVenda
                    .CodigoTipoEstado = TiposEstados.Anulado
                End With

                With ctx
                    GravaEntidadeLinha(Of tbPagamentosVendas)(ctx, tbPagamentoVenda, AcoesFormulario.Alterar, Nothing)
                    .SaveChanges()
                End With

                'ANULA FAs
                AnulaFAsFromNCDA(ctx, IDDocumentoVendaNCDA, IDEstadoAnulado)

            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        ''' <summary>
        ''' Funcao que anula as FAs associadas à NCDA
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="IDDocumentoVendaNCDA"></param>
        ''' <param name="IDEstadoAnulado"></param>
        Private Sub AnulaFAsFromNCDA(ctx As BD.Dinamica.Aplicacao, IDDocumentoVendaNCDA As Long, IDEstadoAnulado As Long)
            Dim FAs As List(Of tbDocumentosVendas) = (From x In ctx.tbDocumentosVendasLinhas
                                                      Join y In ctx.tbDocumentosVendas On y.ID Equals x.IDDocumentoOrigem
                                                      Where x.IDDocumentoVenda = IDDocumentoVendaNCDA AndAlso
                                                          y.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado AndAlso
                                                          y.tbTiposDocumento.Adiantamento
                                                      Select y).ToList()

            If Not FAs Is Nothing AndAlso FAs.Any() Then
                For Each FA As tbDocumentosVendas In FAs

                    Dim IDPagamentoVendaFA As Long = (From x In ctx.tbPagamentosVendasLinhas
                                                      Where x.IDDocumentoVenda = FA.ID
                                                      Select x.IDPagamentoVenda).FirstOrDefault()

                    If IDPagamentoVendaFA <> 0 Then AnulaPagamentoVenda(ctx, IDPagamentoVendaFA, IDEstadoAnulado)
                Next
            End If
        End Sub

        ''' <summary>
        ''' Funcao que anula a FR /// FS quando tem NCDA
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="IDPagamentoVenda"></param>
        ''' <param name="IDEstadoAnulado"></param>
        Protected Friend Sub AnulaPagamentoVendaWithNCDA(ctx As BD.Dinamica.Aplicacao,
                                                 IDPagamentoVenda As Long,
                                                 IDEstadoAnulado As Long)

            Dim PagamentoVenda As PagamentosVendas = GetPagamentoVenda(ctx, IDPagamentoVenda)

            Dim Moeda As Moedas = (From x In ctx.tbMoedas
                                   Where x.ID = PagamentoVenda.IDMoeda
                                   Select New Moedas With {.ID = x.ID, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            For Each lin In PagamentoVenda.ListOfPendentes
                Dim DocumentoVenda As New tbDocumentosVendas
                Dim dblValorJaPago As Nullable(Of Double) = 0
                Dim E_NA As Boolean = False

                DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = lin.IDDocumentoVenda).FirstOrDefault()

                Dim IDDocumentoOrigem As Nullable(Of Long) = (From x In ctx.tbDocumentosVendasLinhas Where x.IDDocumentoVenda = DocumentoVenda.ID).FirstOrDefault().IDDocumentoOrigem

                dblValorJaPago = (From x In ctx.tbPagamentosVendasLinhas
                                  Join y In ctx.tbPagamentosVendas On y.ID Equals x.IDPagamentoVenda
                                  Join z In ctx.tbDocumentosVendasLinhas On z.IDDocumentoVenda Equals x.IDDocumentoVenda
                                  Where z.IDDocumentoOrigem = IDDocumentoOrigem AndAlso
                                              x.IDPagamentoVenda <> IDPagamentoVenda AndAlso
                                              y.CodigoTipoEstado <> TiposEstados.Anulado
                                  Select x Distinct).Sum(Function(s) s.ValorPago)

                If dblValorJaPago Is Nothing Then dblValorJaPago = CDbl(0)

                With DocumentoVenda
                    .ValorPago = 0
                    .IDEstado = IDEstadoAnulado
                    .CodigoTipoEstado = TiposEstados.Anulado
                    .DataHoraEstado = DateAndTime.Now()
                    .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome
                End With

                With ctx
                    GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                    .SaveChanges()
                    .sp_AtualizaMapaCaixa(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, 0)
                    .sp_AtualizaCCEntidades(DocumentoVenda.ID, DocumentoVenda.IDTipoDocumento, AcoesFormulario.Remover, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, DocumentoVenda.IDEntidade)
                End With

                If DocumentoVenda.tbTiposDocumento.GereStock AndAlso DocumentoVenda.tbTiposDocumento.GeraPendente = False Then
                    With DocumentoVenda
                        ctx.sp_AtualizaStock(.ID, .IDTipoDocumento, AcoesFormulario.Remover, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, True, False)
                    End With
                End If

                DocumentoVenda = (From x In ctx.tbDocumentosVendas Where x.ID = IDDocumentoOrigem).FirstOrDefault()
                With DocumentoVenda
                    .ValorPago = dblValorJaPago
                End With

                With ctx
                    GravaEntidadeLinha(Of tbDocumentosVendas)(ctx, DocumentoVenda, AcoesFormulario.Alterar, Nothing)
                    .SaveChanges()
                End With

                'ATUALIZA O PENDENTE
                Dim DocumentoVendaPendente As New tbDocumentosVendasPendentes
                DocumentoVendaPendente = (From x In ctx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = lin.IDDocumentoVenda).FirstOrDefault()

                With DocumentoVendaPendente
                    .ValorPendente = Math.Round(CDbl(.TotalClienteMoedaDocumento), Moeda.CasasDecimaisTotais)
                End With

                With ctx
                    GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(ctx, DocumentoVendaPendente, AcoesFormulario.Alterar, Nothing)
                    .SaveChanges()
                End With
            Next

            'ATUALIZA O PAGAMENTO
            Dim tbPagamentoVenda As New tbPagamentosVendas
            tbPagamentoVenda = (From x In ctx.tbPagamentosVendas Where x.ID = IDPagamentoVenda).FirstOrDefault()

            With tbPagamentoVenda
                .CodigoTipoEstado = TiposEstados.Anulado
            End With

            With ctx
                GravaEntidadeLinha(Of tbPagamentosVendas)(ctx, tbPagamentoVenda, AcoesFormulario.Alterar, Nothing)
                .SaveChanges()
            End With
        End Sub
#End Region

        Public Sub PreencheCaixaPorDefeito(ByRef pagamento As PagamentosVendas)
            Dim idContaCaixa As Long = 0

            Dim idUtilizador As Long = ClsF3MSessao.RetornaUtilizadorID()
            Dim idLoja As Long = ClsF3MSessao.RetornaLojaID()

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryCaixaUtilizador As String = "SELECT IDContaCaixa FROM tbUtilizadoresContaCaixa WHERE IDUtilizador = @idUtilizador AND IDLoja = @idLoja"

                idContaCaixa = ctxGeral.Database _
                    .SqlQuery(Of Long)(queryCaixaUtilizador, {
                        New SqlParameter("@idUtilizador", idUtilizador),
                        New SqlParameter("@idLoja", idLoja)
                    }) _
                    .FirstOrDefault
            End Using

            Dim contaCaixa As tbContasCaixa = Nothing

            If idContaCaixa > 0 Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.ID = idContaCaixa AndAlso cc.Ativo)
            End If

            If contaCaixa Is Nothing Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.IDLoja = idLoja AndAlso cc.PorDefeito AndAlso cc.Ativo)
            End If

            If contaCaixa IsNot Nothing Then
                pagamento.IDContaCaixa = contaCaixa.ID
                pagamento.DescricaoContaCaixa = contaCaixa.Descricao
            End If
        End Sub

        Public Sub SetDefaultBox(ByRef payment As Payments)
            Dim idContaCaixa As Long = 0

            Dim idUtilizador As Long = ClsF3MSessao.RetornaUtilizadorID()
            Dim idLoja As Long = ClsF3MSessao.RetornaLojaID()

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryCaixaUtilizador As String = "SELECT IDContaCaixa FROM tbUtilizadoresContaCaixa WHERE IDUtilizador = @idUtilizador AND IDLoja = @idLoja"

                idContaCaixa = ctxGeral.Database _
                    .SqlQuery(Of Long)(queryCaixaUtilizador, {
                        New SqlParameter("@idUtilizador", idUtilizador),
                        New SqlParameter("@idLoja", idLoja)
                    }) _
                    .FirstOrDefault
            End Using

            Dim contaCaixa As tbContasCaixa = Nothing

            If idContaCaixa > 0 Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.ID = idContaCaixa AndAlso cc.Ativo)
            End If

            If contaCaixa Is Nothing Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.IDLoja = idLoja AndAlso cc.PorDefeito AndAlso cc.Ativo)
            End If

            If contaCaixa IsNot Nothing Then
                payment.IDContaCaixa = contaCaixa.ID
                payment.DescricaoContaCaixa = contaCaixa.Descricao
            End If
        End Sub

        Public Function UtilizadorPodeAlterarCaixa() As Boolean
            Dim podeAlterarCaixa As Boolean = False
            Dim idUtilizador = ClsF3MSessao.RetornaUtilizadorID()

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryPodeAlterarCaixa As String = "SELECT PodeAlterarCaixa FROM tbUtilizadores WHERE ID = @idUtilizador"

                podeAlterarCaixa =
                    ctxGeral.Database _
                        .SqlQuery(Of Boolean)(queryPodeAlterarCaixa, New SqlParameter("@idUtilizador", idUtilizador)) _
                        .FirstOrDefault
            End Using

            Return podeAlterarCaixa
        End Function
    End Class
End Namespace