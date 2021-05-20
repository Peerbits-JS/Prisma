Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaClassificacoesTiposArtigosGeral
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaClassificacoesTiposArtigosGeral, SistemaClassificacoesTiposArtigosGeral)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaClassificacoesTiposArtigosGeral)) As IQueryable(Of SistemaClassificacoesTiposArtigosGeral)
            Return query.Select(Function(e) New SistemaClassificacoesTiposArtigosGeral With {
                .ID = e.ID, .Descricao = e.Descricao, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .CodigoSAFT = e.CodigoSAFT, .CodigoAT = e.CodigoAT,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})

        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaClassificacoesTiposArtigosGeral)) As IQueryable(Of SistemaClassificacoesTiposArtigosGeral)
            Return query.Select(Function(e) New SistemaClassificacoesTiposArtigosGeral With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaClassificacoesTiposArtigosGeral)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaClassificacoesTiposArtigosGeral)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>S
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaClassificacoesTiposArtigosGeral)
            Dim query As IQueryable(Of tbSistemaClassificacoesTiposArtigosGeral) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(inFiltro.FiltroTexto, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace