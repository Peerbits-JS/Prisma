Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Fornecedores
    Public Class RepositorioFornecedoresContatos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedoresContatos, F3M.FornecedoresContatos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbFornecedoresContatos)) As IQueryable(Of F3M.FornecedoresContatos)
            Return query.Select(Function(e) New F3M.FornecedoresContatos With {
                .ID = e.ID, .IDTipo = e.IDTipo, .DescricaoTipo = If(String.IsNullOrEmpty(e.tbTiposContatos.Descricao), "", e.tbTiposContatos.Descricao), .Telefone = e.Telefone,
                .Contato = e.Contato, .IDFornecedor = e.IDFornecedor, .DescricaoFornecedor = e.tbFornecedores.Nome,
                .Telemovel = e.Telemovel, .Fax = e.Fax, .Email = e.Email, .Mailing = e.Mailing, .PagWeb = e.PagWeb, .PagRedeSocial = e.PagRedeSocial,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .Ordem = e.Ordem, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbFornecedoresContatos)) As IQueryable(Of F3M.FornecedoresContatos)
            Return query.Select(Function(e) New F3M.FornecedoresContatos With {
                .ID = e.ID, .DescricaoTipo = e.tbTiposContatos.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.FornecedoresContatos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.FornecedoresContatos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbFornecedoresContatos)
            Dim query As IQueryable(Of tbFornecedoresContatos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.tbTiposContatos.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDForn As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDFornecedor, GetType(Long))

            query = query.Where(Function(o) o.IDFornecedor = IDForn).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace