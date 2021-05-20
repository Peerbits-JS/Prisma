Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Genericos
Imports System.Data.Entity
Imports F3M.Areas
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioContasBancariasContatos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancariasContatos, ContasBancariasContatos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbContasBancariasContatos)) As IQueryable(Of ContasBancariasContatos)
            Return query.Select(Function(f) New ContasBancariasContatos With {
                .ID = f.ID, .IDContaBancaria = f.IDContaBancaria, .IDTipo = f.IDTipo, .Descricao = f.Descricao, .Contato = f.Contato,
                .Telefone = f.Telefone, .Telemovel = f.Telemovel, .Fax = f.Fax, .Email = f.Email, .Mailing = f.Mailing, .PagWeb = f.PagWeb, .PagRedeSocial = f.PagRedeSocial,
                .Ordem = f.Ordem, .DataCriacao = f.DataCriacao, .UtilizadorCriacao = f.UtilizadorCriacao})
            '.DescricaoTipoContato = If(String.IsNullOrEmpty(f.tbTiposcontato.Descricao), "", f.tbTiposcontato.Descricao), DescricaoContaBancaria = f.tbContasBancarias.Descricao
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbContasBancariasContatos)) As IQueryable(Of ContasBancariasContatos)
            Return query.Select(Function(e) New ContasBancariasContatos With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancariasContatos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancariasContatos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbContasBancariasContatos)
            Dim query As IQueryable(Of tbContasBancariasContatos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDContaBancaria, GetType(Long))

            query = query.Where(Function(o) o.IDContaBancaria = IDFT).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region

#Region "ESCRITA"

#End Region

    End Class
End Namespace