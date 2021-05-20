Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaRegimeIVA
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaRegimeIVA, SistemaRegimeIVA)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function ValoresPorDefeito(Optional ByVal codigoStr As String = "N") As SistemaRegimeIVA
            If codigoStr = "N" Then
                Return tabela.Where(Function(e) e.Codigo = codigoStr).Select(Function(e) New SistemaRegimeIVA With {
                    .ID = e.ID, .Descricao = e.Descricao}).FirstOrDefault
            Else
                Return tabela.Where(Function(e) e.Codigo = codigoStr).Select(Function(e) New SistemaRegimeIVA With {
                    .ID = e.ID, .Descricao = e.Descricao}).FirstOrDefault
            End If
        End Function


        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaRegimeIVA)) As IQueryable(Of SistemaRegimeIVA)
            Return query.Select(Function(e) New SistemaRegimeIVA With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaRegimeIVA)) As IQueryable(Of SistemaRegimeIVA)
            Return query.Select(Function(e) New SistemaRegimeIVA With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaRegimeIVA)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaRegimeIVA)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaRegimeIVA)
            Dim query As IQueryable(Of tbSistemaRegimeIVA) = tabela.AsNoTracking

            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            'Dim query2 = From t In tabela.AsNoTracking
            '             Join t2 In BDContexto.tbSistemaRelacaoEspacoFiscalRegimeIva On t2.IDEspacoFiscal Equals t.ID


            ' --- ESPECIFICO ---
            Dim IDEspFisc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEspacoFiscal, GetType(Long))
            If IDEspFisc > 0 Then
                query = From sr In query
                        Join r In BDContexto.tbSistemaRelacaoEspacoFiscalRegimeIva On sr.ID Equals r.IDRegimeIva
                        Join ef In BDContexto.tbSistemaEspacoFiscal On ef.ID Equals r.IDEspacoFiscal
                        Where ef.ID = IDEspFisc
                        Select sr
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace