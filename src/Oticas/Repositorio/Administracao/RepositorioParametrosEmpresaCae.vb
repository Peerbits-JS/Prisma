Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosEmpresaCae
        Inherits RepositorioGenerico(Of F3MEntities, tbParametrosEmpresaCAE, ParametrosEmpresaCae)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosEmpresaCAE)) As IQueryable(Of ParametrosEmpresaCae)
            Return query.Select(Function(e) New ParametrosEmpresaCae With {
                .ID = e.ID, .IDParametrosEmpresa = e.IDParametrosEmpresa, .Codigo = e.Codigo, .Descricao = e.Descricao})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosEmpresaCAE)) As IQueryable(Of ParametrosEmpresaCae)
            Return query.Select(Function(e) New ParametrosEmpresaCae With {
                 .ID = e.ID,
                 .IDParametrosEmpresa = e.IDParametrosEmpresa,
                 .CodigoDescricaoCAE = String.Concat(e.Codigo, " - ", e.Descricao)})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresaCae)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresaCae)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosEmpresaCAE)
            Dim query As IQueryable(Of tbParametrosEmpresaCAE) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.Morada.Contains(filtroTxt))
            'End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace