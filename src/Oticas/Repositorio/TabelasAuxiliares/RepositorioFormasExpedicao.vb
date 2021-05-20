Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioFormasExpedicao
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbFormasExpedicao, FormasExpedicao)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbFormasExpedicao)) As IQueryable(Of FormasExpedicao)
            Return query.Select(Function(e) New FormasExpedicao With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbFormasExpedicao)) As IQueryable(Of FormasExpedicao)
            Return query.Select(Function(e) New FormasExpedicao With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of FormasExpedicao)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of FormasExpedicao)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbFormasExpedicao)
            Dim query As IQueryable(Of tbFormasExpedicao) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As FormasExpedicao
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As FormasExpedicao, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As FormasExpedicao, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As FormasExpedicao, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As FormasExpedicao,
                                                 e As tbFormasExpedicao, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDFormaExpedicao", e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbFormasExpedicaoIdiomas, FormasExpedicaoIdiomas)(inCtx, e, o, dict)
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbFormasExpedicaoIdiomas)(inCtx, e.tbFormasExpedicaoIdiomas.ToList,
                                                                 AcoesFormulario.Remover, Nothing)
            End If
        End Sub
#End Region

    End Class
End Namespace