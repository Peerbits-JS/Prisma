Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Genericos
Imports System.Data.Entity
Imports F3M.Areas
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioContasBancariasMoradas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbContasBancariasMoradas, ContasBancariasMoradas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbContasBancariasMoradas)) As IQueryable(Of ContasBancariasMoradas)
            Return query.Select(Function(e) New ContasBancariasMoradas With {
               .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao, .Rota = e.Rota, .Morada = e.Morada, .IDContaBancaria = e.IDContaBancaria,
               .DescricaoContaBancaria = If(String.IsNullOrEmpty(e.tbContasBancarias.Descricao), "", e.tbContasBancarias.Descricao),
               .IDCodigoPostal = e.IDCodigoPostal, .DescricaoCodigoPostal = If(String.IsNullOrEmpty(e.tbCodigosPostais.Descricao), "", e.tbCodigosPostais.Descricao),
               .IDConcelho = e.IDConcelho, .DescricaoConcelho = If(String.IsNullOrEmpty(e.tbConcelhos.Descricao), "", e.tbConcelhos.Descricao),
               .IDDistrito = e.IDDistrito, .DescricaoDistrito = If(String.IsNullOrEmpty(e.tbDistritos.Descricao), "", e.tbDistritos.Descricao),
               .IDPais = e.IDPais, .DescricaoPais = If(String.IsNullOrEmpty(e.tbPaises.Descricao), "", e.tbPaises.Descricao), .GPS = e.GPS, .Ordem = e.Ordem,
               .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
               .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbContasBancariasMoradas)) As IQueryable(Of ContasBancariasMoradas)
            Return query.Select(Function(e) New ContasBancariasMoradas With {
                .ID = e.ID, .OrdemMorada = e.OrdemMorada, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancariasMoradas)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasBancariasMoradas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbContasBancariasMoradas)
            Dim query As IQueryable(Of tbContasBancariasMoradas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim IDFT As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDContaBancaria, GetType(Long))

            query = query.Where(Function(o) o.IDContaBancaria = IDFT).OrderBy(Function(o) o.Ordem)

            Return query
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As ContasBancariasMoradas
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"

#End Region

    End Class
End Namespace