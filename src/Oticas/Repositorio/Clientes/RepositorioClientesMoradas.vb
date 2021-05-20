Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio
    Public Class RepositorioClientesMoradas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbClientesMoradas, F3M.ClientesMoradas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbClientesMoradas)) As IQueryable(Of F3M.ClientesMoradas)
            Return query.Select(Function(e) New F3M.ClientesMoradas With {
                .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao, .Rota = e.Rota, .IDCodigoPostal = e.IDCodigoPostal, .Morada = e.Morada,
                .DescricaoCodigoPostal = If(String.IsNullOrEmpty(e.tbCodigosPostais.Codigo), "", e.tbCodigosPostais.Codigo), .IDConcelho = e.IDConcelho, .DescricaoConcelho = If(String.IsNullOrEmpty(e.tbConcelhos.Descricao), "", e.tbConcelhos.Descricao),
                .IDDistrito = e.IDDistrito, .DescricaoDistrito = If(String.IsNullOrEmpty(e.tbDistritos.Descricao), "", e.tbDistritos.Descricao), .IDCliente = e.IDCliente, .DescricaoCliente = e.tbClientes.Nome,
                .IDPais = e.IDPais, .DescricaoPais = If(String.IsNullOrEmpty(e.tbPaises.Descricao), "", e.tbPaises.Descricao), .GPS = e.GPS, .Ordem = e.Ordem,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbClientesMoradas)) As IQueryable(Of F3M.ClientesMoradas)
            Return query.Select(Function(e) New F3M.ClientesMoradas With {
                .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.ClientesMoradas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of F3M.ClientesMoradas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbClientesMoradas)
            Dim query As IQueryable(Of tbClientesMoradas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDCliente, GetType(Long))
            query = query.Where(Function(o) o.IDCliente = IDFT).OrderBy(Function(o) o.Ordem)

            ' --- VERSAO DA FUNCIONALIDADE ---
            Dim Versao As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Versao", GetType(Short))
            If Versao = 2 AndAlso Not query.FirstOrDefault Is Nothing Then
                Dim IDMoradaPorDefeito As Nullable(Of Long) = query.Where(Function(f) f.Ordem = 1).FirstOrDefault?.ID
                query = query.Where(Function(w) w.ID <> IDMoradaPorDefeito)
            End If

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As F3M.ClientesMoradas
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace