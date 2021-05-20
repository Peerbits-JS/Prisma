Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaEspacoFiscal
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEspacoFiscal, SistemaEspacoFiscal)

#Region "Construtores"
        Sub New()
            ' TODO: Mudar Permissao
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function ValoresPorDefeito(Optional ByVal codigo As Long = 1) As SistemaEspacoFiscal
            If codigo = 1 Then
                Return tabela.Where(Function(e) e.Codigo = codigo).Select(Function(e) New SistemaEspacoFiscal With {
                    .ID = e.ID, .Descricao = e.Descricao}).FirstOrDefault
            Else
                Return tabela.Where(Function(e) e.Codigo = codigo).Select(Function(e) New SistemaEspacoFiscal With {
                    .ID = e.ID, .Descricao = e.Descricao}).FirstOrDefault
            End If
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaEspacoFiscal)) As IQueryable(Of SistemaEspacoFiscal)
            Return query.Select(Function(e) New SistemaEspacoFiscal With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaEspacoFiscal)) As IQueryable(Of SistemaEspacoFiscal)
            Return query.Select(Function(e) New SistemaEspacoFiscal With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEspacoFiscal)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEspacoFiscal)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaEspacoFiscal)
            Dim query As IQueryable(Of tbSistemaEspacoFiscal) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace