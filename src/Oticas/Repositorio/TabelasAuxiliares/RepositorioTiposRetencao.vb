Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposRetencao
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbTiposRetencao, TiposRetencao)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposRetencao)) As IQueryable(Of TiposRetencao)
            Return query.Select(Function(e) New TiposRetencao With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Contabilidade = e.Contabilidade, .Percentagem = e.Percentagem, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposRetencao)) As IQueryable(Of TiposRetencao)
            Return query.Select(Function(e) New TiposRetencao With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposRetencao)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposRetencao)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposRetencao)
            Dim query As IQueryable(Of tbTiposRetencao) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            If eLookup Then
                query = query.OrderBy(Function(o) o.Descricao)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace