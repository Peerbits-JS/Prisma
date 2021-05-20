Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCondicoesPagamentoIdiomas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamentoIdiomas, CondicoesPagamentoIdiomas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCondicoesPagamentoIdiomas)) As IQueryable(Of CondicoesPagamentoIdiomas)
            Return query.Select(Function(e) New CondicoesPagamentoIdiomas With {
                .ID = e.ID, .IDCondicaoPagamento = e.IDCondicaoPagamento, .DescricaoCondicaoPagamento = e.tbCondicoesPagamento.Descricao,
                .IDIdioma = e.tbIdiomas.ID, .DescricaoIdioma = e.tbIdiomas.Descricao,
                .Descricao = e.Descricao,
                .Ativo = e.Ativo, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCondicoesPagamentoIdiomas)) As IQueryable(Of CondicoesPagamentoIdiomas)
            Return query.Select(Function(e) New CondicoesPagamentoIdiomas With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamentoIdiomas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamentoIdiomas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCondicoesPagamentoIdiomas)
            Dim query As IQueryable(Of tbCondicoesPagamentoIdiomas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDCP As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDCondicaoPagamento, GetType(Long))

            query = query.Where(Function(o) o.IDCondicaoPagamento = IDCP).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace