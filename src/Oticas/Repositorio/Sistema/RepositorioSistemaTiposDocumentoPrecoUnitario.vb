Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposDocumentoPrecoUnitario
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposDocumentoPrecoUnitario, SistemaTiposDocumentoPrecoUnitario)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposDocumentoPrecoUnitario)) As IQueryable(Of SistemaTiposDocumentoPrecoUnitario)
            Return query.Select(Function(e) New SistemaTiposDocumentoPrecoUnitario With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposDocumentoPrecoUnitario)) As IQueryable(Of SistemaTiposDocumentoPrecoUnitario)
            Return query.Select(Function(e) New SistemaTiposDocumentoPrecoUnitario With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoPrecoUnitario)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoPrecoUnitario)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposDocumentoPrecoUnitario)
            Dim query As IQueryable(Of tbSistemaTiposDocumentoPrecoUnitario) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IsFromInventario As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IsFromInventario", GetType(Boolean))
            If IsFromInventario Then
                Dim lst As New List(Of String) From {{"PV1"}, {"PV2"}, {"PV3"}, {"PV4"}, {"PV5"}, {"PV6"}, {"PV7"}, {"PV8"}, {"PV9"}, {"PV10"}, {"002"}, {"003"}, {"004"}}
                query = query.Where(Function(w) lst.Contains(w.Codigo))
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace