Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioParametrizacaoConsentimentosPerguntas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbParametrizacaoConsentimentosPerguntas, ParametrizacaoConsentimentosPerguntas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrizacaoConsentimentosPerguntas)) As IQueryable(Of ParametrizacaoConsentimentosPerguntas)
            Return query.
                Select(Function(entity) New ParametrizacaoConsentimentosPerguntas With {
                .ID = entity.ID, .IDParametrizacaoConsentimento = entity.IDParametrizacaoConsentimento,
                .Codigo = entity.Codigo, .Descricao = entity.Descricao,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo, .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao,
                .DataAlteracao = entity.DataAlteracao, .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrizacaoConsentimentosPerguntas)) As IQueryable(Of ParametrizacaoConsentimentosPerguntas)
            Return query.
                Select(Function(entity) New ParametrizacaoConsentimentosPerguntas With {
                .ID = entity.ID, .Descricao = entity.Descricao,
                .OrdemApresentaPerguntas = entity.OrdemApresentaPerguntas}).
                OrderBy(Function(entity) entity.OrdemApresentaPerguntas).
                Take(TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrizacaoConsentimentosPerguntas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrizacaoConsentimentosPerguntas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrizacaoConsentimentosPerguntas)
            Dim query As IQueryable(Of tbParametrizacaoConsentimentosPerguntas) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
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