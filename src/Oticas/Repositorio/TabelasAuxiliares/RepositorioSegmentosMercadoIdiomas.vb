Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioSegmentosMercadoIdiomas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSegmentosMercadoIdiomas, SegmentosMercadoIdiomas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSegmentosMercadoIdiomas)) As IQueryable(Of SegmentosMercadoIdiomas)
            Return query.Select(Function(e) New SegmentosMercadoIdiomas With {
                .ID = e.ID, .IDSegmentoMercado = e.IDSegmentoMercado, .DescricaoSegmentosMercado = e.tbSegmentosMercado.Descricao,
                .IDIdioma = e.tbIdiomas.ID, .DescricaoIdioma = e.tbIdiomas.Descricao,
                .Descricao = e.Descricao,
                .Ativo = e.Ativo, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSegmentosMercadoIdiomas)) As IQueryable(Of SegmentosMercadoIdiomas)
            Return query.Select(Function(e) New SegmentosMercadoIdiomas With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SegmentosMercadoIdiomas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SegmentosMercadoIdiomas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSegmentosMercadoIdiomas)
            Dim query As IQueryable(Of tbSegmentosMercadoIdiomas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDSM As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDSegmentoMercado, GetType(Long))

            query = query.Where(Function(o) o.IDSegmentoMercado = IDSM).OrderBy(Function(o) o.Ordem)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace