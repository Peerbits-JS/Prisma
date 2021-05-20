Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Autenticacao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMapaCaixa
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbMapaCaixa, MapaCaixa)

        Sub New()
            MyBase.New()
        End Sub


        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMapaCaixa)) As IQueryable(Of MapaCaixa)
            Return query.Select(Function(e) New MapaCaixa With {
                .ID = e.ID, .Descricao = e.Descricao, .DataDocumento = e.DataDocumento, .IDDocumento = e.IDDocumento, .IDFormaPagamento = e.IDFormaPagamento,
                .IDTipoDocumento = e.IDTipoDocumento, .IDLoja = e.IDLoja, .IDMoeda = e.IDMoeda, .IDTipoDocumentoSeries = e.IDTipoDocumentoSeries,
                .DescricaoFormaPagamento = e.DescricaoFormaPagamento, .Natureza = e.Natureza, .NumeroDocumento = e.NumeroDocumento, .TaxaConversao = e.TaxaConversao,
                .TotalMoeda = e.TotalMoeda, .TotalMoedaReferencia = e.TotalMoedaReferencia, .Valor = e.Valor, .ValorEntregue = e.ValorEntregue, .Troco = e.Troco,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMapaCaixa)) As IQueryable(Of MapaCaixa)
            Return ListaCamposTodos(query).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MapaCaixa)
            Dim filtroTxt As String = inFiltro.FiltroTexto

            Dim query As IQueryable(Of MapaCaixa) = AplicaQueryListaPersonalizada(inFiltro)

            query = query.Where(Function(w) w.NumeroDocumento IsNot Nothing AndAlso Not w.NumeroDocumento.Contains("SI_") AndAlso Not w.NumeroDocumento.Contains("SF_"))

            Return query
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MapaCaixa)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
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


        Public Function CaixaAberta(inData As Date, ByVal idContaCaixa As Long) As Boolean
            Try
                Dim idLoja As Long = ClsF3MSessao.RetornaLojaID

                Return BDContexto.tbMapaCaixa _
                    .Where(Function(mc) inData >= mc.DataDocumento AndAlso mc.IDLoja = idLoja AndAlso mc.IDContaCaixa = idContaCaixa AndAlso (mc.NumeroDocumento.Contains("SI") OrElse mc.NumeroDocumento.Contains("SF"))) _
                    .OrderByDescending(Function(o) o.ID).FirstOrDefault?.NumeroDocumento.Contains("SI")
            Catch ex As Exception
                Return False
            End Try
        End Function

    End Class
End Namespace