Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaEntidadeComparticipacao
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadeComparticipacao, SistemaEntidadeComparticipacao)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaEntidadeComparticipacao)) As IQueryable(Of SistemaEntidadeComparticipacao)
            Return query.Select(Function(e) New SistemaEntidadeComparticipacao With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaEntidadeComparticipacao)) As IQueryable(Of SistemaEntidadeComparticipacao)
            Return query.Select(Function(e) New SistemaEntidadeComparticipacao With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEntidadeComparticipacao)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEntidadeComparticipacao)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaEntidadeComparticipacao)
            Dim query As IQueryable(Of tbSistemaEntidadeComparticipacao) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace