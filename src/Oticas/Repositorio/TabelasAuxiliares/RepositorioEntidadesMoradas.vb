Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes
Imports System.Data.Entity

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioEntidadesMoradas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbEntidadesMoradas, EntidadesMoradas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbEntidadesMoradas)) As IQueryable(Of EntidadesMoradas)
            Return query.Select(Function(e) New EntidadesMoradas With {
                .ID = e.ID, .IDEntidade = e.IDEntidade, .DescricaoEntidade = e.tbEntidades.Descricao,
                .IDCodigoPostal = e.IDCodigoPostal, .DescricaoCodigoPostal = e.tbCodigosPostais.Codigo,
                .IDConcelho = e.IDConcelho, .DescricaoConcelho = e.tbConcelhos.Descricao, .IDDistrito = e.IDDistrito, .DescricaoDistrito = e.tbDistritos.Descricao,
                .IDPais = e.IDPais, .DescricaoPais = e.tbPaises.Descricao, .Descricao = e.Descricao,
                .Rota = e.Rota, .Morada = e.Morada, .GPS = e.GPS, .Ordem = e.Ordem, .OrdemMorada = e.OrdemMorada,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbEntidadesMoradas)) As IQueryable(Of EntidadesMoradas)
            Return query.Select(Function(e) New EntidadesMoradas With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of EntidadesMoradas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of EntidadesMoradas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEntidadesMoradas)
            Dim query As IQueryable(Of tbEntidadesMoradas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))

            query = query.Where(Function(o) o.IDEntidade = IDFT).OrderBy(Function(o) o.Ordem)

            Return query
        End Function


        'Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEntidadesMoradas)
        '    Dim query As IQueryable(Of tbEntidadesMoradas) = tabela.AsNoTracking
        '    Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
        '    Dim filtroTxt As String = inFiltro.FiltroTexto

        '    ' --- GENERICO ---
        '    ' COMBO
        '    If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
        '        query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
        '    End If

        '    AplicaFiltroAtivo(inFiltro, query)

        '    If eLookup Then
        '        query = query.OrderBy(Function(o) o.Descricao)
        '    End If

        '    Return query
        'End Function
#End Region

#Region "ESCRITA"
       
#End Region

    End Class
End Namespace