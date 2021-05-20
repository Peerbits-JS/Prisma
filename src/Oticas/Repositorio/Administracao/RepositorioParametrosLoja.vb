Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosLoja
        Inherits RepositorioGenerico(Of F3MEntities, tbParametrosLoja, ParametrosLoja)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosLoja)) As IQueryable(Of ParametrosLoja)
            Return query.Select(Function(e) New ParametrosLoja With {
                .ID = e.ID, .Morada = e.Morada, .CasasDecimaisPercentagem = e.CasasDecimaisPercentagem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosLoja)) As IQueryable(Of ParametrosLoja)
            Return query.Select(Function(e) New ParametrosLoja With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosLoja)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosLoja)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosLoja)
            Dim query As IQueryable(Of tbParametrosLoja) = tabela.AsNoTracking
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

#Region "FUNÇÕES AUXILIARES"
        Public Function getID(ByVal IDLoja As Long) As Long
            Return (From x In BDContexto.tbParametrosLoja Where x.IDLoja = IDLoja Select x.ID).FirstOrDefault()
        End Function
#End Region

    End Class
End Namespace