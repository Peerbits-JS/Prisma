Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaEntidadesEstados
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaEntidadesEstados, SistemaEntidadesEstados)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function RetornaSistemaEntidadesEstados(ByVal inCodigo As String) As SistemaEntidadesEstados
            Return tabela.Where(Function(e) e.Codigo = inCodigo).Select(Function(e) New SistemaEntidadesEstados With {
                    .ID = e.ID, .Descricao = e.Descricao}).FirstOrDefault
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaEntidadesEstados)) As IQueryable(Of SistemaEntidadesEstados)
            Return F3M.Repositorios.Sistema.RepositorioSistemaEntidadesEstados.ListaCamposTodosDocs(Of tbSistemaEntidadesEstados, SistemaEntidadesEstados, tbEstados)(BDContexto, query)
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaEntidadesEstados)) As IQueryable(Of SistemaEntidadesEstados)
            Return F3M.Repositorios.Sistema.RepositorioSistemaEntidadesEstados.ListaCamposComboDocs(Of tbSistemaEntidadesEstados, SistemaEntidadesEstados, tbEstados)(BDContexto, query)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEntidadesEstados)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaEntidadesEstados)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaEntidadesEstados)
            Dim query As IQueryable(Of tbSistemaEntidadesEstados) = tabela.AsNoTracking
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