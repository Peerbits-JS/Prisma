Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposDocumentoMovStock
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposDocumentoMovStock, SistemaTiposDocumentoMovStock)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposDocumentoMovStock)) As IQueryable(Of SistemaTiposDocumentoMovStock)
            Return query.Select(Function(e) New SistemaTiposDocumentoMovStock With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposDocumentoMovStock)) As IQueryable(Of SistemaTiposDocumentoMovStock)
            Return query.Select(Function(e) New SistemaTiposDocumentoMovStock With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoMovStock)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoMovStock)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposDocumentoMovStock)
            Dim query As IQueryable(Of tbSistemaTiposDocumentoMovStock) = tabela.AsNoTracking
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