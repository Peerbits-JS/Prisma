Imports Kendo.Mvc.UI
Imports F3M.Areas.Utilitarios.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.UtilitariosComum
Imports Oticas.Repositorio.Utilitarios

Namespace Areas.Utilitarios.Controllers
    Public Class SAFTPTController
        Inherits SAFTController(Of Oticas.BD.Dinamica.Aplicacao, Oticas.tbSAFT, Oticas.SAFTPT)

        ReadOnly _rpSaftPT As RepositorioSAFTPT

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioSAFTPT)

            _rpSaftPT = New RepositorioSAFTPT
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        ' GET: Index
        <F3MAcesso>
        Public Overrides Function Index(Optional vistaParcial As Boolean = False, Optional ByVal ID As Long = 0) As ActionResult
            ViewBag.VistaParcial = vistaParcial
            Dim saft As New F3M.SAFT With {.TipoSAFT = 1}
            If vistaParcial Then
                Return PartialView(saft)
            End If

            Return View(saft)
        End Function
#End Region

#Region "ACOES DEFAULT POST CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        <HttpPost>
        Public Overrides Function Adiciona(<DataSourceRequest> request As DataSourceRequest,
                                           <Bind> ByVal modelo As SAFTPT, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                If modelo IsNot Nothing Then
                    Dim listaSAFT As New List(Of F3M.SAFT)
                    listaSAFT.AddRange(GerarSAFT(modelo))

                    Dim attrsProd = FileVersionInfo.GetVersionInfo(System.Reflection.Assembly.GetExecutingAssembly().Location)
                    Dim CertAT As F3M.ImposicoesLegais.CertificadoAT = F3M.Modelos.ConstantesCertificacao.clsF3MCertApp.CertificadoAT(URLs.ProjetoOticas, True)

                    For Each SAFT In listaSAFT
#Region "AuditFile/HEADER"
                        RepositorioSAFT.ObtemVersaoSAFT(SAFT)
                        RepositorioSAFT.SetAuditFile(SAFT)
                        'Dim ListaPemp As List(Of tbParametrosEmpresa) = RepositorioSAFT.RetornaEmpresa(Of tbParametrosEmpresa)(repositorio.BDContexto)
                        'RepositorioSAFT.SetHeader(Of tbParametrosEmpresa)(SAFT, ListaPemp)
                        Dim ListaPloj As List(Of tbParametrosLoja) = RepositorioSAFT.RetornaLojaSede(Of tbParametrosLoja)(repositorio.BDContexto)
                        RepositorioSAFT.SetHeader(Of tbParametrosLoja)(SAFT, ListaPloj, attrsProd, CertAT)
#End Region

#Region "SOURCE DOCUMENTS"
#Region "SALES INVOICES"
                        Dim ListaDV As List(Of tbDocumentosVendas) = _rpSaftPT.GetFiscalSaleDocuments(repositorio.BDContexto, SAFT) 'RepositorioSAFT.RetornaDocs(Of tbDocumentosVendas)(repositorio.BDContexto, SAFT, True, False)
                        RepositorioSAFT.SetSalesInvoice(Of tbDocumentosVendas, tbDocumentosVendasLinhas, tbDocumentosVendas, tbDocumentosVendasFormasPagamento)(SAFT, ListaDV)
#Region "SALES INVOICES->MASTER FILES"
                        RepositorioSAFT.SetCustomers(Of tbDocumentosVendas, tbClientes)(SAFT, ListaDV, Nothing, Nothing)
                        Dim listaDVL As List(Of tbDocumentosVendasLinhas) = RepositorioSAFT.RetornaDocLinhas(Of tbDocumentosVendas, tbDocumentosVendasLinhas)(ListaDV)
                        RepositorioSAFT.SetProducts(Of tbDocumentosVendasLinhas)(SAFT, listaDVL)
                        RepositorioSAFT.SetTaxTable(Of tbDocumentosVendasLinhas)(SAFT, listaDVL)
#End Region
#End Region
#Region "PAYMENTS"
                        Dim ListaDR As List(Of tbRecibos) = _rpSaftPT.GetPayments(repositorio.BDContexto, SAFT)
                        RepositorioSAFT.SetPayments(Of tbRecibos, tbRecibosLinhas, tbRecibosLinhasTaxas, tbRecibosFormasPagamento)(SAFT, ListaDR)
#Region "PAYMENTS->MASTER FILES"
                            RepositorioSAFT.SetCustomers(Of tbRecibos, tbClientes)(SAFT, ListaDR, Nothing, Nothing)
#End Region
#End Region
#Region "MOVEMENTOFGOODS"
                        If SAFT.DocTransporte Then
                            Dim ListaDS As List(Of tbDocumentosStock) = _rpSaftPT.GetStockDocuments(repositorio.BDContexto, SAFT) 'RepositorioSAFT.RetornaDocs(Of tbDocumentosStock)(repositorio.BDContexto, SAFT, False, False)
                            Dim ListaDC As List(Of tbDocumentosCompras) = _rpSaftPT.GetPurchaseDocuments(repositorio.BDContexto, SAFT) 'RepositorioSAFT.RetornaDocs(Of tbDocumentosCompras)(repositorio.BDContexto, SAFT, False, False)
                            Dim ListaTR As New List(Of tbDocumentosCompras)
                            If ListaDC.Count > 0 Then
                                ListaTR.AddRange(ListaDC)
                            End If
                            If ListaDS.Count > 0 Then
                                For Each x In ListaDS
                                    Dim docC As tbDocumentosCompras = Activator.CreateInstance(GetType(tbDocumentosCompras))
                                    F3M.Repositorio.Comum.RepositorioDocumentos.Mapear(x, docC)

                                    Dim listaLinhas As New HashSet(Of tbDocumentosComprasLinhas)
                                    Dim hsDL As HashSet(Of tbDocumentosStockLinhas) = ClsUtilitarios.DaPropriedadedoModeloReflection(x, GetType(tbDocumentosStockLinhas).Name)

                                    If hsDL IsNot Nothing AndAlso hsDL.Count > 0 Then
                                        For Each docLin In hsDL
                                            'Dim docLinC As TDocCmpLinhas = Activator.CreateInstance(GetType(TDocCmpLinhas))
                                            'Comum.RepositorioDocumentos.Mapear(docLin, docLinC)
                                            Dim docLinC As tbDocumentosComprasLinhas = RepositorioSAFT.MapearDLEsp(Of tbDocumentosStockLinhas, tbDocumentosComprasLinhas)(docLin)
                                            listaLinhas.Add(docLinC)
                                        Next
                                    End If
                                    ClsUtilitarios.AtribuiPropriedadedoModeloReflection(docC, GetType(tbDocumentosComprasLinhas).Name, listaLinhas)
                                    ListaTR.Add(docC)
                                Next
                            End If
                            RepositorioSAFT.SetMovementOfGoods(Of tbDocumentosCompras, tbDocumentosComprasLinhas)(SAFT, ListaTR)
#Region "MOVEMENTOGOODS->MASTER FILES"
                            RepositorioSAFT.SetCustomers(Of tbDocumentosStock, tbClientes)(SAFT, ListaDS, Nothing, Nothing)
                            RepositorioSAFT.SetSuppliers(Of tbDocumentosCompras, tbFornecedores)(SAFT, ListaDC, Nothing, Nothing)
                            Dim listaTRL As List(Of tbDocumentosComprasLinhas) = RepositorioSAFT.RetornaDocLinhas(Of tbDocumentosCompras, tbDocumentosComprasLinhas)(ListaTR)
                            RepositorioSAFT.SetProducts(Of tbDocumentosComprasLinhas)(SAFT, listaTRL)
                            RepositorioSAFT.SetTaxTable(Of tbDocumentosComprasLinhas)(SAFT, listaTRL)
#End Region
                        End If
#End Region

#Region "WORKING DOCUMENTS"
                        Dim ListaWK As List(Of tbDocumentosVendas) = _rpSaftPT.GetSaleDocuments(repositorio.BDContexto, SAFT)  'RepositorioSAFT.RetornaDocs(Of tbDocumentosVendas)(repositorio.BDContexto, SAFT, True, True)
                        RepositorioSAFT.SetWorkingDocuments(Of tbDocumentosVendas, tbDocumentosVendasLinhas)(SAFT, ListaWK)
#Region "WORKING DOCUMENTS->MASTER FILES"
                        RepositorioSAFT.SetCustomers(Of tbDocumentosVendas, tbClientes)(SAFT, ListaWK, Nothing, Nothing)
                        Dim listaWKL As List(Of tbDocumentosVendasLinhas) = RepositorioSAFT.RetornaDocLinhas(Of tbDocumentosVendas, tbDocumentosVendasLinhas)(ListaWK)
                        RepositorioSAFT.SetProducts(Of tbDocumentosVendasLinhas)(SAFT, listaWKL)
                        RepositorioSAFT.SetTaxTable(Of tbDocumentosVendasLinhas)(SAFT, listaWKL)
#End Region
#End Region
#End Region
                        RepositorioSAFT.GerarFicheiroSAFT(SAFT)
                    Next



                    Dim lngCount As Long = 0
                    For Each SAFT In listaSAFT
                        Dim o As New Oticas.SAFTPT

                        RepositorioSAFTPT.Mapear(SAFT, o)
                        lngCount += 1

                        If Not ClsTexto.ENuloOuVazio(SAFT.Ficheiro) Then
                            If lngCount = listaSAFT.Count Then
                                Return ExecutaAcoes(request, o, inObjFiltro, AcoesFormulario.Adicionar)
                            Else
                                ExecutaAcoes(request, o, inObjFiltro, AcoesFormulario.Adicionar)
                            End If
                        Else
                            Throw New Exception("Erro a guardar SAFT!")
                        End If
                    Next
                End If

                Return Nothing
            Catch ex As Exception
                Return RetornaJSONErrosTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "ACOES DE LEITURA"

#End Region

#Region "Auxilares"
        Private Function GerarSAFT(inSAFT As F3M.SAFT) As List(Of F3M.SAFT)
            Dim ListaSAFT As New List(Of F3M.SAFT)
            If inSAFT IsNot Nothing Then
                Dim strIDLojaSede As String = ClsF3MSessao.RetornaIDLojaSede
                Dim idLojaSede As Long = CLng(If(strIDLojaSede = String.Empty, "0", strIDLojaSede))
                Dim ctx As New F3M.F3MGeralEntities
                Dim arrayOfLojas As New List(Of Long)
                arrayOfLojas = ctx.tbLojas.Where(Function(w) w.IDLojaSede = idLojaSede).Select(Function(s) s.ID).ToList
                If inSAFT.Desagregar Then
                    For Each idloja In arrayOfLojas
                        Dim SAFTNovo As New F3M.SAFT With {
                            .IDLoja = idloja,
                            .DataInicio = inSAFT.DataInicio,
                            .DataFim = inSAFT.DataFim,
                            .TipoSAFT = inSAFT.TipoSAFT,
                            .DocTransporte = inSAFT.DocTransporte}
                        ListaSAFT.Add(SAFTNovo)
                    Next
                Else
                    inSAFT.ListaLojas = New List(Of Long)
                    inSAFT.ListaLojas.AddRange(arrayOfLojas)
                    ListaSAFT.Add(inSAFT)
                End If
            End If





            'If inSAFTModelo.IDLoja IsNot Nothing Then
            '    arrayOfLojas = ctx.tbLojas.Where(Function(w) w.ID = inSAFTModelo.IDLoja).Select(Function(s) s.ID).ToList
            'ElseIf idLoja > 0 Then
            '    arrayOfLojas = ctx.tbLojas.Where(Function(w) w.IDLojaSede = idLoja).Select(Function(s) s.ID).ToList
            'End If


            Return ListaSAFT

        End Function
#End Region

    End Class
End Namespace
