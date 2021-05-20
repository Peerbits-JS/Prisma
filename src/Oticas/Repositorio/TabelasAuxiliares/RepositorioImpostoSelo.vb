Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioImpostoSelo
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbImpostoSelo, ImpostoSelo)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region


#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbImpostoSelo)) As IQueryable(Of ImpostoSelo)
            Return query.Select(Function(e) New ImpostoSelo With {
                .ID = e.ID, .IDVerbaIS = e.IDVerbaIS, .DescricaoVerbaIS = e.tbSistemaVerbasIS.Codigo, .Codigo = e.Codigo,
                .Descricao = e.Descricao, .Percentagem = e.Percentagem, .Valor = e.Valor, .LimiteMaximo = e.LimiteMaximo,
                .LimiteMinimo = e.LimiteMinimo, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbImpostoSelo)) As IQueryable(Of ImpostoSelo)
            Return query.Select(Function(e) New ImpostoSelo With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ImpostoSelo)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ImpostoSelo)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbImpostoSelo)
            Dim query As IQueryable(Of tbImpostoSelo) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDVerb As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDVerbaIS", GetType(Long))

            If IDVerb > 0 Then
                query = query.Where(Function(e) e.IDVerbaIS = IDVerb)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace