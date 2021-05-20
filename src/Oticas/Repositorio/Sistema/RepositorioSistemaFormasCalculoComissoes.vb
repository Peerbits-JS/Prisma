Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaFormasCalculoComissoes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaFormasCalculoComissoes, SistemaFormasCalculoComissoes)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function ValoresPorDefeito() As SistemaFormasCalculoComissoes
            Return tabela.AsNoTracking.Where(Function(e) e.PorDefeito = True).Select(Function(e) New SistemaFormasCalculoComissoes With {
                .ID = e.ID, .Descricao = e.Descricao
            }).FirstOrDefault
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaFormasCalculoComissoes)) As IQueryable(Of SistemaFormasCalculoComissoes)
            Return query.Select(Function(e) New SistemaFormasCalculoComissoes With {
                .ID = e.ID, .Codigo = e.Codigo, .PorDefeito = e.PorDefeito, .Sistema = e.Sistema, .Descricao = e.Descricao,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaFormasCalculoComissoes)) As IQueryable(Of SistemaFormasCalculoComissoes)
            Return query.Select(Function(e) New SistemaFormasCalculoComissoes With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaFormasCalculoComissoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaFormasCalculoComissoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaFormasCalculoComissoes)
            Dim query As IQueryable(Of tbSistemaFormasCalculoComissoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(inFiltro.FiltroTexto, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            ' GRELHA E COMBO (ESPECIFICO)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace