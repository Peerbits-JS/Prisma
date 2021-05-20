Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposDocumentoFiscal
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposDocumentoFiscal, SistemaTiposDocumentoFiscal)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposDocumentoFiscal)) As IQueryable(Of SistemaTiposDocumentoFiscal)
            Return query.Select(Function(e) New SistemaTiposDocumentoFiscal With {
                .ID = e.ID, .Tipo = e.Tipo, .Descricao = e.Descricao, .IDTiposDocumento = e.IDTipoDocumento, .DescricaoTiposDocumento = e.tbSistemaTiposDocumento.Descricao, .Sistema = e.Sistema,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposDocumentoFiscal)) As IQueryable(Of SistemaTiposDocumentoFiscal)
            Return query.Select(Function(e) New SistemaTiposDocumentoFiscal With {
                .ID = e.ID, .Descricao = e.Descricao, .Tipo = e.Tipo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoFiscal)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposDocumentoFiscal)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposDocumentoFiscal)
            Dim query As IQueryable(Of tbSistemaTiposDocumentoFiscal) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaTiposDocumento", GetType(Long))

            If IDTipoDoc >= 0 Then
                query = query.Where(Function(o) o.IDTipoDocumento = IDTipoDoc)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace