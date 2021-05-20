Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioCampanhas
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbCampanhas, Campanhas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "leitura"
        Protected Overrides Function listacampostodos(query As IQueryable(Of tbCampanhas)) As IQueryable(Of Campanhas)
            Return query.Select(Function(e) New Campanhas With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function listacamposcombo(query As IQueryable(Of tbCampanhas)) As IQueryable(Of Campanhas)
            Return query.Select(Function(e) New Campanhas With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' lista
        Public Overrides Function lista(infiltro As ClsF3MFiltro) As IQueryable(Of Campanhas)
            Return listacampostodos(filtraquery(infiltro))
        End Function

        ' lista filtrado
        Public Overrides Function listacombo(infiltro As ClsF3MFiltro) As IQueryable(Of Campanhas)
            Return listacamposcombo(filtraquery(infiltro))
        End Function

        ' filtra lista
        Protected Overrides Function filtraquery(infiltro As ClsF3MFiltro) As IQueryable(Of tbCampanhas)
            Dim query As IQueryable(Of tbCampanhas) = tabela.AsNoTracking
            Dim elookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(infiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtrotxt As String = infiltro.FiltroTexto

            ' --- generico ---
            ' combo
            If Not ClsTexto.ENuloOuVazio(filtrotxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtrotxt))
            End If

            AplicaFiltroAtivo(infiltro, query)

            If elookup Then
                query = query.OrderBy(Function(o) o.Descricao)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace