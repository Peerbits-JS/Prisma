Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports F3M.Modelos.Autenticacao

Namespace Repositorio.Administracao
    Public Class RepositorioCondicionantes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCondicionantes, Condicionantes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbCondicionantes)) As IQueryable(Of Condicionantes)
            Return query.Select(Function(f) New Condicionantes With {
                .ID = f.ID, .CampoCondicionante = f.CampoCondicionante, .ValorCondicionante = f.ValorCondicionante, .IDParametroCamposContexto = f.tbParametrosCamposContexto.ID, .ValorPorDefeito = f.ValorPorDefeito,
                .TipoValorPorDefeito = f.TipoValorPorDefeito, .Ordem = f.Ordem, .Ativo = f.Ativo, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao,
                .UtilizadorCriacao = f.UtilizadorCriacao, .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
                .F3MMarcador = f.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbCondicionantes)) As IQueryable(Of Condicionantes)
            Return query.Select(Function(e) New Condicionantes With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Condicionantes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Condicionantes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbCondicionantes)
            Dim query As IQueryable(Of tbCondicionantes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        Public Function ListaComboID(ByVal IDParametroCamposContexto As Long?) As List(Of Condicionantes)

            Dim list As New List(Of Condicionantes)

            list = BDContexto.tbCondicionantes.Where(Function(x) x.IDParametroCamposContexto = IDParametroCamposContexto).Select(Function(f) New Condicionantes With {.ID = f.ID, .IDParametroCamposContexto = f.IDParametroCamposContexto, .CampoCondicionante = f.CampoCondicionante, .ValorCondicionante = f.ValorCondicionante, .ValorPorDefeito = f.ValorPorDefeito, .TipoValorPorDefeito = f.TipoValorPorDefeito}).ToList()
            Return list.OrderBy(Function(x) x.DescricaoCampoContexto).ToList()
        End Function

#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace