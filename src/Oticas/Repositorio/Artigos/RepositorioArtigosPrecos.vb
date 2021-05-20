Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosPrecos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosPrecos, ArtigosPrecos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosPrecos)) As IQueryable(Of ArtigosPrecos)
            Return query.Select(Function(e) New ArtigosPrecos With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao,
                .IDCodigoPreco = e.IDCodigoPreco, .DescricaoCodigoPreco = e.tbSistemaCodigosPrecos.Descricao,
                .ValorComIva = e.ValorComIva, .ValorSemIva = e.ValorSemIva, .UPCPercentagem = e.UPCPercentagem,
                .PadraoPercentagem = If(e.tbArtigos.Padrao > 0, Math.Round(CDbl((e.ValorSemIva - e.tbArtigos.Padrao) * 100 / e.tbArtigos.Padrao), 2), 100),
                .IDUnidade = e.IDUnidade, .DescricaoUnidade = e.tbUnidades.Descricao,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .IDLoja = e.IDLoja, .DescricaoLoja = If(e.tbLojas IsNot Nothing, e.tbLojas.Descricao, String.Empty),
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosPrecos)) As IQueryable(Of ArtigosPrecos)
            Return query.Select(Function(e) New ArtigosPrecos With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosPrecos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosPrecos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosPrecos)
            Dim query As IQueryable(Of tbArtigosPrecos) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim IDDuplica As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDDuplica, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt OrElse o.IDArtigo = IDDuplica)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace