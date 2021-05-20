Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaMateriasLentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaMateriasLentes, SistemaMateriasLentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaMateriasLentes)) As IQueryable(Of SistemaMateriasLentes)
            Return query.Select(Function(entity) New SistemaMateriasLentes With {
                .ID = entity.ID, .Codigo = entity.Codigo, .Descricao = entity.Descricao,
                .Sistema = entity.Sistema, .Ativo = entity.Ativo,
                .DataCriacao = entity.DataCriacao, .UtilizadorCriacao = entity.UtilizadorCriacao, .DataAlteracao = entity.DataAlteracao,
                .UtilizadorAlteracao = entity.UtilizadorAlteracao, .F3MMarcador = entity.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaMateriasLentes)) As IQueryable(Of SistemaMateriasLentes)
            Return query.Select(Function(entity) New SistemaMateriasLentes With {.ID = entity.ID, .Descricao = entity.Descricao})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaMateriasLentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaMateriasLentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Public Function ListaMateriasLentes() As List(Of SistemaMateriasLentes)
            Return tabela.AsNoTracking().
                Select(Function(entity) New SistemaMateriasLentes With {.ID = entity.ID, .Descricao = entity.Descricao}).
                OrderBy(Function(dto) dto.Descricao).
                ToList()
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaMateriasLentes)
            Dim query As IQueryable(Of tbSistemaMateriasLentes) = tabela.AsNoTracking
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