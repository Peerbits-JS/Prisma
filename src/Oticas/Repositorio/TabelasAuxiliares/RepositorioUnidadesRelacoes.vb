﻿Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioUnidadesRelacoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbUnidadesRelacoes, UnidadesRelacoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbUnidadesRelacoes)) As IQueryable(Of UnidadesRelacoes)
            Return query.Select(Function(e) New UnidadesRelacoes With {
                .ID = e.ID, .IDUnidade = e.IDUnidade, .DescricaoUnidade = e.tbUnidades.Descricao,
                .IDUnidadeConversao = e.IDUnidadeConversao, .DescricaoUnidadeConversao = e.tbUnidades1.Descricao,
                .FatorConversao = e.FatorConversao, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao,
                .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbUnidadesRelacoes)) As IQueryable(Of UnidadesRelacoes)
            Return query.Select(Function(e) New UnidadesRelacoes With {
                .ID = e.ID, .DescricaoUnidade = e.tbUnidades.Descricao, .DescricaoUnidadeConversao = e.tbUnidades1.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of UnidadesRelacoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of UnidadesRelacoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbUnidadesRelacoes)
            Dim query As IQueryable(Of tbUnidadesRelacoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.tbUnidades.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace