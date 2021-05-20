Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosEmpresa
        Inherits RepositorioGenerico(Of F3MEntities, tbParametrosEmpresa, ParametrosEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosEmpresa)) As IQueryable(Of ParametrosEmpresa)
            Return query.Select(Function(e) New ParametrosEmpresa With {
                .ID = e.ID, .Morada = e.Morada, .CasasDecimaisPercentagem = e.CasasDecimaisPercentagem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosEmpresa)) As IQueryable(Of ParametrosEmpresa)
            Return query.Select(Function(e) New ParametrosEmpresa With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresa)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosEmpresa)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosEmpresa)
            Dim query As IQueryable(Of tbParametrosEmpresa) = tabela.AsNoTracking
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