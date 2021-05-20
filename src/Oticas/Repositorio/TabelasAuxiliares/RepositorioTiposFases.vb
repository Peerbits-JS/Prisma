Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposFases
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbTiposFases, TiposFases)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposFases)) As IQueryable(Of TiposFases)
            Return query.Select(Function(e) New TiposFases With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Ordem = e.Ordem,
                .IDSistemaClassificacoesTiposArtigos = e.IDSistemaClassificacoesTiposArtigos, .DescricaoSistemaClassificacoesTiposArtigos = e.tbSistemaClassificacoesTiposArtigos.Descricao,
                .IDSistemaTiposOlhos = e.IDSistemaTiposOlhos, .DescricaoSistemaTiposOlhos = e.tbSistemaTiposOlhos.Descricao,
                .IDSistemaTiposFases = e.IDSistemaTiposFases, .DescricaoSistemaTiposFases = e.tbSistemaTiposFases.Descricao,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposFases)) As IQueryable(Of TiposFases)
            Return query.Select(Function(e) New TiposFases With {
                .ID = e.ID, .Descricao = e.Descricao}).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposFases)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposFases)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposFases)
            Dim query As IQueryable(Of tbTiposFases) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))

            Return query.OrderBy(Function(o) o.Descricao)
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace