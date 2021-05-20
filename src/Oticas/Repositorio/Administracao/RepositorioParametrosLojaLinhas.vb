Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Excepcoes.Tipo
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.SqlClient

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosLojaLinhas
        Inherits RepositorioGenerico(Of F3MEntities, tbParametrosLojalinhas, ParametrosLojaLinhas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosLojaLinhas)) As IQueryable(Of ParametrosLojaLinhas)
            Return query.Select(Function(e) New ParametrosLojaLinhas With {
                .ID = e.ID, .IDLoja = e.IDLoja, .Codigo = e.Codigo, .Descricao = e.Descricao, .Valor = e.Valor})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosLojaLinhas)) As IQueryable(Of ParametrosLojaLinhas)
            Return query.Select(Function(e) New ParametrosLojaLinhas With {
                 .ID = e.ID, .IDLoja = e.IDLoja})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosLojaLinhas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosLojaLinhas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosLojaLinhas)
            Dim query As IQueryable(Of tbParametrosLojaLinhas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"

        'FUNÇÕES AUXILIARES
        Public Function getLinhas(IDLoja As Long, ModoExecucao As Long) As List(Of ParametrosLojaLinhas)
            Dim lst As New List(Of ParametrosLojaLinhas)

            lst = BDContexto.tbParametrosLojaLinhas.Where(Function(y) y.IDLoja = IDLoja).Select(Function(x) New ParametrosLojaLinhas With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao, .Valor = x.Valor, .TipoDados = x.TipoDados}).ToList()
            Return lst
        End Function
#End Region

    End Class
End Namespace