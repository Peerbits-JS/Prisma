Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMedicosTecnicosContatos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbMedicosTecnicosContatos, MedicosTecnicosContatos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMedicosTecnicosContatos)) As IQueryable(Of MedicosTecnicosContatos)
            Return query.Select(Function(e) New MedicosTecnicosContatos With {
                .ID = e.ID, .Descricao = e.Descricao, .Contato = e.Contato,
                .Telefone = e.Telefone, .Telemovel = e.Telemovel, .Fax = e.Fax, .Email = e.Email,
                .Mailing = e.Mailing,
                .PagWeb = e.PagWeb, .PagRedeSocial = e.PagRedeSocial,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .IDMedicoTecnico = e.IDMedicoTecnico, .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                .IDTipo = e.IDTipo, .DescricaoTipo = e.tbTiposContatos.Descricao})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMedicosTecnicosContatos)) As IQueryable(Of MedicosTecnicosContatos)
            Return query.Select(Function(e) New MedicosTecnicosContatos With {
                .ID = e.ID, .Descricao = e.tbTiposContatos.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicosContatos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicosContatos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMedicosTecnicosContatos)
            Dim query As IQueryable(Of tbMedicosTecnicosContatos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDMedicoTecnico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDMedicoTecnico, GetType(Long))

            query = query.Where(Function(o) o.IDMedicoTecnico = IDMedicoTecnico).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace