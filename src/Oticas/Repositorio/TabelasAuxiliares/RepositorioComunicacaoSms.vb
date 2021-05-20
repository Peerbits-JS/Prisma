Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioComunicacaoSms
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbComunicacao, ComunicacaoSms)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbComunicacao)) As IQueryable(Of ComunicacaoSms)
            Return query.Select(Function(e) New ComunicacaoSms With {
                .ID = e.ID,
                .Codigo = e.Codigo, .Descricao = e.Descricao,
                .IDSistemaComunicacao = e.IDSistemaComunicacao, .DescricaoSistemaComunicacao = e.tbSistemaComunicacao.Descricao,
                .Utilizador = e.Utilizador, .Chave = e.Chave,
                .Remetente = e.Remetente,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbComunicacao)) As IQueryable(Of ComunicacaoSms)
            Return query.Where(Function(entity) entity.Ativo).Select(Function(e) New ComunicacaoSms With {.ID = e.ID, .Descricao = e.Descricao}).OrderBy(Function(x) x.Descricao)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ComunicacaoSms)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ComunicacaoSms)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbComunicacao)
            Dim query As IQueryable(Of tbComunicacao) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace