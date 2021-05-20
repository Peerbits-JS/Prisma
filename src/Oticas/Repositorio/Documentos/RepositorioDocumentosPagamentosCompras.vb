Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Comunicacao
Imports F3M.Repositorio.Comum
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity
Imports System.Data.SqlClient

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosPagamentosCompras
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbPagamentosCompras, DocumentosPagamentosCompras)

#Region "CONTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of DocumentosPagamentosCompras)
            Return AplicaQueryListaPersonalizada(inFiltro)
        End Function

        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbPagamentosCompras)) As IQueryable(Of DocumentosPagamentosCompras)
            Dim funcSel As Func(Of tbPagamentosCompras, DocumentosPagamentosCompras) =
                Function(s)
                    Return RepositorioDocPagamentosCompras.MapeiaEsp(Of tbPagamentosCompras, tbPagamentosComprasLinhas,
                        DocumentosPagamentosCompras, tbSistemaTiposDocumentoColunasAutomaticas)(BDContexto, s)
                End Function
            Return inQuery.Select(funcSel).AsQueryable()
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of DocumentosPagamentosCompras)
            Using repD As New RepositorioDocumentos
                Return repD.ListaDocs(Of tbPagamentosCompras, DocumentosPagamentosCompras, tbSistemaTiposDocumentoColunasAutomaticas)(BDContexto, inFiltro, True, True)
            End Using
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbPagamentosCompras)) As IQueryable(Of DocumentosPagamentosCompras)
            Using repD As New RepositorioDocumentos
                Return repD.MapeiaLista(Of tbPagamentosCompras, DocumentosPagamentosCompras, tbSistemaTiposDocumentoColunasAutomaticas)(inQuery, True)
            End Using
        End Function
#End Region

#Region "ESCRITA"
        Public Overrides Sub AdicionaObj(ByRef inModelo As DocumentosPagamentosCompras, inFiltro As ClsF3MFiltro)
            RepositorioDocPagamentosCompras.AdicionaDocPagamento(Of BD.Dinamica.Aplicacao,
                tbPagamentosCompras,
                DocumentosPagamentosCompras,
                tbDocumentosCompras,
                tbDocumentosComprasPendentes,
                tbTiposDocumento,
                tbTiposDocumentoSeries,
                tbEstados,
                tbPagamentosComprasFormasPagamento,
                tbPagamentosComprasLinhas,
                tbMoedas)(inModelo)
        End Sub

        Public Overrides Sub EditaObj(ByRef inModelo As DocumentosPagamentosCompras, inObjFiltro As ClsF3MFiltro)
            RepositorioDocPagamentosCompras.EditaDocPagamento(Of BD.Dinamica.Aplicacao,
                tbPagamentosCompras,
                tbPagamentosComprasLinhas,
                tbDocumentosCompras,
                tbDocumentosComprasPendentes,
                tbEstados,
                tbMoedas,
                DocumentosPagamentosCompras,
                tbTiposDocumento)(inModelo)
        End Sub

        Public Overrides Sub RemoveObj(ByRef inModelo As DocumentosPagamentosCompras, inObjFiltro As ClsF3MFiltro)
            'Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.RegistoNaoPodeSerRemovido) 'Este registo não pode ser removido.
            RepositorioDocPagamentosCompras.RemoveDoc(Of BD.Dinamica.Aplicacao,
                tbPagamentosCompras,
                tbPagamentosComprasLinhas,
                tbDocumentosCompras,
                tbDocumentosComprasPendentes,
                tbEstados,
                tbMoedas,
                DocumentosPagamentosCompras,
                tbTiposDocumento, tbPagamentosComprasFormasPagamento)(inModelo.ID, inModelo)
        End Sub
#End Region

#Region "FUNÇÕES AUXILIARES"
        Public Sub AnulaPagamento(ByVal inIDDocPagCompra As Long)
            RepositorioDocPagamentosCompras.AnulaPagamentoCompra(Of BD.Dinamica.Aplicacao,
                tbPagamentosCompras,
                tbPagamentosComprasLinhas,
                tbDocumentosCompras,
                tbDocumentosComprasPendentes,
                tbEstados,
                tbMoedas)(inIDDocPagCompra)
        End Sub
#End Region

#Region "CONTAS CAIXA"

        Public Sub PreencheCaixaPorDefeito(ByRef pagamento As F3M.DocumentosPagamentosCompras)
            Dim idContaCaixa As Long = 0

            Dim idUtilizador As Long = ClsF3MSessao.RetornaUtilizadorID()
            Dim idLoja As Long = ClsF3MSessao.RetornaLojaID()

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryCaixaUtilizador As String = "SELECT IDContaCaixa FROM tbUtilizadoresContaCaixa WHERE IDUtilizador = @idUtilizador AND IDLoja = @idLoja"

                idContaCaixa = ctxGeral.Database _
                    .SqlQuery(Of Long)(queryCaixaUtilizador, {
                        New SqlParameter("@idUtilizador", idUtilizador),
                        New SqlParameter("@idLoja", idLoja)
                    }) _
                    .FirstOrDefault
            End Using

            Dim contaCaixa As tbContasCaixa = Nothing

            If idContaCaixa > 0 Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.ID = idContaCaixa AndAlso cc.Ativo)
            End If

            If contaCaixa Is Nothing Then
                contaCaixa = BDContexto.tbContasCaixa.FirstOrDefault(Function(cc) cc.IDLoja = idLoja AndAlso cc.PorDefeito AndAlso cc.Ativo)
            End If

            If contaCaixa IsNot Nothing Then
                pagamento.IDContaCaixa = contaCaixa.ID
                pagamento.DescricaoContaCaixa = contaCaixa.Descricao
            End If
        End Sub

        Public Function UtilizadorPodeAlterarCaixa() As Boolean
            Dim podeAlterarCaixa As Boolean = False
            Dim idUtilizador = ClsF3MSessao.RetornaUtilizadorID()

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryPodeAlterarCaixa As String = "SELECT PodeAlterarCaixa FROM tbUtilizadores WHERE ID = @idUtilizador"

                podeAlterarCaixa =
                    ctxGeral.Database _
                        .SqlQuery(Of Boolean)(queryPodeAlterarCaixa, New SqlParameter("@idUtilizador", idUtilizador)) _
                        .FirstOrDefault
            End Using

            Return podeAlterarCaixa
        End Function

#End Region

    End Class
End Namespace