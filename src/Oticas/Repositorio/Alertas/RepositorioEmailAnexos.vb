
Imports F3M.Modelos.Repositorio

Namespace Repositorio
    Public Class RepositorioEmailAnexos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, F3M.Email, F3M.Anexos)

#Region "CONSTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        'Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbClientesAnexos)) As IQueryable(Of F3M.Anexos)
        '    Dim listaAnexos = query.Select(Function(e) New F3M.Anexos With {
        '        .ID = e.ID, .IDChaveEstrangeira = e.IDCliente, .DescricaoChaveEstrangeira = e.tbClientes.Nome,
        '        .IDTipoAnexo = e.IDTipoAnexo, .DescricaoTipoAnexo = e.tbSistemaTiposAnexos.Descricao, .Descricao = e.Descricao,
        '        .FicheiroOriginal = e.FicheiroOriginal, .Ficheiro = e.Ficheiro, .FicheiroThumbnail = e.FicheiroThumbnail,
        '        .Caminho = e.Caminho, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
        '        .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
        '        .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
        '    }).ToList

        '    For Each anexo In listaAnexos
        '        Dim partes As String() = anexo.Ficheiro.Split(".")

        '        If partes.Count > 1 Then
        '            anexo.Extensao = partes(partes.Count - 1)
        '        End If
        '    Next

        '    Return listaAnexos.AsQueryable
        'End Function

        'Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbClientesAnexos)) As IQueryable(Of F3M.Anexos)
        '    Return query.Select(Function(e) New F3M.Anexos With {
        '        .ID = e.ID, .Descricao = e.Descricao, .Ficheiro = e.Ficheiro
        '    })
        'End Function

        '' FILTRA LISTA
        'Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbClientesAnexos)
        '    Dim query As IQueryable(Of tbClientesAnexos) = tabela.AsNoTracking
        '    Dim filtroTxt As String = inFiltro.FiltroTexto

        '    ' --- GENERICO ---
        '    ' COMBO
        '    If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
        '        query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
        '    End If

        '    AplicaFiltroAtivo(inFiltro, query)

        '    ' --- ESPECIFICO ---
        '    Dim IDCli As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDChaveEstrangeira, GetType(Long))

        '    query = query.Where(Function(o) o.IDCliente = IDCli)

        '    Return query
        'End Function
#End Region

#Region "ESCRITA"
#End Region


    End Class
End Namespace

