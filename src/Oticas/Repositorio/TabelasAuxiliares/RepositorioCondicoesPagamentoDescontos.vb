Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCondicoesPagamentoDescontos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamentoDescontos, CondicoesPagamentoDescontos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCondicoesPagamentoDescontos)) As IQueryable(Of CondicoesPagamentoDescontos)
            Return query.Select(Function(e) New CondicoesPagamentoDescontos With {
                .ID = e.ID, .IDCondicaoPagamento = e.IDCondicaoPagamento, .IDTipoEntidade = e.IDTipoEntidade, .DescricaoTipoEntidade = e.tbSistemaTiposEntidade.Tipo,
                .DescricaoCondicaoPagamento = e.tbCondicoesPagamento.Descricao, .AteXDiasAposEmissao = e.AteXDiasAposEmissao, .Desconto = e.Desconto,
                .Ordem = e.Ordem, .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCondicoesPagamentoDescontos)) As IQueryable(Of CondicoesPagamentoDescontos)
            Return query.Select(Function(e) New CondicoesPagamentoDescontos With {
                .ID = e.ID, .AteXDiasAposEmissao = e.AteXDiasAposEmissao, .Desconto = e.Desconto
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamentoDescontos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamentoDescontos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCondicoesPagamentoDescontos)
            Dim query As IQueryable(Of tbCondicoesPagamentoDescontos) = tabela.AsNoTracking

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            Dim IDCP As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDCondicaoPagamento, GetType(Long))

            query = query.Where(Function(o) o.IDCondicaoPagamento = IDCP).OrderBy(Function(o) o.Ordem)


            '----ESPECIFICO-----
            Dim tipoEnt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoEntidade, GetType(Long))

            'If tipoEnt > 0 Then
            'query = query.Where(Function(w) w.IDTipoEntidade.Equals(tipoEnt))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace