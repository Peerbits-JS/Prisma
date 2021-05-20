Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosUnidades
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosUnidades, ArtigosUnidades)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosUnidades)) As IQueryable(Of ArtigosUnidades)
            Return query.Select(Function(e) New ArtigosUnidades With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao,
                .IDUnidade = e.IDUnidade, .DescricaoUnidade = e.tbUnidades.Descricao,
                .IDAUUnidade = e.IDUnidade, .DescricaoAUUnidade = e.tbUnidades.Descricao,
                .IDUnidadeConversao = e.IDUnidadeConversao, .DescricaoUnidadeConversao = e.tbUnidades1.Descricao,
                .FatorConversao = e.FatorConversao, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao,
                .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosUnidades)) As IQueryable(Of ArtigosUnidades)
            Return query.Select(Function(e) New ArtigosUnidades With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosUnidades)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosUnidades)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosUnidades)
            Dim query As IQueryable(Of tbArtigosUnidades) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim IDDuplica As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDDuplica", GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt Or o.IDArtigo = IDDuplica)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace