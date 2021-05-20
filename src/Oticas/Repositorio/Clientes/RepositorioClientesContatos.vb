Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio
    Public Class RepositorioClientesContatos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbClientesContatos, F3M.ClientesContatos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbClientesContatos)) As IQueryable(Of F3M.ClientesContatos)
            Return query.Select(Function(e) New F3M.ClientesContatos With {
                .ID = e.ID, .IDTipo = e.IDTipo, .DescricaoTipo = If(String.IsNullOrEmpty(e.tbTiposContatos.Descricao), "", e.tbTiposContatos.Descricao), .Telefone = e.Telefone,
                .Contato = e.Contato, .IDCliente = e.IDCliente, .DescricaoCliente = e.tbClientes.Nome,
                .Telemovel = e.Telemovel, .Fax = e.Fax, .Email = e.Email, .Mailing = e.Mailing, .PagWeb = e.PagWeb, .PagRedeSocial = e.PagRedeSocial,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .Ordem = e.Ordem, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbClientesContatos)) As IQueryable(Of F3M.ClientesContatos)
            Return query.Select(Function(e) New F3M.ClientesContatos With {
                .ID = e.ID, .DescricaoTipo = e.tbTiposContatos.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.ClientesContatos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.ClientesContatos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbClientesContatos)
            Dim query As IQueryable(Of tbClientesContatos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDCliente, GetType(Long))
            query = query.Where(Function(o) o.IDCliente = IDFT).OrderBy(Function(o) o.Ordem)

            ' --- VERSAO DA FUNCIONALIDADE ---
            Dim Versao As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Versao", GetType(Short))
            If Versao = 2 AndAlso Not query.FirstOrDefault Is Nothing Then
                Dim IDContactoPorDefeito As Nullable(Of Long) = query.Where(Function(f) f.Ordem = 1).FirstOrDefault?.ID
                query = query.Where(Function(w) w.ID <> IDContactoPorDefeito)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace