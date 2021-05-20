Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports System.Data.SqlClient

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaParametrosLoja
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaParametrosLoja, SistemaParametrosLoja)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaParametrosLoja)) As IQueryable(Of SistemaParametrosLoja)
            Return query.Select(Function(e) New SistemaParametrosLoja With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaParametrosLoja)) As IQueryable(Of SistemaParametrosLoja)
            Return query.Select(Function(e) New SistemaParametrosLoja With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaParametrosLoja)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaParametrosLoja)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaParametrosLoja)
            Dim query As IQueryable(Of tbSistemaParametrosLoja) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            Return query
        End Function

        'FUNÇÕES AUXILIARES
        Public Function getLinhas(IDParametrosLoja As Long, ModoExecucao As Long) As List(Of SistemaParametrosLoja)
            Dim lst As New List(Of SistemaParametrosLoja)
            lst = BDContexto.tbSistemaParametrosLoja.Select(Function(x) New SistemaParametrosLoja With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao, .Valor = x.Valor, .TipoDados = x.TipoDados}).ToList()
            Return lst
        End Function

#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace