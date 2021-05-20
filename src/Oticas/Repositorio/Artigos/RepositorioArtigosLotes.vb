Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosLotes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosLotes, ArtigosLotes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosLotes)) As IQueryable(Of ArtigosLotes)
            Return query.Select(Function(e) New ArtigosLotes With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .DataFabrico = e.DataFabrico, .DataValidade = e.DataValidade, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ordem = e.Ordem
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosLotes)) As IQueryable(Of ArtigosLotes)
            Return query.Select(Function(e) New ArtigosLotes With {
                .ID = e.ID, .Descricao = e.Descricao, .IDArtigo = e.IDArtigo, .Codigo = e.Codigo, .CodigoArtigo = e.tbArtigos.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLotes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLotes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosLotes)
            Dim query As IQueryable(Of tbArtigosLotes) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt)

            ' COMBO (GENERICO)
            If Not ClsTexto.ENuloOuVazio(inFiltro.FiltroTexto) Then
                query = query.Where(Function(o) o.Descricao.Contains(inFiltro.FiltroTexto))
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace