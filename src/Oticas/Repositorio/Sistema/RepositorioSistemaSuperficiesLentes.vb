Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaSuperficiesLentes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaSuperficiesLentes, SistemaSuperficiesLentes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"



        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaSuperficiesLentes)) As IQueryable(Of SistemaSuperficiesLentes)
            Return query.Select(Function(e) New SistemaSuperficiesLentes With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaSuperficiesLentes)) As IQueryable(Of SistemaSuperficiesLentes)
            Return query.Select(Function(e) New SistemaSuperficiesLentes With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaSuperficiesLentes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaSuperficiesLentes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaSuperficiesLentes)
            Dim query As IQueryable(Of tbSistemaSuperficiesLentes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)


            '-- ESPECIFICO
            'Dim IDEntidadeEstados As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.IDEntidadeEstado, GetType(Long))

            'If Not ClsTexto.ENuloOuVazio(IDEntidadeEstados) Then
            '    query = query.Where(Function(w) w.IDEntidadeLente = IDEntidadeEstados)
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace