Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosPagamentosComprasAnexos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbPagamentosComprasAnexos, F3M.Anexos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbPagamentosComprasAnexos)) As IQueryable(Of F3M.Anexos)
            Dim listaAnexos = query.Select(Function(e) New F3M.Anexos With {
                .ID = e.ID,
                .IDChaveEstrangeira = e.IDPagamentoCompra,
                .DescricaoChaveEstrangeira = String.Empty,
                .IDTipoAnexo = e.IDTipoAnexo, .DescricaoTipoAnexo = e.tbSistemaTiposAnexos.Descricao, .Descricao = e.Descricao,
                .FicheiroOriginal = e.FicheiroOriginal, .Ficheiro = e.Ficheiro, .FicheiroThumbnail = e.FicheiroThumbnail,
                .Caminho = e.Caminho, .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao,
                .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            }).ToList

            For Each anexo In listaAnexos
                Dim partes As String() = anexo.Ficheiro.Split(".")

                If partes.Count > 1 Then
                    anexo.Extensao = partes(partes.Count - 1)
                End If
            Next

            Return listaAnexos.AsQueryable
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbPagamentosComprasAnexos)) As IQueryable(Of F3M.Anexos)
            Return query.Select(Function(e) New F3M.Anexos With {
                .ID = e.ID, .Descricao = e.Descricao, .Ficheiro = e.Ficheiro
            })
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbPagamentosComprasAnexos)
            Dim query As IQueryable(Of tbPagamentosComprasAnexos) = tabela.AsNoTracking
            Dim IDPagamentoCompra As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDChaveEstrangeira, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDPagamentoCompra = IDPagamentoCompra).OrderBy(Function(o) o.ID)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace