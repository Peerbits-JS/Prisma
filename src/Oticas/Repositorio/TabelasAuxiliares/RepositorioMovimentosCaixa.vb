Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao
Imports System.Data.Entity
Imports System.Data.SqlClient
Imports Kendo.Mvc

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMovimentosCaixa
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbMapaCaixa, MovimentosCaixa)

        Sub New()
            MyBase.New()
        End Sub


        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMapaCaixa)) As IQueryable(Of MovimentosCaixa)
            Return query.Select(Function(e) New MovimentosCaixa With {
                .ID = e.ID, .Descricao = e.Descricao, .DataDocumento = e.DataDocumento, .IDDocumento = e.IDDocumento, .IDFormaPagamento = e.IDFormaPagamento,
                .IDContaCaixa = e.IDContaCaixa, .DescricaoContaCaixa = e.tbContasCaixa.Descricao,
                .IDTipoDocumento = e.IDTipoDocumento, .IDLoja = e.IDLoja, .IDMoeda = e.IDMoeda, .IDTipoDocumentoSeries = e.IDTipoDocumentoSeries,
                .DescricaoFormaPagamento = e.DescricaoFormaPagamento, .Natureza = e.Natureza, .NumeroDocumento = e.NumeroDocumento, .TaxaConversao = e.TaxaConversao,
                .TotalMoeda = e.TotalMoeda, .TotalMoedaReferencia = e.TotalMoedaReferencia, .Valor = e.Valor, .ValorEntregue = e.ValorEntregue, .Troco = e.Troco,
                .IDSistemaNaturezas = If(e.Natureza = TiposNaturezas.Credito, 17, 18), .DescricaoSistemaNaturezas = If(e.Natureza = TiposNaturezas.Credito, "Entrada", "Saída"),
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .VerificaCaixaAberta = True,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMapaCaixa)) As IQueryable(Of MovimentosCaixa)
            Return ListaCamposTodos(query).Take(TamanhoDados.NumeroMaximo)
        End Function

        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MovimentosCaixa)
            Dim filtroTxt As String = inFiltro.FiltroTexto

            Dim query As IQueryable(Of MovimentosCaixa) = AplicaQueryListaPersonalizada(inFiltro)

            query = query.Where(Function(w) w.NumeroDocumento IsNot Nothing AndAlso Not w.NumeroDocumento.Contains("SI_") AndAlso Not w.NumeroDocumento.Contains("SF_"))

            Return query
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MovimentosCaixa)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Overrides Function GridDataFilters(objFiltro As ClsF3MFiltro) As List(Of IFilterDescriptor)
            Dim lstFiltros As New List(Of IFilterDescriptor)

            Dim podeVerDocsLojas = ClsF3MSessao.TemAcessoPorDescricao(AcoesFormulario.Consultar, "DocumentosOutrasLojas", True)

            If Not podeVerDocsLojas Then
                Dim idLoja As String = ClsF3MSessao.RetornaLojaID

                lstFiltros.Add(New FilterDescriptor With {
                    .Member = "IDLoja",
                    .Value = idLoja
                })
            End If

            Return lstFiltros
        End Function

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMapaCaixa)
            Dim query As IQueryable(Of tbMapaCaixa) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            query = query.Where(Function(w) w.NumeroDocumento IsNot Nothing AndAlso Not w.NumeroDocumento.Contains("SI_") AndAlso Not w.NumeroDocumento.Contains("SF_"))

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

        Public Overrides Sub AdicionaObj(ByRef o As MovimentosCaixa, inFiltro As ClsF3MFiltro)
            If Not o.IDContaCaixa > 0 Then
                Throw New Exception(OticasTraducao.Estrutura.ObrigatorioSelecionarCaixa)
            End If

            Dim lngIDFpag As Long = o.IDFormaPagamento
            Dim FormaPagamento As tbFormasPagamento = (From x In BDContexto.tbFormasPagamento Where x.ID = lngIDFpag).FirstOrDefault()

            With o
                .IDMoeda = ClsF3MSessao.RetornaParametros.MoedaReferencia.ID
                .TaxaConversao = ClsF3MSessao.RetornaParametros.MoedaReferencia.TaxaConversao
                .IDLoja = ClsF3MSessao.RetornaLojaID
                .Natureza = o.Natureza
                .NumeroDocumento = String.Empty
                .TotalMoeda = o.Valor
                .TotalMoedaReferencia = o.Valor
                .ValorEntregue = o.Valor
                .Troco = 0
                .DescricaoFormaPagamento = FormaPagamento.Descricao
            End With

            Dim entidade As tbMapaCaixa = Nothing
            entidade = GravaObjContexto(BDContexto, o, AcoesFormulario.Adicionar)

            Dim dtNow = DateAndTime.Now()
            entidade.DataCriacao = New DateTime(o.DataDocumento.Value.Year,
                                                o.DataDocumento.Value.Month,
                                                o.DataDocumento.Value.Day,
                                                dtNow.Hour,
                                                dtNow.Minute,
                                                dtNow.Second)
            BDContexto.SaveChanges()
        End Sub

        Public Overrides Sub EditaObj(ByRef o As MovimentosCaixa, inFiltro As ClsF3MFiltro)
            Dim lngIDFpag As Long = o.IDFormaPagamento
            Dim FormaPagamento As tbFormasPagamento = (From x In BDContexto.tbFormasPagamento Where x.ID = lngIDFpag).FirstOrDefault()

            With o
                .IDMoeda = ClsF3MSessao.RetornaParametros.MoedaReferencia.ID
                .TaxaConversao = ClsF3MSessao.RetornaParametros.MoedaReferencia.TaxaConversao
                .IDLoja = o.IDLoja
                .Descricao = o.Descricao
                .Natureza = o.Natureza
                .TotalMoeda = o.Valor
                .TotalMoedaReferencia = o.Valor
                .ValorEntregue = o.Valor
                .Troco = 0
                .DescricaoFormaPagamento = FormaPagamento.Descricao

                Dim dtNow = DateAndTime.Now()
                .DataCriacao = New DateTime(.DataDocumento.Value.Year,
                                            .DataDocumento.Value.Month,
                                            .DataDocumento.Value.Day,
                                            dtNow.Hour,
                                            dtNow.Minute,
                                            dtNow.Second)
            End With

            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        Public Overrides Sub RemoveObj(ByRef o As MovimentosCaixa, inFiltro As ClsF3MFiltro)
            Dim lngIDFpag As Long = o.IDFormaPagamento
            Dim FormaPagamento As tbFormasPagamento = (From x In BDContexto.tbFormasPagamento Where x.ID = lngIDFpag).FirstOrDefault()

            With o
                If .IDDocumento IsNot Nothing Then
                    Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.RegistoNaoPodeSerRemovido) 'Este registo não pode ser removido.
                End If
            End With

            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub


        Public Sub PreencheCaixaPorDefeito(ByRef movimentoCaixa As MovimentosCaixa)
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
                movimentoCaixa.IDContaCaixa = contaCaixa.ID
                movimentoCaixa.DescricaoContaCaixa = contaCaixa.Descricao
            End If
        End Sub

        Public Function CaixaEstaAberta(inData As Date, idContaCaixa As Long) As Boolean
            Dim idLoja As Long = ClsF3MSessao.RetornaLojaID

            Return BDContexto.tbMapaCaixa.
                Where(Function(f) inData = f.DataDocumento AndAlso
                      f.IDLoja = idLoja AndAlso
                      f.IDContaCaixa = idContaCaixa AndAlso
                      Not String.IsNullOrEmpty(f.NumeroDocumento) AndAlso
                      f.NumeroDocumento.Contains("SI") AndAlso
                      Not f.NumeroDocumento.Contains("SF")).Any()
        End Function

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