Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioPaises
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbPaises, Paises)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbPaises)) As IQueryable(Of Paises)
            Return query.Select(Function(e) New Paises With {
                .ID = e.ID, .Descricao = e.Descricao, .IDSigla = e.IDSigla, .DescricaoSigla = e.tbSistemaSiglasPaises.Sigla, .VariavelContabilidade = e.VariavelContabilidade,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbPaises)) As IQueryable(Of Paises)
            Return query.Select(Function(e) New Paises With {
                .ID = e.ID, .Descricao = e.Descricao, .DescricaoSigla = e.tbSistemaSiglasPaises.Sigla
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Paises)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Paises)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbPaises)
            Dim query As IQueryable(Of tbPaises) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

        Public Function ExistePais() As Oticas.Paises
            'HERE FK
            Dim pais = BDContexto.tbParametrosEmpresa.Where(Function(f) f.ID = 1).Select(Function(e) New Paises With {.ID = e.IDPaisesDesc, .Descricao = e.tbPaises.Descricao}).FirstOrDefault

            Return pais
        End Function

#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace