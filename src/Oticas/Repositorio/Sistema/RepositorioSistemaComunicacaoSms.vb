Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaComunicacaoSms
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbSistemaComunicacao, SistemaComunicacaoSms)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaComunicacao)) As IQueryable(Of SistemaComunicacaoSms)
            Return query.Select(Function(e) New SistemaComunicacaoSms With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .APIURL = e.APIURL,
                .Ativo = e.Ativo, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaComunicacao)) As IQueryable(Of SistemaComunicacaoSms)
            Return query.Select(Function(e) New SistemaComunicacaoSms With {.ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo, .APIURL = e.APIURL})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaComunicacaoSms)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaComunicacaoSms)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaComunicacao)
            Dim query As IQueryable(Of tbSistemaComunicacao) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace