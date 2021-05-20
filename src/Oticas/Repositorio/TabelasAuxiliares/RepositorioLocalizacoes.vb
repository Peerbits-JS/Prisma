Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioLocalizacoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArmazensLocalizacoes, Localizacoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArmazensLocalizacoes)) As IQueryable(Of Localizacoes)
            Return query.Select(Function(e) New Localizacoes With {
                .ID = e.ID, .IDArmazem = e.IDArmazem, .DescricaoArmazem = e.tbArmazens.Descricao, .Codigo = e.Codigo,
                .Descricao = e.Descricao, .CodigoBarras = e.CodigoBarras, .Ativo = e.Ativo, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArmazensLocalizacoes)) As IQueryable(Of Localizacoes)
            Return query.Select(Function(e) New Localizacoes With {
                .ID = e.ID, .IDArmazem = e.IDArmazem, .DescricaoArmazem = e.tbArmazens.Descricao, .Codigo = e.Codigo,
                .Descricao = e.Descricao, .CodigoBarras = e.CodigoBarras
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        '' LISTA
        'Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Localizacoes)
        '    Return ListaCamposTodos(FiltraQuery(inFiltro))
        'End Function

        '' LISTA FILTRADO
        'Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Localizacoes)
        '    Return ListaCamposCombo(FiltraQuery(inFiltro))
        'End Function

        ' LISTA COMBO CODIGO
        Public Function ListaComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Localizacoes)
            Dim listaArts As List(Of Localizacoes) = ListaCamposCombo(FiltraQueryCodigo(inFiltro)).ToList
            If listaArts IsNot Nothing AndAlso listaArts.Count > 0 Then
                Dim listaIDArts As List(Of Long) = listaArts.Select(Function(s) s.ID).ToList
            End If
            Return listaArts.AsQueryable
        End Function


        Public Function ListaCamposComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Localizacoes)
            Dim listaArts As List(Of Localizacoes) = ListaCamposCombo(FiltraQueryCodigo(inFiltro)).ToList

            Return listaArts.AsQueryable
        End Function

        Protected Function FiltraQueryCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArmazensLocalizacoes)
            Dim query As IQueryable(Of tbArmazensLocalizacoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Codigo.Contains(filtroTxt))
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDArm As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArmazem, GetType(Long))

            If IDArm >= 0 AndAlso Not IsNothing(inFiltro.CamposFiltrar) AndAlso inFiltro.CamposFiltrar.ContainsKey(CamposGenericos.IDArmazem) Then
                query = query.Where(Function(o) o.IDArmazem = IDArm)
            End If

            Return query

        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArmazensLocalizacoes)
            Dim query As IQueryable(Of tbArmazensLocalizacoes) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDArm As Long = clsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArmazem, GetType(Long))

            If IDArm >= 0 AndAlso Not IsNothing(inFiltro.CamposFiltrar) AndAlso inFiltro.CamposFiltrar.ContainsKey(CamposGenericos.IDArmazem) Then
                query = query.Where(Function(o) o.IDArmazem = IDArm)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace