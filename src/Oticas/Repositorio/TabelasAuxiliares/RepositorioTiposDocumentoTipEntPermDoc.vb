Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposDocumentoTipEntPermDoc
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTiposDocumentoTipEntPermDoc, TiposDocumentoTipEntPermDoc)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposDocumentoTipEntPermDoc)) As IQueryable(Of TiposDocumentoTipEntPermDoc)
            Return query.Select(Function(e) New TiposDocumentoTipEntPermDoc With {
                .ID = e.ID, .IDTiposDocumento = e.IDTiposDocumento, .IDSistemaTiposEntidadeModulos = e.IDSistemaTiposEntidadeModulos,
                .Descricao = e.tbSistemaTiposEntidadeModulos.tbSistemaTiposEntidade.Entidade, .Ativo = e.Ativo, .Sistema = e.Sistema,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .Ordem = e.Ordem,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposDocumentoTipEntPermDoc)) As IQueryable(Of TiposDocumentoTipEntPermDoc)
            Return query.Select(Function(e) New TiposDocumentoTipEntPermDoc With {
                .ID = e.ID
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoTipEntPermDoc)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoTipEntPermDoc)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposDocumentoTipEntPermDoc)
            Dim query As IQueryable(Of tbTiposDocumentoTipEntPermDoc) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.tbSistemaTiposEntidadeModulos.tbSistemaTiposEntidade.Entidade.Contains(filtroTxt))
            'End If

            AplicaFiltroAtivo(inFiltro, query)

            ' --- ESPECIFICO ---
            Dim ID As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))

            query = query.Where(Function(o) o.IDTiposDocumento = ID)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace