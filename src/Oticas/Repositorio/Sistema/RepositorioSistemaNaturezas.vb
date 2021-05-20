Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaNaturezas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaNaturezas, SistemaNaturezas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaNaturezas)) As IQueryable(Of SistemaNaturezas)
            Return query.Select(Function(e) New SistemaNaturezas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Modulo = e.Modulo, .TipoDoc = e.TipoDoc, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaNaturezas)) As IQueryable(Of SistemaNaturezas)
            Return query.Select(Function(e) New SistemaNaturezas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = If(e.Modulo = "006", If(e.Codigo = "P", "Entrada", "Saída"), e.Descricao), .Modulo = e.Modulo, .TipoDoc = e.TipoDoc
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaNaturezas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaNaturezas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaNaturezas)
            Dim query As IQueryable(Of tbSistemaNaturezas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            ' --- ESPECIFICO ---
            Dim Modulo As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Modulo", GetType(String))

            If Modulo <> String.Empty Then
                If Modulo = SistemaCodigoModulos.ContaCorrente Then
                    query = query.Where(Function(o) o.Modulo = Modulo AndAlso o.TipoDoc = TiposSistemaTiposDocumento.ContaCorrenteLiquidacaoClt)
                Else
                    query = query.Where(Function(o) o.Modulo = Modulo)
                End If
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace