Imports System.Data.Entity
Imports Kendo.Mvc.UI
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.Comum
Imports F3M.Modelos.Controlos
Imports F3M.Modelos.Grelhas
Imports F3M.Repositorio.DocumentosComum
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.BaseDados
Imports System.Data.SqlClient

Namespace Repositorio.BusinessDocuments
    Public Class SaleDocumentsRepository
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, Object)

        Public Const COL_SEL As String = "Selecionado"
        Public Const COL_LOJA As String = "Loja"
        Public Const COL_IDDOC As String = CamposGenericos.IDDocumento
        Public Const COL_DOC As String = CamposGenericos.Documento
        Public Const COL_NUMDOC As String = CamposGenericos.NumeroDocumento
        Public Const COL_VOSSONUMDOC As String = "VossoNumeroDocumento"
        Public Const COL_TIPODOC As String = "TipoDocumento"
        Public Const COL_NOME As String = CamposGenericos.Nome
        Public Const COL_DATADOC As String = CamposGenericos.DataDocumento

        Protected Const TIPO_FISC_ORIG As String = "TipoFiscalOrigem"
        Protected Const TIPO_DOC_SIST_ORIG As String = "CodigoSistemaTiposDocumento"
        Protected Const NATUR_ORIG As String = "NaturezaOrigem"


        Public Sub Assina(saleDocumentId As Long)
            Dim saleDocument As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(entity) entity.ID = saleDocumentId)

            If Not saleDocument Is Nothing Then
                Dim model As DocumentosVendas = GetD(saleDocument)

                Dim isTransf As Boolean = saleDocument.tbTiposDocumento.tbSistemaTiposDocumentoMovStock.Codigo = "004"
                Dim checkIfAssign As Boolean = RepositorioDocumentos.VerificaSeAssinado(Of tbTiposDocumento)(saleDocument.tbTiposDocumento)
                Dim atCom As Boolean = False
                Dim strDocOrigem = saleDocument.tbTiposDocumentoSeries.tbSistemaTiposDocumentoOrigem.Codigo
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
                    atCom = saleDocument.tbTiposDocumento.AcompanhaBensCirculacao

                    RepositorioDocumentos.AssinaDocumento(Of tbTiposDocumento, tbDocumentosVendas, tbEstados)(
                        BDContexto, model, saleDocument, saleDocument.tbTiposDocumento, AcoesFormulario.Alterar, NameOf(tbDocumentosVendas))

                    If Not String.IsNullOrEmpty(saleDocument.Assinatura) Then
                        saleDocument.DataAssinatura = model.DataAssinatura
                    End If
                End If

                If isTransf OrElse atCom Then
                    RepositorioDocumentos.PreencheDadosComunicacaoAT(Of tbTiposDocumento,
                      tbTiposDocumentoSeries,
                      tbDocumentosVendas,
                      tbEstados,
                      tbParametrosCamposContexto,
                      tbSistemaTiposDocumentoComunicacao,
                      tbATEstadoComunicacao)(BDContexto, model, saleDocument, NameOf(tbDocumentosVendas))
                End If

                saleDocument.MensagemDocAT = RepositorioDocumentos.TextoMsgAssinatura(
                    saleDocument.tbTiposDocumento,
                    True,
                    ClsF3MSessao.RetornaEmpresaDemonstracao,
                    False,
                    blnManual,
                    blnReposicao,
                    saleDocument.SerieDocManual,
                    saleDocument.NumeroDocManual,
                    saleDocument.Assinatura)

                ' Solicitar o código do documento AT, quando aplicável
                RepositorioDocumentos.SolicitaCodigoDocAT(Of tbTiposDocumento, tbTiposDocumentoSeries, tbEstados, tbParametrosCamposContexto, tbSistemaTiposDocumentoComunicacao)(
                    BDContexto, model, GetType(tbDocumentosVendas).Name)

                If RepositorioDocumentos.SeGeraQRCode(saleDocument) Then
                    RepositorioDocumentos.TrataQRCode(saleDocument, saleDocument.tbDocumentosVendasLinhas.ToList(), saleDocument.tbTiposDocumentoSeries.ATCodValidacaoSerie, False, saleDocument.Assinatura)
                End If

                BDContexto.Entry(saleDocument).State = EntityState.Modified
                BDContexto.SaveChanges()
            End If
        End Sub

        Private Function GetD(saleDocument As tbDocumentosVendas) As DocumentosVendas
            Return New DocumentosVendas With {
                .ID = saleDocument.ID,
                .Assinatura = saleDocument.Assinatura,
                .IDEstado = saleDocument.IDEstado,
                .DataDocumento = saleDocument.DataDocumento,
                .IDTipoDocumento = saleDocument.IDTipoDocumento,
                .IDTiposDocumentoSeries = saleDocument.IDTiposDocumentoSeries,
                .DataAssinatura = If(saleDocument.DataAssinatura Is Nothing, DateTime.Now, saleDocument.DataAssinatura),
                .CodigoTipoDocumentoSerie = saleDocument.tbTiposDocumentoSeries.CodigoSerie,
                .NumeroDocumento = saleDocument.NumeroDocumento,
                .TotalClienteMoedaReferencia = saleDocument.TotalMoedaReferencia
            }
        End Function

        Public Function GetDocumentsToImport(req As DataSourceRequest, documentId As Long) As ClsKendoGridCliente
            Dim saleDocument As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(entity) entity.ID = documentId)
            Dim saleDocumentLines As List(Of tbDocumentosVendasLinhas) = saleDocument.
                tbDocumentosVendasLinhas.
                Select(Function(s) New tbDocumentosVendasLinhas With {.IDLinhaDocumentoOrigem = s.IDLinhaDocumentoOrigem}).
                ToList()

            Dim naturAtual As String = saleDocument.tbTiposDocumento.tbSistemaNaturezas?.Codigo
            Dim tpDocAtual As String = saleDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo
            Dim tpFiscalAtual As String = saleDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo
            Dim ivaIncluido As Boolean = saleDocument.tbTiposDocumentoSeries.IVAIncluido

            ' Colunas
            Dim lstColsAux As List(Of ClsF3MCampo) = RepositorioDocImportacao.RetornaColunasGrelhaDocs()

            Dim strCond As String = String.Empty
            If ClsUtilitarios.RetornaZeroSeVazio(saleDocument.IDEntidade) > 0 Then
                strCond += String.Concat(" AND ", CamposGenericos.IDEntidade, "=", saleDocument.IDEntidade)
            End If

            If ClsUtilitarios.RetornaZeroSeVazio(saleDocument.IDMoeda) > 0 Then
                strCond += String.Concat(" AND IDMoeda=", saleDocument.IDMoeda)
            End If

            strCond = strCond & " AND d.IDTemp IS NULL AND ISNULL(d.AcaoTemp, 0) <> 1 AND d.AreaTemp = 1  "

            ' Doc Linhas IDs
            Dim strIDLinhas As String = "(0)"
            If saleDocumentLines?.Any() Then
                Dim arrDocLinIDs As String() = saleDocumentLines.Where(Function(f) f.IDLinhaDocumentoOrigem IsNot Nothing).Select(Function(s) CObj(s).IDLinhaDocumentoOrigem.ToString).ToArray

                If arrDocLinIDs.Any() Then
                    strIDLinhas = String.Concat("(", String.Join(",", arrDocLinIDs), ")")
                End If
            End If

            Dim strQry As String = RepositorioDocImportacao.RetornaDocsQry(Of tbTiposDocumento)(
                GetType(tbDocumentosVendas),
                GetType(tbDocumentosVendasLinhas), saleDocument.IDTipoDocumento,
                saleDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo,
                CamposGenericos.IDDocumentoVenda,
                naturAtual,
                tpDocAtual,
                tpFiscalAtual,
                strIDLinhas,
                ivaIncluido,
                strCond,
                lstColsAux)

            Dim strQryTotal As String = RepositorioDocImportacao.RetornaDocumentos(Of tbTiposDocumento)(
                strQry,
                saleDocument.IDTipoDocumento,
                saleDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo,
                saleDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo,
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
            Dim saleDocument As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(entity) entity.ID = documentId)
            Dim saleDocumentLines As List(Of tbDocumentosVendasLinhas) = saleDocument.
                tbDocumentosVendasLinhas.
                Select(Function(s) New tbDocumentosVendasLinhas With {.IDLinhaDocumentoOrigem = s.IDLinhaDocumentoOrigem}).
                ToList()

            Dim naturAtual As String = saleDocument.tbTiposDocumento.tbSistemaNaturezas?.Codigo
            Dim tpDocAtual As String = saleDocument.tbTiposDocumento.tbSistemaTiposDocumento?.Tipo
            Dim tpFiscalAtual As String = saleDocument.tbTiposDocumento.tbSistemaTiposDocumentoFiscal?.Tipo
            Dim ivaIncluido As Boolean = saleDocument.tbTiposDocumentoSeries.IVAIncluido

            ' Colunas
            Dim lstColsAux As List(Of ClsF3MCampo) = RepositorioDocImportacao.RetornaColunasGrelhaDocLinhas(naturAtual, tpDocAtual, tpFiscalAtual, GetType(tbDocumentosVendasLinhas).Name)

            ' Doc IDs
            Dim strIDDoc As String = "(0)"
            If selectedDocs?.Any() Then
                Dim arrDocIDs As String() = selectedDocs.Select(Function(s) s.ToString()).ToArray()
                strIDDoc = String.Concat("(", String.Join(",", arrDocIDs), ")")
            End If

            ' Doc Linhas IDs
            Dim strIDLinhas As String = "(0)"
            If saleDocumentLines?.Any() Then
                If saleDocumentLines.Any(Function(e) e.IDLinhaDocumentoOrigem IsNot Nothing) Then
                    Dim arrDocLinIDs As String() = saleDocumentLines.Where(Function(e) e.IDLinhaDocumentoOrigem IsNot Nothing).Select(Function(s) s.IDLinhaDocumentoOrigem.ToString).ToArray()

                    If arrDocLinIDs.Count > 0 Then
                        strIDLinhas = String.Concat("(", String.Join(",", arrDocLinIDs), ")")
                    End If
                End If
            End If

            ' Doc Linhas Importadas do mm tipo
            Dim strQryTotal As String = RepositorioDocImportacao.RetornaDocLinhasQry(Of tbTiposDocumento)(
                GetType(tbDocumentosVendas), GetType(tbDocumentosVendasLinhas), CamposGenericos.IDDocumentoVenda, naturAtual, tpDocAtual, tpFiscalAtual, strIDDoc, strIDLinhas, lstColsAux)

            Return RepositorioDocImportacao.RetornaColunasDataTable(req, strQryTotal, lstColsAux)
        End Function

    End Class
End Namespace
