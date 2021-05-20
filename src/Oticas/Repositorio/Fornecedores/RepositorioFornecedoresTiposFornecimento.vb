Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.Fornecedores
    Public Class RepositorioFornecedoresTiposFornecimento
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedoresTiposFornecimento, FornecedoresTiposFornecimentos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbFornecedoresTiposFornecimento)) As IQueryable(Of FornecedoresTiposFornecimentos)
            Return query.Select(Function(e) New FornecedoresTiposFornecimentos With {
                .ID = e.ID, .IDFornecedor = e.IDFornecedor, .DescricaoFornecedor = e.tbFornecedores.Nome, .IDTipoFornecimento = e.IDTipoFornecimento,
                .DescricaoTipoFornecimento = e.tbTiposFornecimentos.Descricao, .Ordem = e.Ordem,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbFornecedoresTiposFornecimento)) As IQueryable(Of FornecedoresTiposFornecimentos)
            Return query.Select(Function(e) New FornecedoresTiposFornecimentos With {
                .ID = e.ID, .DescricaoTipoFornecimento = e.tbTiposFornecimentos.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of FornecedoresTiposFornecimentos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of FornecedoresTiposFornecimentos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbFornecedoresTiposFornecimento)
            Dim query As IQueryable(Of tbFornecedoresTiposFornecimento) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.tbTiposFornecimentos.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDForn As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDFornecedor, GetType(Long))

            query = query.Where(Function(o) o.IDFornecedor = IDForn).OrderBy(Function(o) o.Ordem)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As FornecedoresTiposFornecimentos
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace