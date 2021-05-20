Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioIVARegioes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbIVARegioes, IVARegioes)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbIVARegioes)) As IQueryable(Of IVARegioes)
            Return F3M.Repositorio.Comum.RepositorioIVARegioes.ListaCamposTodosComum(Of tbIVARegioes, IVARegioes)(BDContexto, query)
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbIVARegioes)) As IQueryable(Of IVARegioes)
            Return F3M.Repositorio.Comum.RepositorioIVARegioes.ListaCamposComboComum(Of tbIVARegioes, IVARegioes)(BDContexto, query)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of IVARegioes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of IVARegioes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbIVARegioes)
            Dim query As IQueryable(Of tbIVARegioes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDIva As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDIVA, GetType(Long))

            query = query.Where(Function(o) o.IDIva = IDIva)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace