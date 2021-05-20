Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosAssociados
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosAssociados, ArtigosAssociados)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosAssociados)) As IQueryable(Of ArtigosAssociados)
            Return query.Select(Function(e) New ArtigosAssociados With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao,
                .IDArtigoDimensaoLinha1 = e.IDArtigoDimensaoLinha1,
                .DescricaoArtigoDimensaoLinha1 = If(String.IsNullOrEmpty(e.tbDimensoesLinhas.Descricao), "", e.tbDimensoesLinhas.Descricao),
                .IDArtigoDimensaoLinha2 = e.IDArtigoDimensaoLinha2,
                .DescricaoArtigoDimensaoLinha2 = If(String.IsNullOrEmpty(e.tbDimensoesLinhas2.Descricao), "", e.tbDimensoesLinhas2.Descricao),
                .IDArtigoAssociado = e.IDArtigoAssociado,
                .DescricaoArtigoAssociado = e.tbArtigos1.Descricao,
                .IDArtigoDimensaoLinha1Associado = e.IDArtigoDimensaoLinha1Associado,
                .DescricaoArtigoDimensaoLinha1Associado = If(String.IsNullOrEmpty(e.tbDimensoesLinhas1.Descricao), "", e.tbDimensoesLinhas1.Descricao),
                .IDArtigoDimensaoLinha2Associado = e.IDArtigoDimensaoLinha2Associado,
                .DescricaoArtigoDimensaoLinha2Associado = If(String.IsNullOrEmpty(e.tbDimensoesLinhas3.Descricao), "", e.tbDimensoesLinhas3.Descricao),
                .Quantidade = e.Quantidade, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao,
                .F3MMarcador = e.F3MMarcador, .CodigoSistemaTipoDim = e.tbArtigos1.tbSistemaTiposDimensoes.Codigo, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosAssociados)) As IQueryable(Of ArtigosAssociados)
            Return query.Select(Function(e) New ArtigosAssociados With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosAssociados)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosAssociados)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosAssociados)
            Dim query As IQueryable(Of tbArtigosAssociados) = tabela.AsNoTracking
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