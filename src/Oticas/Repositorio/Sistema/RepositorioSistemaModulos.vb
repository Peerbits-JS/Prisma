Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaModulos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaModulos, SistemaModulos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaModulos)) As IQueryable(Of SistemaModulos)
            Return query.Select(Function(e) New SistemaModulos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaModulos)) As IQueryable(Of SistemaModulos)
            Return query.Select(Function(e) New SistemaModulos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaModulos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaModulos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaModulos)
            Dim query As IQueryable(Of tbSistemaModulos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(inFiltro.FiltroTexto, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If


            ' --- ESPECIFICO ---
            Dim blnTiposDocumento As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TiposDocumento", GetType(String))

            If blnTiposDocumento Then
                query = query.Where(Function(o) o.TiposDocumentos = True)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace