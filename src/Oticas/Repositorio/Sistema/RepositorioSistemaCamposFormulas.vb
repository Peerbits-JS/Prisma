Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports F3M

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaCamposFormulas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaCamposFormulas, SistemaCamposFormulas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaCamposFormulas)) As IQueryable(Of SistemaCamposFormulas)
            Return query.Select(Function(e) New SistemaCamposFormulas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaCamposFormulas)) As IQueryable(Of SistemaCamposFormulas)
            Return query.Select(Function(e) New SistemaCamposFormulas With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaCamposFormulas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaCamposFormulas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaCamposFormulas)
            Dim query As IQueryable(Of tbSistemaCamposFormulas) = tabela.AsNoTracking
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

        Public Overridable Function ObtemPorObjIDEntidade(inID As Long) As IQueryable(Of tbSistemaCamposFormulas)
            Try
                Dim query As IQueryable(Of tbSistemaCamposFormulas) = tabela.AsNoTracking
                'Dim lstCondicoes As New List(Of tbColunasListasPersonalizadas)

                ' ID = ID ESCOLHIDO
                'lstCondicoes.Add(
                '    New tbColunasListasPersonalizadas With {
                '        .ColunaVista = "IDEntidade",
                '        .OperadorCondicao = LINQ.Equal,
                '        .ValorCondicao = objID,
                '        .TipoColuna = TipoCampoVistas.Inteiro})

                'ClsF3MLINQ.ExecutaFiltros(lstCondicoes, query)

                Return query.Where(Function(f) f.IDEntidadesFormulas = inID)
            Catch
                Throw
            End Try
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace