Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTipoDistOperacoes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTipoDistOperacoes, SistemaTipoDistOperacoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTipoDistOperacoes)) As IQueryable(Of SistemaTipoDistOperacoes)
            Return query.Select(Function(e) New SistemaTipoDistOperacoes With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTipoDistOperacoes)) As IQueryable(Of SistemaTipoDistOperacoes)
            Return query.Select(Function(e) New SistemaTipoDistOperacoes With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTipoDistOperacoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTipoDistOperacoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTipoDistOperacoes)
            Dim query As IQueryable(Of tbSistemaTipoDistOperacoes) = tabela.AsNoTracking
            Dim IDFichaTecnica As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDFichaTecnica, GetType(Long))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If IDFichaTecnica > 0 Then
            '    Dim TemDimArtigo As Boolean = False
            '    Dim TemElementos As Boolean = False
            '    Using ctx As New BD.Dinamica.Aplicacao
            '        Dim objFT = ctx.tbFichaTecnica.AsNoTracking.Where(Function(f) f.ID = IDFichaTecnica)
            '        TemDimArtigo = objFT.Any(Function(a) a.tbFichaTecnicaLinhasDimensao1.Count Or a.tbFichaTecnicaLinhasDimensao2.Count)
            '        TemElementos = objFT.Any(Function(a) a.tbFichaTecnicaElementos.Count)
            '    End Using
            '    If Not TemDimArtigo Then
            '        query = query.Where(Function(f) f.Codigo <> "PDA" And f.Codigo <> "PDAE" And f.Codigo <> "PEDA")
            '    End If
            '    If Not TemElementos Then
            '        query = query.Where(Function(f) f.Codigo <> "PE" And f.Codigo <> "PDAE" And f.Codigo <> "PEDA")
            '    End If
            'End If

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Descricao))
            'End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace