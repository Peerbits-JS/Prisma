Imports System.Data.Entity
Imports System.Data.SqlClient
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Controlos
Imports F3M.Modelos.Grelhas
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports F3M.Repositorio.DocumentosComum
Imports Kendo.Mvc.UI

Namespace Repositorio.BusinessDocuments
    Public Class PurchaseDocumentsRepository
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDocumentosCompras, Object)

        Public Const COL_SEL As String = "Selecionado"
        Public Const COL_LOJA As String = "Loja"
        Public Const COL_IDDOC As String = CamposGenericos.IDDocumento
        Public Const COL_DOC As String = CamposGenericos.Documento
        Public Const COL_NUMDOC As String = CamposGenericos.NumeroDocumento
        Public Const COL_VOSSONUMDOC As String = "VossoNumeroDocumento"
        Public Const COL_TIPODOC As String = "TipoDocumento"
        Public Const COL_NOME As String = CamposGenericos.Nome
        Public Const COL_DATADOC As String = CamposGenericos.DataDocumento
        ' AVISO: NAO MUDAR ESTES NOMES
        Protected Const TIPO_FISC_ORIG As String = "TipoFiscalOrigem"
        Protected Const TIPO_DOC_SIST_ORIG As String = "CodigoSistemaTiposDocumento"
        Protected Const NATUR_ORIG As String = "NaturezaOrigem"

        ' Colunas Grelha Doc Linhas
        Public Const COL_COD As String = CamposGenericos.Codigo
        Public Const COL_ART As String = "Artigo"
        Public Const COL_QTD As String = CamposGenericos.Quantidade

        Public Function GetById(id As Long) As tbDocumentosCompras
            Return BDContexto.tbDocumentosCompras.FirstOrDefault(Function(f) f.ID = id)
        End Function

        Public Sub Assina(purchaseDocumentId As Long)
            Dim purchaseDocument As tbDocumentosCompras = BDContexto.tbDocumentosCompras.FirstOrDefault(Function(entity) entity.ID = purchaseDocumentId)

            If Not purchaseDocument Is Nothing Then
                Dim model As DocumentosCompras = GetD(purchaseDocument)

                Dim isTransf As Boolean = purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumentoMovStock.Codigo = "004"
                Dim checkIfAssign As Boolean = RepositorioDocumentos.VerificaSeAssinado(Of tbTiposDocumento)(purchaseDocument.tbTiposDocumento)
                Dim atCom As Boolean = False
                Dim strDocOrigem = purchaseDocument.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo
                Dim blnManual As Boolean = False
                Dim blnReposicao As Boolean = False
                If strDocOrigem = TiposDocumentosOrigem.Manual Then
                    blnManual = True
                    blnReposicao = False
                ElseIf strDocOrigem = TiposDocumentosOrigem.Reposicao Then
                    blnManual = False
                    blnReposicao = True
                End If

                If isTransf OrElse checkIfAssign Then
                    atCom = purchaseDocument.tbTiposDocumento.AcompanhaBensCirculacao

                    RepositorioDocumentos.AssinaDocumento(Of tbTiposDocumento, tbDocumentosCompras, tbEstados)(
                        BDContexto, model, purchaseDocument, purchaseDocument.tbTiposDocumento, AcoesFormulario.Alterar, NameOf(tbDocumentosCompras))

                    If Not String.IsNullOrEmpty(purchaseDocument.Assinatura) Then
                        purchaseDocument.DataAssinatura = model.DataAssinatura
                    End If
                End If

                If isTransf OrElse atCom Then
                    RepositorioDocumentos.PreencheDadosComunicacaoAT(Of tbTiposDocumento,
                      tbTiposDocumentoSeries,
                      tbDocumentosCompras,
                      tbEstados,
                      tbParametrosCamposContexto,
                      tbSistemaTiposDocumentoComunicacao,
                      tbATEstadoComunicacao)(BDContexto, model, purchaseDocument, NameOf(tbDocumentosCompras))
                End If

                purchaseDocument.MensagemDocAT = RepositorioDocumentos.TextoMsgAssinatura(
                    purchaseDocument.tbTiposDocumento,
                    True,
                    ClsF3MSessao.RetornaEmpresaDemonstracao,
                    False,
                    blnManual,
                    blnReposicao,
                    purchaseDocument.SerieDocManual,
                    purchaseDocument.NumeroDocManual,
                    purchaseDocument.Assinatura)

                BDContexto.Entry(purchaseDocument).State = EntityState.Modified
                BDContexto.SaveChanges()

                ' Solicitar o código do documento AT, quando aplicável
                RepositorioDocumentos.SolicitaCodigoDocAT(Of tbTiposDocumento, tbTiposDocumentoSeries, tbEstados, tbParametrosCamposContexto, tbSistemaTiposDocumentoComunicacao)(
                    BDContexto, model, GetType(tbDocumentosCompras).Name)
            End If
        End Sub

        Private Function GetD(purchaseDocument As tbDocumentosCompras) As DocumentosCompras
            Return New DocumentosCompras With {
                .ID = purchaseDocument.ID,
                .Assinatura = purchaseDocument.Assinatura,
                .IDEstado = purchaseDocument.IDEstado,
                .DataDocumento = purchaseDocument.DataDocumento,
                .IDTipoDocumento = purchaseDocument.IDTipoDocumento,
                .IDTiposDocumentoSeries = purchaseDocument.IDTiposDocumentoSeries,
                .DataAssinatura = If(purchaseDocument.DataAssinatura Is Nothing, DateTime.Now, purchaseDocument.DataAssinatura),
                .CodigoTipoDocumentoSerie = purchaseDocument.tbTiposDocumentoSeries.CodigoSerie,
                .NumeroDocumento = purchaseDocument.NumeroDocumento,
                .TotalClienteMoedaReferencia = purchaseDocument.TotalMoedaReferencia
            }
        End Function

        Public Function GetDocumentsToImport(req As DataSourceRequest, documentId As Long) As ClsKendoGridCliente
            Dim purchaseDocument As tbDocumentosCompras = BDContexto.tbDocumentosCompras.FirstOrDefault(Function(entity) entity.ID = documentId)
            Dim purchaseDocumentLines As List(Of tbDocumentosComprasLinhas) = purchaseDocument.
                tbDocumentosComprasLinhas.
                Select(Function(s) New tbDocumentosComprasLinhas With {.IDLinhaDocumentoOrigem = s.IDLinhaDocumentoOrigem}).
                ToList()

            Dim naturAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaNaturezas?.Codigo
            Dim tpDocAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo
            Dim tpFiscalAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo
            Dim ivaIncluido As Boolean = purchaseDocument.tbTiposDocumentoSeries.IVAIncluido

            ' Colunas
            Dim lstColsAux As List(Of ClsF3MCampo) = RepositorioDocImportacao.RetornaColunasGrelhaDocs()

            Dim strCond As String = String.Empty
            If ClsUtilitarios.RetornaZeroSeVazio(purchaseDocument.IDEntidade) > 0 Then
                strCond += String.Concat(" AND ", CamposGenericos.IDEntidade, "=", purchaseDocument.IDEntidade)
            End If

            If ClsUtilitarios.RetornaZeroSeVazio(purchaseDocument.IDMoeda) > 0 Then
                strCond += String.Concat(" AND IDMoeda=", purchaseDocument.IDMoeda)
            End If

            strCond = strCond & " AND d.IDTemp IS NULL AND ISNULL(d.AcaoTemp, 0) <> 1  "

            ' Doc Linhas IDs
            Dim strIDLinhas As String = "(0)"
            If purchaseDocumentLines?.Any() Then
                Dim arrDocLinIDs As String() = purchaseDocumentLines.Where(Function(f) f.IDLinhaDocumentoOrigem IsNot Nothing).Select(Function(s) CObj(s).IDLinhaDocumentoOrigem.ToString).ToArray

                If arrDocLinIDs.Any() Then
                    strIDLinhas = String.Concat("(", String.Join(",", arrDocLinIDs), ")")
                End If
            End If

            Dim strQry As String = RepositorioDocImportacao.RetornaDocsQry(Of tbTiposDocumento)(
                GetType(tbDocumentosCompras),
                GetType(tbDocumentosComprasLinhas), purchaseDocument.IDTipoDocumento,
                purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo,
                CamposGenericos.IDDocCompra,
                naturAtual,
                tpDocAtual,
                tpFiscalAtual,
                strIDLinhas,
                ivaIncluido,
                strCond,
                lstColsAux)

            Dim strQryTotal As String = RepositorioDocImportacao.RetornaDocumentos(Of tbTiposDocumento)(
                strQry,
                purchaseDocument.IDTipoDocumento,
                purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo,
                purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo,
                naturAtual)

            'Performance com tabela temporaria
            Dim strNomeTemp As String = "#tmp_IMP_" & ClsF3MSessao.RetornaUtilizadorID & "_" & Now.ToString("MMddyyyHHmmssfff")
            Dim strQTable As String = String.Concat("create Table ", strNomeTemp, " (ID BigInt null, ", COL_SEL, " bit null, ", COL_LOJA, " nvarchar(10) null, ", COL_DOC, " nvarchar(255) null, ", COL_NUMDOC, " bigint null, ", COL_VOSSONUMDOC, " nvarchar(256) null,                                          ", COL_TIPODOC, " nvarchar(256) null,                                               ", COL_DATADOC, " DateTime,                                             ", TIPO_DOC_SIST_ORIG, " nvarchar(255) null )")

            Dim appNomeBDEmpresa As String = ClsBaseDados.DaNomeBD(ClsF3MSessao.RetornaCodigoEmpresa)
            Dim strConexao As String = String.Concat(ChavesWebConfig.BD.ConnStrSemBD, appNomeBDEmpresa)
            Dim connection As SqlConnection = New SqlConnection(strConexao)
            connection.Open()
            Dim strinsert As String
            Dim sqlcmd As SqlCommand
            sqlcmd = New SqlCommand(strQTable, connection)
            sqlcmd.ExecuteNonQuery()

            If strQryTotal <> String.Empty Then
                strinsert = String.Concat("INSERT INTO ", strNomeTemp)
                strinsert = String.Concat(strinsert, " ", strQryTotal)
                sqlcmd = New SqlCommand(strinsert, connection)
                sqlcmd.ExecuteNonQuery()
            End If

            Dim strFinal As String = String.Concat(" SELECT * FROM ", strNomeTemp)
            Dim clskend As ClsKendoGridCliente = RepositorioDocImportacao.RetornaColunasDataTableConexion(req, strFinal, lstColsAux, connection)
            connection.Close()

            Return clskend
        End Function

        Public Overridable Function GetDocumentLinesToImport(req As DataSourceRequest, documentId As Long, selectedDocs As Long()) As ClsKendoGridCliente
            Dim purchaseDocument As tbDocumentosCompras = BDContexto.tbDocumentosCompras.FirstOrDefault(Function(entity) entity.ID = documentId)
            Dim purchaseDocumentLines As List(Of tbDocumentosComprasLinhas) = purchaseDocument.
                tbDocumentosComprasLinhas.
                Select(Function(s) New tbDocumentosComprasLinhas With {.IDLinhaDocumentoOrigem = s.IDLinhaDocumentoOrigem}).
                ToList()

            Dim naturAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaNaturezas?.Codigo
            Dim tpDocAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo
            Dim tpFiscalAtual As String = purchaseDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo
            Dim ivaIncluido As Boolean = purchaseDocument.tbTiposDocumentoSeries.IVAIncluido

            ' Colunas
            Dim lstColsAux As List(Of ClsF3MCampo) = RepositorioDocImportacao.RetornaColunasGrelhaDocLinhas(naturAtual, tpDocAtual, tpFiscalAtual, GetType(tbDocumentosComprasLinhas).Name)

            ' Doc IDs
            Dim strIDDoc As String = "(0)"
            If selectedDocs?.Any() Then
                Dim arrDocIDs As String() = selectedDocs.Select(Function(s) s.ToString()).ToArray()
                strIDDoc = String.Concat("(", String.Join(",", arrDocIDs), ")")
            End If

            ' Doc Linhas IDs
            Dim strIDLinhas As String = "(0)"
            If purchaseDocumentLines?.Any() Then
                If purchaseDocumentLines.Any(Function(e) e.IDLinhaDocumentoOrigem IsNot Nothing) Then
                    Dim arrDocLinIDs As String() = purchaseDocumentLines.Where(Function(e) e.IDLinhaDocumentoOrigem IsNot Nothing).Select(Function(s) s.IDLinhaDocumentoOrigem.ToString).ToArray()

                    If arrDocLinIDs.Count > 0 Then
                        strIDLinhas = String.Concat("(", String.Join(",", arrDocLinIDs), ")")
                    End If
                End If
            End If

            ' Doc Linhas Importadas do mm tipo
            Dim strQryTotal As String = RepositorioDocImportacao.RetornaDocLinhasQry(Of tbTiposDocumento)(
                GetType(tbDocumentosCompras), GetType(tbDocumentosComprasLinhas), CamposGenericos.IDDocCompra, naturAtual, tpDocAtual, tpFiscalAtual, strIDDoc, strIDLinhas, lstColsAux)

            Return RepositorioDocImportacao.RetornaColunasDataTable(req, strQryTotal, lstColsAux)
        End Function

    End Class
End Namespace
