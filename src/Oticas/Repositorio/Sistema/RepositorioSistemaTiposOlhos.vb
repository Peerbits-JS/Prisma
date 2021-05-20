﻿Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposOlhos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposOlhos, SistemaTiposOlhos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposOlhos)) As IQueryable(Of SistemaTiposOlhos)
            Return query.Select(Function(e) New SistemaTiposOlhos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposOlhos)) As IQueryable(Of SistemaTiposOlhos)
            Return query.Select(Function(e) New SistemaTiposOlhos With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposOlhos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposOlhos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposOlhos)
            Dim query As IQueryable(Of tbSistemaTiposOlhos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDSistemaClassificacoesTiposArtigos As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaClassificacoesTiposArtigos", GetType(Long))
            Select Case IDSistemaClassificacoesTiposArtigos
                Case 1
                    query = query.Where(Function(w) w.Codigo = "OD" OrElse w.Codigo = "OE" OrElse w.Codigo = "ARO")
                Case 3
                    query = query.Where(Function(w) w.Codigo = "OD" OrElse w.Codigo = "OE")
            End Select

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
#End Region
    End Class
End Namespace