Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioGruposArtigo
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbGruposArtigo, GruposArtigo)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbGruposArtigo)) As IQueryable(Of GruposArtigo)
            Return query.Select(Function(e) New GruposArtigo With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .VariavelContabilidade = e.VariavelContabilidade,
                .Ativo = e.Ativo, .UtilizadorCriacao = e.UtilizadorCriacao, .DataCriacao = e.DataCriacao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .DataAlteracao = e.DataAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbGruposArtigo)) As IQueryable(Of GruposArtigo)
            Return query.Select(Function(e) New GruposArtigo With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of GruposArtigo)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of GruposArtigo)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbGruposArtigo)
            Dim query As IQueryable(Of tbGruposArtigo) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace