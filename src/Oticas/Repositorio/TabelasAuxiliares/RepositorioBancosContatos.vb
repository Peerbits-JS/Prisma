Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioBancosContatos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbBancosContatos, BancosContatos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbBancosContatos)) As IQueryable(Of BancosContatos)
            Return query.Select(Function(e) New BancosContatos With {
                .ID = e.ID, .IDTipo = e.IDTipo, .Telefone = e.Telefone,
                .DescricaoTipo = e.tbTiposContatos.Descricao,
                .Contato = e.Contato, .IDBanco = e.IDBanco, .DescricaoBanco = e.tbBancos.Descricao,
                .Telemovel = e.Telemovel, .Fax = e.Fax, .Email = e.Email, .Mailing = e.Mailing, .PagWeb = e.PagWeb, .PagRedeSocial = e.PagRedeSocial,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .Ordem = e.Ordem, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbBancosContatos)) As IQueryable(Of BancosContatos)
            Return query.Select(Function(e) New BancosContatos With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of BancosContatos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of BancosContatos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbBancosContatos)
            Dim query As IQueryable(Of tbBancosContatos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDBanco, GetType(Long))

            query = query.Where(Function(o) o.IDBanco = IDFT).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region
    End Class
End Namespace