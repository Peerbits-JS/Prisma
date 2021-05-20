﻿Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioSetoresAtividade
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSetoresAtividade, SetoresAtividade)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSetoresAtividade)) As IQueryable(Of SetoresAtividade)
            Return query.Select(Function(e) New SetoresAtividade With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .VariavelContabilidade = e.VariavelContabilidade,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSetoresAtividade)) As IQueryable(Of SetoresAtividade)
            Return query.Select(Function(e) New SetoresAtividade With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SetoresAtividade)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SetoresAtividade)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSetoresAtividade)
            Dim query As IQueryable(Of tbSetoresAtividade) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As SetoresAtividade, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As SetoresAtividade, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As SetoresAtividade, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As SetoresAtividade,
                                                 e As tbSetoresAtividade, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDSetorAtividade", e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbSetoresAtividadeIdiomas, SetoresAtividadeIdiomas)(inCtx, e, o, dict)
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbSetoresAtividadeIdiomas)(inCtx, e.tbSetoresAtividadeIdiomas.ToList,AcoesFormulario.Remover, Nothing)
            End If
        End Sub
#End Region

    End Class
End Namespace