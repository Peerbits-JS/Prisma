Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposComposicoes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposComposicoes, SistemaTiposComposicoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposComposicoes)) As IQueryable(Of SistemaTiposComposicoes)
            Return query.Select(Function(e) New SistemaTiposComposicoes With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposComposicoes)) As IQueryable(Of SistemaTiposComposicoes)
            Return query.Select(Function(e) New SistemaTiposComposicoes With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposComposicoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposComposicoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposComposicoes)
            Dim query As IQueryable(Of tbSistemaTiposComposicoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            'End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace