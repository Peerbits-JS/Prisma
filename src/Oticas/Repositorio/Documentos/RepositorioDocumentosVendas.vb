Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports F3M.Repositorio.TabelasAuxiliaresComum
Imports Oticas.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Repositorio.Administracao
Imports F3M.Repositorios.Administracao
Imports Oticas.BD.Dinamica
Imports F3M.Models.Communication
Imports F3M.Modelos.Excepcoes.Tipo

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosVendas
        Inherits RepositorioDocumentos(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendas)

        Private Shared codigoAcesso As String = "015.005.003"

        Dim EMultiEmpresa As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Dim intCasasDecTotais As Integer = 0
        Dim intCasasDecImposto As Integer = 0
        Dim intCasasDecPrecosUnitarios As Integer = 0
        Dim lngIDTaxaIVA As Long = 2
        Dim dblTaxaIVA As Double = 6

        Dim ELinhasTodas As Boolean = True
        Dim EServicosChangeEntidade As Boolean = False
        Dim lstConfigDesconto As List(Of IVA) = Nothing
        Dim lstArtigosCalcula As List(Of tbArtigos) = Nothing
        Dim campoAlteradoDTD As String = String.Empty

        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosVendas)
            Dim query As IQueryable(Of Oticas.DocumentosVendas) = AplicaQueryListaPersonalizada(inFiltro)
            Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))

            If IDEntidade <> 0 Then
                query = query.Where(Function(w) w.IDEntidade = IDEntidade)
            End If

            Dim IDEntidadeFromHistorico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEntidadeFromHistorico", GetType(Long))
            If IDEntidadeFromHistorico <> 0 Then
                query = query.Where(Function(f) f.IDEntidade = IDEntidadeFromHistorico)
            End If

            'TODO VER +
            Dim lngIDSistTD As Long = RepositorioTipoDoc.RetornaSistTipoDoc(Of tbTiposDocumento)(New BD.Dinamica.Aplicacao, TiposSistemaTiposDocumento.VendasServico)
            If lngIDSistTD <> 0 Then
                query = query.Where(Function(f) f.IDSistemaTiposDocumento <> lngIDSistTD)
            End If
            'END TODO

            Dim FromHistorico As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "FromHistorico", GetType(Boolean))
            Dim IgnoraAcessoPorLoja As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IgnoraAcessoPorLoja", GetType(Boolean))
            If Not FromHistorico AndAlso Not IgnoraAcessoPorLoja AndAlso Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, codigoAcesso) Then
                query = query.Where(Function(f) f.IDLoja = ClsF3MSessao.RetornaLojaID)
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)

            Return query
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbDocumentosVendas)) As IQueryable(Of Oticas.DocumentosVendas)
            Dim funcSel As Func(Of tbDocumentosVendas, Oticas.DocumentosVendas) = Function(s) MapeiaEsp(s)

            Return query.Select(funcSel).AsQueryable
        End Function

        Public Function MapeiaEsp(inDocBD As tbDocumentosVendas) As Oticas.DocumentosVendas
            If inDocBD IsNot Nothing Then
                Dim docMOD As New Oticas.DocumentosVendas
                Dim docMODCA As New tbSistemaTiposDocumentoColunasAutomaticas
                ' Mapeia Generico
                RepositorioDocumentos.MapeiaCamposGen(Of tbDocumentosVendas, Oticas.DocumentosVendas, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosVendasLinhas, Oticas.DocumentosVendasLinhas)(inDocBD, docMOD, docMODCA)
                ' Mapeia Especifico
                With docMOD
                    .SubTotal = inDocBD.SubTotal
                    .CodigoMoeda = inDocBD.CodigoMoeda
                    .CodigoTipoEstado = inDocBD.CodigoTipoEstado
                    .DescontosLinha = inDocBD.DescontosLinha
                    .TotalIva = inDocBD.TotalIva
                    .CodigoPostalFiscal = inDocBD.CodigoPostalFiscal
                    .SegundaVia = inDocBD.SegundaVia
                    .TotalClienteMoedaDocumento = inDocBD.TotalClienteMoedaDocumento
                    .TotalClienteMoedaReferencia = inDocBD.TotalClienteMoedaReferencia
                    .CodigoTipoDocumento = inDocBD.tbTiposDocumento.Codigo
                    .Adiantamento = inDocBD.tbTiposDocumento.Adiantamento
                    .TipoFiscal = If(inDocBD.tbTiposDocumento IsNot Nothing,
                                     If(inDocBD.tbTiposDocumento.tbSistemaTiposDocumentoFiscal IsNot Nothing,
                                        inDocBD.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo, String.Empty), String.Empty)
                    .CodigoCliente = inDocBD.tbClientes?.Codigo
                    .Adiantamento = inDocBD.tbTiposDocumento.Adiantamento
                    .DescricaoSplitterLadoDireito = inDocBD.Documento

                    .IDSistemaTiposDocumento = If(inDocBD.tbTiposDocumento.tbSistemaTiposDocumento IsNot Nothing,
                                                  inDocBD.tbTiposDocumento.tbSistemaTiposDocumento.ID, Nothing)
                    .DataNascimento = inDocBD.DataNascimento
                    .Idade = inDocBD.Idade
                    .ContatoPreferencial = String.Empty
                    .SimboloMoedaRef = If(inDocBD.tbMoedas IsNot Nothing, inDocBD.tbMoedas.Simbolo, String.Empty)
                    .DescricaoTipoEstado = If(inDocBD.tbEstados IsNot Nothing,
                                              If(inDocBD.tbEstados.tbSistemaTiposEstados IsNot Nothing,
                                                 inDocBD.tbEstados.tbSistemaTiposEstados.Descricao, String.Empty), String.Empty)
                    .OutrosDescontos = inDocBD.OutrosDescontos
                    .TotalPontos = inDocBD.TotalPontos
                    .TotalValesOferta = inDocBD.TotalValesOferta
                    .TotalEntidade1 = inDocBD.TotalEntidade1
                    .TotalEntidade2 = inDocBD.TotalEntidade2
                    .IDEntidade1 = inDocBD.IDEntidade1
                    .DescricaoEntidade1 = If(inDocBD.tbEntidades IsNot Nothing, inDocBD.tbEntidades.Descricao, String.Empty)
                    .Entidade1Automatica = inDocBD.Entidade1Automatica
                    .NumeroBeneficiario1 = inDocBD.NumeroBeneficiario1
                    .Parentesco1 = inDocBD.Parentesco1
                    .IDEntidade2 = inDocBD.IDEntidade2
                    .DescricaoEntidade2 = If(inDocBD.tbEntidades1 IsNot Nothing, inDocBD.tbEntidades1.Descricao, String.Empty)
                    .NumeroBeneficiario2 = inDocBD.NumeroBeneficiario2
                    .Parentesco2 = inDocBD.Parentesco2
                    .ValorPago = inDocBD.ValorPago
                    .ValorPendente = (inDocBD.TotalMoedaDocumento - inDocBD.ValorPago)
                    .RazaoEstado = inDocBD.RazaoEstado

                    Dim ctx As BD.Dinamica.Aplicacao = Activator.CreateInstance(GetType(BD.Dinamica.Aplicacao))
                    .RegistoBloqueado = RepositorioDocumentos.RegistoBloqueadoVendas(ctx, inDocBD.ID, inDocBD.IDTipoDocumento)
                End With

                'TODO VER +
                PreencheLinhas(docMOD)

                Return docMOD
            End If

            Return Nothing
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbDocumentosVendas)) As IQueryable(Of Oticas.DocumentosVendas)
            Using repD As New RepositorioDocumentos
                Return repD.MapeiaLista(Of tbDocumentosVendas, Oticas.DocumentosVendas, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosVendasLinhas, Oticas.DocumentosVendasLinhas)(inQuery, True)
            End Using
        End Function
        ' LISTA ESPECIFICOS
        ' FILTRA ESP
        Protected Function FiltraQueryEsp(inFiltro As ClsF3MFiltro) As IQueryable(Of tbDocumentosVendas)
            Dim query As IQueryable(Of tbDocumentosVendas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            AplicaFiltroAtivo(inFiltro, query)

            Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))
            If IDEntidade <> 0 Then
                Return query.Where(Function(w) w.IDEntidade = IDEntidade)
            End If

            Dim IDEntidadeFromHistorico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEntidadeFromHistorico", GetType(Long))
            If IDEntidadeFromHistorico <> 0 Then
                Return query.Where(Function(f) f.IDEntidade = IDEntidadeFromHistorico)
            End If

            Return query
        End Function

        Public Function ListaEsp(inFiltro As ClsF3MFiltro) As List(Of DocumentosVendas)
            Return ListaCamposTodosEsp(FiltraQueryEsp(inFiltro))
        End Function

        Protected Function ListaCamposTodosEsp(inQuery As IQueryable(Of tbDocumentosVendas)) As List(Of DocumentosVendas)
            Dim lngIDSistTD As Long = RepositorioTipoDoc.RetornaSistTipoDoc(Of tbTiposDocumento)(
                New Oticas.BD.Dinamica.Aplicacao, TiposSistemaTiposDocumento.VendasFinanceiro)

            Return ListaCamposTodos(inQuery.Where(Function(f) f.tbTiposDocumento.IDSistemaTiposDocumento = lngIDSistTD)).ToList
        End Function

        Public Function ListaEspByID(inFiltro As ClsF3MFiltro) As List(Of DocumentosVendas)
            Dim query As IQueryable(Of tbDocumentosVendas) = tabela.AsNoTracking
            Dim IDDocumentoVendas As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDDocumentoVendaAux", GetType(Long))

            If IDDocumentoVendas <> 0 Then
                query = query.Where(Function(f) f.ID = IDDocumentoVendas)
            End If

            Return ListaCamposTodosEsp(query)
        End Function

        Public Function Importar(inObjFiltro As ClsF3MFiltro) As DocumentosVendas
            Dim DocVendas As New DocumentosVendas
            Dim DocImportacao As New Object

            Dim iddocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "iddocumento", GetType(Long))
            Dim tipodocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "tipodocumento", GetType(Long))

            Dim lngId As Long = GetIDTipoDocumentoServico()
            If (iddocumento > 0 AndAlso tipodocumento > 0) Then

                Select Case tipodocumento
                    Case lngId
                        Dim EstadoEFT As New F3M.Estados
                        Dim ArmazemPorDefeito As New tbArmazensLocalizacoes

                        Using rep As New RepositorioDocumentosVendasServicos
                            'DocImportacao = rep.ListaEsp(inObjFiltro).Where(Function(f) f.ID = iddocumento).FirstOrDefault()
                            DocImportacao = BDContexto.Database.SqlQuery(Of DocumentosVendasServicos)("select * from tbdocumentosvendas where id=" & iddocumento).AsQueryable.FirstOrDefault()

                            rep.PreencheSubServicos(DocImportacao)
                            Mapear(DocImportacao, DocVendas)

                            DocVendas.DescricaoEntidade = DocVendas.NomeFiscal

                            'COMO VEM DOS SERVIÇOS ATRIBUI O ESTADO EFETIVO!
                            Using rpEstados As New Repositorio.TabelasAuxiliares.RepositorioEstados
                                EstadoEFT = rpEstados.RetornaEstadoByEntidadeETipoEstado(TiposEntidadeEstados.DocumentosVenda, TiposEstados.Efetivo)

                                If EstadoEFT Is Nothing Then EstadoEFT = rpEstados.ValorInicial(True, TiposEntidadeEstados.DocumentosVenda)
                            End Using

                            With DocVendas
                                .DocumentosVendasLinhas = DirectCast(DocImportacao, DocumentosVendasServicos).Servicos.SelectMany(Function(s) s.DocumentosVendasLinhas).Where(Function(t) t.Descricao IsNot Nothing).ToList
                                .DocumentosVendasLinhas.AddRange(DocImportacao.Diversos)

                                If Not EstadoEFT Is Nothing Then
                                    .IDEstado = EstadoEFT.ID : .DescricaoEstado = EstadoEFT.Descricao : .CodigoTipoEstado = EstadoEFT.CodigoTipoEstado
                                End If
                            End With
                            'END ESTADOS

                            Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
                            If IsNumeric(strIDLoc) AndAlso strIDLoc <> 0 Then
                                ArmazemPorDefeito = BDContexto.tbArmazensLocalizacoes.Where(Function(w) w.ID = strIDLoc).FirstOrDefault()
                            End If

                            Dim intOrdem As Integer = 1
                            For Each DVL In DocVendas.DocumentosVendasLinhas
                                With DVL
                                    'reset values
                                    .AcaoCRUD = AcoesFormulario.Adicionar : .IDDocumentoVenda = CLng(0) : .IDServico = Nothing
                                    .Diametro = Nothing : .IDModelo = Nothing : .IDTipoLente = Nothing : .IDTipoOlho = Nothing : .IDTratamentoLente = Nothing : .IDTipoGraduacao = Nothing
                                    .IDEstado = Nothing

                                    'doc origem
                                    .IDLinhaDocumentoOrigem = .ID
                                    .IDDocumentoOrigem = iddocumento : .IDTipoDocumentoOrigem = tipodocumento
                                    .DocumentoOrigem = DocVendas.Documento : .DataDocOrigem = DocVendas.DataDocumento

                                    'armazem
                                    .IDArmazem = ArmazemPorDefeito?.IDArmazem : .DescricaoArmazem = ArmazemPorDefeito?.tbArmazens?.Descricao
                                    .IDArmazemLocalizacao = ArmazemPorDefeito?.ID : .CodigoArmazemLocalizacao = ArmazemPorDefeito?.Codigo : .DescricaoArmazemLocalizacao = ArmazemPorDefeito?.Descricao

                                    'ordem e id
                                    .Ordem = intOrdem : .ID = CLng(0)
                                End With

                                intOrdem += 1
                            Next

                            DocVendas.Entidade1Automatica = False
                        End Using
                    Case Else
                        Using rep As New RepositorioDocumentosVendas

                            DocImportacao = New List(Of DocumentosVendas)

                            DocImportacao = BDContexto.Database.SqlQuery(Of DocumentosVendasServicos)("select * from tbDocumentosVendas where id=" & iddocumento).AsQueryable.FirstOrDefault()

                            Mapear(DocImportacao, DocVendas)
                            rep.PreencheLinhasNC(DocVendas)

                            DocVendas.DescricaoEntidade = DocVendas.NomeFiscal

                            Dim intOrdem As Integer = 1
                            For Each DVL In DocVendas.DocumentosVendasLinhas
                                With DVL
                                    'reset values
                                    .AcaoCRUD = AcoesFormulario.Adicionar : .IDDocumentoVenda = CLng(0) : .IDServico = Nothing
                                    .Diametro = Nothing : .IDModelo = Nothing : .IDTipoLente = Nothing : .IDTipoOlho = Nothing : .IDTratamentoLente = Nothing : .IDTipoGraduacao = Nothing
                                    .IDEstado = Nothing

                                    'doc origem
                                    .IDLinhaDocumentoOrigem = .ID
                                    .IDDocumentoOrigem = iddocumento : .IDTipoDocumentoOrigem = tipodocumento
                                    .DocumentoOrigem = DocVendas.Documento : .DataDocOrigem = DocVendas.DataDocumento

                                    'ordem e id
                                    .Ordem = intOrdem : .ID = CLng(0)
                                End With

                                intOrdem += 1
                            Next

                            DocVendas.Entidade1Automatica = False
                        End Using
                End Select

                Calcula(inObjFiltro, DocVendas)
            End If

            Return DocVendas
        End Function

        ''' <summary>
        ''' Function that returns document sale nca id from document sale 
        ''' </summary>
        ''' <param name="DocumentSaleId"></param>
        ''' <returns></returns>
        Protected Friend Function GetDocumentSaleNcaId(DocumentSaleId As Long) As Long
            Dim reciboId As Long = BDContexto.tbRecibosLinhas.Where(Function(w) w.IDDocumentoVenda = DocumentSaleId).Select(Function(s) s.IDRecibo).FirstOrDefault()
            Dim DocumentSaleNcaId As Long = BDContexto.tbRecibosLinhas.
                Where(Function(w) w.IDRecibo = reciboId AndAlso
                w.IDDocumentoVenda <> DocumentSaleId AndAlso
                w.tbDocumentosVendas.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito AndAlso
                w.tbDocumentosVendas.tbTiposDocumento.Adiantamento = True AndAlso
                w.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo).
                Select(Function(s) s.tbDocumentosVendas.ID).FirstOrDefault()

            If DocumentSaleNcaId = 0 Then
                Dim IDDocumentoVendaServico As Long? = (From x In BDContexto.tbDocumentosVendasLinhas
                                                        Where x.IDDocumentoVenda = DocumentSaleId
                                                        Select x.IDDocumentoOrigem).FirstOrDefault()

                If IDDocumentoVendaServico IsNot Nothing AndAlso IDDocumentoVendaServico <> 0 Then
                    DocumentSaleNcaId = GetNCDAByIDDocumentoVendaServico(IDDocumentoVendaServico)
                End If
            End If

            Return DocumentSaleNcaId
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef inModelo As Oticas.DocumentosVendas, inFiltro As ClsF3MFiltro)
            Try
                Dim ctx As Aplicacao = Activator.CreateInstance(GetType(Aplicacao))

                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                    Try
                        Dim IdDocOrigem? As Long = inModelo.IdDocOrigem
                        If Not IdDocOrigem Is Nothing Then
                            Dim docOrigem As tbDocumentosVendas = ctx.tbDocumentosVendas.FirstOrDefault(Function(entity) entity.ID = IdDocOrigem)
                            If Not docOrigem Is Nothing Then
                                If VerificaSeJaExisteDocumentoAssociado(inModelo, docOrigem) Then Throw New Exception(Traducao.EstruturaDeErrosIX.IX_tbDocumentosVendas_Chave)
                                AtualizaPropsDocOrigem(ctx, docOrigem)
                            End If
                        End If

                        Dim GerouNC As Boolean = False
                        Dim IDDocumentoVendaOrigem As Long
                        Dim TotalNC As Double = CDbl(0)
                        Dim IDTipoDocumento As Long = inModelo.IDTipoDocumento
                        Dim GereCaixasBancos As Boolean = False

                        inModelo.GeraPendente = ctx.tbTiposDocumento.
                                        Where(Function(w) w.ID = IDTipoDocumento).
                                        Select(Function(s) s.GeraPendente).FirstOrDefault()

                        GereCaixasBancos = ctx.tbTiposDocumento.
                                        Where(Function(w) w.ID = IDTipoDocumento).
                                        Select(Function(s) s.GereCaixasBancos).FirstOrDefault()

                        GeraNCAdiantamentosWithTransaction(ctx, inModelo, inFiltro, GerouNC, IDDocumentoVendaOrigem, TotalNC)
                        GeraDocVendaWithTransaction(ctx, inModelo, inFiltro)

                        If GerouNC AndAlso inModelo.TotalClienteMoedaDocumento >= TotalNC Then 'VERIFICA SE O TOTAL A PAGAR É >= AO VALOR DOS ADIANTAMENTOS (TotalNC)
                            GeraDocVendaPendenteWithTransaction(ctx, inModelo, inModelo.TotalClienteMoedaDocumento)

                            If GerouNC AndAlso inModelo.GeraPendente Then
                                PreencheRecibo(ctx, inModelo, GerouNC, IDDocumentoVendaOrigem, TotalNC, inModelo.TotalMoedaDocumento)

                                If Not inModelo.NCDA_CLI_DIFF Is Nothing Then
                                    Using rpPagamentosVendas As New RepositorioPagamentosVendas
                                        rpPagamentosVendas.PreencheGeraPagamentos_NCDA_CLI_DIFF(ctx, inModelo, GerouNC, IDDocumentoVendaOrigem, TotalNC)
                                    End Using
                                End If

                            Else
                                Using rpPagamentosVendas As New RepositorioPagamentosVendas
                                    rpPagamentosVendas.PreencheGeraPagamentos_NCDA(ctx, inModelo, GerouNC, IDDocumentoVendaOrigem, TotalNC)
                                End Using

                                GravaPagamentosWithTransaction(ctx, inModelo, inFiltro)
                            End If

                            trans.Commit()

                        ElseIf inModelo.TotalClienteMoedaDocumento < TotalNC Then
                            Throw New Exception(Traducao.EstruturaErros.ValorDocumentoInferiorAdiantamentosEfetuados)

                        Else
                            If inModelo.CodigoSistemaTiposDocumento = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso inModelo.TipoFiscal IsNot Nothing AndAlso inModelo.TipoFiscal <> TiposDocumentosFiscal.FaturaProforma Then
                                If inModelo.GeraPendente = False AndAlso GereCaixasBancos = False Then
                                Else
                                    GeraDocVendaPendenteWithTransaction(ctx, inModelo, inModelo.TotalClienteMoedaDocumento)
                                    GravaPagamentosWithTransaction(ctx, inModelo, inFiltro)
                                End If
                            End If

                            trans.Commit()
                        End If
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            Catch
                Throw
            End Try
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef inModelo As Oticas.DocumentosVendas, inFiltro As ClsF3MFiltro)
            Dim strQry As String = String.Empty
            Dim blnAtualizaCC As Boolean = False
            Dim blnAtualizaCX As Boolean = False
            Dim blnAtualizaStock As Boolean = False
            Dim docBD As tbDocumentosVendas = BDContexto.tbDocumentosVendas.Find(inModelo.ID)
            Dim strAssinatura As String = String.Empty
            Dim strMo As String = String.Empty
            Dim strMe As String = String.Empty
            Dim lngIDestado As Long = 0
            Dim lngIDestadoNovo As Long = 0
            Dim numAnterior As Long = 0

            If docBD IsNot Nothing Then
                strAssinatura = docBD.Assinatura
                lngIDestado = docBD.IDEstado
                strMe = Convert.ToBase64String(docBD.F3MMarcador)
            End If
            strMo = inModelo.Concorrencia
            lngIDestadoNovo = inModelo.IDEstado

            If strMo <> strMe Then
                If lngIDestadoNovo = lngIDestado Then
                    ValidarConcorrencia(AcoesFormulario.Alterar, inModelo, docBD)
                Else
                    Throw New Exception(Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada)
                End If
            End If

            Using inCtx As New BD.Dinamica.Aplicacao
                ValidarDocumento(inCtx, inModelo)

                If strAssinatura <> String.Empty AndAlso inModelo.Assinatura <> strAssinatura Then
                    Throw New Exception(Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada)
                End If

                Using trans As DbContextTransaction = inCtx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                    Try
                        Dim e As tbDocumentosVendas = inCtx.tbDocumentosVendas.Find(inModelo.ID)
                        numAnterior = ClsUtilitarios.RetornaZeroSeVazio(e.NumeroDocumento)

                        If e IsNot Nothing Then
                            Dim blnAnulado As Boolean = RepositorioDocumentosVendas.EAnulado(inCtx, inModelo.IDEstado)
                            If strAssinatura = String.Empty AndAlso Not blnAnulado Then
                                Dim blnEfetivo As Boolean = RepositorioDocumentosVendas.EEfetivo(inCtx, inModelo.IDEstado)
                                Calcula(Nothing, inModelo)

                                Dim lngID As Long = inModelo.IDTipoDocumento
                                Dim lngIDSerie As Long = inModelo.IDTiposDocumentoSeries
                                Dim CodigoTipoDocumento As String = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.Codigo

                                Dim ERasc As Boolean = RepositorioDocumentos.ERascunho(Of tbEstados)(inCtx, inModelo)
                                Dim docSerie As tbTiposDocumentoSeries = RepositorioDocumentos.EditaDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries, tbEstados)(inCtx, inModelo, e, inFiltro)
                                With inModelo
                                    .ExecutaListaCamposEvitaMapear = True
                                    .ListaCamposEvitaMapear = New List(Of String)
                                    .ListaCamposEvitaMapear.Add("ValorPago")
                                    .ListaCamposEvitaMapear.Add("NumeroDocumento")
                                    .ListaCamposEvitaMapear.Add("CodigoDocOrigem")
                                    .ListaCamposEvitaMapear.Add("IDLoja")
                                    .ListaCamposEvitaMapear.Add("IDLojaSede")

                                    If .ContribuinteFiscal IsNot Nothing AndAlso .ContribuinteFiscal.Replace(" ", "") = CamposGenericos.NIFDesconhecido Then
                                        .ContribuinteFiscal = Traducao.EstruturaAplicacaoTermosBase.ConsumidorFinal
                                    End If
                                    .TipoFiscal = e.TipoFiscal
                                End With

                                Mapear(inModelo, e)
                                PreeEntDadosUtilizador(e, inModelo.ID, AcoesFormulario.Alterar)

                                GravaLinhasTodas(inCtx, inModelo, e, AcoesFormulario.Alterar)

                                RepositorioDocumentos.DefineNumeroDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries)(inCtx, inModelo, docSerie, ERasc, numAnterior)

                                With e
                                    .NumeroDocumento = inModelo.NumeroDocumento
                                    .Documento = String.Concat(docSerie.tbTiposDocumento.Codigo, " ", docSerie.CodigoSerie, "/", e.NumeroDocumento)
                                End With

                                Dim tbdvp = e.tbDocumentosVendasPendentes.FirstOrDefault
                                If tbdvp IsNot Nothing Then
                                    tbdvp.Documento = e.Documento
                                    tbdvp.TotalMoedaDocumento = e.TotalMoedaDocumento
                                    tbdvp.TotalMoedaReferencia = e.TotalMoedaReferencia
                                    tbdvp.TotalClienteMoedaReferencia = e.TotalClienteMoedaReferencia
                                    tbdvp.TotalClienteMoedaDocumento = e.TotalClienteMoedaDocumento
                                    tbdvp.ValorPendente = e.TotalClienteMoedaDocumento
                                    tbdvp.NumeroDocumento = e.NumeroDocumento
                                End If

                                'HERE CERTIFICACAO!
                                If blnEfetivo Then
                                    Dim IDEmp As Long = CLng(ClsF3MSessao.RetornaLojaID)
                                    Dim Emp As ParametrosLoja = (From x In BDContexto.tbParametrosLoja
                                                                 Where x.IDLoja = IDEmp
                                                                 Select New ParametrosLoja With {.ID = x.ID, .CodigoPostal = x.CodigoPostal,
                                                                                                        .Localidade = x.Localidade, .NIF = x.NIF,
                                                                                                        .DesignacaoComercial = x.DesignacaoComercial,
                                                                                                        .Morada = x.Morada}).FirstOrDefault()

                                    With e
                                        .CodigoPostalLoja = Emp.CodigoPostal
                                        .LocalidadeLoja = Emp.Localidade
                                        .SiglaLoja = ClsF3MSessao.RetornaParametros.SiglaPais()
                                        .NIFLoja = Emp.NIF
                                        .DesignacaoComercialLoja = Emp.DesignacaoComercial
                                        .MoradaLoja = Emp.Morada
                                    End With
                                End If
                                'END CERTIFICACAO!

                                inCtx.Entry(e).State = EntityState.Modified
                                inCtx.SaveChanges()

                                If blnEfetivo Then

                                    Dim IDDocumentoVenda As Long = inModelo.ID
                                    inModelo.IDDocumentoVendaPendente = (From x In inCtx.tbDocumentosVendasPendentes Where x.IDDocumentoVenda = IDDocumentoVenda Select x.ID).FirstOrDefault()
                                    GravaPagamentosWithTransaction(inCtx, inModelo, inFiltro)

                                    Dim TDS = inCtx.tbTiposDocumentoSeries.Where(Function(f) f.ID = lngIDSerie).FirstOrDefault()

                                    Dim CodigoSerie As String = String.Empty
                                    Dim strDocOrigem As String = String.Empty
                                    Dim lngIDDocOrigem As Long = 0

                                    Dim blnManual As Boolean = False
                                    Dim blnReposicao As Boolean = False

                                    With TDS
                                        CodigoSerie = .CodigoSerie
                                        lngIDDocOrigem = .IDSistemaTiposDocumentoOrigem
                                        strDocOrigem = inCtx.tbSistemaTiposDocumentoOrigem.Where(Function(f) f.ID = lngIDDocOrigem).FirstOrDefault.Codigo
                                    End With

                                    If strDocOrigem = F3M.Modelos.Constantes.TiposDocumentosOrigem.Manual Then
                                        blnManual = True
                                        blnReposicao = False
                                    ElseIf strDocOrigem = F3M.Modelos.Constantes.TiposDocumentosOrigem.Reposicao Then
                                        blnManual = False
                                        blnReposicao = True
                                    Else
                                        blnManual = False
                                        blnReposicao = False
                                    End If

                                    blnAtualizaCC = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereContaCorrente
                                    blnAtualizaCX = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereCaixasBancos
                                    blnAtualizaStock = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereStock

                                    Dim tipoDoc As String = docSerie.tbTiposDocumento.tbSistemaTiposDocumento.Tipo
                                    Dim tipoDocFiscal As String = docSerie.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo

                                    Dim assinaDocumento As Boolean =
                                        (tipoDoc = TiposSistemaTiposDocumento.VendasTransporte AndAlso (tipoDocFiscal = TiposDocumentosFiscal.GuiaRemessa OrElse tipoDocFiscal = TiposDocumentosFiscal.GuiaTransporte)) OrElse
                                        (tipoDoc = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso tipoDocFiscal <> TiposDocumentosFiscal.NaoFiscal) OrElse
                                        (tipoDoc = TiposSistemaTiposDocumento.VendasOrcamento) OrElse
                                        (tipoDoc = TiposSistemaTiposDocumento.VendasEncomenda)

                                    If assinaDocumento Then
                                        ' Guardar a informação necessária à geração da assinatura e à comunicação à AT
                                        inModelo.CodigoTipoDocumentoSerie = e.tbTiposDocumentoSeries?.CodigoSerie
                                        inModelo.CodigoTipoDocumento = e.tbTiposDocumento.Codigo
                                        inModelo.DescricaoTipoDocumento = e.tbTiposDocumento.Descricao

                                        'Assinatura
                                        Dim at As New F3M.ImposicoesLegais.AssinaturaAT With {
                                            .dtData = inModelo.DataDocumento,
                                            .IDTipoDocumento = inModelo.IDTipoDocumento,
                                            .IDTiposDocumentoSeries = inModelo.IDTiposDocumentoSeries,
                                            .dtDataRegisto = inModelo.DataAssinatura,
                                            .strTipoDocumento = CodigoTipoDocumento,
                                            .strSerie = CodigoSerie,
                                            .strNumDocumento = e.NumeroDocumento,
                                            .strGrossTotal = Format(If(inModelo.TotalMoedaReferencia Is Nothing, 0, inModelo.TotalMoedaReferencia), "0.00").Replace(",", "."),
                                            .strTabela = "tbDocumentosVendas"
                                        }

                                        F3M.ImposicoesLegais.ClsF3MAssinaturasAT.GerarAssinatura(inCtx, e.ID, ClsF3MSessao.RetornaEmpresaID, at, F3M.Modelos.ConstantesCertificacao.clsF3MCertApp.CertificadoAT(Nothing, True))

                                        Dim strMensagem As String = TextoMensagemAssinatura(inCtx, True, ClsF3MSessao.RetornaEmpresaDemonstracao, False, blnManual, blnReposicao, e.SerieDocManual, e.NumeroDocManual, e.IDTipoDocumento, at.strAssinatura)

                                        Dim VarlorPago As String = Format(If(e.ValorPago Is Nothing, 0, e.ValorPago), "0.00").Replace(",", ".")
                                        strQry = "UPDATE " & at.strTabela & " SET datahoraestado=dataassinatura, assinatura=" & ClsUtilitarios.EnvolveSQL(at.strAssinatura) & ", CodigoEntidade='D" & e.ID & "', MensagemDocAT=" & ClsUtilitarios.EnvolveSQL(strMensagem) & ", versaochaveprivada=1, valorpago=" & VarlorPago & " where id=" & e.ID
                                        inCtx.Database.ExecuteSqlCommand(strQry)

                                        inModelo.Assinatura = at.strAssinatura

                                        'QRCODE
                                        If RepositorioDocumentos.SeGeraQRCode(Of Oticas.tbDocumentosVendas)(e) Then
                                            RepositorioDocumentos.TrataQRCode(Of Oticas.tbDocumentosVendas, Oticas.tbDocumentosVendasLinhas)(e, e.tbDocumentosVendasLinhas.ToList(), docSerie.ATCodValidacaoSerie, False, inModelo.Assinatura)
                                        End If
                                    End If

                                    If tipoDoc = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso tipoDocFiscal = TiposDocumentosFiscal.NaoFiscal Then
                                        e.Assinatura = Nothing
                                        e.DataAssinatura = Nothing
                                        e.MensagemDocAT = Nothing
                                    End If
                                End If
                            Else

                                If blnAnulado Then
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "idestado", inModelo.IDEstado)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "CodigoTipoEstado", TiposEstados.Anulado)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "DataHoraEstado", Format(DateAndTime.Now, FormatoData.DataHora))
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "UtilizadorEstado", ClsF3MSessao.RetornaUtilizadorNome)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "RazaoEstado", inModelo.RazaoEstado)

                                    inCtx.sp_AtualizaCCEntidades(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, inModelo.IDEntidade)
                                    inCtx.sp_AtualizaMapaCaixa(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Remover, ClsF3MSessao.RetornaUtilizadorID, 0)

                                    inCtx.sp_AtualizaStock(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Remover, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                                    RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Remover)

                                    strQry = "UPDATE tbdocumentosvendaspendentes SET ativo=0 WHERE iddocumentovenda=" & inModelo.ID
                                    inCtx.Database.ExecuteSqlCommand(strQry)

                                    'QRCODE
                                    If RepositorioDocumentos.SeGeraQRCode(Of tbDocumentosVendas)(e) Then
                                        RepositorioDocumentos.TrataQRCode(Of tbDocumentosVendas, tbDocumentosVendasLinhas)(e, e.tbDocumentosVendasLinhas.ToList(), e.tbTiposDocumentoSeries.ATCodValidacaoSerie, False, e.Assinatura)
                                    End If
                                Else
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "observacoes", inModelo.Observacoes)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "idestado", inModelo.IDEstado)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "CodigoTipoEstado", TiposEstados.Efetivo)
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "DataHoraEstado", Format(DateAndTime.Now, FormatoData.DataHora))
                                    RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "UtilizadorEstado", ClsF3MSessao.RetornaUtilizadorNome)
                                End If
                            End If

                            If blnAtualizaCC Then
                                inCtx.sp_AtualizaCCEntidades(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorID, inModelo.IDEntidade)
                            End If

                            If blnAtualizaCX Then
                                If inModelo.PagamentosVendas IsNot Nothing Then
                                    Dim idcontaCaixa As Long = inModelo.PagamentosVendas.IDContaCaixa

                                    If idcontaCaixa > 0 Then
                                        inCtx.sp_AtualizaMapaCaixa(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, ClsF3MSessao.RetornaUtilizadorID, idcontaCaixa)
                                    End If
                                End If
                            End If

                            If blnAtualizaStock Then
                                inCtx.sp_AtualizaStock(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                                RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Adicionar)
                            End If
                        End If

                        inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Alterar, "tbDocumentosVendas", ClsF3MSessao.RetornaUtilizadorNome)

                        trans.Commit()
                    Catch
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Oticas.DocumentosVendas, inFiltro As ClsF3MFiltro)
            Dim blnRascunho As Boolean = RepositorioDocumentosVendas.ERascunho(BDContexto, o.IDEstado)

            If Not blnRascunho Then
                Throw New Exception(Traducao.EstruturaDocumentos.DocumentoValido)
            End If

            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ''' <summary>
        ''' GravaLinhasTodas
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <param name="e"></param>
        ''' <param name="inAcao"></param>
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Oticas.DocumentosVendas, e As tbDocumentosVendas, inAcao As AcoesFormulario)
            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then

                Dim intOdem As Integer = 1
                Dim blnTemLinhas As Boolean = inModelo.DocumentosVendasLinhas.Where(Function(f) f.CodigoArtigo IsNot Nothing AndAlso f.AcaoCRUD <> AcoesFormulario.Remover).Any

                If blnTemLinhas = False Then
                    Throw New Exception(Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada)
                End If

                For Each div In inModelo.DocumentosVendasLinhas.Where(Function(f) f.CodigoArtigo IsNot Nothing).OrderBy(Function(o) o.Ordem)
                    Dim tbDVL As New tbDocumentosVendasLinhas

                    Mapear(div, tbDVL)

                    If tbDVL.IDArtigo IsNot Nothing Then
                        With tbDVL
                            .DataCriacao = Date.Now
                            .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                            .IDDocumentoVenda = inModelo.ID
                            .QuantidadeStock = tbDVL.Quantidade
                            .Ordem = intOdem
                            If inModelo.IdDocOrigem IsNot Nothing AndAlso inModelo.TipoFiscal <> "NC" Then
                                .IDDocumentoOrigemInicial = inModelo.IdDocOrigem
                            Else
                                .IDDocumentoOrigemInicial = Nothing
                            End If
                            If .IDLote = 0 Then .IDLote = Nothing
                            If inModelo.ID = 0 Then
                                div.AcaoCRUD = AcoesFormulario.Adicionar
                            End If
                            If div.AcaoCRUD = AcoesFormulario.Adicionar Then .ID = CLng(0)
                        End With

                        GravaEntidadeLinha(Of tbDocumentosVendasLinhas)(inCtx, tbDVL, div.AcaoCRUD, Nothing)

                        If div.AcaoCRUD <> AcoesFormulario.Remover Then intOdem += 1

                    ElseIf div.AcaoCRUD <> AcoesFormulario.Remover Then
                        Dim blnRascunho As Boolean = RepositorioDocumentosVendas.ERascunho(BDContexto, inModelo.IDEstado)
                        If Not blnRascunho Then
                            If inModelo.CodigoSistemaTiposDocumento = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso inModelo.TipoFiscal IsNot Nothing AndAlso inModelo.TipoFiscal <> TiposDocumentosFiscal.FaturaProforma Then
                                GravaLinhasEntidades(Of tbDocumentosVendasPendentes)(inCtx, e.tbDocumentosVendasPendentes.Where(Function(f) f.IDDocumentoVenda = e.ID).ToList, AcoesFormulario.Remover, Nothing)
                            End If
                        End If
                        GravaEntidadeLinha(Of tbDocumentosVendasLinhas)(inCtx, tbDVL, AcoesFormulario.Remover, Nothing)
                    End If
                Next
            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Remover, "tbDocumentosVendas", F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorNome)

                GravaLinhasEntidades(Of tbDocumentosVendasPendentes)(inCtx, e.tbDocumentosVendasPendentes.Where(Function(f) f.IDDocumentoVenda = e.ID).ToList, AcoesFormulario.Remover, Nothing)
                GravaLinhasEntidades(Of tbDocumentosVendasLinhas)(inCtx, e.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoVenda = e.ID).ToList, AcoesFormulario.Remover, Nothing)
            End If
        End Sub

        Private Sub PreencheRecibo(ctx As Aplicacao, ByRef inModelo As DocumentosVendas, ByVal GerouNC As Boolean,
                                   ByVal IDDocumentoVendaOrigem As Long, ByVal inValorNC As Double, ByVal inValorDoc As Double)

            'ID DOC VENDA 
            Dim IDDocumentoVenda As Long = inModelo.ID

            'ID DOC VENDA PENDENTE
            Dim IDDocVendaPendente As Long = (From x In ctx.tbDocumentosVendasPendentes
                                              Where x.IDDocumentoVenda = IDDocumentoVenda
                                              Select x.ID).FirstOrDefault()

            'MOEDA DO DOC
            Dim IDMoeda As Long = inModelo.IDMoeda
            Dim Moeda As Moedas = (From x In BDContexto.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .TaxaConversao = x.TaxaConversao, .CasasDecimaisTotais = x.CasasDecimaisTotais}).FirstOrDefault()

            'MOEDA REFERENCIA
            Dim MoedaReferencia As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia

            Dim PagamentoVenda As New PagamentosVendas
            With PagamentoVenda
                .Data = DateAndTime.Now()
                .Descricao = Traducao.EstruturaTiposDocumento.Comparticipacao 'Comparticipação
                .IDEntidade = inModelo.IDEntidade
                .IDLoja = inModelo.IDLoja
                .IDMoeda = Moeda.ID
                .TaxaConversao = Moeda.TaxaConversao
                .TotalMoeda = inValorNC
                .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                .TotalPagar = inValorNC
                .Troco = CDbl(0)
                .ValorEntregue = inValorNC

                If inModelo.PagamentosVendas IsNot Nothing Then
                    .IDContaCaixa = inModelo.PagamentosVendas.IDContaCaixa
                End If
            End With

            PagamentoVenda.ListOfPendentes = New List(Of DocumentosVendasPendentes)

            Using rp As New RepositorioDocumentosVendasPendentes
                Dim DocVendaPendente As New DocumentosVendasPendentes
                Mapear(inModelo, DocVendaPendente)

                With DocVendaPendente
                    .ID = IDDocVendaPendente
                    .IDDocumentoVenda = IDDocumentoVenda
                    .IDMoeda = Moeda.ID
                    .TaxaConversao = Moeda.TaxaConversao
                    .ValorPendente = inValorDoc
                    .ValorPendenteAux = .ValorPendente
                    .ValorPago = inValorNC
                    .LinhaSelecionada = True
                    .GereContaCorrente = True
                    .TotalMoedaDocumento = inValorDoc
                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorDoc, Moeda.TaxaConversao)
                    .CodigoSistemaNaturezas = TiposNaturezas.Debito
                End With

                PagamentoVenda.ListOfPendentes.Add(DocVendaPendente)
            End Using

            If GerouNC AndAlso Not inModelo.NotaCredito Is Nothing Then
                Using rp As New RepositorioDocumentosVendasPendentes
                    Dim DocVendaPendente As New DocumentosVendasPendentes
                    Mapear(inModelo.NotaCredito, DocVendaPendente)

                    With DocVendaPendente
                        .ID = DocVendaPendente.ID
                        .IDDocumentoVenda = DocVendaPendente.ID
                        .IDMoeda = Moeda.ID
                        .TaxaConversao = Moeda.TaxaConversao
                        .ValorPendente = inValorNC
                        .ValorPendenteAux = .ValorPendente
                        .ValorPago = .ValorPendente
                        .LinhaSelecionada = True
                        .GereContaCorrente = True
                        .TotalMoedaDocumento = inValorNC
                        .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                        .CodigoSistemaNaturezas = TiposNaturezas.Credito
                    End With

                    PagamentoVenda.ListOfPendentes.Add(DocVendaPendente)
                End Using
            End If

            PagamentoVenda.ListOfFormasPagamento = New List(Of PagamentosVendasFormasPagamento)

            If GerouNC AndAlso inModelo.NCDA_CLI_DIFF Is Nothing Then
                PagamentoVenda.ListOfFormasPagamento = AtribuiFormasPagamento(ctx, IDDocumentoVenda, IDDocumentoVendaOrigem, IDMoeda)

            Else
                Dim PagamentoVendaFormPag As New PagamentosVendasFormasPagamento
                With PagamentoVendaFormPag
                    .AcaoCRUD = AcoesFormulario.Adicionar
                    .IDFormaPagamento = 1 'HERE FK
                    .CodigoSistemaTipoFormaPagamento = "NU" 'HERE FK
                    .DescricaoFormaPagamento = "Numerário" 'HERE FK
                    .Valor = inValorNC
                    .IDDocumentoVenda = IDDocumentoVenda
                    .IDPagamentoVenda = PagamentoVenda.ID
                    .IDMoeda = Moeda.ID
                    .TaxaConversao = Moeda.TaxaConversao
                    .TotalMoeda = inValorNC
                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(inValorNC, Moeda.TaxaConversao)
                    .Ordem = 1
                End With

                PagamentoVenda.ListOfFormasPagamento.Add(PagamentoVendaFormPag)
            End If

            Using rp As New RepositorioPagamentosVendas
                If Not inModelo.NCDA_CLI_DIFF Is Nothing Then
                    rp.AdicionaPagamento_CLI_DIFF(ctx, PagamentoVenda, inModelo.IDMoeda, IDDocumentoVenda)

                Else
                    rp.AdicionaPagamentoComparticipacao(ctx, PagamentoVenda, inModelo.IDMoeda, IDDocumentoVenda)
                End If
            End Using
        End Sub

        Protected Friend Sub GeraDocVendaWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Oticas.DocumentosVendas, inFiltro As ClsF3MFiltro)
            GeraDocVendaWithTransaction(inCtx, inModelo, inFiltro, Nothing)
        End Sub

        Protected Friend Sub GeraDocVendaWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Oticas.DocumentosVendas, inFiltro As ClsF3MFiltro, inModeloPV As PagamentosVendas)
            Dim Opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Opcao", GetType(String)) 'pagamentos || adiantamentos

            Calcula(Nothing, inModelo, inCtx)

            'If Not ClsF3MSessao.EmDesenvolvimento AndAlso (inModelo.IDPaisFiscal IsNot Nothing OrElse inModelo.IDPaisFiscal = 184) AndAlso inModelo.ContribuinteFiscal <> Traducao.EstruturaAplicacaoTermosBase.ConsumidorFinal AndAlso Not ClsUtilitarios.ValidaNIF(inModelo.ContribuinteFiscal) Then
            '    Throw New Exception(ClsTexto.Traduz(Traducao.EstruturaEmpresas.NIFInvalido))
            'End If

            ValidarDocumento(inCtx, inModelo)

            Dim blnEfetivo As Boolean = EEfetivo(inCtx, inModelo.IDEstado)

            Dim lngID As Long = inModelo.IDTipoDocumento
            Dim lngIDSerie As Long = inModelo.IDTiposDocumentoSeries
            Dim strTipoDocumento As String = String.Empty

            strTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.tbSistemaTiposDocumentoFiscal?.Tipo

            Dim TDS = inCtx.tbTiposDocumentoSeries.Where(Function(f) f.ID = lngIDSerie).FirstOrDefault()

            Dim CodigoSerie As String = String.Empty
            Dim strDocOrigem As String = String.Empty
            Dim lngIDDocOrigem As Long = 0

            Dim blnManual As Boolean = False
            Dim blnReposicao As Boolean = False
            Dim blnAtualizaStock As Boolean = False
            Dim blnGeraPendente As Boolean = False

            With TDS
                CodigoSerie = .CodigoSerie
                lngIDDocOrigem = .IDSistemaTiposDocumentoOrigem
                strDocOrigem = inCtx.tbSistemaTiposDocumentoOrigem.Where(Function(f) f.ID = lngIDDocOrigem).FirstOrDefault.Codigo
            End With

            If strDocOrigem = TiposDocumentosOrigem.Manual Then
                blnManual = True
                blnReposicao = False
            ElseIf strDocOrigem = TiposDocumentosOrigem.Reposicao Then
                blnManual = False
                blnReposicao = True
            Else
                blnManual = False
                blnReposicao = False
            End If

            Dim CodigoTipoDocumento As String = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.Codigo

            If inModelo.TotalMoedaReferencia - inModelo.TotalIva > 1000 AndAlso Not String.IsNullOrEmpty(strTipoDocumento) AndAlso strTipoDocumento.ToLower = "fs" Then
                Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.Aviso_FaturaSimplificada)
            End If

            If inModelo.IDMoeda Is Nothing Then 'HERE
                inModelo.IDMoeda = 1
                inModelo.TaxaConversao = 1
            End If

            If inModelo.DataVencimento Is Nothing Then
                inModelo.DataVencimento = inModelo.DataDocumento
                inModelo.DataCarga = Date.Now
            End If

            Dim ERasc As Boolean = RepositorioDocumentos.ERascunho(Of tbEstados)(inCtx, inModelo)
            Dim docSerie As tbTiposDocumentoSeries = RepositorioDocumentos.AdicionaDocumento(
                Of tbDocumentosVendas, DocumentosVendas, tbTiposDocumentoSeries, tbEstados)(inCtx, inModelo, inFiltro)

            inModelo.ValorPago = CDbl(0)
            inModelo.SegundaVia = False
            ' Preencher a lista de campos que não quero que sejam mexidos
            inModelo.ExecutaListaCamposEvitaMapear = True
            inModelo.ListaCamposEvitaMapear = New List(Of String)
            inModelo.ListaCamposEvitaMapear.Add("NumeroDocumento")
            If inModelo.ContribuinteFiscal IsNot Nothing AndAlso inModelo.ContribuinteFiscal.Replace(" ", "") = CamposGenericos.NIFDesconhecido Then
                inModelo.ContribuinteFiscal = Traducao.EstruturaAplicacaoTermosBase.ConsumidorFinal
            End If

            Dim e As New tbDocumentosVendas
            Mapear(inModelo, e)
            PreeEntDadosUtilizador(e, 0, AcoesFormulario.Adicionar)

            GravaLinhasTodas(inCtx, inModelo, e, AcoesFormulario.Adicionar)

            RepositorioDocumentos.DefineNumeroDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries)(inCtx, inModelo, docSerie, ERasc, 0)

            With e
                .NumeroDocumento = inModelo.NumeroDocumento
                .Documento = String.Concat(docSerie.tbTiposDocumento.Codigo, " ", docSerie.CodigoSerie, "/", e.NumeroDocumento)
            End With

            inModelo.Documento = e.Documento

            'HERE CERTIFICACAO!
            Dim IDLoja As Long = ClsF3MSessao.RetornaLojaID
            Dim IDLojaSede As Long = ClsF3MSessao.RetornaIDLojaSede
            Dim ParamLojaSede As New ParametrosLoja
            Dim ParamLoja As ParametrosLoja = (From x In BDContexto.tbParametrosLoja
                                               Where x.IDLoja = IDLoja
                                               Select New ParametrosLoja With {
                                             .ID = x.ID,
                                             .Morada = x.Morada,
                                             .CodigoPostal = x.CodigoPostal,
                                             .Localidade = x.Localidade,
                                             .NIF = x.NIF,
                                             .DesignacaoComercial = x.DesignacaoComercial}).FirstOrDefault()

            ParamLojaSede = (From x In BDContexto.tbParametrosLoja
                             Where x.IDLoja = IDLojaSede
                             Select New ParametrosLoja With {
                                         .ID = x.ID,
                                         .Morada = x.Morada,
                                         .CodigoPostal = x.CodigoPostal,
                                         .Localidade = x.Localidade,
                                         .NIF = x.NIF,
                                         .DesignacaoComercial = x.DesignacaoComercial,
                                        .Telefone = x.Telefone}).FirstOrDefault()

            With e
                .CodigoPostalLoja = ParamLoja.CodigoPostal
                .LocalidadeLoja = ParamLoja.Localidade
                .SiglaLoja = ClsF3MSessao.RetornaParametros.SiglaPais()
                .SiglaPaisFiscal = .SiglaLoja
                .NIFLoja = ParamLoja.NIF
                .DesignacaoComercialLoja = ParamLoja.DesignacaoComercial
                .MoradaLoja = ParamLoja.Morada
                .IDLojaSede = IDLojaSede
                .MoradaSede = ParamLojaSede.Morada
                .LocalidadeSede = ParamLojaSede.Localidade
                .CodigoPostalSede = ParamLojaSede.CodigoPostal
                .TelefoneSede = ParamLojaSede.Telefone
            End With
            'END CERTIFICACAO!

            inCtx.Entry(e).State = EntityState.Added
            inCtx.SaveChanges()
            lngIDEstado = inModelo.IDEstado
            inModelo.ID = e.ID

            If blnEfetivo Then
                Dim tipoDoc As String = docSerie.tbTiposDocumento.tbSistemaTiposDocumento.Tipo
                Dim tipoDocFiscal As String = docSerie.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo

                Dim assinaDocumento As Boolean =
                    (tipoDoc = TiposSistemaTiposDocumento.VendasTransporte AndAlso (tipoDocFiscal = TiposDocumentosFiscal.GuiaRemessa OrElse tipoDocFiscal = TiposDocumentosFiscal.GuiaTransporte)) OrElse
                    (tipoDoc = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso tipoDocFiscal <> TiposDocumentosFiscal.NaoFiscal) OrElse
                    (tipoDoc = TiposSistemaTiposDocumento.VendasOrcamento) OrElse
                    (tipoDoc = TiposSistemaTiposDocumento.VendasEncomenda)

                If assinaDocumento Then
                    ' Guardar a informação necessária à geração da assinatura e à comunicação à AT
                    inModelo.CodigoTipoDocumentoSerie = e.tbTiposDocumentoSeries?.CodigoSerie
                    inModelo.CodigoTipoDocumento = e.tbTiposDocumento.Codigo
                    inModelo.DescricaoTipoDocumento = e.tbTiposDocumento.Descricao

                    'Assinatura
                    Dim at As New F3M.ImposicoesLegais.AssinaturaAT With {
                        .dtData = inModelo.DataDocumento,
                        .IDTipoDocumento = inModelo.IDTipoDocumento,
                        .IDTiposDocumentoSeries = inModelo.IDTiposDocumentoSeries,
                        .dtDataRegisto = inModelo.DataAssinatura,
                        .strTipoDocumento = CodigoTipoDocumento,
                        .strSerie = CodigoSerie,
                        .strNumDocumento = e.NumeroDocumento,
                        .strGrossTotal = Format(If(inModelo.TotalMoedaReferencia Is Nothing, 0, inModelo.TotalMoedaReferencia), "0.00").Replace(",", "."),
                        .strTabela = "tbDocumentosVendas"
                    }

                    F3M.ImposicoesLegais.ClsF3MAssinaturasAT.GerarAssinatura(inCtx, e.ID, ClsF3MSessao.RetornaEmpresaID, at, F3M.Modelos.ConstantesCertificacao.clsF3MCertApp.CertificadoAT(Nothing, True))

                    Dim strMensagem As String = TextoMensagemAssinatura(inCtx, True, ClsF3MSessao.RetornaEmpresaDemonstracao, False, blnManual, blnReposicao, e.SerieDocManual, e.NumeroDocManual, e.IDTipoDocumento, at.strAssinatura)

                    Dim mensagemATQuery As String = "update " & at.strTabela & " set datahoraestado=dataassinatura, assinatura=" & ClsUtilitarios.EnvolveSQL(at.strAssinatura) & ", CodigoEntidade='" & "D" & e.ID & "', MensagemDocAT=" & ClsUtilitarios.EnvolveSQL(strMensagem) & ", versaochaveprivada=1 where id=" & e.ID
                    inCtx.Database.ExecuteSqlCommand(mensagemATQuery)

                    inModelo.Assinatura = at.strAssinatura

                    'QRCODE
                    If RepositorioDocumentos.SeGeraQRCode(Of tbDocumentosVendas)(e) Then
                        RepositorioDocumentos.TrataQRCode(Of tbDocumentosVendas, tbDocumentosVendasLinhas)(e, e.tbDocumentosVendasLinhas.ToList(), docSerie.ATCodValidacaoSerie, False, inModelo.Assinatura)
                    End If
                End If

                If tipoDoc = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso tipoDocFiscal = TiposDocumentosFiscal.NaoFiscal Then
                    e.Assinatura = Nothing
                    e.DataAssinatura = Nothing
                    e.MensagemDocAT = Nothing
                End If

                blnAtualizaCC = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereContaCorrente
                blnAtualizaCX = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereCaixasBancos
                blnAtualizaStock = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereStock
                blnGeraPendente = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GeraPendente

                'atualiza o valor pago no servico e anula a ncda ao gerar um nc (caso exista servico na origem)
                AtualizaValorPagoDocOrigemAnulaNCDAFromNC(inCtx, inModelo)

                strQry = "update a set a.IDDocumentoOrigem=null, a.IDTipoDocumentoOrigem=null, a.IDLinhaDocumentoOrigem=null, a.IDDocumentoOrigemInicial=null " &
                        "from tbDocumentosVendasLinhas a inner join (select o.IDDocumentoOrigem, o.IDTipoDocumentoOrigem, o.IDLinhaDocumentoOrigem " &
                        "from tbDocumentosVendasLinhas l inner join tbDocumentosVendasLinhas o on l.IDLinhaDocumentoOrigem=o.id " &
                        "where l.IDDocumentoVenda=" & e.ID & ") b on a.IDTipoDocumentoOrigem=b.IDTipoDocumentoOrigem and a.IDDocumentoOrigem=b.IDDocumentoOrigem and a.IDLinhaDocumentoOrigem=b.IDLinhaDocumentoOrigem " &
                        " INNER JOIN tbDocumentosVendas AS V ON V.ID = a.IDDocumentoVenda " &
                        " INNER JOIN tbTiposDocumento AS TD ON TD.ID = V.IDTipoDocumento AND TD.Adiantamento <> 1 "
                inCtx.Database.ExecuteSqlCommand(strQry)

                strQry = "update c set c.ncontribuinte=d.contribuinteFiscal from tbDocumentosVendas d inner join tbclientes c on d.identidade=c.id " &
                        "where d.id=" & e.ID & " and (c.ncontribuinte is null or c.ncontribuinte='') "
                inCtx.Database.ExecuteSqlCommand(strQry)

                strQry = "update l set l.UPCMoedaRef=a.UltimoPrecoCusto,  l.precounitariomoedaref=l.precounitarioefetivo, l.precounitarioefetivomoedaref=l.precounitarioefetivo, l.PCMAtualMoedaRef=a.Medio from tbDocumentosVendasLinhas l inner join tbartigos a on l.idartigo=a.id " &
                        " where l.IDDocumentoVenda=" & e.ID
                inCtx.Database.ExecuteSqlCommand(strQry)

                inCtx.sp_AtualizaCCEntidades(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Adicionar, ClsF3MSessao.RetornaUtilizadorID, inModelo.IDEntidade)

                If blnAtualizaCX Then
                    If inModelo.PagamentosVendas IsNot Nothing Then
                        Dim idContaCaixa As Long = inModelo.PagamentosVendas.IDContaCaixa

                        If idContaCaixa > 0 Then
                            inCtx.sp_AtualizaMapaCaixa(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Adicionar, ClsF3MSessao.RetornaUtilizadorID, idContaCaixa)
                        End If
                    End If
                Else
                    If Not blnGeraPendente Then
                        'strQry = "update valorpendente=0 from tbDocumentosVendaspendentes where IDDocumentoVenda=" & e.ID
                        'inCtx.Database.ExecuteSqlCommand(strQry)
                    End If
                End If

                If blnAtualizaStock Then
                    inCtx.sp_AtualizaStock(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                    RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Adicionar)
                End If
            End If

            inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Adicionar, "tbDocumentosVendas", ClsF3MSessao.RetornaUtilizadorNome)
        End Sub

        Protected Friend Sub GeraDocVendaPendenteWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Oticas.DocumentosVendas, ByVal inValorPendente As Double)
            Dim DVP As New tbDocumentosVendasPendentes
            With DVP
                .ID = 0
                .DataCriacao = DateTime.Now()
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                .IDTipoDocumento = inModelo.IDTipoDocumento
                .IDTipoEntidade = inModelo.IDTipoEntidade
                .NumeroDocumento = inModelo.NumeroDocumento
                .IDEntidade = inModelo.IDEntidade
                .DescricaoEntidade = inModelo.DescricaoEntidade
                .DataDocumento = inModelo.DataDocumento
                .DataVencimento = inModelo.DataDocumento
                .Documento = inModelo.Documento
                .IDMoeda = inModelo.IDMoeda

                .ValorPendente = inValorPendente

                Dim lngIDTipodocumento As Long
                lngIDTipodocumento = inModelo.IDTipoDocumento

                .IDSistemaNaturezas = (From x In inCtx.tbTiposDocumento Where x.ID = lngIDTipodocumento Select x.IDSistemaNaturezas).FirstOrDefault()

                .TotalMoedaDocumento = inModelo.TotalMoedaDocumento
                .TotalMoedaReferencia = inModelo.TotalMoedaReferencia
                .TotalClienteMoedaDocumento = inValorPendente
                .TotalClienteMoedaReferencia = inValorPendente
                .TaxaConversao = inModelo.TaxaConversao
                .Ativo = True
                .IDDocumentoVenda = inModelo.ID

                If inModelo.CodigoSistemaTiposDocumento = TiposSistemaTiposDocumento.VendasFinanceiro AndAlso inModelo.TipoFiscal = TiposDocumentosFiscal.NaoFiscal Then
                    .Documento = inModelo.SerieDocManual & "/" & inModelo.NumeroDocManual
                End If

                GravaEntidadeLinha(Of tbDocumentosVendasPendentes)(inCtx, DVP, AcoesFormulario.Adicionar, Nothing)
                inCtx.SaveChanges()
            End With

            inModelo.IDDocumentoVendaPendente = DVP.ID
        End Sub

        Protected Friend Sub GeraNCAdiantamentosWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As DocumentosVendas, inFiltro As ClsF3MFiltro,
                                                                ByRef GerouNC As Boolean, ByRef IDDocumentoVendaOrigem As Long, ByRef dblTotalNC As Double)
            Try
                GerouNC = False

                Dim lngID_FA As Long? = (From x In inCtx.tbTiposDocumento
                                         Where x.Ativo = True _
                                            And x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo _
                                            And x.Adiantamento = True
                                         Select x.ID).FirstOrDefault()

                Dim LstLinhas As List(Of DocumentosVendasLinhas) = inModelo.DocumentosVendasLinhas.ToList
                If LstLinhas.Count Then
                    Dim IDDocOrigem As Long? = LstLinhas.FirstOrDefault.IDDocumentoOrigem
                    If IDDocOrigem IsNot Nothing Then
                        Dim DocOrigemAdiantamento = inCtx.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoOrigem = IDDocOrigem And f.tbDocumentosVendas.IDTipoDocumento = lngID_FA And f.tbDocumentosVendas.CodigoTipoEstado = TiposEstados.Efetivo).Select(Function(s) s.tbDocumentosVendas).FirstOrDefault

                        Dim ListOfDocsVendasLinhasAdiantamento As List(Of tbDocumentosVendasLinhas) = (From x In inCtx.tbDocumentosVendasLinhas
                                                                                                       Join y In inCtx.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                                                                                                       Where x.IDDocumentoOrigem = IDDocOrigem And y.IDTipoDocumento = lngID_FA And y.CodigoTipoEstado = TiposEstados.Efetivo Select x).ToList()

                        If DocOrigemAdiantamento IsNot Nothing Then
                            Dim LstLinhasAdiantamento As List(Of tbDocumentosVendasLinhas) = DocOrigemAdiantamento.tbDocumentosVendasLinhas.ToList
                            If LstLinhasAdiantamento.Count Then
                                Dim sumLinhasAdiantamento As Double? = LstLinhasAdiantamento.Sum(Function(s) s.TotalFinal)
                                If sumLinhasAdiantamento IsNot Nothing AndAlso sumLinhasAdiantamento > 0 Then

                                    Dim GeraPendente As Long = inModelo.GeraPendente

                                    Dim TipoDocNCA As tbTiposDocumento = (From x In inCtx.tbTiposDocumento
                                                                          Where x.Ativo = True AndAlso
                                                                             x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito AndAlso
                                                                             x.Adiantamento = True AndAlso
                                                                             x.GeraPendente = GeraPendente
                                                                          Select x).FirstOrDefault()

                                    Dim lngIDSerie As Long

                                    If EMultiEmpresa Then
                                        Dim IDLojaSedeByIDLojaEmSessao As Long
                                        Using rpLojas As New RepositorioLojas
                                            IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                                        End Using

                                        lngIDSerie = (From x In inCtx.tbTiposDocumentoSeries
                                                      Where x.IDTiposDocumento = TipoDocNCA.ID AndAlso
                                                          x.AtivoSerie AndAlso
                                                          x.IDLoja = IDLojaSedeByIDLojaEmSessao
                                                      Select x.ID).FirstOrDefault()

                                    Else
                                        lngIDSerie = (From x In inCtx.tbTiposDocumentoSeries
                                                      Where x.IDTiposDocumento = TipoDocNCA.ID AndAlso
                                                          x.AtivoSerie AndAlso
                                                          x.SugeridaPorDefeito
                                                      Select x.ID).FirstOrDefault()
                                    End If

                                    If lngIDSerie = 0 Then
                                        Throw New Exception(Traducao.EstruturaErros.NaoEstaDefinidaSerieParaTipoDoc_X_NestaLoja.Replace("{0}", Traducao.EstruturaTiposDocumento.NotaCreditoAdiantamento))
                                    End If

                                    Dim NewNC As New DocumentosVendas

                                    Mapear(inModelo, NewNC)

                                    With NewNC
                                        .TipoFiscal = TiposDocumentosFiscal.NotaCredito
                                        .IDTipoDocumento = TipoDocNCA.ID
                                        .IDTiposDocumentoSeries = lngIDSerie
                                        .Adiantamento = TipoDocNCA.Adiantamento
                                        .DataCriacao = DateAndTime.Now()
                                        .DataDocumento = Date.Now.Date
                                        .DataHoraEstado = Date.Now
                                        .DataVencimento = Date.Now
                                        .DataCarga = Date.Now
                                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                        .DocumentosVendasLinhas = New List(Of DocumentosVendasLinhas)

                                        'ZERAR VALORES
                                        .PercentagemDesconto = CDbl(0)
                                        .ValorDesconto = CDbl(0)
                                    End With

                                    For Each linha In ListOfDocsVendasLinhasAdiantamento.ToList()
                                        Dim newLinha As New DocumentosVendasLinhas
                                        Mapear(linha, newLinha)

                                        With newLinha
                                            .AcaoCRUD = CShort(AcoesFormulario.Adicionar)
                                            .IDAdiantamentoOrigem = .IDDocumentoVenda
                                            .IDDocumentoOrigem = linha.IDDocumentoVenda
                                            .DocumentoOrigem = linha.tbDocumentosVendas.Documento
                                        End With

                                        NewNC.DocumentosVendasLinhas.Add(newLinha)
                                    Next

                                    If inModelo.GeraPendente AndAlso DocOrigemAdiantamento.IDEntidade <> inModelo.IDEntidade Then
                                        'GERA NCDA EM NOME DO 1º CLIENTE
                                        GeraNCDA_CLI_DIFF(inCtx, inModelo, inFiltro, DocOrigemAdiantamento, ListOfDocsVendasLinhasAdiantamento)

                                    ElseIf Not inModelo.GeraPendente AndAlso DocOrigemAdiantamento.IDEntidade <> inModelo.IDEntidade Then
                                        MapeiaClienteDocOrigem(inCtx, DocOrigemAdiantamento.ID, NewNC)
                                    End If

                                    If inModelo.GeraPendente AndAlso DocOrigemAdiantamento.IDEntidade <> inModelo.IDEntidade Then
                                        GerouNC = True
                                        IDDocumentoVendaOrigem = IDDocOrigem
                                        dblTotalNC = inModelo.NCDA_CLI_DIFF.TotalMoedaDocumento
                                    Else
                                        GeraDocVendaWithTransaction(inCtx, NewNC, inFiltro)
                                        GeraDocVendaPendenteWithTransaction(inCtx, NewNC, 0)

                                        With inModelo
                                            .NotaCredito = New DocumentosVendas
                                            .NotaCredito = NewNC
                                        End With

                                        If Not inModelo.GeraPendente Then
                                            AtualizaValorPago_FROM_NCDA(inCtx, NewNC.ID, NewNC.TotalMoedaDocumento)
                                        End If

                                        GerouNC = True
                                        IDDocumentoVendaOrigem = IDDocOrigem
                                        dblTotalNC = NewNC.TotalMoedaDocumento
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub
        Private Sub AtualizaValorPago_FROM_NCDA(inCtx As BD.Dinamica.Aplicacao, inID As Long, ByVal inValorPago As Double)
            Dim DocumentosVendas As New tbDocumentosVendas

            DocumentosVendas = inCtx.tbDocumentosVendas.Where(Function(f) f.ID = inID).FirstOrDefault()

            With DocumentosVendas
                .ValorPago = inValorPago
            End With

            With inCtx
                .tbDocumentosVendas.Attach(DocumentosVendas)
                .Entry(DocumentosVendas).[Property](Function(x) x.ValorPago).IsModified = True
                .SaveChanges()
            End With
        End Sub

        Private Sub GeraNCDA_CLI_DIFF(inCtx As Aplicacao, ByRef inModelo As Oticas.DocumentosVendas,
                              inFiltro As ClsF3MFiltro,
                              DocOrigemAdiantamento As tbDocumentosVendas,
                              ListOfDocsVendasLinhasAdiantamento As List(Of tbDocumentosVendasLinhas))

            Dim TipoDocNCDA As tbTiposDocumento = (From x In inCtx.tbTiposDocumento
                                                   Where x.Ativo = True AndAlso
                                                       x.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito AndAlso
                                                       x.Adiantamento = True AndAlso Not x.GeraPendente AndAlso x.GereCaixasBancos AndAlso x.GereContaCorrente
                                                   Select x).FirstOrDefault()

            Dim lngIDSerie As Long

            If EMultiEmpresa Then
                Dim IDLojaSedeByIDLojaEmSessao As Long
                Using rpLojas As New RepositorioLojas
                    IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                End Using

                lngIDSerie = (From x In inCtx.tbTiposDocumentoSeries
                              Where x.IDTiposDocumento = TipoDocNCDA.ID AndAlso
                                  x.AtivoSerie AndAlso
                                  x.IDLoja = IDLojaSedeByIDLojaEmSessao
                              Select x.ID).FirstOrDefault()

            Else
                lngIDSerie = (From x In inCtx.tbTiposDocumentoSeries
                              Where x.IDTiposDocumento = TipoDocNCDA.ID AndAlso
                                  x.AtivoSerie AndAlso
                                  x.SugeridaPorDefeito
                              Select x.ID).FirstOrDefault()
            End If

            If lngIDSerie = 0 Then
                Throw New Exception(Traducao.EstruturaErros.NaoEstaDefinidaSerieParaTipoDoc_X_NestaLoja.Replace("{0}", Traducao.EstruturaTiposDocumento.NotaCreditoAdiantamento))
            End If

            Dim NewNC As New DocumentosVendas

            Mapear(inModelo, NewNC)

            MapeiaClienteDocOrigem(inCtx, DocOrigemAdiantamento.ID, NewNC)

            With NewNC
                .ID = 0
                .TipoFiscal = TiposDocumentosFiscal.NotaCredito
                .IDTipoDocumento = TipoDocNCDA.ID
                .IDTiposDocumentoSeries = lngIDSerie
                .Adiantamento = True
                .DataCriacao = DateAndTime.Now()
                .DataDocumento = Date.Now.Date
                .DataHoraEstado = Date.Now
                .DataVencimento = Date.Now
                .DataCarga = Date.Now
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                .DocumentosVendasLinhas = New List(Of DocumentosVendasLinhas)

                'ZERAR VALORES
                .PercentagemDesconto = CDbl(0)
                .ValorDesconto = CDbl(0)
            End With

            For Each linha In ListOfDocsVendasLinhasAdiantamento.ToList()
                Dim newLinha As New DocumentosVendasLinhas
                Mapear(linha, newLinha)

                With newLinha
                    .AcaoCRUD = CShort(AcoesFormulario.Adicionar)
                    .IDAdiantamentoOrigem = .IDDocumentoVenda
                    .IDDocumentoOrigem = linha.IDDocumentoVenda
                    .DocumentoOrigem = linha.tbDocumentosVendas.Documento
                End With

                NewNC.DocumentosVendasLinhas.Add(newLinha)
            Next

            GeraDocVendaWithTransaction(inCtx, NewNC, inFiltro)
            GeraDocVendaPendenteWithTransaction(inCtx, NewNC, 0)

            inModelo.NCDA_CLI_DIFF = NewNC
        End Sub


        Public Sub ValidarDocumento(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef model As Oticas.DocumentosVendas)
            Dim blnTemLinhas As Boolean = False
            Dim dblTotalLinha As Double = 0
            Dim dblTotalDescontosLinha As Double = 0
            Dim dblTotalDocumento As Double = 0
            Dim dblTotalLinhas As Double = 0
            Dim lstArtAbaixoPrecoCusto As New List(Of DocumentosVendasLinhas)

            For Each DVL In model.DocumentosVendasLinhas
                If DVL.AcaoCRUD <> AcoesFormulario.Remover Then
                    If Not DVL.IDArtigo Is Nothing Then
                        blnTemLinhas = True
                        If DVL.Descricao Is Nothing Then
                            Throw New Exception(Traducao.EstruturaDocumentos.DescricaoNaoPreenchida)
                        End If

                        If DVL.Quantidade < 1 Then
                            Throw New Exception(Traducao.EstruturaDocumentos.QuantidadeZero)
                        End If

                        If DVL.TotalComDescontoLinha < 0 Then
                            Throw New Exception(Traducao.EstruturaDocumentos.ValorDescontoLinhaInvalido)
                        End If

                        If DVL.TotalComDescontoCabecalho.Value < 0 Then
                            Throw New Exception(Traducao.EstruturaDocumentos.ValorDescontosInvalido)
                        End If

                        If DVL.ValorEntidade1.Value > DVL.TotalComDescontoCabecalho Then
                            Throw New Exception(Traducao.EstruturaDocumentos.ValorEntidade1Invalido)
                        End If

                        If DVL.ValorEntidade2 > DVL.TotalComDescontoCabecalho Then
                            Throw New Exception(Traducao.EstruturaDocumentos.ValorEntidade2Invalido)
                        End If

                        If DVL.IDTaxaIva Is Nothing Then
                            Throw New Exception(Traducao.EstruturaDocumentos.CodigoIvaInvalido)
                        End If

                        If model.TipoFiscal = TiposDocumentosFiscal.NotaCredito OrElse model.TipoFiscal = TiposDocumentosFiscal.NotaDebito Then
                            If DVL.DocumentoOrigem Is Nothing OrElse String.IsNullOrEmpty(DVL.DocumentoOrigem) Then
                                Throw New Exception(Traducao.Cliente.Doc_docorigem_falta)
                            End If
                        End If

                        dblTotalLinha += If(DVL.PrecoUnitario IsNot Nothing, DVL.PrecoUnitario, 0)

                        dblTotalDescontosLinha += If(DVL.ValorDescontoLinha IsNot Nothing, DVL.ValorDescontoLinha, 0) + If(DVL.ValorDescontoCabecalho IsNot Nothing, DVL.ValorDescontoCabecalho, 0)

                        dblTotalLinhas += If(DVL.ValorIncidencia IsNot Nothing, DVL.ValorIncidencia, 0) + If(DVL.ValorIVA IsNot Nothing, DVL.ValorIVA, 0)

                        'TODO: PASSAR ISTO PARA FORA DO CICLO
                        Dim prcMedio As Double? = inCtx.tbArtigos.Where(Function(f) f.ID = DVL.IDArtigo).FirstOrDefault.Medio
                        If DVL.PrecoUnitarioEfetivo < prcMedio Then
                            lstArtAbaixoPrecoCusto.Add(DVL)
                        End If
                    End If
                End If
            Next

            If model.AcaoFormulario = AcoesFormulario.Adicionar Then
                dblTotalDocumento = model.TotalMoedaDocumento
                If Math.Round(dblTotalDocumento, intCasasDecTotais, MidpointRounding.AwayFromZero) <> Math.Round(dblTotalLinhas, intCasasDecTotais, MidpointRounding.AwayFromZero) Then
                    Throw New ClsExF3MValidacao("O Total de iva do documento não corresponde ao somatório do iva das linhas. Por favor altere uma linha para recalcular os valores.", TipoAlerta.Aviso)
                End If
            End If

            If model.ID = 0 AndAlso Not blnTemLinhas Then Throw New Exception(Traducao.EstruturaDocumentos.NaoTemLinhas)

            If model.TotalEntidade1 > 0 AndAlso model.IDEntidade1 Is Nothing Then Throw New Exception(Traducao.EstruturaDocumentos.Entidade1NaoPreenchida)

            If model.TotalEntidade2 > 0 AndAlso model.IDEntidade2 Is Nothing Then Throw New Exception(Traducao.EstruturaDocumentos.Entidade2NaoPreenchida)

            'VALIDA FS > 1000
            Dim idTipoDocumento As Long = model.IDTipoDocumento
            Dim strTipoDocumento = BDContexto.tbTiposDocumento.Where(Function(f) f.ID = idTipoDocumento).FirstOrDefault?.tbSistemaTiposDocumentoFiscal?.Tipo

            If model.TotalMoedaDocumento > CDbl(1000) AndAlso strTipoDocumento IsNot Nothing AndAlso strTipoDocumento.ToLower() = TiposDocumentosFiscal.FaturaSimplificada.ToLower() Then
                Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.Aviso_FaturaSimplificada)
            End If

            'valida se tem pagamentos
            Dim IDDocumentoVenda As Long = model.ID
            Dim IDEstadoAnterior As Nullable(Of Long) = BDContexto.tbDocumentosVendas.Where(Function(f) f.ID = IDDocumentoVenda).FirstOrDefault?.IDEstado
            If model.IDEstado <> IDEstadoAnterior Then
                Using rp As New RepositorioPagamentosVendas
                    If rp.GetPagamentosVendas(model.ID).Where(Function(f) f.CodigoTipoEstado <> TiposEstados.Anulado).Count > 0 Then
                        Throw New Exception(Traducao.Cliente.Aviso_DocTemPagamentos)
                    End If
                End Using
            End If

            ' Validação do limite máximo de descontos do documento.
            Dim LMD As Double? = ClsF3MSessao.ListaPropriedadeStorage(Of Double?)("LimiteMaxDesconto")
            If LMD IsNot Nothing Then
                If (dblTotalDescontosLinha > 0) Then
                    If (dblTotalDescontosLinha * 100 / dblTotalLinha) > LMD Then
                        Throw New Exception(Traducao.EstruturaDocumentos.UltrapassouLimiteMaxDesconto.Replace("{0}", LMD))
                    End If
                End If
            End If

            ' Validação do total do documento de venda do serviço
            Dim TDV As Long = ClsF3MSessao.ListaPropriedadeStorage(Of Long)("TotalDocVenda")
            If TDV > 0 Then
                Dim DocOrigem As tbDocumentosVendas

                Dim IDDocOrigem = model.DocumentosVendasLinhas.Where(Function(f) f.IDDocumentoOrigem IsNot Nothing).FirstOrDefault?.IDDocumentoOrigem
                DocOrigem = inCtx.tbDocumentosVendas.Where(Function(f) f.ID = IDDocOrigem).FirstOrDefault

                If DocOrigem IsNot Nothing Then
                    Select Case TDV
                        Case 1 '"Igual ao Serviço"
                            If model.TotalMoedaDocumento <> DocOrigem.TotalMoedaDocumento Then
                                Throw New Exception(Traducao.EstruturaDocumentos.TotalDocVendaIgualServico)
                            End If
                        Case 2 '"Abaixo ou Igual ao Serviço"
                            If model.TotalMoedaDocumento > DocOrigem.TotalMoedaDocumento Then
                                Throw New Exception(Traducao.EstruturaDocumentos.TotalDocVendaMenorIgualServico)
                            End If
                        Case 3 '"Acima ou Igual ao Serviço"
                            If model.TotalMoedaDocumento < DocOrigem.TotalMoedaDocumento Then
                                Throw New Exception(Traducao.EstruturaDocumentos.TotalDocVendaMaiorIgualServico)
                            End If
                    End Select
                End If
            End If

            ' Validação do preço de venda abaixo do custo medio de custo.
            Dim VACM As Boolean? = ClsF3MSessao.ListaPropriedadeStorage(Of Boolean?)("VendaAbaixoCustoMedio")
            If Not IsNothing(VACM) AndAlso Not VACM Then
                If lstArtAbaixoPrecoCusto.Count Then
                    Throw New Exception(Traducao.EstruturaDocumentos.VendaAbaixoCustoMedio.Replace("{0}", String.Join(",", lstArtAbaixoPrecoCusto.Select(Function(s) s.CodigoArtigo).Distinct().ToList())))
                End If
            End If

            Dim blnAnulado As Boolean = RepositorioDocumentosVendas.EAnulado(BDContexto, model.IDEstado)
            If blnAnulado Then 'anulado
                Dim NumDiasAnular As Long = DateDiff("d", CDate(model.DataDocumento), DateTime.Now.Date)
                If NumDiasAnular < 0 OrElse NumDiasAnular > ClsF3MSessao.RetornaParametros.NumDiasAnular Then
                    Throw New Exception(Traducao.Cliente.Aviso_NumDiasAnular)
                    'model.ValidaEstado = 12 ' o numero de dias para anular é superior ao definido nos parâmetros da empresa
                End If
            Else
                Dim NumDias As Long = DateDiff("d", DateTime.Now.Date, CDate(model.DataDocumento))
                If NumDias > ClsF3MSessao.RetornaParametros.NumDiasAntecedencia Then
                    Throw New Exception(Traducao.Cliente.Aviso_NumDiasAntecedencia)
                    'model.ValidaEstado = 11 ' o numero de dias de antecendencia na geração do documento é superior ao definido nos parâmetros da empresa
                End If
            End If

            If model.AcaoFormulario <> AcoesFormulario.Adicionar Then
                'validar se tem documento origem associado e vai anular 
                If LerIDDocumentoOrigem(BDContexto, model.ID, model.IDTipoDocumento) Then
                    Throw New Exception(Traducao.Cliente.Aviso_TemDocOrigem)
                End If
            End If

            If Not blnAnulado Then 'se não está anulado
                'valida se o escolheu consumidor final e o tipo doc permite
                Dim blnCF As Boolean? = (From x In BDContexto.tbTiposDocumento Where x.ID = idTipoDocumento Select x.RegistarCosumidorFinal).FirstOrDefault()
                If model.CodigoEntidade = "CF" AndAlso Not blnCF Then Throw New Exception(Traducao.Cliente.Aviso_ConsumidorFinal)
            End If
        End Sub

        ''' <summary>
        ''' Funcao que atualiza o valor pago no servico e anula a ncda ao gerar um nc (caso exista servico na origem)
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="inModelo"></param>
        Private Sub AtualizaValorPagoDocOrigemAnulaNCDAFromNC(ctx As BD.Dinamica.Aplicacao, inModelo As DocumentosVendas)
            If inModelo.TipoFiscal = TiposDocumentosFiscal.NotaCredito AndAlso (inModelo.Adiantamento Is Nothing OrElse inModelo.Adiantamento = False) Then
                Dim IDDocumentoOrigemNC As Long? = inModelo.DocumentosVendasLinhas.FirstOrDefault().IDDocumentoOrigem

                If Not IDDocumentoOrigemNC Is Nothing Then
                    Dim IDDocumentoOrigemFT As Long? = ctx.tbDocumentosVendasLinhas.Where(Function(w) w.IDDocumentoVenda = IDDocumentoOrigemNC).FirstOrDefault.IDDocumentoOrigem

                    If Not IDDocumentoOrigemFT Is Nothing Then
                        Dim docVenda As tbDocumentosVendas = ctx.tbDocumentosVendas.FirstOrDefault(Function(w) w.ID = IDDocumentoOrigemFT)

                        If docVenda.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico Then
                            'ANULA CASO EXISTA NCDA
                            Dim IDNCDA As Long = GetNCDAByIDDocumentoVendaServico(ctx, docVenda.ID)
                            If IDNCDA <> 0 Then
                                Dim ID_ESTADO_ANULADO_DV As Long = (From x In BDContexto.tbEstados
                                                                    Where x.tbSistemaTiposEstados.Codigo = TiposEstados.Anulado AndAlso
                                                                        x.tbSistemaEntidadesEstados.Codigo = TiposEntidadeEstados.DocumentosVenda
                                                                    Select x.ID).FirstOrDefault()

                                Using rpPagamentosVendas As New RepositorioPagamentosVendas
                                    rpPagamentosVendas.AnulaNCDA(ctx, IDNCDA, ID_ESTADO_ANULADO_DV)
                                End Using
                            End If

                            'ATUALIZA VALOR PAGO
                            'Dim strSqlQueryValorJaPago As String = String.Empty
                            'strSqlQueryValorJaPago &= " SELECT ISNULL(SUM(DVL.ValorIncidencia + DVL.ValorIVA), 0) AS resultado "
                            'strSqlQueryValorJaPago &= " FROM tbDocumentosVendas AS DV  "
                            'strSqlQueryValorJaPago &= "    INNER JOIN tbDocumentosVendasLinhas AS DVL ON DV.ID = DVL.IDDocumentoVenda "
                            'strSqlQueryValorJaPago &= "    INNER JOIN tbTiposDocumento AS TD ON DV.IDTipoDocumento = TD.ID "
                            'strSqlQueryValorJaPago &= "    INNER JOIN tbSistemaTiposDocumentoFiscal AS TDF ON TDF.ID = TD.IDSistemaTiposDocumentoFiscal "
                            'strSqlQueryValorJaPago &= "    INNER JOIN tbEstados AS E ON E.ID = DV.IDEstado "
                            'strSqlQueryValorJaPago &= "    INNER JOIN tbSistemaTiposEstados AS TE ON TE.ID = E.IDTipoEstado "
                            'strSqlQueryValorJaPago &= " WHERE TE.Codigo ='" & TiposEstados.Efetivo & "' AND DVL.iddocumentoorigem =" & docVenda.ID
                            'strSqlQueryValorJaPago &= " AND TD.Adiantamento = 1 AND TDF.Tipo = '" & TiposDocumentosFiscal.FaturaRecibo & "'"

                            'Dim valorJaPago As Double = 0 ctx.Database.SqlQuery(Of Double)(strSqlQueryValorJaPago).FirstOrDefault()

                            'ATUALIZA VALOR PAGO DO SERVICO
                            With docVenda
                                .ValorPago = CDbl(0)
                            End With

                            With ctx
                                .tbDocumentosVendas.Attach(docVenda)
                                .Entry(docVenda).[Property](Function(x) x.ValorPago).IsModified = True
                                .SaveChanges()
                            End With
                        End If
                    End If
                End If
            End If
        End Sub
#End Region

#Region "Funções Auxiliares"
        Public Sub PreencheLinhas(item As DocumentosVendas)
            Try
                item.DocumentosVendasLinhas.AddRange(BDContexto.tbDocumentosVendasLinhas _
                                       .Where(Function(f) f.IDServico Is Nothing And f.IDDocumentoVenda = item.ID) _
                                       .Select(Function(s) New Oticas.DocumentosVendasLinhas With {
                                                .ID = s.ID, .IDDocumentoVenda = s.IDDocumentoVenda, .IDCampanha = s.IDCampanha, .IDArtigo = s.IDArtigo, .Descricao = s.Descricao,
                                                .IDTipoOlho = s.IDTipoOlho, .Quantidade = s.Quantidade, .ValorDescontoLinha = s.ValorDescontoLinha,
                                                .PrecoUnitario = s.PrecoUnitario, .PrecoUnitarioEfetivo = s.PrecoUnitarioEfetivo, .PrecoUnitarioEfetivoSemIva = s.PrecoUnitarioEfetivoSemIva, .ValorDescontoEfetivoSemIva = s.ValorDescontoEfetivoSemIva, .Desconto1 = s.Desconto1,
                                                .TotalComDescontoLinha = s.TotalComDescontoLinha, .ValorDescontoCabecalho = s.ValorDescontoCabecalho, .TotalComDescontoCabecalho = s.TotalComDescontoCabecalho,
                                                .TotalFinal = s.TotalFinal, .ValorUnitarioEntidade1 = s.ValorUnitarioEntidade1, .ValorUnitarioEntidade2 = s.ValorUnitarioEntidade2,
                                                .ValorEntidade1 = s.ValorEntidade1, .ValorEntidade2 = s.ValorEntidade2, .IDTaxaIva = s.IDTaxaIva, .TaxaIva = s.TaxaIva, .ValorIVA = s.ValorIVA, .ValorIncidencia = s.ValorIncidencia,
                                                .DescricaoVariavel = s.tbArtigos.DescricaoVariavel, .MotivoIsencaoIva = s.MotivoIsencaoIva, .CodigoMotivoIsencaoIva = If(s.tbIVA.tbSistemaCodigosIVA IsNot Nothing, s.tbIVA.tbSistemaCodigosIVA.Codigo, Nothing),
                                                .IDEspacoFiscal = s.IDEspacoFiscal, .EspacoFiscal = s.EspacoFiscal, .SiglaPais = s.SiglaPais, .IDRegimeIva = s.IDRegimeIva, .RegimeIva = s.RegimeIva,
                                                .IDTipoDocumentoOrigem = s.IDTipoDocumentoOrigem, .IDDocumentoOrigem = s.IDDocumentoOrigem, .IDLinhaDocumentoOrigem = s.IDLinhaDocumentoOrigem, .DocumentoOrigem = s.DocumentoOrigem,
                                                .CodigoArtigo = s.tbArtigos.Codigo, .IDUnidade = s.IDUnidade, .CodigoRegiaoIva = s.CodigoRegiaoIva,
                                                .TipoTaxa = s.TipoTaxa, .CodigoBarrasArtigo = s.CodigoBarrasArtigo, .CodigoUnidade = s.CodigoUnidade, .CodigoTipoIva = s.CodigoTipoIva,
                                                .IDLote = s.IDLote, .CodigoLote = s.CodigoLote, .DescricaoLote = s.DescricaoLote, .GereLotes = False,
                                                .IDArmazem = s.IDArmazem, .IDArmazemDestino = s.IDArmazemDestino, .DescricaoArmazem = If(s.tbArmazens IsNot Nothing, s.tbArmazens.Descricao, Nothing), .DescricaoArmazemDestino = If(s.tbArmazens1 IsNot Nothing, s.tbArmazens1.Descricao, Nothing),
                                                .IDArmazemLocalizacao = s.IDArmazemLocalizacao, .CodigoArmazemLocalizacao = If(s.tbArmazensLocalizacoes IsNot Nothing, s.tbArmazensLocalizacoes.Codigo, Nothing), .DescricaoArmazemLocalizacao = If(s.tbArmazensLocalizacoes IsNot Nothing, s.tbArmazensLocalizacoes.Descricao, Nothing),
                                                .IDArmazemLocalizacaoDestino = s.IDArmazemLocalizacaoDestino, .CodigoArmazemLocalizacaoDestino = If(s.tbArmazens1 IsNot Nothing, s.tbArmazens1.Codigo, Nothing), .DescricaoArmazemLocalizacaoDestino = If(s.tbArmazensLocalizacoes1 IsNot Nothing, s.tbArmazensLocalizacoes1.Descricao, Nothing),
                                                .AcaoCRUD = CShort(AcoesFormulario.Alterar), .Ordem = s.Ordem, .Campanha = s.tbCampanhas.Descricao, .CodigoIva = s.tbIVA.Codigo,
                                                .DataEntrega = s.DataEntrega}).OrderBy(Function(o) o.Ordem).ToList())

            Catch ex As Exception
                Throw ex
            End Try
        End Sub

        ''' <summary>
        ''' Funcao que mapeia as linhas do documento para a nota de credito
        ''' </summary>
        ''' <param name="item"></param>
        Public Sub PreencheLinhasNC(item As DocumentosVendas)
            Dim DVLinhasDocumentoOrigem As List(Of tbDocumentosVendasLinhas) = BDContexto.tbDocumentosVendasLinhas.Where(
                Function(f) f.IDServico Is Nothing AndAlso f.IDDocumentoVenda = item.ID).
                Include("tbDocumentosVendas.tbEstados.tbSistemaTiposEstados").
                Include("tbArtigos").
                Include("tbIVA.tbSistemaCodigosIVA").
                Include("tbCampanhas").
                Include("tbArmazens").
                Include("tbArmazensLocalizacoes").
                ToList()

            PreencheLinhasNC(item, DVLinhasDocumentoOrigem)
        End Sub

        Public Sub PreencheLinhasNC(item As DocumentosVendas, DVLinhasDocumentoOrigem As List(Of tbDocumentosVendasLinhas), Optional blnNC As Boolean = False)

            Dim DVLinhasNC As List(Of tbDocumentosVendasLinhas)
            If blnNC Then
                DVLinhasNC = (From x In BDContexto.tbDocumentosVendasLinhas
                              Where x.IDDocumentoOrigem = item.ID AndAlso x.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo
                              Select x).ToList()
            Else
                DVLinhasNC = DVLinhasDocumentoOrigem.Where(
                    Function(f) f.IDDocumentoOrigem IsNot Nothing AndAlso
                    f.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo).ToList()
            End If

            For Each lin As tbDocumentosVendasLinhas In DVLinhasDocumentoOrigem
                Dim NCsLinha = DVLinhasNC.Where(Function(f) f.IDLinhaDocumentoOrigem IsNot Nothing AndAlso f.IDLinhaDocumentoOrigem = lin.ID).ToList
                Dim sumQtd As Double = NCsLinha.Sum(Function(f) f.Quantidade)

                Dim newLinha As New DocumentosVendasLinhas
                Mapear(lin, newLinha)

                With newLinha
                    .AcaoCRUD = AcoesFormulario.Alterar
                    .Ordem = lin.Ordem

                    .CodigoArtigo = lin.tbArtigos.Codigo : .DescricaoVariavel = lin.tbArtigos.DescricaoVariavel
                    .CodigoIva = lin.tbIVA.Codigo : .MotivoIsencaoIva = lin.tbIVA.Mencao : .CodigoMotivoIsencaoIva = lin.tbIVA.tbSistemaCodigosIVA?.Codigo
                    .Campanha = lin.tbCampanhas?.Descricao

                    .IDArmazemDestino = lin.IDArmazem : .DescricaoArmazemDestino = lin.tbArmazens?.Descricao
                    .IDArmazemLocalizacaoDestino = lin.IDArmazemLocalizacao : .CodigoArmazemLocalizacaoDestino = lin.tbArmazensLocalizacoes?.Codigo
                    .DescricaoArmazemLocalizacaoDestino = lin.tbArmazensLocalizacoes?.Descricao
                End With

                If lin.Quantidade > sumQtd Then newLinha.Quantidade = lin.Quantidade - sumQtd

                If lin.Quantidade <> sumQtd Then item.DocumentosVendasLinhas.Add(newLinha)
            Next
        End Sub

        Public Shared Function ERascunho(inCtx As BD.Dinamica.Aplicacao, inIDEstado As Long?) As Boolean?
            Try
                Dim Estado As List(Of tbEstados) = inCtx.tbEstados.Where(Function(f) f.ID = inIDEstado And f.tbSistemaTiposEstados.Codigo = "RSC").ToList

                If Estado IsNot Nothing Then
                    Return (Estado.Count > 0)
                End If

                Return Nothing
            Catch
                Throw
            End Try
        End Function

        Public Shared Function EEfetivo(inCtx As BD.Dinamica.Aplicacao, inIDEstado As Long?) As Boolean?
            Try
                Dim Estado As List(Of tbEstados) = inCtx.tbEstados.Where(Function(f) f.ID = inIDEstado And f.tbSistemaTiposEstados.Codigo = "EFT").ToList

                If Estado IsNot Nothing Then
                    Return (Estado.Count > 0)
                End If

                Return Nothing
            Catch
                Throw
            End Try
        End Function

        Public Shared Function EAnulado(inCtx As BD.Dinamica.Aplicacao, inIDEstado As Long?) As Boolean?
            Try
                Dim Estado As List(Of tbEstados) = inCtx.tbEstados.Where(Function(f) f.ID = inIDEstado And f.tbSistemaTiposEstados.Codigo = "ANL").ToList

                If Estado IsNot Nothing Then
                    Return (Estado.Count > 0)
                End If

                Return Nothing
            Catch
                Throw
            End Try
        End Function

        Public Shared Sub AtualizaCampo(inCtx As BD.Dinamica.Aplicacao, ByVal strTabela As String, ByVal lngId As Long, ByVal strCampo As String, ByVal strValor As String)
            Dim strQry As String = "update " & strTabela & " set " & strCampo & "=" & ClsUtilitarios.EnvolveSQL(strValor) & " where id=" & lngId
            inCtx.Database.ExecuteSqlCommand(strQry)
        End Sub

        Private Function VerificaSeJaExisteDocumentoAssociado(model As DocumentosVendas, docOrigem As tbDocumentosVendas) As Boolean
            Return Convert.ToBase64String(model.F3MMarcadorDocOrigem) <> Convert.ToBase64String(docOrigem.F3MMarcador)
        End Function

        Private Sub AtualizaPropsDocOrigem(ctx As Aplicacao, docOrigem As tbDocumentosVendas)
            With docOrigem
                .DataAlteracao = DateAndTime.Now()
                .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome()
            End With

            With ctx
                .tbDocumentosVendas.Attach(docOrigem)
                .Entry(docOrigem).[Property](Function(x) x.DataAlteracao).IsModified = True
                .Entry(docOrigem).[Property](Function(x) x.UtilizadorAlteracao).IsModified = True
                .SaveChanges()
            End With
        End Sub
#End Region

#Region "Cálculos"
        Private Function RetornaQtdVsPreco(inDVL As DocumentosVendasLinhas) As Double
            Try
                If inDVL.Quantidade Is Nothing Then inDVL.Quantidade = 1
                If inDVL.PrecoUnitario Is Nothing Then inDVL.PrecoUnitario = 0
                Dim dblValor As Double
                dblValor = inDVL.PrecoUnitario
                inDVL.PrecoUnitario = Math.Round(dblValor, intCasasDecPrecosUnitarios)
                dblValor = inDVL.Quantidade * inDVL.PrecoUnitario
                Return dblValor
            Catch
                Throw
            End Try
        End Function

        Public Sub CalculaTotalLinha(ByRef inDVL As DocumentosVendasLinhas, Col As String, ByRef inDV As DocumentosVendas)
            CalculaTotalLinha(inDVL, Col, inDV, intCasasDecTotais, intCasasDecPrecosUnitarios)
        End Sub

        Public Sub CalculaTotalLinha(ByRef inDVL As DocumentosVendasLinhas, Col As String, ByRef inDV As DocumentosVendas, ByVal inCDTotais As Integer, ByVal inCDPrecoUnit As Integer)
            Dim strTipo As String = String.Empty
            Dim inServico As New Servicos
            Dim lngID As Long = 0
            Dim lngIDTipoGraduacao As Long = 0
            Dim lngIDTipoOlho As Long = 0

            intCasasDecTotais = inCDTotais
            intCasasDecPrecosUnitarios = inCDPrecoUnit

            Select Case Col
                Case "Quantidade", "PrecoUnitario", "CodigoArtigo"
                    CalculaQtdPreco(inDVL)
                    CalculaValorDescontoLinha(inDVL)
                    CalculaValorDescontoCabecalho(inDVL, inDV)

                    If inDV.Entidade1Automatica AndAlso inDV.IDEntidade1 IsNot Nothing Then
                        If inDVL.Descricao IsNot Nothing AndAlso (inDVL.IDArtigo Is Nothing OrElse inDVL.IDArtigo >= 0) Then
                            Select Case inDVL.IDTipoGraduacao
                                Case TipoGraduacao.LentesContacto
                                    strTipo = "LC"
                                Case Else
                                    Select Case inDVL.IDTipoOlho
                                        Case TipoOlho.Direito, TipoOlho.Esquerdo
                                            strTipo = "LO"
                                    End Select
                            End Select

                            Select Case strTipo
                                Case "LO"
                                    If inDVL.IDTipoLente Is Nothing Then
                                        inDVL.IDTipoLente = 1
                                    End If

                                    Dim rp As New RepositorioEntidades
                                    Using rp
                                        inDVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoLentes(inDV, inDVL, strTipo, inDVL.IDTipoLente, inDVL.PotenciaCilindrica, inDVL.PotenciaEsferica, inDVL.PotenciaPrismatica, inDVL.TotalComDescontoCabecalho / inDVL.Quantidade)
                                    End Using

                                Case "LC"
                                    If inDVL.IDTipoLente Is Nothing Then
                                        inDVL.IDTipoLente = 10
                                    End If

                                    Dim rp As New RepositorioEntidades
                                    Using rp
                                        inDVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoLentes(inDV, inDVL, strTipo, inDVL.IDTipoLente, inDVL.PotenciaCilindrica, inDVL.PotenciaEsferica, 0, inDVL.TotalComDescontoCabecalho / inDVL.Quantidade)
                                    End Using
                                Case Else
                                    Dim rp As New RepositorioEntidades
                                    Using rp
                                        inDVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoArtigo(inDV, inDVL, inDVL.IDArtigo, inDVL.TotalComDescontoCabecalho / inDVL.Quantidade)
                                    End Using
                            End Select
                        Else
                            Dim rp As New RepositorioEntidades
                            Using rp
                                inDVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoArtigo(inDV, inDVL, inDVL.IDArtigo, inDVL.TotalComDescontoCabecalho / inDVL.Quantidade)
                            End Using
                        End If

                        CalculaValorUnitarioEntidade1(inDVL, inDV)
                    Else
                        CalculaValorEntidade1(inDVL)
                    End If

                    CalculaValorEntidade2(inDVL)

                Case "Desconto1"
                    CalculaDesconto1(inDVL)
                    CalculaValorDescontoCabecalho(inDVL, inDV)
                    CalculaValorEntidade2(inDVL)

                Case "ValorDescontoLinha"
                    CalculaValorDescontoLinha(inDVL)
                    CalculaValorDescontoCabecalho(inDVL, inDV)
                    CalculaValorEntidade2(inDVL)

                Case "TotalComDescontoLinha"
                    CalculaTotalComDescontoLinha(inDVL)
                    CalculaValorDescontoCabecalho(inDVL, inDV)
                    CalculaValorEntidade2(inDVL)

                Case "ValorDescontoCabecalho"
                    CalculaValorDescontoCabecalho(inDVL, inDV)

                Case "TotalComDescontoCabecalho"
                    CalculaTotalComDescontoCabecalho(inDVL)

                Case "ValorUnitarioEntidade1"
                    CalculaValorUnitarioEntidade1(inDVL, inDV)

                Case "ValorEntidade1"
                    CalculaValorEntidade1(inDVL)

                Case "ValorUnitarioEntidade2"
                    CalculaValorUnitarioEntidade2(inDVL)

                Case "ValorEntidade2"
                    CalculaValorEntidade2(inDVL)
            End Select

            CalculaPrecoUnitarioEfetivo(inDVL)

            With inDVL
                .TotalFinal = CalculaPrecoFinal(inDVL)
                .PrecoTotal = .TotalFinal
            End With

            CalculaValorIncidenciaLinha(inDVL)
            CalculaValorIvaLinha(inDVL)
        End Sub

        Private Sub CalculaDesconto1(ByRef inDVL As DocumentosVendasLinhas)

            inDVL.Desconto1 = Math.Round(CDbl(inDVL.Desconto1), 2)

            If inDVL.Desconto1 > 100 Then
                inDVL.Desconto1 = 100
            End If

            inDVL.TotalSemDescontoLinha = RetornaQtdVsPreco(inDVL)
            inDVL.ValorDescontoLinha = RetornaQtdVsPreco(inDVL) * inDVL.Desconto1 / 100
            inDVL.TotalComDescontoLinha = RetornaQtdVsPreco(inDVL) - inDVL.ValorDescontoLinha

            If inDVL.ValorDescontoLinha > (inDVL.TotalSemDescontoLinha - inDVL.ValorEntidade1 - inDVL.ValorEntidade2) Then
                inDVL.ValorDescontoLinha = inDVL.TotalSemDescontoLinha - inDVL.ValorEntidade1 - inDVL.ValorEntidade2
                If inDVL.ValorDescontoLinha < 0 Then
                    inDVL.ValorDescontoLinha = 0
                    inDVL.ValorEntidade1 = 0
                    inDVL.ValorEntidade2 = 0
                End If

                If inDVL.TotalSemDescontoLinha = 0 Then
                    dblValor = 0
                Else
                    dblValor = inDVL.ValorDescontoLinha * 100 / inDVL.TotalSemDescontoLinha
                End If
                inDVL.Desconto1 = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            End If
        End Sub

        Private Sub CalculaValorDescontoLinha(ByRef inDVL As DocumentosVendasLinhas)
            Dim dblValor As Double

            inDVL.TotalSemDescontoLinha = RetornaQtdVsPreco(inDVL)
            inDVL.ValorDescontoLinha = Math.Round(CDbl(inDVL.ValorDescontoLinha), intCasasDecTotais)

            If inDVL.ValorDescontoLinha > RetornaQtdVsPreco(inDVL) Then
                inDVL.ValorDescontoLinha = RetornaQtdVsPreco(inDVL)
            End If

            inDVL.TotalComDescontoLinha = RetornaQtdVsPreco(inDVL) - inDVL.ValorDescontoLinha

            'HERE
            If inDVL.TotalSemDescontoLinha = 0 Then
                inDVL.Desconto1 = 0
                inDVL.TotalComDescontoLinha = 0
            Else
                dblValor = inDVL.ValorDescontoLinha * 100 / inDVL.TotalSemDescontoLinha
                inDVL.Desconto1 = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            End If

            If inDVL.ValorDescontoLinha > (inDVL.TotalSemDescontoLinha - inDVL.ValorEntidade1 - inDVL.ValorEntidade2) Then
                inDVL.ValorDescontoLinha = inDVL.TotalSemDescontoLinha - inDVL.ValorEntidade1 - inDVL.ValorEntidade2
                If inDVL.ValorDescontoLinha < 0 Then
                    inDVL.ValorDescontoLinha = 0
                    inDVL.ValorEntidade1 = 0
                    inDVL.ValorEntidade2 = 0
                End If

                If inDVL.TotalSemDescontoLinha = 0 Then
                    dblValor = 0
                Else
                    dblValor = inDVL.ValorDescontoLinha * 100 / inDVL.TotalSemDescontoLinha
                End If
                inDVL.Desconto1 = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            End If
        End Sub

        Private Sub CalculaTotalComDescontoLinha(ByRef inDVL As DocumentosVendasLinhas)

            inDVL.TotalSemDescontoLinha = RetornaQtdVsPreco(inDVL)
            inDVL.TotalSemDescontoLinha = Math.Round(CDbl(inDVL.TotalSemDescontoLinha), intCasasDecTotais)

            If inDVL.TotalComDescontoLinha > inDVL.TotalSemDescontoLinha Then
                inDVL.TotalComDescontoLinha = inDVL.TotalSemDescontoLinha
            End If

            If inDVL.TotalSemDescontoLinha = 0 Then
                inDVL.Desconto1 = 0
                inDVL.TotalComDescontoLinha = 0
            Else
                inDVL.ValorDescontoLinha = RetornaQtdVsPreco(inDVL) - inDVL.TotalComDescontoLinha
                dblValor = inDVL.ValorDescontoLinha * 100 / inDVL.TotalSemDescontoLinha
                inDVL.Desconto1 = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            End If

            If inDVL.TotalComDescontoLinha < inDVL.TotalComDescontoCabecalho Then
                inDVL.TotalComDescontoCabecalho = inDVL.TotalComDescontoLinha
            End If
        End Sub

        Private Sub CalculaValorDescontoCabecalho(ByRef inDVL As DocumentosVendasLinhas, inModelo As DocumentosVendas)
            Dim UtilizaConfigDescontos As Boolean = lstConfigDesconto.Where(Function(w) w.Desconto <> 0).Count > 0

            If UtilizaConfigDescontos AndAlso ELinhasTodas AndAlso (inModelo.ValorDesconto <> 0 OrElse inModelo.PercentagemDesconto <> 0) Then
                CalculaValorDescCabComConfigDescontos(inDVL, inModelo)

            Else
                CalculaValorDescCabSemConfigDescontos(inDVL)
            End If
        End Sub

        Private Sub CalculaTotalComDescontoCabecalho(ByRef inDVL As DocumentosVendasLinhas)
            Try
                If inDVL.TotalComDescontoCabecalho > inDVL.TotalComDescontoLinha Then
                    inDVL.TotalComDescontoCabecalho = 0
                End If

                If inDVL.TotalComDescontoCabecalho < inDVL.ValorEntidade1 + inDVL.ValorEntidade2 Then
                    inDVL.TotalComDescontoCabecalho = inDVL.ValorEntidade1 + inDVL.ValorEntidade2
                End If

                inDVL.ValorDescontoCabecalho = RetornaQtdVsPreco(inDVL) - inDVL.ValorDescontoLinha - inDVL.TotalComDescontoCabecalho
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorUnitarioEntidade1(ByRef inDVL As DocumentosVendasLinhas, ByRef inDV As DocumentosVendas)
            Try
                inDVL.ValorUnitarioEntidade1 = Math.Round(CDbl(inDVL.ValorUnitarioEntidade1), intCasasDecPrecosUnitarios)

                inDVL.ValorEntidade1 = inDVL.Quantidade * inDVL.ValorUnitarioEntidade1

                If inDVL.ValorEntidade1 + inDVL.ValorEntidade2 > inDVL.TotalComDescontoCabecalho Then
                    inDVL.ValorEntidade1 = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade2
                    inDVL.ValorUnitarioEntidade1 = inDVL.ValorEntidade1 / inDVL.Quantidade

                    If inDVL.ValorEntidade1 < 0 Then
                        inDVL.ValorEntidade1 = 0
                        inDVL.ValorUnitarioEntidade1 = 0
                    End If
                End If
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorEntidade1(ByRef inDVL As DocumentosVendasLinhas)
            Try
                inDVL.ValorEntidade1 = Math.Round(CDbl(inDVL.ValorEntidade1), intCasasDecTotais)

                If inDVL.ValorEntidade1 + inDVL.ValorEntidade2 > inDVL.TotalComDescontoCabecalho Then
                    inDVL.ValorEntidade1 = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade2
                End If
                Dim dblValor As Double = inDVL.ValorEntidade1 / inDVL.Quantidade
                inDVL.ValorUnitarioEntidade1 = Math.Round(dblValor, intCasasDecPrecosUnitarios)

                inDVL.TotalFinal = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade1
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorUnitarioEntidade2(ByRef inDVL As DocumentosVendasLinhas)
            Try
                inDVL.ValorEntidade2 = Math.Round(CDbl(inDVL.ValorEntidade2), intCasasDecPrecosUnitarios)

                inDVL.ValorEntidade2 = inDVL.Quantidade * inDVL.ValorUnitarioEntidade2

                If inDVL.ValorEntidade1 + inDVL.ValorEntidade2 > inDVL.TotalComDescontoCabecalho Then
                    inDVL.ValorEntidade2 = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade1
                    inDVL.ValorUnitarioEntidade2 = inDVL.ValorEntidade2 / inDVL.Quantidade

                    If inDVL.ValorEntidade2 < 0 Then
                        inDVL.ValorEntidade2 = 0
                        inDVL.ValorUnitarioEntidade2 = 0
                    End If
                End If
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorEntidade2(ByRef inDVL As DocumentosVendasLinhas)
            Try
                inDVL.ValorEntidade2 = Math.Round(CDbl(inDVL.ValorEntidade2), intCasasDecTotais)

                If inDVL.ValorEntidade1 + inDVL.ValorEntidade2 > inDVL.TotalComDescontoCabecalho Then
                    inDVL.ValorEntidade2 = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade1
                End If
                Dim dblValor As Double = inDVL.ValorEntidade2 / inDVL.Quantidade
                inDVL.ValorUnitarioEntidade2 = Math.Round(dblValor, intCasasDecPrecosUnitarios)

                inDVL.TotalFinal = inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade2
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Private Function CalculaPrecoFinal(ByRef inDVL As DocumentosVendasLinhas) As Double
            Dim dblValor As Double = (RetornaQtdVsPreco(inDVL) - inDVL.ValorDescontoLinha - inDVL.ValorDescontoCabecalho - inDVL.ValorEntidade1 - inDVL.ValorEntidade2)
            Return Math.Round(dblValor, intCasasDecTotais)
        End Function

        Private Sub CalculaPrecoUnitarioEfetivo(ByRef inDVL As DocumentosVendasLinhas)
            Dim dblValor As Double = 0
            Dim dblValorSemIva As Double = 0

            If inDVL.TaxaIva Is Nothing Then
                inDVL.TaxaIva = dblTaxaIVA
                inDVL.IDTaxaIva = lngIDTaxaIVA
            End If

            If inDVL.Quantidade > 0 Then
                dblValor = (RetornaQtdVsPreco(inDVL) - inDVL.ValorDescontoLinha - inDVL.ValorDescontoCabecalho) / inDVL.Quantidade
                dblValorSemIva = dblValor * 100 / (100 + inDVL.TaxaIva)
            End If

            inDVL.PrecoUnitarioEfetivo = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            inDVL.PrecoUnitarioEfetivoSemIva = Math.Round(dblValorSemIva, intCasasDecPrecosUnitarios)
        End Sub

        Private Sub CalculaQtdPreco(inDVL As DocumentosVendasLinhas)
            Try
                If inDVL.NumCasasDecUnidade Is Nothing Then
                    inDVL.Quantidade = Math.Round(CDbl(inDVL.Quantidade), 0)
                Else
                    inDVL.Quantidade = Math.Round(CDbl(inDVL.Quantidade), CInt(inDVL.NumCasasDecUnidade))
                End If

                If inDVL.Quantidade = 0 Then
                    inDVL.Quantidade = 1
                End If
                Dim dblValor = RetornaQtdVsPreco(inDVL)
                inDVL.TotalSemDescontoLinha = Math.Round(dblValor, intCasasDecPrecosUnitarios)
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorIvaLinha(inDVL As DocumentosVendasLinhas)
            Try
                Dim dblValor As Double

                With inDVL
                    dblValor = (.TotalComDescontoCabecalho - .ValorEntidade2) - .ValorIncidencia

                    .ValorIVA = Math.Round(dblValor, intCasasDecTotais)
                    .ValorImposto = .ValorIVA
                End With
            Catch
                Throw
            End Try
        End Sub

        Private Sub CalculaValorIncidenciaLinha(inDVL As DocumentosVendasLinhas)
            Try
                Dim dblValor As Double
                If inDVL.TaxaIva Is Nothing Then
                    inDVL.TaxaIva = dblTaxaIVA
                    inDVL.IDTaxaIva = lngIDTaxaIVA
                End If

                dblValor = (inDVL.TotalComDescontoCabecalho - inDVL.ValorEntidade2) * 100 / (100 + inDVL.TaxaIva)
                inDVL.ValorIncidencia = Math.Round(dblValor, intCasasDecTotais)
                dblValor = (inDVL.TotalSemDescontoLinha - inDVL.TotalFinal) * 100 / (100 + inDVL.TaxaIva)
                inDVL.ValorDescontoEfetivoSemIva = Math.Round(dblValor, intCasasDecTotais)

                If inDVL.IDArtigo Is Nothing Then
                    inDVL.TaxaIva = Nothing
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Function Calcula(inFiltro As ClsF3MFiltro, ByRef inModelo As DocumentosVendas, Optional inCtx As BD.Dinamica.Aplicacao = Nothing) As DocumentosVendas
            Try
                If inModelo.IDTipoDocumento IsNot Nothing Then
                    If inCtx IsNot Nothing Then
                        BDContexto = inCtx
                    End If

                    ' --- 
                    If Not inFiltro Is Nothing Then
                        ELinhasTodas = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, "ELinhasTodas", GetType(Boolean))
                        EServicosChangeEntidade = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, "EServicosChangeEntidade", GetType(Boolean))
                        campoAlteradoDTD = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, "CampoAlterado", CamposGenericos.CampoTexto)
                    End If


                    Dim modelAux As DocumentosVendas = inModelo
                    Dim ids?() As Long = modelAux.DocumentosVendasLinhas.Select(Function(s) s.IDArtigo).Distinct.ToArray()

                    lstArtigosCalcula = New List(Of tbArtigos)
                    lstArtigosCalcula = BDContexto.tbArtigos.Include("tbArtigosPrecos").Where(Function(w) ids.Contains(w.ID)).ToList

                    Using rpIVA As New Oticas.Repositorio.TabelasAuxiliares.RepositorioIVA
                        lstConfigDesconto = rpIVA.ListaDescontosIVA()
                    End Using
                    ' --- 

                    Dim mTotalLinhas As Double = 0
                    Dim mSubTotal As Double = 0
                    Dim dblValorDescontoGlobal As Double = 0
                    Dim dblValorEntidade2 As Double = 0

                    Dim CampoAlterado As String = String.Empty
                    Dim Col As String = String.Empty

                    Dim IDLinha As Long = 0

                    Dim strQry As String = ""
                    strQry &= " select TD.ID from tbTiposDocumento TD "
                    strQry &= "  inner join tbSistemaTiposDocumentoFiscal TDS on TD.IDSistemaTiposDocumentoFiscal=TDS.ID "
                    strQry &= " inner join tbSistemaModulos SM on SM.ID=TD.IDModulo "
                    strQry &= " where TDS.Tipo='" & TiposDocumentosFiscal.NotaCredito & "' and SM.Codigo='" & SistemaCodigoModulos.Vendas & "' and td.Adiantamento=0 "

                    Dim lngID As Long = BDContexto.Database.SqlQuery(Of Long)(strQry).FirstOrDefault()

                    If inModelo.IDTipoDocumento = lngID Then
                        ValidaQuantidadePrecoUnitario(inModelo)
                    End If

                    Dim lngIdEntidade As Long = 0
                    If inModelo.IDEntidade IsNot Nothing Then
                        lngIdEntidade = inModelo.IDEntidade
                    End If

                    Dim lngIDMoeda As Long? = inModelo.IDMoeda
                    Dim moeda As tbMoedas = BDContexto.tbMoedas.Find(lngIDMoeda)

                    If moeda IsNot Nothing Then
                        intCasasDecTotais = moeda.CasasDecimaisTotais
                        intCasasDecImposto = moeda.CasasDecimaisIva
                        intCasasDecPrecosUnitarios = moeda.CasasDecimaisPrecosUnitarios
                    Else
                        intCasasDecTotais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                        intCasasDecImposto = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisIva
                        intCasasDecPrecosUnitarios = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios
                    End If

                    If Not inFiltro Is Nothing Then
                        CampoAlterado = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, "CampoAlterado", CamposGenericos.CampoTexto)
                        Col = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Col", GetType(String))
                        IDLinha = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDLinha", GetType(Long))
                    End If

                    If IDLinha <> 0 AndAlso Not String.IsNullOrEmpty(Col) Then
                        Dim DVL As New Oticas.DocumentosVendasLinhas
                        Dim IDServico = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, "IDServico", CamposGenericos.CampoValor)

                        If Not IDServico Is Nothing Then
                            IDServico = CType(IDServico, Long)
                            DVL = inModelo.DocumentosVendasLinhas.Where(Function(f) f.IDServico = IDServico And f.ID = IDLinha And f.AcaoCRUD <> AcoesFormulario.Remover).FirstOrDefault

                        Else
                            DVL = inModelo.DocumentosVendasLinhas.Where(Function(f) f.IDServico Is Nothing And f.ID = IDLinha And f.AcaoCRUD <> AcoesFormulario.Remover).FirstOrDefault

                            'TODO - SERVICOS ESTAO A UTILIZAR O ID E AS VENDAS A ORDEM
                            If DVL Is Nothing OrElse DVL.IDTipoOlho Is Nothing Then
                                DVL = inModelo.DocumentosVendasLinhas.Where(Function(f) f.IDServico Is Nothing And f.Ordem = IDLinha And f.AcaoCRUD <> AcoesFormulario.Remover).FirstOrDefault
                            End If
                        End If

                        If DVL IsNot Nothing Then
                            If DVL.Quantidade Is Nothing Then DVL.Quantidade = 1
                            If DVL.PrecoUnitario < 0 Then DVL.PrecoUnitario = 0
                            If DVL.Desconto1 < 0 Then DVL.Desconto1 = 0
                            If DVL.ValorDescontoLinha < 0 Then DVL.ValorDescontoLinha = 0
                            If DVL.TotalComDescontoLinha < 0 Then DVL.TotalComDescontoLinha = 0
                            If DVL.ValorUnitarioEntidade1 < 0 Then DVL.ValorUnitarioEntidade1 = 0
                            If DVL.ValorUnitarioEntidade2 < 0 Then DVL.ValorUnitarioEntidade2 = 0
                            If DVL.ValorEntidade1 < 0 Then DVL.ValorEntidade1 = 0
                            If DVL.ValorEntidade2 < 0 Then DVL.ValorEntidade2 = 0
                            If DVL.Quantidade Is Nothing Then DVL.Quantidade = 1
                            If DVL.Quantidade < 1 Then DVL.Quantidade = 1
                            If DVL.ValorEntidade1 Is Nothing Then DVL.ValorEntidade1 = 0
                            If DVL.ValorEntidade2 Is Nothing Then DVL.ValorEntidade2 = 0
                            If DVL.ValorDescontoLinha Is Nothing Then DVL.ValorDescontoLinha = 0
                            If DVL.ValorDescontoCabecalho Is Nothing Then DVL.ValorDescontoCabecalho = 0

                            ' Atribuir os valores para a definição das casas decimais a aplicar nas linhas
                            DVL.CasasDecimaisPrecosUnitarios = intCasasDecPrecosUnitarios
                            DVL.CasasDecimaisTotais = intCasasDecTotais
                            DVL.CasasDecimaisIva = intCasasDecImposto

                            Dim cli As tbClientes = BDContexto.tbClientes.Find(lngIdEntidade)

                            If cli IsNot Nothing AndAlso cli.Desconto1 > 0 AndAlso Col <> "Desconto1" AndAlso DVL.AcaoCRUD = AcoesFormulario.Adicionar Then
                                DVL.Desconto1 = cli.Desconto1
                                CalculaTotalLinha(DVL, "Desconto1", inModelo)
                            End If

                            If IDLinha >= 0 AndAlso Col IsNot Nothing Then
                                If DVL IsNot Nothing Then
                                    CalculaTotalLinha(DVL, Col, inModelo)
                                End If
                            End If

                            For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                                mTotalLinhas += DVL.TotalComDescontoLinha
                                mSubTotal += DVL.TotalSemDescontoLinha
                            Next

                            With inModelo
                                .PercentagemDesconto = ClsUtilitarios.RetornaZeroSeVazioDuplo(.PercentagemDesconto)
                                .ValorDesconto = ClsUtilitarios.RetornaZeroSeVazioDuplo(.ValorDesconto)
                                .TotalMoedaReferencia = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalMoedaReferencia)
                                .TotalMoedaDocumento = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalMoedaDocumento)
                                .SubTotal = mSubTotal
                            End With

                            PreencherTaxaIvaDaLinha(BDContexto, inModelo, DVL)

                            With inModelo
                                If mTotalLinhas = 0 Then
                                    inModelo.PercentagemDesconto = 0
                                Else
                                    inModelo.PercentagemDesconto = Math.Round(CDbl(inModelo.ValorDesconto) * 100 / CDbl(mTotalLinhas), 6)
                                End If
                            End With
                        End If
                    Else
                        'Determinar o valor das linhas com desconto 
                        For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                            ' Define preco de Artigo de acordo com os PV's definidos no Cliente e Loja (caso estejam definidos)
                            ' e caso o artigo tenha preços definidos para esse PV nessa Loja.
                            If DVL.PrecoUnitario = 0 AndAlso (Not ELinhasTodas OrElse EServicosChangeEntidade) Then
                                Select Case CampoAlterado
                                    Case "TotalMoedaReferencia", "TotalMoedaDocumento", "ValorDesconto", "PercentagemDesconto"
                                    Case Else
                                        Dim cli As tbClientes = BDContexto.tbClientes.Find(lngIdEntidade)
                                        If cli IsNot Nothing Then
                                            Dim IDEntidade As Long = inModelo.IDEntidade
                                            Dim pvCliente As Long = cli.IDPrecoSugerido
                                            If DVL.IDArtigo IsNot Nothing AndAlso DVL.IDArtigo > 0 Then
                                                Dim PrecosArtigos As List(Of tbArtigosPrecos) = lstArtigosCalcula.Where(Function(f) f.ID = DVL.IDArtigo).FirstOrDefault.tbArtigosPrecos.ToList()
                                                If PrecosArtigos.Any() Then

                                                    Dim PVLojaCliente = PrecosArtigos.Where(Function(a) a.IDLoja IsNot Nothing AndAlso a.IDLoja = ClsF3MSessao.RetornaLojaID AndAlso a.IDCodigoPreco = cli.IDPrecoSugerido).FirstOrDefault()
                                                    If PVLojaCliente IsNot Nothing Then
                                                        DVL.PrecoUnitario = PVLojaCliente.ValorComIva
                                                    Else

                                                        Dim PVClienteSemLoja = PrecosArtigos.Where(Function(a) a.IDLoja Is Nothing AndAlso a.IDCodigoPreco = cli.IDPrecoSugerido).FirstOrDefault()
                                                        If PVClienteSemLoja IsNot Nothing Then
                                                            DVL.PrecoUnitario = PVClienteSemLoja.ValorComIva

                                                        Else
                                                            Dim PV1LojaAtual = PrecosArtigos.Where(Function(a) a.IDLoja IsNot Nothing AndAlso a.IDLoja = ClsF3MSessao.RetornaLojaID AndAlso a.tbSistemaCodigosPrecos.Codigo = "PV1").FirstOrDefault()
                                                            If PV1LojaAtual IsNot Nothing Then
                                                                DVL.PrecoUnitario = PV1LojaAtual.ValorComIva

                                                            Else
                                                                Dim PV1SemLoja = PrecosArtigos.Where(Function(a) a.IDLoja Is Nothing AndAlso a.tbSistemaCodigosPrecos.Codigo = "PV1").FirstOrDefault()
                                                                If PV1SemLoja IsNot Nothing Then
                                                                    DVL.PrecoUnitario = PV1SemLoja.ValorComIva

                                                                Else
                                                                    DVL.PrecoUnitario = CDbl(0)
                                                                End If
                                                            End If
                                                        End If
                                                    End If
                                                End If
                                            End If
                                        End If
                                End Select
                            End If
                            ' Atribuir os valores para a definição das casas decimais a aplicar nas linhas
                            DVL.CasasDecimaisPrecosUnitarios = intCasasDecPrecosUnitarios
                            DVL.CasasDecimaisTotais = intCasasDecTotais
                            DVL.CasasDecimaisIva = intCasasDecImposto

                            If CampoAlterado IsNot Nothing Then
                                If CampoAlterado.ToLower = "entidade" Then
                                    CalculaTotalLinha(DVL, "Desconto1", inModelo)
                                End If
                            End If

                            CalculaQtdPreco(DVL)
                            CalculaValorDescontoLinha(DVL)
                            CalculaTotalComDescontoLinha(DVL)
                            mTotalLinhas += DVL.TotalComDescontoLinha

                            CalculaValorDescontoCabecalho(DVL, inModelo)

                            If inModelo.Entidade1Automatica AndAlso inModelo.IDEntidade1 IsNot Nothing Then
                                Dim strTipo As String = String.Empty

                                If DVL.Descricao IsNot Nothing AndAlso (DVL.IDArtigo Is Nothing OrElse DVL.IDArtigo = 0) Then

                                    Select Case DVL.IDTipoGraduacao
                                        Case TipoGraduacao.LentesContacto
                                            strTipo = "LC"
                                        Case Else
                                            Select Case DVL.IDTipoOlho
                                                Case TipoOlho.Direito, TipoOlho.Esquerdo
                                                    strTipo = "LO"
                                            End Select
                                    End Select

                                    Select Case strTipo
                                        Case "LO"
                                            If DVL.IDTipoLente Is Nothing Then
                                                DVL.IDTipoLente = 1
                                            End If

                                            Dim rp As New RepositorioEntidades
                                            Using rp
                                                DVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoLentes(inModelo, DVL, strTipo, DVL.IDTipoLente, DVL.PotenciaCilindrica, DVL.PotenciaEsferica, DVL.PotenciaPrismatica, DVL.TotalComDescontoCabecalho / DVL.Quantidade)
                                            End Using
                                        Case "LC"
                                            If DVL.IDTipoLente Is Nothing Then
                                                DVL.IDTipoLente = 10
                                            End If

                                            Dim rp As New RepositorioEntidades
                                            Using rp
                                                DVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoLentes(inModelo, DVL, strTipo, DVL.IDTipoLente, DVL.PotenciaCilindrica, DVL.PotenciaEsferica, 0, DVL.TotalComDescontoCabecalho / DVL.Quantidade)
                                            End Using
                                        Case Else
                                    End Select

                                ElseIf DVL.Descricao IsNot Nothing And DVL.IDArtigo IsNot Nothing AndAlso DVL.IDArtigo > 0 Then

                                    Dim rp As New RepositorioEntidades
                                    Using rp
                                        DVL.ValorUnitarioEntidade1 = rp.LerValorComparticipacaoArtigo(inModelo, DVL, DVL.IDArtigo, DVL.TotalComDescontoCabecalho / DVL.Quantidade)
                                    End Using
                                End If
                            Else
                            End If

                            CalculaValorUnitarioEntidade1(DVL, inModelo)

                            PreencherTaxaIvaDaLinha(BDContexto, inModelo, DVL)
                        Next

                        'Determinar o desconto global
                        With inModelo
                            .PercentagemDesconto = ClsUtilitarios.RetornaZeroSeVazioDuplo(.PercentagemDesconto)
                            .ValorDesconto = ClsUtilitarios.RetornaZeroSeVazioDuplo(.ValorDesconto)
                            .TotalMoedaReferencia = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalMoedaReferencia)
                            .TotalMoedaDocumento = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalMoedaDocumento)
                            .SubTotal = mTotalLinhas
                        End With

                        Select Case CampoAlterado
                            Case "TotalMoedaReferencia", "TotalMoedaDocumento"
                                If inModelo.TotalMoedaDocumento > mTotalLinhas Then
                                    inModelo.TotalMoedaDocumento = mTotalLinhas
                                End If

                                inModelo.ValorDesconto = Math.Round(mTotalLinhas - ClsUtilitarios.RetornaZeroSeVazioDuplo(inModelo.TotalMoedaDocumento), intCasasDecTotais)
                                If mTotalLinhas = 0 Then
                                    inModelo.PercentagemDesconto = 0
                                Else
                                    inModelo.PercentagemDesconto = Math.Round(CDbl(inModelo.ValorDesconto) * 100 / mTotalLinhas, 6)
                                End If
                                inModelo.TotalPontos = 0
                                inModelo.TotalValesOferta = 0
                                inModelo.OutrosDescontos = 0
                            Case "PercentagemDesconto"
                                If mTotalLinhas = 0 Then
                                    inModelo.ValorDesconto = 0
                                Else
                                    inModelo.ValorDesconto = Math.Round((mTotalLinhas * CDbl(inModelo.PercentagemDesconto)) / 100, intCasasDecPrecosUnitarios)
                                End If
                                inModelo.TotalMoedaDocumento = mTotalLinhas - inModelo.ValorDesconto

                                inModelo.TotalPontos = 0
                                inModelo.TotalValesOferta = 0
                                inModelo.OutrosDescontos = 0
                            Case "ValorDesconto"
                                If mTotalLinhas = 0 Then
                                    inModelo.PercentagemDesconto = 0
                                Else
                                    inModelo.PercentagemDesconto = Math.Round(CDbl(inModelo.ValorDesconto) * 100 / mTotalLinhas, 6)
                                End If
                                inModelo.TotalPontos = 0
                                inModelo.TotalValesOferta = 0
                                inModelo.OutrosDescontos = 0
                            Case "TotalPontos", "TotalValesOferta"
                                If inModelo.TotalPontos > mTotalLinhas Then
                                    inModelo.TotalPontos = mTotalLinhas
                                    inModelo.TotalValesOferta = 0
                                End If
                                If inModelo.TotalValesOferta > mTotalLinhas Then
                                    inModelo.TotalValesOferta = mTotalLinhas
                                    inModelo.TotalPontos = 0
                                End If

                                inModelo.ValorDesconto = inModelo.TotalPontos + inModelo.TotalValesOferta
                                If inModelo.ValorDesconto > mTotalLinhas Then
                                    inModelo.ValorDesconto = mTotalLinhas
                                    inModelo.TotalValesOferta = mTotalLinhas - inModelo.TotalPontos
                                End If

                                If mTotalLinhas = 0 Then
                                    inModelo.PercentagemDesconto = 0
                                Else
                                    inModelo.PercentagemDesconto = Math.Round(CDbl(inModelo.ValorDesconto) * 100 / mTotalLinhas, 6)
                                End If
                        End Select

                        'Aplicar desconto global
                        For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                            If DVL.TotalComDescontoLinha > 0 Then
                                DVL.ValorDescontoCabecalho = Math.Round(CDbl(DVL.TotalComDescontoLinha) * CDbl(inModelo.PercentagemDesconto) / 100, intCasasDecTotais)
                                dblValorDescontoGlobal += Math.Round(CDbl(DVL.ValorDescontoCabecalho), intCasasDecTotais)
                                CalculaTotalLinha(DVL, "ValorDescontoCabecalho", inModelo)
                                CalculaTotalLinha(DVL, "ValorUnitarioEntidade1", inModelo)
                                CalculaTotalLinha(DVL, "ValorUnitarioEntidade2", inModelo)
                            End If
                        Next

                        Dim intI As Integer = 0
                        Dim dblDiff As Double = Math.Round(dblValorDescontoGlobal - CDbl(inModelo.ValorDesconto), intCasasDecTotais)
                        Dim dblInc As Double = 0.01
                        If dblDiff < 0 Then
                            dblDiff = Math.Abs(dblDiff)
                            dblInc = -0.01
                        End If
                        'Se existem diferenças
                        If dblDiff > 0 Then
                            For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)

                                intI += 1
                                If DVL.TotalComDescontoLinha > 0 Then
                                    DVL.ValorDescontoCabecalho = Math.Round(CDbl(DVL.ValorDescontoCabecalho - dblInc), intCasasDecTotais)
                                    dblDiff = Math.Round(CDbl(dblDiff - 0.01), intCasasDecTotais)
                                    If dblDiff > 0 AndAlso intI = inModelo.DocumentosVendasLinhas.Count - 1 Then
                                        DVL.ValorDescontoCabecalho += Math.Round(dblDiff, intCasasDecTotais)
                                    End If
                                    CalculaTotalLinha(DVL, "ValorDescontoCabecalho", inModelo)
                                    CalculaTotalLinha(DVL, "ValorUnitarioEntidade1", inModelo)
                                    CalculaTotalLinha(DVL, "ValorUnitarioEntidade2", inModelo)
                                    If dblDiff <= 0 Then
                                        Exit For
                                    End If
                                End If
                            Next
                        End If

                        If CampoAlterado = "TotalEntidade2" Then
                            'Aplicar entidade 2
                            For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                                If DVL.TotalComDescontoCabecalho = 0 OrElse (inModelo.SubTotal - inModelo.ValorDesconto) = 0 Then
                                Else
                                    DVL.ValorEntidade2 = Math.Round(CDbl(inModelo.TotalEntidade2) * CDbl(DVL.TotalComDescontoCabecalho / (inModelo.SubTotal - inModelo.ValorDesconto)), intCasasDecTotais)
                                    dblValorEntidade2 += Math.Round(CDbl(DVL.ValorEntidade2), intCasasDecTotais)
                                    CalculaTotalLinha(DVL, "ValorEntidade2", inModelo)
                                End If
                            Next

                            Dim intK As Integer = 0
                            Dim dblDiff2 As Double = Math.Round(dblValorEntidade2 - CDbl(inModelo.TotalEntidade2), intCasasDecTotais)
                            Dim dblInc2 As Double = 0.01
                            If dblDiff2 < 0 Then
                                dblDiff2 = Math.Abs(dblDiff2)
                                dblInc2 = -0.01
                            End If

                            'Se existem diferenças
                            If dblDiff2 > 0 Then
                                For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                                    intK += 1
                                    If DVL.ValorEntidade2 > 0 Then
                                        DVL.ValorEntidade2 = Math.Round(CDbl(DVL.ValorEntidade2 - dblInc2), intCasasDecTotais)
                                        dblDiff2 = Math.Round(CDbl(dblDiff2 - 0.01), intCasasDecTotais)
                                        If dblDiff2 > 0 AndAlso intK = inModelo.DocumentosVendasLinhas.Count - 1 Then
                                            DVL.ValorEntidade2 += Math.Round(dblDiff2, intCasasDecTotais)
                                        End If
                                        CalculaTotalLinha(DVL, "ValorEntidade2", inModelo)
                                        If dblDiff2 <= 0 Then
                                            Exit For
                                        End If
                                    End If
                                Next
                            End If
                        End If

                    End If

                    'efetuar os calculos 
                    EfetuaCalculos(inModelo)

                    If mTotalLinhas <> 0 Then
                        inModelo.PercentagemDesconto = Math.Round(CDbl(inModelo.ValorDesconto) * 100 / mTotalLinhas, 6)
                    End If

                    'Preenche info armazens e localizações das linhas de artigos
                    Dim lngIDLoja As Long = ClsF3MSessao.RetornaLojaID
                    Dim IDArmLocLoja As Long? = BDContexto.tbParametrosCamposContexto.
                    Where(Function(f) f.tbParametrosContexto.IDLoja = lngIDLoja AndAlso f.CodigoCampo = "ArmazemLocalizacao").
                    FirstOrDefault.ValorCampo
                    Dim lstArmazens As Object
                    Dim lngIDTipoDocumento As Long = inModelo.IDTipoDocumento

                    Dim strCodigoMov As String = BDContexto.tbTiposDocumento.
                    Where(Function(f) f.ID = lngIDTipoDocumento).FirstOrDefault?.tbSistemaTiposDocumentoMovStock?.Codigo

                    Dim IDArtigos = inModelo.DocumentosVendasLinhas.Select(Function(s) s.IDArtigo).Distinct.ToList

                    If IDArmLocLoja Is Nothing Then
                        lstArmazens = BDContexto.tbArtigosArmazensLocalizacoes.Where(Function(f) f.PorDefeito AndAlso IDArtigos.Contains(f.IDArtigo)).ToList
                    Else
                        lstArmazens = BDContexto.tbArmazensLocalizacoes.Where(Function(f) f.ID = IDArmLocLoja).FirstOrDefault
                    End If

                    'isto para carregar a incidenciapercentagem
                    Dim lstArtigos As List(Of tbArtigos) = BDContexto.tbArtigos.Where(Function(e) IDArtigos.Contains(e.ID)).ToList

                    For Each DVL In inModelo.DocumentosVendasLinhas.Where(Function(f) f.IDArtigo IsNot Nothing)

                        DVL.PercIncidencia = lstArtigos.Where(Function(s) s.ID = DVL.IDArtigo).FirstOrDefault?.IncidenciaPercentagem

                        If DVL.IDArmazem Is Nothing OrElse DVL.DescricaoArmazem = "" Then
                            If IDArmLocLoja Is Nothing Then
                                Dim armAux As Object = lstArmazens.Where(Function(f) f.IDArtigo = DVL.IDArtigo).FirstOrDefault

                                If armAux IsNot Nothing Then
                                    With DVL
                                        If strCodigoMov = SistemaMovimentacaoStock.Saida Then
                                            If .IDArmazem Is Nothing Then
                                                .IDArmazem = armAux.IDArmazem
                                                .DescricaoArmazem = armAux.tbArmazens?.Descricao
                                            End If
                                            If .IDArmazemLocalizacao Is Nothing Then
                                                .IDArmazemLocalizacao = armAux.IDArmazemLocalizacao
                                                .CodigoArmazemLocalizacao = armAux.tbArmazensLocalizacoes?.Codigo
                                                .DescricaoArmazemLocalizacao = armAux.tbArmazensLocalizacoes?.Desricao
                                            End If

                                            If .IDArmazem = 0 Then
                                                .IDArmazem = Nothing
                                            End If
                                            If .IDArmazemLocalizacao = 0 Then
                                                .IDArmazemLocalizacao = Nothing
                                            End If
                                        End If

                                        If strCodigoMov = SistemaMovimentacaoStock.Entrada Then
                                            If .IDArmazemDestino Is Nothing Then
                                                .IDArmazemDestino = armAux.IDArmazem
                                                .DescricaoArmazemDestino = armAux.tbArmazens?.Descricao
                                            End If
                                            If .IDArmazemLocalizacaoDestino Is Nothing Then
                                                .IDArmazemLocalizacaoDestino = armAux.IDArmazemLocalizacao
                                                .CodigoArmazemLocalizacaoDestino = armAux.tbArmazensLocalizacoes?.Codigo
                                                .DescricaoArmazemLocalizacaoDestino = armAux.tbArmazensLocalizacoes?.Desricao
                                            End If

                                            If .IDArmazemDestino = 0 Then
                                                .IDArmazemDestino = Nothing
                                            End If
                                            If .IDArmazemLocalizacaoDestino = 0 Then
                                                .IDArmazemLocalizacaoDestino = Nothing
                                            End If
                                        End If
                                    End With
                                End If
                            ElseIf lstArmazens IsNot Nothing Then
                                With DVL
                                    If strCodigoMov = SistemaMovimentacaoStock.Saida Then
                                        If .IDArmazem Is Nothing OrElse DVL.DescricaoArmazem = "" Then
                                            .IDArmazem = lstArmazens.IDArmazem
                                            .DescricaoArmazem = lstArmazens.tbArmazens?.Descricao
                                        End If
                                        If .IDArmazemLocalizacao Is Nothing OrElse DVL.DescricaoArmazemLocalizacao = "" Then
                                            .IDArmazemLocalizacao = lstArmazens.ID
                                            .CodigoArmazemLocalizacao = lstArmazens.Codigo
                                            .DescricaoArmazemLocalizacao = lstArmazens.Descricao
                                        End If
                                    End If
                                    If strCodigoMov = SistemaMovimentacaoStock.Entrada Then
                                        If .IDArmazemDestino Is Nothing Then
                                            .IDArmazemDestino = lstArmazens.IDArmazem
                                            .DescricaoArmazemDestino = lstArmazens.tbArmazens?.Descricao
                                        End If
                                        If .IDArmazemLocalizacaoDestino Is Nothing Then
                                            .IDArmazemLocalizacaoDestino = lstArmazens.ID
                                            .CodigoArmazemLocalizacaoDestino = lstArmazens.Codigo
                                            .DescricaoArmazemLocalizacaoDestino = lstArmazens.Descricao
                                        End If
                                    End If
                                End With
                            End If
                        End If
                    Next
                End If

                If ELinhasTodas Then
                    Dim i As Integer = 0
                    For Each lin In inModelo.DocumentosVendasLinhas.OrderBy(Function(f) f.Ordem)
                        lin.IndexLinhaEmAlteracao = i
                        i += 1
                    Next
                End If

                Return inModelo
            Catch
                Throw
            End Try
        End Function

        Private Sub EfetuaCalculos(ByRef model As DocumentosVendas)
            Try
                Dim TotalPrecoAtual As Double = 0, TotalCompart1 As Double = 0, TotalCompart2 As Double = 0, TotalIva As Double = 0
                Dim TotalDescontosLinha As Double = 0, SubTotal As Double = 0, TotalDescontosCabecalho As Double = 0
                Dim MoedaReferencia As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia

                For Each DVL In model.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                    SubTotal += DVL.TotalSemDescontoLinha
                    TotalPrecoAtual += CalculaPrecoFinal(DVL)
                    TotalCompart1 += DVL.ValorEntidade1
                    TotalCompart2 += DVL.ValorEntidade2
                    TotalIva += DVL.ValorIVA
                    TotalDescontosLinha += DVL.ValorDescontoLinha
                    TotalDescontosCabecalho += DVL.ValorDescontoCabecalho
                Next

                With model
                    .SubTotal = Math.Round(CDbl(SubTotal), intCasasDecTotais)
                    .TotalIva = Math.Round(CDbl(TotalIva), intCasasDecTotais)
                    .ValorImposto = Math.Round(CDbl(TotalIva), intCasasDecTotais)
                    .TotalMoedaReferencia = Math.Round(CDbl(TotalPrecoAtual + TotalCompart1), intCasasDecTotais)
                    .TotalMoedaDocumento = Math.Round(CDbl(TotalPrecoAtual + TotalCompart1), intCasasDecTotais)
                    .TotalEntidade1 = Math.Round(CDbl(TotalCompart1), intCasasDecTotais)
                    .TotalEntidade2 = Math.Round(CDbl(TotalCompart2), intCasasDecTotais)
                    .DescontosLinha = Math.Round(CDbl(TotalDescontosLinha), intCasasDecTotais)
                    .TotalValesOferta = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalValesOferta)
                    .TotalPontos = ClsUtilitarios.RetornaZeroSeVazioDuplo(.TotalPontos)
                    .OutrosDescontos = .TotalValesOferta + .TotalPontos
                    .ValorDesconto = Math.Round(CDbl(TotalDescontosCabecalho), intCasasDecTotais)
                    .TotalClienteMoedaDocumento = Math.Round(CDbl(TotalPrecoAtual), intCasasDecTotais)
                    .TotalClienteMoedaReferencia = Math.Round(CDbl(TotalPrecoAtual), intCasasDecTotais)

                    If model.TaxaConversao Is Nothing OrElse model.TaxaConversao = 0 Then model.TaxaConversao = 1

                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(TotalPrecoAtual + TotalCompart1, model.TaxaConversao)
                    .TotalClienteMoedaReferencia = ClsUtilitarios.CalculaCambio(TotalPrecoAtual, model.TaxaConversao)
                End With
            Catch
                Throw
            End Try
        End Sub

        Public Function ValidaEstado(inFiltro As ClsF3MFiltro, ByRef model As DocumentosVendas) As DocumentosVendas
            Try
                Dim lngID As Long = model.ID
                Dim lngIDEstadoAnterior As Long = 0
                Dim strTipoDocumento As String = String.Empty
                Dim dblTotalMoedaReferencia As Double = 0
                Dim lngIDTipoDocumento As Long = 0
                Dim blnCodigoPostal As Boolean = False
                Dim blnNIF As Boolean = False

                model.ValidaEstado = 0
                lngIDTipoDocumento = model.IDTipoDocumento

                If lngID <> 0 Then
                    Dim lin As tbDocumentosVendas = (From x In BDContexto.tbDocumentosVendas).Where(Function(f) f.ID = lngID).FirstOrDefault
                    With lin
                        lngIDEstadoAnterior = .IDEstado
                        dblTotalMoedaReferencia = .TotalMoedaReferencia
                        strTipoDocumento = .tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo
                    End With
                Else
                    dblTotalMoedaReferencia = model.TotalMoedaReferencia
                    strTipoDocumento = BDContexto.tbTiposDocumento.Where(Function(f) f.ID = lngIDTipoDocumento).FirstOrDefault.tbSistemaTiposDocumentoFiscal.Tipo
                End If

                ''VALIDA SE E NC OU ND E NAO TEM DOC ORIGEM
                'If model.TipoFiscal = TiposDocumentosFiscal.NotaCredito OrElse model.TipoFiscal = TiposDocumentosFiscal.NotaDebito Then
                '    For Each lin In model.DocumentosVendasLinhas.Where(Function(w) w.AcaoCRUD <> AcoesFormulario.Remover)
                '        If String.IsNullOrEmpty(lin.DocumentoOrigem) Then
                '            model.ValidaEstado = 8 'Tem que preencher o(s) documento(s) de origem.
                '            Return model
                '        End If
                '        If Not String.IsNullOrEmpty(lin.DocumentoOrigem) Then
                '            If lin.DataDocOrigem > model.DataDocumento Then
                '                model.ValidaEstado = 10 'a data dos documentos origem não pode ser superior à data do documento atual
                '                Return model
                '            End If
                '        End If
                '    Next
                'End If

                If model.IDEstado <> lngIDEstadoAnterior Then
                    'valida se tem pagamentos
                    Using rp As New RepositorioPagamentosVendas
                        If rp.GetPagamentosVendas(lngID).Where(Function(f) f.CodigoTipoEstado <> TiposEstados.Anulado).Count > 0 Then
                            model.ValidaEstado = 1
                            Return model
                        End If
                    End Using
                End If

                Dim blnAnulado As Boolean = RepositorioDocumentosVendas.EAnulado(BDContexto, model.IDEstado)
                If blnAnulado Then 'anulado
                    Dim NumDiasAnular As Long = DateDiff("d", CDate(model.DataDocumento), DateTime.Now.Date)
                    If NumDiasAnular < 0 OrElse NumDiasAnular > ClsF3MSessao.RetornaParametros.NumDiasAnular Then
                        model.ValidaEstado = 12 ' o numero de dias para anular é superior ao definido nos parâmetros da empresa
                        Return model
                    End If
                Else
                    Dim NumDias As Long = DateDiff("d", DateTime.Now.Date, CDate(model.DataDocumento))
                    If NumDias > ClsF3MSessao.RetornaParametros.NumDiasAntecedencia Then
                        model.ValidaEstado = 11 ' o numero de dias de antecendencia na geração do documento é superior ao definido nos parâmetros da empresa
                        Return model
                    End If
                End If

                'valida se tem compartificação e o documento não vai para cc
                Dim blnGeraContaCorrente As Boolean = BDContexto.tbTiposDocumento.Where(Function(f) f.ID = lngIDTipoDocumento).FirstOrDefault.GereContaCorrente
                If Not blnGeraContaCorrente Then
                    For Each Linha In model.DocumentosVendasLinhas
                        Dim IDDocOrigem As Nullable(Of Long) = Linha.IDDocumentoOrigem
                        If Not IDDocOrigem Is Nothing Then
                            Dim dblTotalEntidade1 As Double = BDContexto.tbDocumentosVendas.Where(Function(f) f.ID = IDDocOrigem).FirstOrDefault.TotalEntidade1
                            If dblTotalEntidade1 > 0 Then
                                model.ValidaEstado = 2
                                Exit For
                            End If
                        End If
                    Next
                End If

                'avisar se for do tipo fs que o valor de estar entre 100 e 1000
                'If (model.TotalMoedaReferencia - model.TotalIva) > 100 And strTipoDocumento.ToLower = "fs" Then
                '    model.ValidaEstado = 5
                '    Return model
                'End If

                'pergunta se pretende mudar de estado
                Dim blnRascunho As Boolean = RepositorioDocumentosVendas.ERascunho(BDContexto, model.IDEstado)
                If model.IDEstado <> lngIDEstadoAnterior Then
                    If Not blnRascunho Then
                        model.ValidaEstado = 0
                        Return model
                    End If
                End If

                Return model
            Catch
                Throw
            End Try
        End Function

        Private Function ValidaQuantidadePrecoUnitario(model As DocumentosVendas)
            Try
                'É NC e tem de validar as Quantidades e PrecosUnitarios por artigo
                If model.DocumentosVendasLinhas.Count Then
                    Dim IDDocOrigem = model.DocumentosVendasLinhas.FirstOrDefault.IDDocumentoOrigem
                    If IDDocOrigem IsNot Nothing Then
                        Dim DocVendaOrigem = BDContexto.tbDocumentosVendas.Where(Function(f) f.ID = IDDocOrigem).FirstOrDefault

                        For Each Linha In model.DocumentosVendasLinhas
                            Dim LinhaOrigem = DocVendaOrigem.tbDocumentosVendasLinhas.Where(Function(f) f.ID = Linha.IDLinhaDocumentoOrigem).FirstOrDefault
                            If Linha.Quantidade > LinhaOrigem.Quantidade Then
                                Linha.Quantidade = LinhaOrigem.Quantidade
                            End If
                            If Linha.PrecoUnitario > LinhaOrigem.PrecoUnitario Then
                                Linha.PrecoUnitario = LinhaOrigem.PrecoUnitario
                            End If
                        Next
                    End If
                End If

                Return model
            Catch
                Throw
            End Try
        End Function

        Private Sub PreencherTaxaIvaDaLinha(ByRef inCtx As Aplicacao, modelo As DocumentosVendas, DSL As DocumentosVendasLinhas)
            Try
                Dim siglaPaisLinha As String = ClsF3MSessao.RetornaParametros.Lojas.SiglaPais
                Dim CodigoRegiaoIva As String = "C"
                Dim CodigoTipoIva As String = ""
                'If Not ERascunho(BDContexto, modelo.IDEstado) Then
                '    Exit Sub
                'End If
                Dim IdTaxaIvaCarregar As Long = 0
                If modelo.IDEntidade Is Nothing Then
                    ' Se o documento não tem entidade, marcar para carregar o iva da ficha do artigo
                    IdTaxaIvaCarregar = 0
                Else
                    ' Se o documento tem entidade, carregar qual o tipo de taxa de iva a carregar tendo em conta a informação introduzida
                    Dim IDParametrosCamposContextoTaxasIva As Long = 0
                    If modelo.IDRegimeIva = RegimeIva.InversaoSujeitoPassivo Then
                        If modelo.IDEspacoFiscal = EspacoFiscal.Nacional Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.InversaoSujeitoPassivoNacional
                        ElseIf modelo.IDEspacoFiscal = EspacoFiscal.Intracomunitario Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.InversaoSujeitoPassivoIntracomunitario
                        End If
                    ElseIf modelo.IDRegimeIva = RegimeIva.Isento Then
                        If modelo.IDEspacoFiscal = EspacoFiscal.Nacional Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.IsentoNacional
                        ElseIf modelo.IDEspacoFiscal = EspacoFiscal.Externo Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.IsentoExterno
                        End If
                    End If
                    If IDParametrosCamposContextoTaxasIva = 0 Then
                        ' Como não foi encontrada nenhum tipo de taxa de iva a carregar, vamos marcar para carregar o iva da ficha do artigo
                        IdTaxaIvaCarregar = 0
                    Else
                        ' vamos à tabela dos parâmetros carregar a taxa correspondente
                        Using rep As New RepositorioParametrosCamposContexto
                            Dim lstAux = inCtx.tbParametrosCamposContexto.AsNoTracking.Where(Function(a) a.ID = IDParametrosCamposContextoTaxasIva).
                                Select(Function(a) New ParametrosCamposContexto With {.ValorCampo = a.ValorCampo}).FirstOrDefault()
                            If lstAux Is Nothing Then
                                IdTaxaIvaCarregar = 0
                            ElseIf lstAux IsNot Nothing AndAlso lstAux.ValorCampo Is String.Empty Then
                                IdTaxaIvaCarregar = 0
                            Else
                                IdTaxaIvaCarregar = lstAux.ValorCampo
                            End If
                        End Using
                    End If
                End If
                ' Carregar a informação do Iva tendo em conta a taxa obtida
                If IdTaxaIvaCarregar = 0 Then
                    ' Se não foi indicada nenhuma taxa vamos carregar a do artigo
                    If DSL.IDArtigo IsNot Nothing Then
                        Dim IDArtigo As Long = DSL.IDArtigo
                        Dim lstAux = inCtx.tbArtigos.AsNoTracking.Where(Function(a) a.ID = IDArtigo).
                            Select(Function(a) New Oticas.Artigos With {.IDTaxa = a.tbIVA.ID}).FirstOrDefault
                        If lstAux IsNot Nothing Then
                            IdTaxaIvaCarregar = lstAux.IDTaxa
                            If DSL.IDTaxaIva Is Nothing Then DSL.IDTaxaIva = 0
                            If IdTaxaIvaCarregar <> DSL.IDTaxaIva Then IdTaxaIvaCarregar = DSL.IDTaxaIva
                        End If
                    End If
                End If
                If IdTaxaIvaCarregar = 0 Then
                    DSL.IDTaxaIva = Nothing
                    DSL.CodigoTaxaIva = Nothing
                    DSL.TaxaIva = Nothing
                    DSL.IDTipoIva = Nothing
                    DSL.MotivoIsencaoIva = Nothing
                    DSL.IDEspacoFiscal = Nothing
                    DSL.EspacoFiscal = Nothing
                    DSL.IDRegimeIva = Nothing
                    DSL.RegimeIva = Nothing
                    DSL.SiglaPais = Nothing
                Else
                    ' Se o local da operação existe na taxa do iva, carregar a taxa do iva do local da operação
                    If modelo.IDLocalOperacao IsNot Nothing Then
                        Dim lstAux1 = inCtx.tbIVARegioes.AsNoTracking.Where(Function(a) a.IDIva = IdTaxaIvaCarregar And a.IDRegiao = modelo.IDLocalOperacao).
                            Select(Function(a) New F3M.IVARegioes With {.IDIvaRegiao = a.IDIvaRegiao, .CodigoRegiaoIva = a.tbSistemaRegioesIVA.Codigo}).FirstOrDefault()

                        If lstAux1 IsNot Nothing Then
                            IdTaxaIvaCarregar = lstAux1.IDIvaRegiao
                            CodigoRegiaoIva = lstAux1.CodigoRegiaoIva
                            If lstAux1.CodigoRegiaoIva = "A" Then
                                siglaPaisLinha = "PT-AC"
                            ElseIf lstAux1.CodigoRegiaoIva = "M" Then
                                siglaPaisLinha = "PT-MA"
                            Else
                                siglaPaisLinha = ClsF3MSessao.RetornaParametros.Lojas.SiglaPais
                            End If
                        Else
                            CodigoTipoIva = DSL.CodigoTipoIva
                            siglaPaisLinha = ClsF3MSessao.RetornaParametros.Lojas.SiglaPais
                        End If
                    End If
                    Dim lstAux = inCtx.tbIVA.AsNoTracking.Where(Function(a) a.ID = IdTaxaIvaCarregar).
                        Select(Function(a) New F3M.IVA With {.ID = a.ID,
                                                                    .Codigo = a.Codigo,
                                                                    .Taxa = a.Taxa,
                                                                    .Mencao = a.Mencao,
                                                                    .CodigoTipoIva = a.tbSistemaCodigosIVA.Codigo,
                                                                    .CodigoTaxaIva = a.tbSistemaTiposIVA.Codigo,
                                                                    .IDTipoIva = a.IDTipoIva}).FirstOrDefault()
                    If lstAux Is Nothing Then
                        DSL.CodigoRegiaoIva = Nothing
                        DSL.IDTaxaIva = Nothing
                        DSL.CodigoTaxaIva = Nothing
                        DSL.TaxaIva = Nothing
                        DSL.IDTipoIva = Nothing
                        DSL.MotivoIsencaoIva = Nothing
                        DSL.IDEspacoFiscal = Nothing
                        DSL.EspacoFiscal = Nothing
                        DSL.IDRegimeIva = Nothing
                        DSL.RegimeIva = Nothing
                        DSL.SiglaPais = Nothing
                    Else
                        DSL.CodigoRegiaoIva = CodigoRegiaoIva
                        DSL.IDTaxaIva = lstAux.ID
                        DSL.CodigoTaxaIva = lstAux.CodigoTaxaIva
                        DSL.TaxaIva = lstAux.Taxa
                        DSL.IDTipoIva = lstAux.IDTipoIva
                        DSL.CodigoIva = lstAux.Codigo
                        If lstAux.CodigoTipoIva Is Nothing AndAlso CodigoTipoIva <> "" Then
                            DSL.CodigoTipoIva = CodigoTipoIva
                        End If
                        If DSL.CodigoTipoIva Is Nothing AndAlso lstAux.CodigoTaxaIva IsNot Nothing Then
                            DSL.CodigoTipoIva = lstAux.CodigoTaxaIva
                        End If

                        If modelo.IDLocalOperacao IsNot Nothing Then
                            If modelo.IDLocalOperacao = 2 Then
                                DSL.CodigoRegiaoIva = "A"
                                siglaPaisLinha = "PT-AC"
                            ElseIf modelo.IDLocalOperacao = 3 Then
                                DSL.CodigoRegiaoIva = "M"
                                siglaPaisLinha = "PT-MA"
                            End If
                        End If

                        If Math.Round(CDbl(DSL.TaxaIva), ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem) = Math.Round(CDbl(0.0), ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem) Then
                            If String.IsNullOrEmpty(DSL.MotivoIsencaoIva) Then
                                DSL.MotivoIsencaoIva = lstAux.Mencao
                                DSL.CodigoMotivoIsencaoIva = lstAux.CodigoTipoIva
                            End If
                        Else
                            DSL.MotivoIsencaoIva = Nothing
                            DSL.CodigoMotivoIsencaoIva = Nothing
                        End If

                        DSL.CodigoTaxaIva = lstAux.Codigo

                        DSL.IDEspacoFiscal = modelo.IDEspacoFiscal
                        DSL.EspacoFiscal = If(modelo.EspacoFiscal IsNot Nothing, modelo.EspacoFiscal, DSL.EspacoFiscal)
                        DSL.IDRegimeIva = modelo.IDRegimeIva
                        DSL.RegimeIva = modelo.RegimeIva
                        DSL.SiglaPais = siglaPaisLinha
                    End If
                End If
            Catch ex As Exception
                Throw ex
            End Try
        End Sub
#End Region
        'VER!
        Public Function EDocumentoEfetivo(ByVal IDDocumentoVenda As Long) As Boolean
            Return EEfetivo(BDContexto, (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVenda Select x.IDEstado).FirstOrDefault())
        End Function

        Public Function EDocumentoAnulado(ByVal IDDocumentoVenda As Long) As Boolean
            Return EAnulado(BDContexto, (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVenda Select x.IDEstado).FirstOrDefault())
        End Function

        Public Function EDocumentoRascunho(ByVal IDDocumentoVenda As Long) As Boolean
            Return ERascunho(BDContexto, (From x In BDContexto.tbDocumentosVendas Where x.ID = IDDocumentoVenda Select x.IDEstado).FirstOrDefault())
        End Function
        'END VER!

        Protected Friend Function VerificaValorPago(ByVal IDDocumentoVenda As Long) As Boolean
            Dim DocumentoVenda As DocumentosVendas = (From x In BDContexto.tbDocumentosVendas
                                                      Where x.ID = IDDocumentoVenda
                                                      Select New DocumentosVendas With {.ID = x.ID, .ValorPago = x.ValorPago, .TotalMoedaDocumento = x.TotalMoedaDocumento, .TotalEntidade1 = x.TotalEntidade1}).FirstOrDefault()

            Dim dblValorTotal As Double = DocumentoVenda.TotalMoedaDocumento

            If Not DocumentoVenda.TotalEntidade1 Is Nothing AndAlso CDbl(DocumentoVenda.TotalEntidade1) > 0 Then
                dblValorTotal = DocumentoVenda.TotalMoedaDocumento + DocumentoVenda.TotalEntidade1
            End If

            If DocumentoVenda.ValorPago >= dblValorTotal Then
                Return False
            Else
                Return True
            End If
        End Function
        'END VER!

        Public Function GetIDTipoDocumentoServico() As Long
            Return BDContexto.tbTiposDocumento.Where(Function(f) f.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico).FirstOrDefault.ID
        End Function

        Public Function TextoMensagemAssinatura(ByRef inCtx As BD.Dinamica.Aplicacao, ByVal blnRegrasCert As Boolean, ByVal blnFormacao As Boolean, ByVal blnCopia As Boolean,
                                        ByVal blnManual As Boolean, ByVal blnRepDados As Boolean, ByVal strSerieManual As String, ByVal strNumeroManual As String,
                                        ByVal lngIdTipoDocumento As Long, ByVal strAssinatura As String) As String

            Dim strNumCertificado As String = F3M.Modelos.ConstantesCertificacao.clsF3MCertApp.CertificadoAT(URLs.ProjetoOticas, True).CERT_NUMCERTIFICADO & "/AT" & F3M.Modelos.Constantes.SaftAT.CSeparadorMsgAt
            Dim strTipoDocumento As String = String.Empty
            Dim strCertificacao As String = String.Empty
            Dim strSistemaTipoDocumento As String = String.Empty

            Dim blnDocumentoFiscal As Boolean = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.tbSistemaTiposDocumento.TipoFiscal
            If blnDocumentoFiscal Then
                If blnManual OrElse blnRepDados Then
                    strTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.Codigo
                Else
                    strTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.tbSistemaTiposDocumentoFiscal.Tipo
                End If

                strSistemaTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.tbSistemaTiposDocumento.Tipo
                If strSistemaTipoDocumento = TiposSistemaTiposDocumento.StockTransfArmazensComTransito OrElse strSistemaTipoDocumento = TiposSistemaTiposDocumento.ComprasTransporte OrElse strSistemaTipoDocumento = TiposSistemaTiposDocumento.VendasTransporte Then
                    blnDocumentoTransporte = True
                End If
            Else
                If strSistemaTipoDocumento = TiposSistemaTiposDocumento.VendasOrcamento Then
                    strTipoDocumentoFiscal = "OR"
                    If blnManual OrElse blnRepDados Then
                        strTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.Codigo
                    End If
                ElseIf strSistemaTipoDocumento = TiposSistemaTiposDocumento.VendasEncomenda Then
                    strTipoDocumentoFiscal = "NE"
                    If blnManual OrElse blnRepDados Then
                        strTipoDocumento = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngIdTipoDocumento).FirstOrDefault.Codigo
                    End If
                Else
                    strTipoDocumento = "SV"
                End If
            End If

            strCertificacao = RepositorioDocumentos.AtribuiMensagemDocAT(blnRegrasCert, blnFormacao, blnCopia, blnManual, blnRepDados, strSerieManual, strNumeroManual, False, blnDocumentoFiscal, lngIdTipoDocumento, strTipoDocumento, strNumCertificado, strAssinatura, blnDocumentoTransporte)

            Return strCertificacao
        End Function

        ''' <summary>
        '''Atribui Formas de pagamento do serviço (Faturas de adiantamento)
        ''' </summary>
        ''' <param name="inCtx">inModelo (PAGAMENTOSVENDAS)</param>
        '''  <param name="IDDocumentoVenda">IDDocumentoVenda (Documento de Venda novo)</param>
        '''  <param name="IDDocumentoVendaOrigem">IDDocumentoVendaOrigem (Serviço)</param>
        ''' <param name="IDMoeda">IDMoeda (IDMoeda -> DocumentoVenda)</param>
        ''' <remarks></remarks>
        Private Function AtribuiFormasPagamento(inCtx As BD.Dinamica.Aplicacao, ByVal IDDocumentoVenda As Long, ByVal IDDocumentoVendaOrigem As Long, ByVal IDMoeda As Long) As List(Of PagamentosVendasFormasPagamento)
            Dim MoedaRef As MoedaReferencia = ClsF3MSessao.RetornaParametros.MoedaReferencia
            Dim Moeda As Moedas = (From x In BDContexto.tbMoedas
                                   Where x.ID = IDMoeda
                                   Select New Moedas With {.ID = x.ID, .TaxaConversao = x.TaxaConversao}).FirstOrDefault()

            Return (From x In (From t In inCtx.tbPagamentosVendasFormasPagamento
                               Join y In inCtx.tbPagamentosVendasLinhas On y.IDPagamentoVenda Equals t.IDPagamentoVenda
                               Join m In inCtx.tbPagamentosVendas On m.ID Equals y.IDPagamentoVenda
                               Join z In inCtx.tbDocumentosVendasLinhas On z.IDDocumentoVenda Equals y.IDDocumentoVenda
                               Where z.IDDocumentoOrigem = IDDocumentoVendaOrigem And m.CodigoTipoEstado <> TiposEstados.Anulado
                               Group t By t.IDFormaPagamento Into Group
                               Select Group.Distinct()).ToList()
                    Select New PagamentosVendasFormasPagamento With {.AcaoCRUD = AcoesFormulario.Adicionar,
                                                                    .IDFormaPagamento = x.FirstOrDefault().IDFormaPagamento,
                                                                    .CodigoSistemaTipoFormaPagamento = x.FirstOrDefault().tbFormasPagamento.tbSistemaTiposFormasPagamento.Codigo,
                                                                    .DescricaoFormaPagamento = x.FirstOrDefault().tbFormasPagamento.Descricao,
                                                                    .Valor = x.Sum(Function(f) f.Valor),
                                                                    .IDDocumentoVenda = IDDocumentoVenda,
                                                                    .IDPagamentoVenda = x.FirstOrDefault().IDPagamentoVenda,
                                                                    .IDMoeda = Moeda.ID,
                                                                    .TaxaConversao = Moeda.TaxaConversao,
                                                                    .TotalMoeda = .Valor,
                                                                    .TotalMoedaReferencia = ClsUtilitarios.CalculaCambio(.Valor, Moeda.TaxaConversao)
                                                                    }).ToList()
        End Function

        Public Function LerIDDocumentoOrigem(ByVal inCtx As BD.Dinamica.Aplicacao, ByVal IDDocumento As Long, ByVal IDTipoDocumento As Long) As Boolean

            Dim DocOrigem = inCtx.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoOrigem = IDDocumento And f.tbDocumentosVendas.IDTipoDocumento = IDTipoDocumento).Select(Function(s) s.tbDocumentosVendas).FirstOrDefault

            Dim ListOfDocsVendasLinhasAdiantamento As List(Of tbDocumentosVendasLinhas) = (From x In inCtx.tbDocumentosVendasLinhas
                                                                                           Join y In inCtx.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                                                                                           Where x.IDDocumentoOrigem = IDDocumento And y.IDTipoDocumento = IDTipoDocumento Select x).ToList()

            Dim blnTemDoc As Boolean = False

            blnTemDoc = ListOfDocsVendasLinhasAdiantamento.Count > 0

            Return blnTemDoc
        End Function

        Public Function LerNCExistentes(ByRef inIDDocVenda As Long) As Long
            Dim IDDocVenda = inIDDocVenda
            Dim DocVenda As New Oticas.DocumentosVendas

            Dim LinhasDocumento = BDContexto.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoVenda = IDDocVenda)

            Dim LinhasNC = BDContexto.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoOrigem = IDDocVenda AndAlso
                                                                         f.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo)

            Dim TotalQuantidadeDoc = LinhasDocumento.Sum(Function(s) s.Quantidade)
            Dim TotalPrecoUnitarioDoc = LinhasDocumento.Sum(Function(s) s.PrecoUnitario)

            Dim TotalQuantidadeNC = LinhasNC.Sum(Function(s) s.Quantidade)
            Dim TotalPrecoUnitarioNC = LinhasNC.Sum(Function(s) s.PrecoUnitario)

            If TotalPrecoUnitarioDoc = TotalPrecoUnitarioNC AndAlso TotalQuantidadeDoc = TotalQuantidadeNC Then
                Mapear(LinhasNC.FirstOrDefault.tbDocumentosVendas, DocVenda)
            End If

            Return DocVenda.ID
        End Function

        Private Sub GravaPagamentosWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As DocumentosVendas, inFiltro As ClsF3MFiltro)
            Dim ValorPagoAux As Double = 0
            Dim ValorPendenteAux As Double = 0

            If Not inModelo.PagamentosVendas Is Nothing Then
                Using rp As New RepositorioPagamentosVendas
                    Using rp2 As New RepositorioDocumentosVendasServicos

                        With inModelo.PagamentosVendas.ListOfPendentes(0)
                            ValorPagoAux = .ValorPago
                            ValorPendenteAux = .ValorPendente
                        End With

                        inModelo.PagamentosVendas.ListOfPendentes(0) = rp2.GetDocumentoVendaPendenteWithTransaction(inCtx, inModelo.ID)

                        With inModelo.PagamentosVendas.ListOfPendentes(0)
                            .LinhaSelecionada = True
                            .ValorPago = ValorPagoAux
                            .ValorPendente = ValorPendenteAux
                        End With
                    End Using

                    rp.Calcula(inFiltro, inModelo.PagamentosVendas, inModelo.CasasDecimaisTotais)

                    rp.AdicionaPagamento_FROMDOCSVENDAS(inCtx, inModelo.PagamentosVendas, inModelo.IDMoeda, inModelo.ID, inModelo.IDDocumentoVendaPendente)
                End Using
            End If
        End Sub

#Region "NOTAS DE CRÉDITO A DINHEIRO DE ADIANTAMENTOS"
        ''' <summary>
        ''' Funcao que retorna o id da ncda by id do servico
        ''' </summary>
        ''' <param name="IDDocumentoVendaServico"></param>
        ''' <returns></returns>
        Protected Friend Function GetNCDAByIDDocumentoVendaServico(IDDocumentoVendaServico As Long) As Long
            Return GetNCDAByIDDocumentoVendaServico(BDContexto, IDDocumentoVendaServico)
        End Function

        Protected Friend Function GetNCDAByIDDocumentoVendaServico(ctx As Aplicacao, IDDocumentoVendaServico As Long) As Long
            Return (From x In ctx.tbDocumentosVendas
                    Join y In ctx.tbDocumentosVendasLinhas On y.IDDocumentoVenda Equals x.ID
                    Join t In ctx.tbDocumentosVendasLinhas On t.IDDocumentoOrigem Equals y.IDDocumentoVenda
                    Join j In ctx.tbDocumentosVendas On j.ID Equals t.IDDocumentoVenda
                    Where y.IDDocumentoVenda <> IDDocumentoVendaServico AndAlso
                                             y.IDDocumentoOrigem = IDDocumentoVendaServico AndAlso
                                             j.tbTiposDocumento.Adiantamento AndAlso
                                             j.tbTiposDocumento.GereCaixasBancos AndAlso
                                             j.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo
                    Select j.ID).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que retorna se existe alguma NCDA com o documento como origem
        ''' </summary>
        ''' <param name="idDocumentoOrigem"></param>
        ''' <returns></returns>
        Protected Friend Function Retorna_DocNCDA(idDocumentoOrigem As Long) As String
            Dim IDDocumentoOrigemFT As Long? = BDContexto.tbDocumentosVendasLinhas.Where(Function(w) w.IDDocumentoVenda = idDocumentoOrigem).FirstOrDefault.IDDocumentoOrigem

            If Not IDDocumentoOrigemFT Is Nothing Then
                Dim docVenda As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(w) w.ID = IDDocumentoOrigemFT)

                If docVenda.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = TiposSistemaTiposDocumento.VendasServico Then
                    Dim IDDocumentoVendaServico As Long = docVenda.ID

                    Dim IDNCDA As Long = GetNCDAByIDDocumentoVendaServico(IDDocumentoVendaServico)

                    If IDNCDA <> 0 Then
                        Return BDContexto.tbDocumentosVendas.FirstOrDefault(Function(f) f.ID = IDNCDA).Documento
                    End If
                End If
            End If

            Return String.Empty
        End Function
#End Region

#Region "ADICIONA ESPECIFICO"
        ''' <summary>
        ''' Funcao que mapeia os dados do cliente para o documento de venda
        ''' </summary>
        ''' <param name="inIDEntidade"></param>
        ''' <param name="inModelo"></param>
        Public Sub ImportarClientesToDocVenda(ByVal inIDEntidade As Long, inModelo As DocumentosVendas)
            'preenche entitdade
            Using rpClientes As New RepositorioClientes
                rpClientes.PreencheEntidadeForClass(Of DocumentosVendas)(inIDEntidade, inModelo)
            End Using

            With inModelo
                'preenche já c/ linhas vazias
                .DocumentosVendasLinhas = New List(Of DocumentosVendasLinhas)
                'set flag flgImpFromClientesToDV to true
                .flgImpFromClientesToDV = True
            End With
        End Sub

        ''' <summary>
        ''' Funcao que mapeia do documento de venda para a nota de credito
        ''' </summary>
        ''' <param name="inIDDocumentoVenda"></param>
        ''' <param name="inModelo"></param>
        Public Sub ImportarDocVendaToNC(ByVal inIDDocumentoVenda As Long, inModelo As Oticas.DocumentosVendas)
            'retorna o modelo do doc venda
            Dim docOrigem As tbDocumentosVendas = RetornaMapeiaDocVenda(inIDDocumentoVenda, inModelo)

            Dim LinhasdocOrigem As List(Of tbDocumentosVendasLinhas) = (From x In BDContexto.tbDocumentosVendasLinhas
                                                                        Where x.IDDocumentoVenda = docOrigem.ID Select x).ToList()


            Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
            If Not IsNumeric(strIDLoc) Then strIDLoc = "0"
            Dim armazemPorDefeito As tbArmazensLocalizacoes = BDContexto.tbArmazensLocalizacoes.FirstOrDefault(Function(w) w.ID = strIDLoc)

            'preenche as linhas no modelo
            PreencheLinhasNC(inModelo, LinhasdocOrigem, True)

            Dim intOrdem As Integer = 1
            For Each DocVendaLinha As DocumentosVendasLinhas In inModelo.DocumentosVendasLinhas
                With DocVendaLinha
                    'doc origem na linha
                    AtribuiPropsDocOrigem(docOrigem, DocVendaLinha)
                    'reset values
                    .AcaoCRUD = AcoesFormulario.Adicionar : .IDDocumentoVenda = CLng(0) : .IDServico = Nothing
                    'ordem e id
                    .Ordem = intOrdem : .ID = CLng(0)
                    'armazem e localização
                    If Not armazemPorDefeito Is Nothing Then
                        If Not .IDArmazem Is Nothing Then
                            .IDArmazem = armazemPorDefeito.IDArmazem
                            .IDArmazemLocalizacao = armazemPorDefeito.ID
                            .DescricaoArmazem = armazemPorDefeito.tbArmazens.Descricao
                            .DescricaoArmazemLocalizacao = armazemPorDefeito.Descricao
                        End If
                        If Not .IDArmazemDestino Is Nothing Then
                            .IDArmazemDestino = armazemPorDefeito.IDArmazem
                            .IDArmazemLocalizacaoDestino = armazemPorDefeito.ID
                            .DescricaoArmazemDestino = armazemPorDefeito.tbArmazens.Descricao
                            .DescricaoArmazemLocalizacaoDestino = armazemPorDefeito.Descricao
                        End If
                    End If
                End With
                'contador na ordem
                intOrdem += 1
            Next

            'especificos cabecacalho DocVenda -> NC
            With inModelo
                .ID = CLng(0) : .AcaoFormulario = AcoesFormulario.Adicionar
                .Entidade1Automatica = False : .flgEEditavelEntidade1Automatica = False
                'set flag flgImpFromVendasToNC to true
                .flgImpFromVendasToNC = True
                .IdDocOrigem = docOrigem.ID
                .F3MMarcadorDocOrigem = docOrigem.F3MMarcador
            End With
        End Sub

        ''' <summary>
        ''' Funcao que mapeia do servico para o documento de venda
        ''' </summary>
        ''' <param name="inIDServico"></param>
        ''' <param name="inModelo"></param>
        Public Sub ImportarServicoToDV(ByVal inIDServico As Long, inModelo As Oticas.DocumentosVendas)
            'retorna o modelo do doc venda
            Dim docOrigem As tbDocumentosVendas = RetornaMapeiaDocVenda(inIDServico, inModelo)

            'mapear especifico sv to dv
            With docOrigem
                .ContribuinteFiscal = docOrigem.tbClientes?.NContribuinte
            End With

            'preenche as linhas no modelo
            PreencheLinhasNC(inModelo, docOrigem.tbDocumentosVendasLinhas.ToList)

            'retorna o estado efetivo (por defeito)
            Dim EstadoEFT As New F3M.Estados
            Using rpEstados As New Repositorio.TabelasAuxiliares.RepositorioEstados
                EstadoEFT = rpEstados.RetornaEstadoByEntidadeETipoEstado(TiposEntidadeEstados.DocumentosVenda, TiposEstados.Efetivo)
                If EstadoEFT Is Nothing Then EstadoEFT = rpEstados.ValorInicial(True, TiposEntidadeEstados.DocumentosVenda)
            End Using
            'retorna o armazem (por defeito) que está associado há loja
            Dim ArmazemPorDefeito As New tbArmazensLocalizacoes
            Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
            If IsNumeric(strIDLoc) AndAlso strIDLoc <> 0 Then
                ArmazemPorDefeito = BDContexto.tbArmazensLocalizacoes.Where(Function(w) w.ID = strIDLoc).FirstOrDefault()
            End If

            Dim intPos As Integer = 0

            Dim intOrdem As Integer = 1
            For Each DocVendaLinha As DocumentosVendasLinhas In inModelo.DocumentosVendasLinhas
                With DocVendaLinha
                    'doc origem na linha
                    AtribuiPropsDocOrigem(docOrigem, DocVendaLinha)
                    'reset values
                    .AcaoCRUD = AcoesFormulario.Adicionar : .IDDocumentoVenda = CLng(0) : .IDServico = Nothing
                    .Diametro = Nothing : .IDModelo = Nothing : .IDTipoLente = Nothing : .IDTipoOlho = Nothing : .IDTratamentoLente = Nothing : .IDTipoGraduacao = Nothing
                    .IDEstado = Nothing

                    If ClsF3MSessao.RetornaParametros.Lojas.ParametroArtigoTipoDescricao = 2 Then
                        intPos = InStr(DocVendaLinha.Descricao, "Esf:")
                        If intPos > 0 Then
                            .Descricao = .Descricao.Substring(0, intPos - 1)
                        End If
                    End If

                    'armazem
                    .IDArmazem = ArmazemPorDefeito?.IDArmazem : .DescricaoArmazem = ArmazemPorDefeito?.tbArmazens?.Descricao
                    .IDArmazemLocalizacao = ArmazemPorDefeito?.ID : .CodigoArmazemLocalizacao = ArmazemPorDefeito?.Codigo : .DescricaoArmazemLocalizacao = ArmazemPorDefeito?.Descricao
                    'ordem e id
                    .Ordem = intOrdem : .ID = CLng(0)
                End With
                'contador na ordem
                intOrdem += 1
            Next

            'atribui ao modelo principal valores p/ defeito
            With inModelo
                .ID = CLng(0) : .AcaoFormulario = AcoesFormulario.Adicionar
                .Entidade1Automatica = False : .flgEEditavelEntidade1Automatica = True
                'estado efetivo p/ defeito
                If Not EstadoEFT Is Nothing Then
                    .IDEstado = EstadoEFT.ID : .DescricaoEstado = EstadoEFT.Descricao : .CodigoTipoEstado = EstadoEFT.CodigoTipoEstado
                End If
                'set flag flgImpFromServicosToDV to true
                .flgImpFromServicosToDV = True
                .IdDocOrigem = docOrigem.ID
                .F3MMarcadorDocOrigem = docOrigem.F3MMarcador
            End With
        End Sub

        ''' <summary>
        ''' Funcao que mapeia do servico para a fatura da entidade 2
        ''' </summary>
        ''' <param name="inIDServico"></param>
        ''' <param name="inModelo"></param>
        Public Sub ImportarServicoToFT2(ByVal inIDServico As Long, inModelo As Oticas.DocumentosVendas)
            'retorna o modelo do doc venda
            Dim docOrigem As tbDocumentosVendas = RetornaMapeiaDocVendaToEntidade2(inIDServico, inModelo)

            'mapear especifico sv to dv
            With docOrigem
                .ContribuinteFiscal = docOrigem.tbClientes?.NContribuinte
            End With

            'preenche as linhas no modelo
            PreencheLinhasFT2(docOrigem, inModelo)

            'retorna o estado efetivo (por defeito)
            Dim EstadoEFT As New F3M.Estados
            Using rpEstados As New Repositorio.TabelasAuxiliares.RepositorioEstados
                EstadoEFT = rpEstados.RetornaEstadoByEntidadeETipoEstado(TiposEntidadeEstados.DocumentosVenda, TiposEstados.Efetivo)
                If EstadoEFT Is Nothing Then EstadoEFT = rpEstados.ValorInicial(True, TiposEntidadeEstados.DocumentosVenda)
            End Using

            'atribui ao modelo principal valores p/ defeito
            With inModelo
                .ID = CLng(0) : .AcaoFormulario = AcoesFormulario.Adicionar
                .Entidade1Automatica = False : .flgEEditavelEntidade1Automatica = False
                'estado efetivo p/ defeito
                If Not EstadoEFT Is Nothing Then
                    .IDEstado = EstadoEFT.ID : .DescricaoEstado = EstadoEFT.Descricao : .CodigoTipoEstado = EstadoEFT.CodigoTipoEstado
                End If
                'totais da entidade 2 trocam com o total moeda documento
                .TotalMoedaDocumento = docOrigem.TotalEntidade2 : .TotalClienteMoedaReferencia = docOrigem.TotalEntidade2
                .TotalEntidade2 = docOrigem.TotalMoedaDocumento
                'set flag flgImpFromServicosToFT2 to true
                .flgImpFromServicosToFT2 = True
                .IdDocOrigem = docOrigem.ID
                .F3MMarcadorDocOrigem = docOrigem.F3MMarcador
                .OrigemEntidade2 = True
            End With

            Dim inObjFiltro As New ClsF3MFiltro
            Calcula(inObjFiltro, inModelo)
        End Sub

        ''' <summary>
        ''' Funcao que retorna o documento de origem e mapeia para o documento de venda
        ''' </summary>
        ''' <param name="idDocVenda"></param>
        ''' <param name="model"></param>
        ''' <returns></returns>
        Private Function RetornaMapeiaDocVenda(idDocVenda As Long, model As DocumentosVendas) As tbDocumentosVendas
            Dim docOrigem As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(f) f.ID = idDocVenda)


            With model
                Dim customer As tbClientes = docOrigem.tbClientes

                If customer IsNot Nothing Then
                    Dim customerAddress As tbClientesMoradas = customer.tbClientesMoradas?.OrderBy(Function(o) o.Ordem).FirstOrDefault()

                    .IDEntidade = customer.ID : .DescricaoEntidade = customer.Nome : .NomeFiscal = customer.Nome : .CodigoEntidade = customer.Codigo
                    .IDCondicaoPagamento = customer.IDCondicaoPagamento : .DescricaoCondicaoPagamento = customer.tbCondicoesPagamento?.Descricao
                    .IDMoeda = customer.IDMoeda : .DescricaoMoeda = customer.tbMoedas.Descricao : .TaxaConversao = customer.tbMoedas.TaxaConversao
                    .ContribuinteFiscal = customer.NContribuinte
                    .IDEspacoFiscal = customer.IDEspacoFiscal : .DescricaoEspacoFiscal = customer.tbSistemaEspacoFiscal?.Descricao
                    .IDRegimeIva = customer.IDRegimeIva : .DescricaoRegimeIva = customer.tbSistemaRegimeIVA?.Descricao
                    .IDLocalOperacao = customer.IDLocalOperacao : .DescricaoLocalOperacao = customer.tbSistemaRegioesIVA.Descricao
                    .IDPaisFiscal = customer.IDPais : .DescricaoPaisFiscal = customer.tbPaises?.Descricao

                    If customerAddress IsNot Nothing Then
                        .MoradaFiscal = customerAddress.Morada
                        .IDCodigoPostalFiscal = customerAddress.IDCodigoPostal : .DescricaoCodigoPostalFiscal = customerAddress.tbCodigosPostais?.Descricao
                        .IDConcelhoFiscal = customerAddress.IDConcelho : .DescricaoConcelhoFiscal = customerAddress.tbConcelhos?.Descricao
                        .IDDistritoFiscal = customerAddress.IDDistrito : .DescricaoDistritoFiscal = customerAddress.tbDistritos?.Descricao
                    End If
                End If

                .ID = docOrigem.ID

                .TotalMoedaDocumento = docOrigem.TotalMoedaDocumento : .TotalMoedaReferencia = docOrigem.TotalMoedaReferencia : .SubTotal = docOrigem.SubTotal
                .DescontosLinha = docOrigem.DescontosLinha : .PercentagemDesconto = docOrigem.PercentagemDesconto : .ValorDesconto = docOrigem.ValorDesconto
                .OutrosDescontos = docOrigem.OutrosDescontos : .TotalPontos = docOrigem.TotalPontos : .TotalValesOferta = docOrigem.TotalValesOferta
                .TotalIva = docOrigem.TotalIva
                .TotalEntidade1 = docOrigem.TotalEntidade1 : .TotalEntidade2 = docOrigem.TotalEntidade2

                .Entidade1Automatica = docOrigem.Entidade1Automatica

                .IDEntidade1 = docOrigem.IDEntidade1 : .DescricaoEntidade1 = docOrigem.tbEntidades?.Descricao
                .IDEntidade2 = docOrigem.IDEntidade2 : .DescricaoEntidade2 = docOrigem.tbEntidades1?.Descricao

                .NumeroBeneficiario1 = docOrigem.NumeroBeneficiario1 : .Parentesco1 = docOrigem.Parentesco1
                .NumeroBeneficiario2 = docOrigem.NumeroBeneficiario2 : .Parentesco2 = docOrigem.Parentesco2
            End With

            Return docOrigem
        End Function

        ''' <summary>
        '''  Funcao que retorna o documento de origem e mapeia para o documento de venda da entidade 2
        ''' </summary>
        ''' <param name="serviceId"></param>
        ''' <param name="model"></param>
        ''' <returns></returns>
        Private Function RetornaMapeiaDocVendaToEntidade2(serviceId As Long, model As Oticas.DocumentosVendas) As tbDocumentosVendas
            Dim originSaleDocument As tbDocumentosVendas = BDContexto.tbDocumentosVendas.FirstOrDefault(Function(f) f.ID = serviceId)

            If Not originSaleDocument.IDEntidade2 Is Nothing AndAlso Not originSaleDocument.tbEntidades1.tbClientes2 Is Nothing Then
                Dim customerByEntity2 As tbClientes = originSaleDocument.tbEntidades1.tbClientes2
                Dim customerAddress As tbClientesMoradas = customerByEntity2.tbClientesMoradas?.OrderBy(Function(o) o.Ordem).FirstOrDefault()

                With model
                    .IDEntidade = customerByEntity2.ID : .DescricaoEntidade = customerByEntity2.Nome : .NomeFiscal = customerByEntity2.Nome : .CodigoEntidade = customerByEntity2.Codigo
                    .IDCondicaoPagamento = customerByEntity2.IDCondicaoPagamento : .DescricaoCondicaoPagamento = customerByEntity2.tbCondicoesPagamento?.Descricao
                    .IDMoeda = customerByEntity2.IDMoeda : .DescricaoMoeda = customerByEntity2.tbMoedas.Descricao : .TaxaConversao = customerByEntity2.tbMoedas.TaxaConversao
                    .ContribuinteFiscal = customerByEntity2.NContribuinte
                    .IDEspacoFiscal = customerByEntity2.IDEspacoFiscal : .DescricaoEspacoFiscal = customerByEntity2.tbSistemaEspacoFiscal?.Descricao
                    .IDRegimeIva = customerByEntity2.IDRegimeIva : .DescricaoRegimeIva = customerByEntity2.tbSistemaRegimeIVA?.Descricao
                    .IDLocalOperacao = customerByEntity2.IDLocalOperacao : .DescricaoLocalOperacao = customerByEntity2.tbSistemaRegioesIVA.Descricao
                    .IDPaisFiscal = customerByEntity2.IDPais : .DescricaoPaisFiscal = customerByEntity2.tbPaises?.Descricao

                    If Not customerAddress Is Nothing Then
                        .MoradaFiscal = customerAddress.Morada
                        .IDCodigoPostalFiscal = customerAddress.IDCodigoPostal : .DescricaoCodigoPostalFiscal = customerAddress.tbCodigosPostais?.Descricao
                        .IDConcelhoFiscal = customerAddress.IDConcelho : .DescricaoConcelhoFiscal = customerAddress.tbConcelhos?.Descricao
                        .IDDistritoFiscal = customerAddress.IDDistrito : .DescricaoDistritoFiscal = customerAddress.tbDistritos?.Descricao
                    End If
                End With
            End If

            With model
                .ID = originSaleDocument.ID

                .TotalMoedaDocumento = originSaleDocument.TotalMoedaDocumento : .TotalMoedaReferencia = originSaleDocument.TotalMoedaReferencia : .SubTotal = originSaleDocument.SubTotal
                .DescontosLinha = originSaleDocument.DescontosLinha : .PercentagemDesconto = originSaleDocument.PercentagemDesconto : .ValorDesconto = originSaleDocument.ValorDesconto
                .OutrosDescontos = originSaleDocument.OutrosDescontos : .TotalPontos = originSaleDocument.TotalPontos : .TotalValesOferta = originSaleDocument.TotalValesOferta
                .TotalIva = originSaleDocument.TotalIva
                .TotalEntidade1 = originSaleDocument.TotalEntidade1 : .TotalEntidade2 = originSaleDocument.TotalEntidade2

                .Entidade1Automatica = originSaleDocument.Entidade1Automatica

                .IDEntidade1 = originSaleDocument.IDEntidade1 : .DescricaoEntidade1 = originSaleDocument.tbEntidades?.Descricao
                .IDEntidade2 = originSaleDocument.IDEntidade2 : .DescricaoEntidade2 = originSaleDocument.tbEntidades1?.Descricao

                .NumeroBeneficiario1 = originSaleDocument.NumeroBeneficiario1 : .Parentesco1 = originSaleDocument.Parentesco1
                .NumeroBeneficiario2 = originSaleDocument.NumeroBeneficiario2 : .Parentesco2 = originSaleDocument.Parentesco2
            End With

            Return originSaleDocument
        End Function

        ''' <summary>
        ''' Funcao que mapeia os dados do cliente do documento origem para o novo documento
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="idDocVenda"></param>
        ''' <param name="model"></param>
        ''' <returns></returns>
        Private Function MapeiaClienteDocOrigem(ctx As Aplicacao, idDocVenda As Long, ByRef model As DocumentosVendas) As DocumentosVendas
            Dim docOrigem As tbDocumentosVendas = ctx.tbDocumentosVendas.FirstOrDefault(Function(f) f.ID = idDocVenda)

            With model
                Dim customer As tbClientes = docOrigem.tbClientes

                If customer IsNot Nothing Then
                    Dim customerAddress As tbClientesMoradas = customer.tbClientesMoradas?.OrderBy(Function(o) o.Ordem).FirstOrDefault()

                    .IDEntidade = customer.ID : .DescricaoEntidade = customer.Nome : .NomeFiscal = customer.Nome : .CodigoEntidade = customer.Codigo
                    .IDCondicaoPagamento = customer.IDCondicaoPagamento : .DescricaoCondicaoPagamento = customer.tbCondicoesPagamento?.Descricao
                    .IDMoeda = customer.IDMoeda : .DescricaoMoeda = customer.tbMoedas.Descricao : .TaxaConversao = customer.tbMoedas.TaxaConversao
                    .ContribuinteFiscal = customer.NContribuinte
                    .IDEspacoFiscal = customer.IDEspacoFiscal : .DescricaoEspacoFiscal = customer.tbSistemaEspacoFiscal?.Descricao
                    .IDRegimeIva = customer.IDRegimeIva : .DescricaoRegimeIva = customer.tbSistemaRegimeIVA?.Descricao
                    .IDLocalOperacao = customer.IDLocalOperacao : .DescricaoLocalOperacao = customer.tbSistemaRegioesIVA.Descricao
                    .IDPaisFiscal = customer.IDPais : .DescricaoPaisFiscal = customer.tbPaises?.Descricao

                    If customerAddress IsNot Nothing Then
                        .MoradaFiscal = customerAddress.Morada
                        .IDCodigoPostalFiscal = customerAddress.IDCodigoPostal : .DescricaoCodigoPostalFiscal = customerAddress.tbCodigosPostais?.Descricao
                        .IDConcelhoFiscal = customerAddress.IDConcelho : .DescricaoConcelhoFiscal = customerAddress.tbConcelhos?.Descricao
                        .IDDistritoFiscal = customerAddress.IDDistrito : .DescricaoDistritoFiscal = customerAddress.tbDistritos?.Descricao
                    End If
                End If
            End With

            Return model
        End Function

        ''' <summary>
        ''' Funcao que atribui props do documento de origem a linha do documento de venda
        ''' </summary>
        ''' <param name="inDocOrigem"></param>
        ''' <param name="inLinha"></param>
        Private Sub AtribuiPropsDocOrigem(ByVal inDocOrigem As tbDocumentosVendas, inLinha As DocumentosVendasLinhas)
            With inLinha
                .IDLinhaDocumentoOrigem = .ID
                .IDDocumentoOrigem = inDocOrigem.ID : .DocumentoOrigem = inDocOrigem.Documento
                .IDTipoDocumentoOrigem = inDocOrigem.IDTipoDocumento
                .DataDocOrigem = inDocOrigem.DataDocumento
            End With
        End Sub

        ''' <summary>
        ''' Funcao auxiliar que preenche as linhas para  a fatura da entidade 2
        ''' </summary>
        ''' <param name="docOrigem"></param>
        ''' <param name="inModelo"></param>
        Private Sub PreencheLinhasFT2(docOrigem As tbDocumentosVendas, inModelo As DocumentosVendas)
            'retorna o armazem (por defeito) que está associado há loja
            Dim ArmazemPorDefeito As New tbArmazensLocalizacoes
            Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
            If IsNumeric(strIDLoc) AndAlso strIDLoc <> 0 Then
                ArmazemPorDefeito = BDContexto.tbArmazensLocalizacoes.Where(Function(w) w.ID = strIDLoc).FirstOrDefault()
            End If

            Dim intOrdem As Integer = 1
            For Each lin As tbDocumentosVendasLinhas In docOrigem.tbDocumentosVendasLinhas.ToList()
                Dim newLinha As New DocumentosVendasLinhas
                'mapear do dbset tbDocumentosVendasLinhas para o model DocumentosVendasLinhas
                Mapear(lin, newLinha)
                'doc origem na linha
                AtribuiPropsDocOrigem(docOrigem, newLinha)

                With newLinha
                    'reset values
                    .AcaoCRUD = CShort(AcoesFormulario.Adicionar) : .IDServico = Nothing : .IDDocumentoVenda = CLng(0)
                    .Diametro = Nothing : .IDModelo = Nothing : .IDTipoLente = Nothing : .IDTipoOlho = Nothing : .IDTratamentoLente = Nothing : .IDTipoGraduacao = Nothing
                    .IDEstado = Nothing
                    'iva e campanha
                    .CodigoIva = lin.tbIVA.Codigo : .MotivoIsencaoIva = lin.tbIVA.Mencao : .CodigoMotivoIsencaoIva = lin.tbIVA.tbSistemaCodigosIVA?.Codigo
                    'campanha
                    .Campanha = lin.tbCampanhas?.Descricao
                    'armazem
                    .IDArmazem = ArmazemPorDefeito?.IDArmazem : .DescricaoArmazem = ArmazemPorDefeito?.tbArmazens?.Descricao
                    'armazem localizacao
                    .IDArmazemLocalizacao = ArmazemPorDefeito?.ID : .CodigoArmazemLocalizacao = ArmazemPorDefeito?.Codigo : .DescricaoArmazemLocalizacao = ArmazemPorDefeito?.Descricao
                    'valores da entidade 2
                    dblvalor = CDbl(.PrecoUnitarioEfetivo) - CDbl(.ValorUnitarioEntidade2)
                    .ValorUnitarioEntidade2 = dblvalor : .ValorEntidade2 = dblvalor * .Quantidade
                    'get codigo artigo by codigo taxa iva
                    Dim strTiposIVACodigo As String = "DV-" & BDContexto.tbIVA.Where(Function(f) f.ID = .IDTaxaIva).FirstOrDefault().tbSistemaTiposIVA.Codigo
                    Dim Artigo As Oticas.Artigos = (From x In BDContexto.tbArtigos
                                                    Where x.Codigo = strTiposIVACodigo
                                                    Select New Oticas.Artigos With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao}).FirstOrDefault()

                    .IDArtigo = Artigo.ID : .CodigoArtigo = Artigo.Codigo : .DescricaoArtigo = Artigo.Descricao
                    .ValorUnitarioEntidade1 = CDbl(0)
                    .ValorEntidade1 = CDbl(0)

                    'lote
                    Dim strSql As String = ""
                    strSql &= " Select lotes.id "
                    strSql &= " From tbArtigosLotes As lotes "
                    strSql &= " Left Join tbArtigos As art On lotes.IDArtigo = art.ID  "
                    strSql &= " Left Join tbSistemaOrdemLotes as sisOL on sisOL.ID = art.IDOrdemLoteMovSaida  "
                    strSql &= " Left Join tbCCStockArtigos as ccSA on ccSA.IDArtigo = lotes.IDArtigo And ccSA.IDArtigoLote = lotes.ID  "
                    strSql &= " Left Join tbStockArtigos as sA on SA.IDArtigo = lotes.IDArtigo And sA.IDArtigoLote = lotes.ID "
                    strSql &= " where lotes.IDArtigo = art.ID And art.id = " & Artigo.ID & " order by (case sisOL.Codigo when 'DVDASC' then lotes.DataValidade END) ASC, (case sisOL.Codigo when 'FIFO' then lotes.DataCriacao END) ASC, (case sisOL.Codigo when 'DVDDSC' then lotes.DataValidade END) DESC, (case sisOL.Codigo when 'LIFO' then lotes.DataCriacao END) DESC, (case sisOL.Codigo when 'ULM' then ccSA.DataDocumento END) DESC "
                    Dim IDLote As Nullable(Of Long) = BDContexto.Database.SqlQuery(Of Nullable(Of Long))(strSql).FirstOrDefault()
                    .IDLote = IDLote
                    'valores totais
                    .TotalFinal = Math.Round(CDbl(.TotalComDescontoCabecalho - .ValorEntidade2), CShort(inModelo.CasasDecimaisTotais))
                    .PrecoTotal = .TotalFinal
                    'ordem e id
                    .Ordem = intOrdem : .ID = CLng(0)
                End With
                'contador na ordem
                intOrdem += 1

                inModelo.DocumentosVendasLinhas.Add(newLinha)
            Next
        End Sub
#End Region

#Region "CALCULOS - DESCONTOS POR TAXAS DE IVA"
        ''' <summary>
        ''' Funcao que calcula o valor de descontos sem configuracao
        ''' </summary>
        ''' <param name="inDVL"></param>
        Private Sub CalculaValorDescCabSemConfigDescontos(inDVL As DocumentosVendasLinhas)
            With inDVL
                .ValorDescontoCabecalho = Math.Round(CDbl(.ValorDescontoCabecalho), intCasasDecTotais)

                If .ValorDescontoLinha + .ValorDescontoCabecalho > RetornaQtdVsPreco(inDVL) Then
                    .ValorDescontoCabecalho = RetornaQtdVsPreco(inDVL) - .ValorDescontoLinha
                End If

                .TotalComDescontoCabecalho = Math.Round(CDbl(RetornaQtdVsPreco(inDVL) - .ValorDescontoLinha - .ValorDescontoCabecalho), intCasasDecTotais)
            End With
        End Sub

        ''' <summary>
        ''' Funcao que calcula o valor de descontos com configuracao
        ''' </summary>
        ''' <param name="inDVL"></param>
        ''' <param name="inModelo"></param>
        Private Sub CalculaValorDescCabComConfigDescontos(inDVL As DocumentosVendasLinhas, inModelo As DocumentosVendas)
            'get valor desconto global
            Dim valorDescontoGlobal As Double = 0
            If inModelo.ValorDesconto IsNot Nothing Then
                valorDescontoGlobal = inModelo.ValorDesconto
            End If

            If inModelo.SubTotal Is Nothing Then inModelo.SubTotal = CDbl(0)

            If campoAlteradoDTD = "PercentagemDesconto" Then
                If inModelo.PercentagemDesconto Is Nothing Then inModelo.PercentagemDesconto = CDbl(0)

                valorDescontoGlobal = Math.Round(CDbl(inModelo.SubTotal * (inModelo.PercentagemDesconto / 100)), intCasasDecTotais)
            End If

            'valor utilizado nas linhas que tem configuracao de descontos
            Dim utilizado As Double = CDbl(0)
            Dim excesso As Double = CDbl(0)

            'get todas as linhas 
            Dim linhasTodas As List(Of DocumentosVendasLinhas) = inModelo.DocumentosVendasLinhas.Where(Function(w)
                                                                                                           Return w.AcaoCRUD <> AcoesFormulario.Remover
                                                                                                       End Function).ToList()

            'get linhas agrupadas por taxa de iva
            Dim linhasTodasByIVA = From x In linhasTodas
                                   Join m In lstConfigDesconto On m.IDIva Equals x.IDTaxaIva
                                   Order By m.Desconto Descending
                                   Select New With {.Linha = x, .IVADesconto = m}

            If (linhasTodasByIVA.Any(Function(a) a.IVADesconto.Desconto > 0)) Then
                'calcula linhas que tenham peso de descontos
                For Each lin In linhasTodasByIVA.Where(Function(w) w.IVADesconto.Desconto > 0)
                    'get linha atual
                    Dim linhaAtual As DocumentosVendasLinhas = lin.Linha

                    'get preco
                    'Dim preco As Double = RetornaQtdVsPreco(linhaAtual)
                    Dim preco As Double = linhaAtual.TotalComDescontoLinha
                    'get percentagem valor minimo preco venda
                    Dim percValorMinimoPV As Double = Math.Round(CDbl(lin.IVADesconto.ValorMinimo / 100), 6)
                    If percValorMinimoPV = CDbl(0) Then percValorMinimoPV = 1

                    'get se respeita o custo medio no valor minimo
                    Dim boolValorMinimoCMedio As Boolean = lin.IVADesconto.PCM

                    If Not linhaAtual.IDArtigo Is Nothing AndAlso preco > 0 Then
                        'get peso
                        Dim peso As Double = Math.Round(CDbl(lin.IVADesconto.Desconto / 100), 2)

                        'get all taxas iva
                        Dim idTaxasIVA As Long?() = linhasTodas.Where(Function(w) RetornaQtdVsPreco(w) > 0).Select(Function(s) s.IDTaxaIva).Distinct().ToArray()
                        'get somatorio dos pesos
                        Dim sumPesos As Double = lstConfigDesconto.Where(Function(w) idTaxasIVA.Contains(w.IDIva)).Select(Function(s) s.Desconto).Sum()
                        sumPesos /= 100

                        'get peso do peso
                        Dim pesoDoPeso = Math.Round(CDbl(peso / sumPesos), 6)

                        'get total das taxas de iva
                        Dim totalTaxasIVA As Double = CDbl(0)
                        linhasTodas.Where(Function(w) Not w.IDTaxaIva Is Nothing AndAlso w.IDTaxaIva = linhaAtual.IDTaxaIva).ToList().ForEach(Sub(f)
                                                                                                                                                  totalTaxasIVA += f.TotalComDescontoLinha
                                                                                                                                              End Sub)
                        'get valor desconto cabecalho
                        Dim valorDescontoCabecalho As Double = CDbl(0)
                        valorDescontoCabecalho = Math.Round(CDbl(pesoDoPeso * valorDescontoGlobal * (preco / totalTaxasIVA)), intCasasDecTotais)
                        'sum transporte da linha anterior
                        valorDescontoCabecalho = Math.Round(CDbl(valorDescontoCabecalho + excesso), intCasasDecTotais)

                        'percentagem de desconto em relacao ao preco
                        Dim aux As Double = Math.Round(CDbl(valorDescontoCabecalho / preco), 6)
                        'verifica se a percentagem em relacao em preco e superior que ao preco 
                        If aux > 1 Then
                            excesso = Math.Round(valorDescontoCabecalho - preco, intCasasDecTotais)
                            valorDescontoCabecalho = preco
                            aux = 1 '100%

                        Else
                            excesso = CDbl(0)
                        End If

                        'verifica se o preco e maior que o valor minimo % pv definido na configuracao de descontos
                        If aux > (1 - percValorMinimoPV) AndAlso percValorMinimoPV <> 1 Then
                            valorDescontoCabecalho = Math.Round(CDbl(preco - (preco * percValorMinimoPV)), intCasasDecTotais)
                            If valorDescontoCabecalho < 0 Then
                                valorDescontoCabecalho = 0
                            End If
                        End If

                        'verifica se valida preco custo medio
                        If boolValorMinimoCMedio Then
                            'get preco medio do artigo
                            Dim precoCustoMedioArtigo As Double? = lstArtigosCalcula.Where(Function(w) w.ID = linhaAtual.IDArtigo).Select(Function(s) s.Medio).FirstOrDefault()
                            If precoCustoMedioArtigo Is Nothing Then precoCustoMedioArtigo = CDbl(0)
                            'verifica se o valor e superior ao custo medio
                            If preco - valorDescontoCabecalho < precoCustoMedioArtigo Then
                                valorDescontoCabecalho = Math.Round(CDbl(preco - precoCustoMedioArtigo), intCasasDecTotais)
                                If valorDescontoCabecalho < 0 Then
                                    valorDescontoCabecalho = 0
                                End If
                            End If
                        End If

                        'atualiza valor utilizado
                        utilizado += valorDescontoCabecalho
                        If valorDescontoGlobal - utilizado < 0 Then
                            valorDescontoCabecalho += valorDescontoGlobal - utilizado
                        End If

                        'set to linha
                        With linhaAtual
                            .TotalComDescontoCabecalho = Math.Round(CDbl(preco - valorDescontoCabecalho), intCasasDecTotais)
                            .ValorDescontoCabecalho = valorDescontoCabecalho
                            If .Quantidade > 0 Then
                                .PrecoUnitarioEfetivo = .TotalComDescontoCabecalho / .Quantidade
                                .TotalFinal = .TotalComDescontoCabecalho
                            End If
                        End With

                    Else
                        'set to linha
                        With linhaAtual
                            .TotalComDescontoCabecalho = CDbl(0) : .ValorDescontoCabecalho = CDbl(0)
                        End With
                    End If
                Next

                'calcula valor em falta
                excesso = valorDescontoGlobal - utilizado

                'calcula linhas que não tenham peso de descontos
                For Each lin In linhasTodasByIVA.Where(Function(w) w.IVADesconto.Desconto = 0)
                    'get linha atual
                    Dim linhaAtual As DocumentosVendasLinhas = lin.Linha

                    If excesso > 0 Then
                        If Not linhaAtual.IDArtigo Is Nothing AndAlso ELinhasTodas AndAlso valorDescontoGlobal <> 0 Then
                            'get preco
                            Dim preco As Double = RetornaQtdVsPreco(linhaAtual)

                            Dim valorDescontoCabecalho As Double = excesso
                            If valorDescontoCabecalho > preco Then
                                excesso = Math.Round(CDbl(valorDescontoCabecalho - preco), intCasasDecTotais)
                                valorDescontoCabecalho = preco

                            Else
                                excesso = CDbl(0)
                            End If

                            'set to linha
                            With linhaAtual
                                .TotalComDescontoCabecalho = Math.Round(CDbl(preco - valorDescontoCabecalho), intCasasDecTotais)
                                .ValorDescontoCabecalho = valorDescontoCabecalho
                            End With
                        End If

                    Else
                        'set to linha
                        With linhaAtual
                            .TotalComDescontoCabecalho = CDbl(0) : .ValorDescontoCabecalho = CDbl(0)
                        End With
                    End If
                Next

            Else
                CalculaValorDescCabSemConfigDescontos(inDVL)
            End If
        End Sub
#End Region

#Region "COPY"
        Public Function RetornaModSelectTipoDocDuplica(ByVal idDocumento As Long) As F3M.DocumentosSelectTipoDocDuplicar
            Return tabela.
                AsNoTracking().
                Where(Function(entity) entity.ID = idDocumento).
                Select(Function(entity) New F3M.DocumentosSelectTipoDocDuplicar With {
                .IDDuplicar = entity.ID, .DocumentoDuplicar = entity.Documento,
                .DescricaoDocumentoDuplicar = entity.tbTiposDocumento.Descricao & " " & entity.Documento,
                .IDSistemaTipoEntidadeDuplicar = entity.IDTipoEntidade,
                .IDTipoDocumentoDuplicar = entity.tbTiposDocumento.ID, .DescricaoTipoDocumentoDuplicar = entity.tbTiposDocumento.Descricao,
                .IDModuloDuplicar = entity.tbTiposDocumento.IDModulo, .CodigoTipoDocumentoDuplicar = entity.tbTiposDocumento.Codigo,
                .IDTiposDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.ID, .DescricaoTiposDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.DescricaoSerie,
                .CodigoTipoDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.CodigoSerie}).
                FirstOrDefault()
        End Function
#End Region

#Region "COMMUNICATION - SMS"
        Public Overrides Function GetCommunicationSmsProperties(id As Long) As ClsF3MCommunicationSms
            Dim entityToSendSmsId As Long = tabela.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = id).IDEntidade
            Dim phoneNumber As String = BDContexto.tbClientesContatos.OrderBy(Function(entity) entity.Ordem)?.FirstOrDefault(Function(entity) entity.IDCliente = entityToSendSmsId)?.Telemovel
            Return New ClsF3MCommunicationSms With {.EntityId = id, .EntityToSendSmsId = entityToSendSmsId, .MobilePhoneNumber = phoneNumber}
        End Function
#End Region
    End Class
End Namespace