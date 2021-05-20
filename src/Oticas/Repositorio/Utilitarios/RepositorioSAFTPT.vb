Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Utilitarios
    Public Class RepositorioSAFTPT
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSAFT, Oticas.SAFTPT)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSAFT)) As IQueryable(Of SAFTPT)
            Return query.Select(Function(e) New SAFTPT With {
                .ID = e.ID, .Ficheiro = e.Ficheiro, .Caminho = e.Caminho, .Versao = e.Versao, .DataInicio = e.DataInicio,
                .DataFim = e.DataFim, .FacturacaoMensal = e.FacturacaoMensal,
                .TipoSAFT = e.TipoSAFT, .IDLoja = e.IDLoja, .DescricaoLoja = If(e.tbLojas IsNot Nothing, e.tbLojas.Descricao, String.Empty),
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSAFT)) As IQueryable(Of SAFTPT)
            Return query.Select(Function(e) New SAFTPT With {
                .ID = e.ID, .Ficheiro = e.Ficheiro, .TipoSAFT = e.TipoSAFT, .IDLoja = e.IDLoja, .DescricaoLoja = If(e.tbLojas IsNot Nothing, e.tbLojas.Descricao, String.Empty)})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SAFTPT)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SAFTPT)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSAFT)
            Dim query As IQueryable(Of tbSAFT) = tabela.AsNoTracking

            Dim tiposaft As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TipoSAFT", GetType(Long))

            ' COMBO (GENERICO)
            If Not ClsTexto.ENuloOuVazio(inFiltro.FiltroTexto) Then
                query = query.Where(Function(o) o.Ficheiro.Contains(inFiltro.FiltroTexto))
            End If

            If tiposaft > 0 Then
                query = query.Where(Function(o) o.TipoSAFT = tiposaft)
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNCOES AUXILIARES"
        Protected Friend Function GetFiscalSaleDocuments(ctx As BD.Dinamica.Aplicacao, model As F3M.SAFT) As List(Of tbDocumentosVendas)
            Dim dataFim As Date = CDate(model.DataFim).AddDays(1)
            Dim arrayOfLojas As List(Of Long) = GetStores(model)

            Dim saleDocuments As IQueryable(Of tbDocumentosVendas) = ctx.
                tbDocumentosVendas.
                AsNoTracking().
                Include("tbTiposDocumento.tbSistemaTiposDocumento").
                Include("tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem").
                Include("tbClientes.tbClientesMoradas").
                Include("tbTiposDocumento.tbSistemaTiposDocumentoFiscal").
                Include("tbTiposDocumento.tbSistemaNaturezas").
                Include("tbDocumentosVendasLinhas.tbSistemaTiposIVA").
                Include("tbDocumentosVendasLinhas.tbArtigos.tbTiposArtigos.tbSistemaClassificacoesTiposArtigosGeral").
                Include("tbDocumentosVendasFormasPagamento.tbFormasPagamento").
                Where(Function(w) w.IDTemp Is Nothing AndAlso w.AcaoTemp <> 1 AndAlso
                w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                (w.CodigoTipoEstado = TiposEstados.Efetivo OrElse w.CodigoTipoEstado = TiposEstados.Anulado)).
                AsQueryable()

            If (Not arrayOfLojas Is Nothing AndAlso arrayOfLojas.Any()) Then
                saleDocuments = saleDocuments.Where(Function(w) arrayOfLojas.Contains(w.IDLoja))
            End If

            saleDocuments = saleDocuments.
            Where(Function(w) (w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.EsteSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.OutroSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Reposicao OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Manual) AndAlso
                w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                w.tbTiposDocumento.tbSistemaTiposDocumento.TipoFiscal AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaProforma AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NaoFiscal AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasTransporte)

            Return saleDocuments.ToList()

        End Function
        Protected Friend Function GetSaleDocuments(ctx As BD.Dinamica.Aplicacao, model As F3M.SAFT) As List(Of tbDocumentosVendas)
            Dim dataFim As Date = CDate(model.DataFim).AddDays(1)
            Dim arrayOfLojas As List(Of Long) = GetStores(model)

            Dim saleDocuments As IQueryable(Of tbDocumentosVendas) = ctx.
                tbDocumentosVendas.
                AsNoTracking().
                Include("tbTiposDocumento.tbSistemaTiposDocumento").
                Include("tbTiposDocumento.tbSistemaTiposDocumentoFiscal").
                Include("tbTiposDocumento.tbSistemaNaturezas").
                Include("tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem").
                Include("tbClientes.tbClientesMoradas").
                Include("tbDocumentosVendasLinhas.tbSistemaTiposIVA").
                Include("tbDocumentosVendasLinhas.tbArtigos.tbTiposArtigos.tbSistemaClassificacoesTiposArtigosGeral").
                Include("tbDocumentosVendasFormasPagamento.tbFormasPagamento").
                Where(Function(w) w.IDTemp Is Nothing AndAlso w.AcaoTemp <> 1 AndAlso
                w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                (w.CodigoTipoEstado = TiposEstados.Efetivo OrElse w.CodigoTipoEstado = TiposEstados.Anulado)).
                AsQueryable()

            If (Not arrayOfLojas Is Nothing AndAlso arrayOfLojas.Any()) Then
                saleDocuments = saleDocuments.Where(Function(w) arrayOfLojas.Contains(w.IDLoja))
            End If

            saleDocuments = saleDocuments.
            Where(Function(w) (w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.EsteSistema OrElse
            w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Reposicao OrElse
            w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.OutroSistema OrElse
            w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Manual) AndAlso
            w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
            (w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasOrcamento OrElse
            w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasEncomenda OrElse
            (w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso
            w.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaProforma)))

            Return saleDocuments.ToList()
        End Function

        Protected Friend Function GetStockDocuments(ctx As BD.Dinamica.Aplicacao, model As F3M.SAFT) As List(Of tbDocumentosStock)
            Dim dataFim As Date = CDate(model.DataFim).AddDays(1)
            Dim arrayOfLojas As List(Of Long) = GetStores(model)

            Dim stockDocuments As IQueryable(Of tbDocumentosStock) = ctx.
                tbDocumentosStock.
                AsNoTracking().
                Include("tbTiposDocumento.tbSistemaTiposDocumento").
                Include("tbTiposDocumento.tbSistemaTiposDocumentoFiscal").
                Include("tbTiposDocumento.tbSistemaNaturezas").
                Include("tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem").
                Include("tbClientes.tbClientesMoradas").
                Include("tbDocumentosStockLinhas.tbSistemaTiposIVA").
                Include("tbDocumentosStockLinhas.tbArtigos.tbTiposArtigos.tbSistemaClassificacoesTiposArtigosGeral").
                Where(Function(w) w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                (w.CodigoTipoEstado = TiposEstados.Efetivo OrElse w.CodigoTipoEstado = TiposEstados.Anulado)).
                AsQueryable()

            If (Not arrayOfLojas Is Nothing AndAlso arrayOfLojas.Any()) Then
                stockDocuments = stockDocuments.Where(Function(w) arrayOfLojas.Contains(w.IDLoja))
            End If

            stockDocuments = stockDocuments.
                Where(Function(w) (w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.EsteSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.OutroSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Reposicao OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Manual) AndAlso
                w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                w.tbTiposDocumento.AcompanhaBensCirculacao)

            Return stockDocuments.ToList()
        End Function

        Protected Friend Function GetPurchaseDocuments(ctx As BD.Dinamica.Aplicacao, model As F3M.SAFT) As List(Of tbDocumentosCompras)
            Dim dataFim As Date = CDate(model.DataFim).AddDays(1)
            Dim arrayOfLojas As List(Of Long) = GetStores(model)

            Dim purchaseDocuments As IQueryable(Of tbDocumentosCompras) = ctx.
                tbDocumentosCompras.
                AsNoTracking().
                Include("tbTiposDocumento.tbSistemaTiposDocumento").
                Include("tbTiposDocumento.tbSistemaTiposDocumentoFiscal").
                Include("tbTiposDocumento.tbSistemaNaturezas").
                Include("tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem").
                Include("tbFornecedores.tbFornecedoresMoradas").
                Include("tbDocumentosComprasLinhas.tbSistemaTiposIVA").
                Include("tbDocumentosComprasLinhas.tbArtigos.tbTiposArtigos.tbSistemaClassificacoesTiposArtigosGeral").
                Where(Function(w) w.IDTemp Is Nothing AndAlso w.AcaoTemp <> 1 AndAlso
                w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                (w.CodigoTipoEstado = TiposEstados.Efetivo OrElse w.CodigoTipoEstado = TiposEstados.Anulado)).
                AsQueryable()

            If (Not arrayOfLojas Is Nothing AndAlso arrayOfLojas.Any()) Then
                purchaseDocuments = purchaseDocuments.Where(Function(w) arrayOfLojas.Contains(w.IDLoja))
            End If

            purchaseDocuments = purchaseDocuments.
                Where(Function(w) (w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.EsteSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.OutroSistema OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Reposicao OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo = TiposDocumentosOrigem.Manual) AndAlso
                w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                w.tbTiposDocumento.AcompanhaBensCirculacao)

            Return purchaseDocuments.ToList()
        End Function

        Protected Friend Function GetPayments(ctx As BD.Dinamica.Aplicacao, model As F3M.SAFT) As List(Of tbRecibos)
            Dim dataFim As Date = CDate(model.DataFim).AddDays(1)
            Dim arrayOfLojas As List(Of Long) = GetStores(model)

            Dim payments As IQueryable(Of tbRecibos) = ctx.
                tbRecibos.
                AsNoTracking().
                Include("tbTiposDocumento.tbSistemaTiposDocumento").
                Include("tbTiposDocumento.tbSistemaTiposDocumentoFiscal").
                Include("tbTiposDocumento.tbSistemaNaturezas").
                Include("tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem").
                Include("tbClientes.tbClientesMoradas").
                Include("tbRecibosLinhas.tbTiposDocumento.tbSistemaNaturezas").
                Include("tbRecibosFormasPagamento.tbFormasPagamento").
                Include("tbRecibosLinhas.tbRecibosLinhasTaxas").
                Where(Function(w) w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                (w.CodigoTipoEstado = TiposEstados.Efetivo OrElse w.CodigoTipoEstado = TiposEstados.Anulado)).
                AsQueryable()

            If (Not arrayOfLojas Is Nothing AndAlso arrayOfLojas.Any()) Then
                payments = payments.Where(Function(w) arrayOfLojas.Contains(w.IDLoja))
            End If

            payments = payments.
                Where(Function(w) (w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo.Equals(TiposDocumentosOrigem.EsteSistema) OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo.Equals(TiposDocumentosOrigem.OutroSistema) OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo.Equals(TiposDocumentosOrigem.Reposicao) OrElse
                w.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo.Equals(TiposDocumentosOrigem.Manual)) AndAlso
                (w.CodigoTipoEstado.Equals(TiposEstados.Efetivo) Or w.CodigoTipoEstado.Equals(TiposEstados.Anulado)) AndAlso
                w.DataDocumento >= model.DataInicio AndAlso w.DataDocumento < dataFim AndAlso
                w.tbTiposDocumento.IDSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                w.tbTiposDocumento.tbSistemaTiposDocumento.TipoFiscal AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo.Equals(TiposDocumentosFiscal.FaturaProforma) AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo.Equals(TiposDocumentosFiscal.NaoFiscal) AndAlso
                Not w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo.Equals(TiposSistemaTiposDocumento.VendasTransporte))

            Return payments.ToList()
        End Function

        Private Function GetStores(model As F3M.SAFT) As List(Of Long)
            Dim arrayOfLojas As New List(Of Long)

            If model.IDLoja IsNot Nothing Then
                arrayOfLojas.Add(model.IDLoja)

            ElseIf model.ListaLojas IsNot Nothing Then
                arrayOfLojas.AddRange(model.ListaLojas)
            End If

            Return arrayOfLojas
        End Function
#End Region
    End Class
End Namespace