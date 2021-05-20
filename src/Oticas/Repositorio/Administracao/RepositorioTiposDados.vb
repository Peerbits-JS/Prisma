Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports F3M.Modelos.Autenticacao

Namespace Repositorio.Administracao
    Public Class RepositorioTiposDados
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbTiposDados, TiposDados)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposDados)) As IQueryable(Of TiposDados)
            Return query.Select(Function(f) New TiposDados With {
                .ID = f.ID, .Descricao = f.Descricao, .Ordem = f.Ordem, .Ativo = f.Ativo, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao,
                .UtilizadorCriacao = f.UtilizadorCriacao, .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
                .F3MMarcador = f.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposDados)) As IQueryable(Of TiposDados)
            Return query.Select(Function(e) New TiposDados With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDados)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDados)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposDados)
            Dim query As IQueryable(Of tbTiposDados) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.Morada.Contains(filtroTxt))
            'End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace