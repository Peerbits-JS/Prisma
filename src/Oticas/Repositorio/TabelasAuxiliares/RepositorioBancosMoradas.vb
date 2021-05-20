Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioBancosMoradas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbBancosMoradas, BancosMoradas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbBancosMoradas)) As IQueryable(Of BancosMoradas)
            Return query.Select(Function(e) New BancosMoradas With {
                .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao, .Rota = e.Rota, .Morada = e.Morada, .IDCodigoPostal = e.IDCodigoPostal,
                .DescricaoCodigoPostal = If(String.IsNullOrEmpty(e.tbCodigosPostais.Descricao), "", e.tbCodigosPostais.Descricao), .IDConcelho = e.IDConcelho, .DescricaoConcelho = If(String.IsNullOrEmpty(e.tbConcelhos.Descricao), "", e.tbConcelhos.Descricao),
                .IDDistrito = e.IDDistrito, .DescricaoDistrito = If(String.IsNullOrEmpty(e.tbDistritos.Descricao), "", e.tbDistritos.Descricao), .IDBanco = e.IDBanco, .DescricaoBanco = e.tbBancos.Descricao,
                .IDPais = e.IDPais, .DescricaoPais = If(String.IsNullOrEmpty(e.tbPaises.Descricao), "", e.tbPaises.Descricao), .GPS = e.GPS, .Ordem = e.Ordem,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbBancosMoradas)) As IQueryable(Of BancosMoradas)
            Return query.Select(Function(e) New BancosMoradas With {
                .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of BancosMoradas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of BancosMoradas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbBancosMoradas)
            Dim query As IQueryable(Of tbBancosMoradas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDBanco, GetType(Long))

            query = query.Where(Function(o) o.IDBanco = IDFT).OrderBy(Function(o) o.Ordem)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As BancosMoradas
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region
    End Class
End Namespace