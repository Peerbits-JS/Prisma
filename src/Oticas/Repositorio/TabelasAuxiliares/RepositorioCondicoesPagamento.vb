Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCondicoesPagamento
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCondicoesPagamento, CondicoesPagamento)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCondicoesPagamento)) As IQueryable(Of CondicoesPagamento)
            Return query.Select(Function(e) New CondicoesPagamento With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .IDTipoCondDataVencimento = e.IDTipoCondDataVencimento, .CodigoTipoCondDataVencimento = e.tbSistemaTiposCondDataVencimento.Codigo,
                .DescricaoTipoCondDataVencimento = e.tbSistemaTiposCondDataVencimento.Descricao,
                .DescontosIncluiIva = e.DescontosIncluiIva,
                .Ativo = e.Ativo, .Prazo = e.Prazo, .ValorCondicao = e.ValorCondicao, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCondicoesPagamento)) As IQueryable(Of CondicoesPagamento)
            Return query.Select(Function(e) New CondicoesPagamento With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Prazo = e.Prazo,
                .CodigoTipoCondDataVencimento = e.tbSistemaTiposCondDataVencimento.Codigo, .ValorCondicao = e.ValorCondicao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamento)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of CondicoesPagamento)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCondicoesPagamento)
            Dim query As IQueryable(Of tbCondicoesPagamento) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As CondicoesPagamento
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As CondicoesPagamento, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As CondicoesPagamento, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As CondicoesPagamento, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Oticas.CondicoesPagamento,
                                                 e As tbCondicoesPagamento, inAcao As AcoesFormulario)
            Try

                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                dict.Add(CamposGenericos.IDCondicaoPagamento, e.ID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    GravaLinhas(Of tbCondicoesPagamentoIdiomas, CondicoesPagamentoIdiomas)(inCtx, e, o, dict)
                    GravaLinhas(Of tbCondicoesPagamentoDescontos, CondicoesPagamentoDescontos)(inCtx, e, o, dict)
                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    GravaLinhasEntidades(Of tbCondicoesPagamentoIdiomas)(inCtx, e.tbCondicoesPagamentoIdiomas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbCondicoesPagamentoDescontos)(inCtx, e.tbCondicoesPagamentoDescontos.ToList, AcoesFormulario.Remover, Nothing)
                End If

                inCtx.SaveChanges()
            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Function getUltimaEntidade(ByVal IDCondicoesPagamento As Long) As Long
            Return (From x In BDContexto.tbCondicoesPagamentoDescontos Order By x.ID Descending Where x.IDCondicaoPagamento = IDCondicoesPagamento Select x.IDTipoEntidade).FirstOrDefault()
        End Function
#End Region

    End Class
End Namespace