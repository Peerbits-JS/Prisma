Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosFornecedores
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosFornecedores, ArtigosFornecedores)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosFornecedores)) As IQueryable(Of ArtigosFornecedores)
            Return query.Select(Function(e) New ArtigosFornecedores With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao, .IDFornecedor = e.IDFornecedor, .DescricaoFornecedor = e.tbFornecedores.Nome,
                .Referencia = e.Referencia, .CodigoBarras = e.CodigoBarras,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao,
                .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosFornecedores)) As IQueryable(Of ArtigosFornecedores)
            Return query.Select(Function(e) New ArtigosFornecedores With {
                .ID = e.ID, .DescricaoFornecedor = e.tbFornecedores.Nome
            })
        End Function

        ' LISTA 
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosFornecedores)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosFornecedores)
            'Return ListaCamposCombo(FiltraQuery(inFiltro))
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosFornecedores)
            Dim query As IQueryable(Of tbArtigosFornecedores) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace