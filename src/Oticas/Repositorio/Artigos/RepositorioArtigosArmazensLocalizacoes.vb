Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosArmazensLocalizacoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosArmazensLocalizacoes, ArtigosArmazensLocalizacoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosArmazensLocalizacoes)) As IQueryable(Of ArtigosArmazensLocalizacoes)
            Return query.Select(Function(e) New ArtigosArmazensLocalizacoes With {
                .ID = e.ID, .IDArtigo = e.IDArtigo,
                .IDArmazem = e.tbArmazens.ID, .DescricaoArmazem = e.tbArmazens.Descricao,
                .IDArmazemLocalizacao = e.tbArmazensLocalizacoes.ID,
                .CodigoArmazemLocalizacao = If(String.IsNullOrEmpty(e.tbArmazensLocalizacoes.Codigo), String.Empty, e.tbArmazensLocalizacoes.Codigo),
                .DescricaoArmazemLocalizacao = If(String.IsNullOrEmpty(e.tbArmazensLocalizacoes.Descricao), String.Empty, e.tbArmazensLocalizacoes.Descricao),
                .PorDefeito = e.PorDefeito, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosArmazensLocalizacoes)) As IQueryable(Of ArtigosArmazensLocalizacoes)
            Return query.Select(Function(e) New ArtigosArmazensLocalizacoes With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosArmazensLocalizacoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosArmazensLocalizacoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosArmazensLocalizacoes)
            Dim query As IQueryable(Of tbArtigosArmazensLocalizacoes) = tabela.AsNoTracking

            AplicaFiltroAtivo(inFiltro, query)

            ' COMBO (GENERICO)
            'If Not ClsTexto.ENuloOuVazio(inFiltro.FiltroTexto) Then
            '    query = query.Where(Function(o) o.Descricao.Contains(inFiltro.FiltroTexto))
            'End If

            ' EXEMPLO
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            ' GRELHA E COMBO (ESPECIFICO)
            If IDArt >= 0 Then
                query = query.Where(Function(o) o.IDArtigo = IDArt)
            End If
            Return query
        End Function
#End Region

#Region "FUNCOES ESP"
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace