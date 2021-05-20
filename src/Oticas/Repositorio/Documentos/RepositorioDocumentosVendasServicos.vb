Imports System.Data.Entity
Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.BaseDados
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports F3M.Repositorio.TabelasAuxiliaresComum
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Repositorio.Artigos
Imports Oticas.Modelos.Constantes
Imports F3M.Models.Communication

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosVendasServicos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendasServicos)

        Private Shared codigoAcesso As String = "015.005.003"

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosVendasServicos)
            Dim query As IQueryable(Of Oticas.DocumentosVendasServicos) = AplicaQueryListaPersonalizada(inFiltro)

            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 1 " & Now.ToString(“HH:mm:ss.fff”))
            Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))
            If IDEntidade <> 0 Then
                query = query.Where(Function(w) w.IDEntidade = IDEntidade)
            End If

            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 2 " & Now.ToString(“HH:mm:ss.fff”))
            Dim IDEntidadeFromHistorico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEntidadeFromHistorico", GetType(Long))
            If IDEntidadeFromHistorico <> 0 Then
                query = query.Where(Function(f) f.IDEntidade = IDEntidadeFromHistorico)
            End If

            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 3 " & Now.ToString(“HH:mm:ss.fff”))
            Dim lngIDSistTD As Long = RepositorioTipoDoc.RetornaSistTipoDoc(Of tbTiposDocumento)(
                New Oticas.BD.Dinamica.Aplicacao, TiposSistemaTiposDocumento.VendasServico)
            If lngIDSistTD <> 0 Then
                query = query.Where(Function(f) f.IDSistemaTiposDocumento = lngIDSistTD)
            End If

            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 4 " & Now.ToString(“HH:mm:ss.fff”))
            Dim FromHistorico As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "FromHistorico", GetType(Boolean))
            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 5 " & Now.ToString(“HH:mm:ss.fff”))
            Dim IgnoraAcessoPorLoja As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IgnoraAcessoPorLoja", GetType(Boolean))
            If Not FromHistorico AndAlso Not IgnoraAcessoPorLoja AndAlso Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, codigoAcesso) Then
                query = query.Where(Function(f) f.IDLoja = ClsF3MSessao.RetornaLojaID)
            End If

            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 6 " & Now.ToString(“HH:mm:ss.fff”))
            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query, True)
            ClsUtilitarios.CodeTrace("REC.log", "Servicos: Lista : 7 " & Now.ToString(“HH:mm:ss.fff”))

            Return query
        End Function

        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbDocumentosVendas)) As IQueryable(Of DocumentosVendasServicos)
            Dim funcSel As Func(Of tbDocumentosVendas, Oticas.DocumentosVendasServicos) = Function(s) MapeiaEsp(s)

            Return inQuery.Select(funcSel).AsQueryable
        End Function

        Public Function MapeiaEsp(inDocBD As tbDocumentosVendas) As Oticas.DocumentosVendasServicos
            Dim docMOD As New Oticas.DocumentosVendasServicos
            Dim docMODCA As New tbSistemaTiposDocumentoColunasAutomaticas

            If inDocBD IsNot Nothing Then
                ' Mapeia Generico
                RepositorioDocumentos.MapeiaCamposGen(Of tbDocumentosVendas, Oticas.DocumentosVendasServicos, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosVendasLinhas, Oticas.DocumentosVendasLinhas)(inDocBD, docMOD, docMODCA)
                ' Mapeia Especifico
                With docMOD
                    .CodigoMoeda = inDocBD.CodigoMoeda
                    .CodigoTipoEstado = inDocBD.CodigoTipoEstado
                    .DescontosLinha = inDocBD.DescontosLinha
                    .TotalIva = inDocBD.TotalIva
                    .CodigoPostalFiscal = inDocBD.CodigoPostalFiscal
                    .SegundaVia = inDocBD.SegundaVia
                    .TotalClienteMoedaDocumento = inDocBD.TotalClienteMoedaDocumento
                    .TotalClienteMoedaReferencia = inDocBD.TotalClienteMoedaReferencia
                    .CodigoTipoDocumento = inDocBD.tbTiposDocumento.Codigo
                    .TipoFiscal = If(inDocBD.tbTiposDocumento IsNot Nothing,
                                     If(inDocBD.tbTiposDocumento.tbSistemaTiposDocumentoFiscal IsNot Nothing,
                                        inDocBD.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo, String.Empty), String.Empty)
                    .CodigoCliente = inDocBD.tbClientes.Codigo
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

                    Dim ctx As BD.Dinamica.Aplicacao = Activator.CreateInstance(GetType(BD.Dinamica.Aplicacao))
                    .RegistoBloqueado = RepositorioDocumentos.RegistoBloqueadoVendas(ctx, inDocBD.ID, inDocBD.IDTipoDocumento)

                    PreencheSubServicos(docMOD)

                    .RegistoBloqueado = .RegistoBloqueado OrElse .Servicos.Any(Function(s) Not s.IDDocumentosVendasServicosSubstituicaoArtigos Is Nothing)
                End With
            End If

            Return docMOD
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbDocumentosVendas)) As IQueryable(Of Oticas.DocumentosVendasServicos)
            Using repD As New RepositorioDocumentos
                Return repD.MapeiaLista(Of tbDocumentosVendas, Oticas.DocumentosVendasServicos, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosVendasLinhas, Oticas.DocumentosVendasLinhas)(inQuery, True)
            End Using
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbDocumentosVendas)
            Dim query As IQueryable(Of tbDocumentosVendas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            AplicaFiltroAtivo(inFiltro, query)

            Dim IDEntidade As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEntidade, GetType(Long))
            If IDEntidade > 0 Then
                Return query.Where(Function(f) f.IDEntidade = IDEntidade)
            End If

            Dim IDEntidadeFromHistorico As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEntidadeFromHistorico", GetType(Long))
            If IDEntidadeFromHistorico > 0 Then
                Return query.Where(Function(f) f.IDEntidade = IDEntidadeFromHistorico)
            End If

            Return query
        End Function

        Public Function ListaArtigosComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Artigos)
            Dim result As IQueryable(Of Oticas.Artigos) = Nothing

            Using rep As New RepositorioArtigos
                If ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoServico", GetType(Long)) <> 0 AndAlso inFiltro.FiltroTexto?.ToUpper = "LO" Then
                    inFiltro.FiltroTexto = "LO0"
                End If
                result = rep.ListaComboCodigo(inFiltro)
            End Using

            Dim lstArtigosIds As Long() = result.Select(Function(artigo) artigo.ID).ToArray()
                Dim lstLO As List(Of Oticas.tbLentesOftalmicas) = BDContexto.tbLentesOftalmicas.Where(Function(w) lstArtigosIds.Any(Function(idartigo) idartigo = w.IDArtigo)).ToList()
                Dim lstLC As List(Of Oticas.tbLentesContato) = BDContexto.tbLentesContato.Where(Function(w) lstArtigosIds.Any(Function(idartigo) idartigo = w.IDArtigo)).ToList()

                For Each linha In result
                    If linha.IDTipoArtigo = TipoArtigo.LentesOftalmicas AndAlso lstLO.Where(Function(f) f.IDArtigo = linha.ID).Count Then
                        Dim r = lstLO.Where(Function(f) f.IDArtigo = linha.ID).FirstOrDefault
                        linha.Diametro = r.Diametro
                        linha.PotenciaEsferica = r.PotenciaEsferica
                        linha.PotenciaCilindrica = r.PotenciaCilindrica
                        linha.PotenciaPrismatica = r.PotenciaPrismatica
                        linha.Adicao = r.Adicao
                    ElseIf linha.IDTipoArtigo = TipoArtigo.LentesContacto AndAlso lstLC.Where(Function(f) f.IDArtigo = linha.ID).Count Then
                        Dim r = lstLC.Where(Function(f) f.IDArtigo = linha.ID).FirstOrDefault
                        linha.Diametro = r.Diametro
                        linha.Eixo = r.Eixo
                        linha.RaioCurvatura = r.Raio
                        linha.DetalheRaio = r.Raio2
                        linha.PotenciaEsferica = r.PotenciaEsferica
                        linha.PotenciaCilindrica = r.PotenciaCilindrica
                        linha.Adicao = r.Adicao
                    End If
                Next

            Return result
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef inModelo As Oticas.DocumentosVendasServicos, inFiltro As ClsF3MFiltro)
            Try
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 1 " & Now.ToString(“HH:mm:ss.fff”))

                Using inCtx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = inCtx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 2 " & Now.ToString(“HH:mm:ss.fff”))

                            ValidarDocumento(inModelo)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 3 " & Now.ToString(“HH:mm:ss.fff”))
                            Calcula(Nothing, inModelo)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 4 " & Now.ToString(“HH:mm:ss.fff”))
                            Dim ERasc As Boolean = RepositorioDocumentos.ERascunho(Of tbEstados)(inCtx, inModelo)
                            Dim docSerie As tbTiposDocumentoSeries = RepositorioDocumentos.AdicionaDocumento(
                                Of tbDocumentosVendas, DocumentosVendasServicos, tbTiposDocumentoSeries, tbEstados)(inCtx, inModelo, inFiltro)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 5 " & Now.ToString(“HH:mm:ss.fff”))
                            Dim lngID As Long = inModelo.IDTipoDocumento
                            Dim lngIDSerie As Long = inModelo.IDTiposDocumentoSeries

                            Dim CodigoTipoDocumento As String = inCtx.tbTiposDocumento.Find(lngID).Codigo
                            Dim TDS As tbTiposDocumentoSeries = inCtx.tbTiposDocumentoSeries.Find(lngIDSerie)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 6 " & Now.ToString(“HH:mm:ss.fff”))
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

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 7 " & Now.ToString(“HH:mm:ss.fff”))
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

                            inModelo.ValorPago = CDbl(0)

                            If inModelo.IDMoeda Is Nothing Then 'HERE FK
                                inModelo.IDMoeda = 1
                                inModelo.TaxaConversao = 1
                            End If

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 8 " & Now.ToString(“HH:mm:ss.fff”))
                            ' Preencher a lista de campos que não quero que sejam mexidos
                            With inModelo
                                .ExecutaListaCamposEvitaMapear = True
                                .ListaCamposEvitaMapear = New List(Of String)
                                .ListaCamposEvitaMapear.Add("NumeroDocumento")
                            End With

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 9 " & Now.ToString(“HH:mm:ss.fff”))
                            'Preencher os dados fiscais
                            PreencheDadosFiscaisCliente(inCtx, inModelo)

                            Dim e As New tbDocumentosVendas
                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 10 " & Now.ToString(“HH:mm:ss.fff”))
                            Mapear(inModelo, e)
                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 11 " & Now.ToString(“HH:mm:ss.fff”))
                            PreeEntDadosUtilizador(e, 0, AcoesFormulario.Adicionar)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 12 " & Now.ToString(“HH:mm:ss.fff”))
                            GravaLinhasTodas(inCtx, inModelo, e, AcoesFormulario.Adicionar)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 13 " & Now.ToString(“HH:mm:ss.fff”))
                            Dim strMensagem As String = String.Empty
                            Using rpd As New RepositorioDocumentosVendas
                                strMensagem = rpd.TextoMensagemAssinatura(inCtx, True, ClsF3MSessao.RetornaEmpresaDemonstracao, False, blnManual, blnReposicao, "", "", e.IDTipoDocumento, "")
                                e.MensagemDocAT = strMensagem
                            End Using

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 14 " & Now.ToString(“HH:mm:ss.fff”))
                            RepositorioDocumentos.DefineNumeroDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries)(inCtx, inModelo, docSerie, ERasc, 0)
                            e.NumeroDocumento = inModelo.NumeroDocumento
                            e.Documento = String.Concat(docSerie.tbTiposDocumento.Codigo, " ", docSerie.CodigoSerie, "/", e.NumeroDocumento)
                            e.IDLojaSede = ClsF3MSessao.RetornaIDLojaSede
                            inCtx.Entry(e).State = EntityState.Added
                            inCtx.SaveChanges()
                            lngIDEstado = inModelo.IDEstado
                            inModelo.ID = e.ID
                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 15 " & Now.ToString(“HH:mm:ss.fff”))

                            If Not ERasc Then
                                Dim blnAtualizaStock As Boolean = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereStock
                                If blnAtualizaStock Then
                                    ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 16 " & Now.ToString(“HH:mm:ss.fff”))
                                    inCtx.sp_AtualizaStock(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                                    ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 17 " & Now.ToString(“HH:mm:ss.fff”))
                                    RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Adicionar)
                                End If
                            End If

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 18 " & Now.ToString(“HH:mm:ss.fff”))
                            inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Adicionar, "tbDocumentosVendas", ClsF3MSessao.RetornaUtilizadorNome)

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 19 " & Now.ToString(“HH:mm:ss.fff”))
                            trans.Commit()
                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: AdicionaObj : 20 " & Now.ToString(“HH:mm:ss.fff”))

                        Catch
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef inModelo As Oticas.DocumentosVendasServicos, inFiltro As ClsF3MFiltro)
            Try
                Dim DocumentoVenda As tbDocumentosVendas = BDContexto.tbDocumentosVendas.Find(inModelo.ID)
                Dim strMo As String = String.Empty
                Dim strMe As String = String.Empty
                Dim lngIDestado As Long = 0
                Dim lngIDestadoNovo As Long = 0
                Dim numAnterior As Long = 0
                Dim strAssinatura As String = String.Empty
                Dim blnAnulado As Boolean = False

                If DocumentoVenda IsNot Nothing Then
                    strAssinatura = DocumentoVenda.Assinatura
                    lngIDestado = DocumentoVenda.IDEstado
                    strMe = Convert.ToBase64String(DocumentoVenda.F3MMarcador)
                End If
                strMo = inModelo.Concorrencia
                lngIDestadoNovo = inModelo.IDEstado

                If strMo <> strMe Then
                    If lngIDestadoNovo = lngIDestado Then
                        ValidarConcorrencia(AcoesFormulario.Alterar, inModelo, DocumentoVenda)
                    Else
                        Throw New Exception(Traducao.EstruturaErros.ValorPendenteAlteradoInfoAtualizada)
                    End If
                End If

                'ALTERA E GRAVA OBSERVACOES QUANDO TEM DOCS ASSOCIADOS E O ESTADO E EFT
                Dim temDocumentos As Boolean = BDContexto.tbDocumentosVendasLinhas.Any(Function(d) d.IDDocumentoOrigem = DocumentoVenda.ID AndAlso d.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo)
                If temDocumentos AndAlso DocumentoVenda.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo Then
                    If inModelo.InputsAlterados?.Where(Function(f) f.elemProp = CamposGenericos.Observacoes).Count > 0 OrElse
                        inModelo.GraduacoesAlteradas?.Any(Function(w) w = "DNP" OrElse w = "AcuidadeVisual" OrElse w = "AnguloPantoscopico" OrElse w = "DistanciaVertex" OrElse w = "Altura") Then

                        With DocumentoVenda
                            'UPDATE ÀS OBSERVACOES
                            .Observacoes = inModelo.Observacoes
                            'UPDATE AO UTILIZADOR / DATA DE ALTERACAO
                            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome : .DataAlteracao = DateAndTime.Now()

                            'BD UPDATE
                            With BDContexto
                                .Entry(DocumentoVenda).Property(CamposGenericos.Observacoes).IsModified = True
                                .Entry(DocumentoVenda).Property(CamposGenericos.UtilizadorAlteracao).IsModified = True
                                .Entry(DocumentoVenda).Property(CamposGenericos.DataAlteracao).IsModified = True
                                .SaveChanges()
                            End With

                            For Each servico As Servicos In inModelo.Servicos
                                For Each graduacoesServico As DocumentosVendasLinhasGraduacoes In servico.DocumentosVendasLinhasGraduacoes
                                    If graduacoesServico.ID > 0 Then
                                        Dim graduacao As tbDocumentosVendasLinhasGraduacoes = BDContexto.tbDocumentosVendasLinhasGraduacoes.Where(Function(w) w.ID = graduacoesServico.ID).FirstOrDefault()

                                        With graduacao
                                            .AcuidadeVisual = graduacoesServico.AcuidadeVisual
                                            .AnguloPantoscopico = graduacoesServico.AnguloPantoscopico
                                            .Altura = graduacoesServico.Altura
                                            .DNP = graduacoesServico.DNP
                                            .DistanciaVertex = graduacoesServico.DistanciaVertex
                                        End With

                                        'BD UPDATE
                                        With BDContexto
                                            .Entry(graduacao).Property(Function(p) p.AcuidadeVisual).IsModified = True
                                            .Entry(graduacao).Property(Function(p) p.AnguloPantoscopico).IsModified = True
                                            .Entry(graduacao).Property(Function(p) p.Altura).IsModified = True
                                            .Entry(graduacao).Property(Function(p) p.DNP).IsModified = True
                                            .Entry(graduacao).Property(Function(p) p.DistanciaVertex).IsModified = True

                                            .Entry(graduacao).Property(CamposGenericos.UtilizadorAlteracao).IsModified = True
                                            .Entry(graduacao).Property(CamposGenericos.DataAlteracao).IsModified = True
                                            .SaveChanges()
                                        End With
                                    End If
                                Next
                            Next
                        End With
                        '++++++++++++++++++++++++++
                        Exit Sub '++++++++++++++++++
                        '++++++++++++++++++++++++++
                    End If
                End If

                ValidarDocumento(inModelo)

                Using inCtx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = inCtx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            Calcula(Nothing, inModelo)

                            Dim e As tbDocumentosVendas = inCtx.tbDocumentosVendas.Find(inModelo.ID)
                            numAnterior = ClsUtilitarios.RetornaZeroSeVazio(e.NumeroDocumento)

                            Dim lngID As Long = inModelo.IDTipoDocumento
                            Dim blnAtualizaStock As Boolean = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.GereStock

                            If e IsNot Nothing Then
                                If strAssinatura = String.Empty Then
                                    Dim ERasc As Boolean = RepositorioDocumentos.ERascunho(Of tbEstados)(inCtx, inModelo)
                                    Dim docSerie As tbTiposDocumentoSeries = RepositorioDocumentos.EditaDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries, tbEstados)(inCtx, inModelo, e, inFiltro)

                                    Dim lngIDSerie As Long = inModelo.IDTiposDocumentoSeries

                                    Dim CodigoTipoDocumento As String = inCtx.tbTiposDocumento.Where(Function(f) f.ID = lngID).FirstOrDefault.Codigo
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

                                    With inModelo
                                        .ExecutaListaCamposEvitaMapear = True
                                        .ListaCamposEvitaMapear = New List(Of String)
                                        .ListaCamposEvitaMapear.Add("Assinatura")
                                        .ListaCamposEvitaMapear.Add("IDLoja")
                                        .ListaCamposEvitaMapear.Add("ValorPago")
                                        .ListaCamposEvitaMapear.Add("CodigoDocOrigem")
                                        .ListaCamposEvitaMapear.Add("NumeroDocumento")
                                    End With

                                    'TODO!!!
                                    With inModelo
                                        .ContribuinteFiscal = inCtx.Database.SqlQuery(Of String)("SELECT NContribuinte FROM tbClientes WHERE ID =" & inModelo.IDEntidade).FirstOrDefault()
                                        .DataNascimento = inCtx.Database.SqlQuery(Of DateTime?)("SELECT isnull(DataNascimento,null) as DataNascimento FROM tbClientes WHERE ID =" & inModelo.IDEntidade).FirstOrDefault()
                                    End With

                                    Mapear(inModelo, e)
                                    PreeEntDadosUtilizador(e, inModelo.ID, AcoesFormulario.Alterar)
                                    GravaLinhasTodas(inCtx, inModelo, e, AcoesFormulario.Alterar)

                                    Dim strMensagem As String = String.Empty

                                    Using rpd As New RepositorioDocumentosVendas
                                        strMensagem = rpd.TextoMensagemAssinatura(inCtx, True, ClsF3MSessao.RetornaEmpresaDemonstracao, False, blnManual, blnReposicao, "", "", e.IDTipoDocumento, "")
                                        e.MensagemDocAT = strMensagem
                                    End Using

                                    RepositorioDocumentos.DefineNumeroDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries)(inCtx, inModelo, docSerie, ERasc, numAnterior)
                                    e.NumeroDocumento = inModelo.NumeroDocumento
                                    e.Documento = String.Concat(docSerie.tbTiposDocumento.Codigo, " ", docSerie.CodigoSerie, "/", e.NumeroDocumento)
                                    inCtx.Entry(e).State = EntityState.Modified

                                    inCtx.SaveChanges()
                                    lngIDestado = inModelo.IDEstado
                                    inModelo.ID = e.ID
                                    inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Alterar, "tbDocumentosVendas", ClsF3MSessao.RetornaUtilizadorNome)
                                Else
                                    blnAnulado = RepositorioDocumentosVendas.EAnulado(inCtx, inModelo.IDEstado)

                                    inCtx.sp_AtualizaStock(inModelo.ID, inModelo.IDTipoDocumento, AcoesFormulario.Remover, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                                    RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Remover)

                                    If blnAnulado Then
                                        RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "idestado", inModelo.IDEstado)
                                        RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "CodigoTipoEstado", TiposEstados.Anulado)
                                        RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "DataHoraEstado", Format(DateAndTime.Now, FormatoData.DataHora))
                                        RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "UtilizadorEstado", ClsF3MSessao.RetornaUtilizadorNome)
                                        RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "Assinatura", ".")

                                        strQry = "update tbdocumentosvendaspendentes SET ativo=0 WHERE iddocumentovenda=" & inModelo.ID
                                        inCtx.Database.ExecuteSqlCommand(strQry)
                                    Else
                                        'RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "observacoes", inModelo.Observacoes)
                                        'RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "idestado", inModelo.IDEstado)
                                        'RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "CodigoTipoEstado", TiposEstados.Efetivo)
                                        'RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "DataHoraEstado", Format(DateAndTime.Now, FormatoData.DataHora))
                                        'RepositorioDocumentosVendas.AtualizaCampo(inCtx, "tbDocumentosVendas", inModelo.ID, "UtilizadorEstado", ClsF3MSessao.RetornaUtilizadorNome)
                                    End If
                                End If

                                If blnAtualizaStock AndAlso Not blnAnulado Then
                                    inCtx.sp_AtualizaStock(e.ID, e.IDTipoDocumento, AcoesFormulario.Adicionar, "tbDocumentosVendas", "tbDocumentosVendasLinhas", "", "IDDocumentoVenda", "", ClsF3MSessao.RetornaUtilizadorNome, (inModelo.FazTestesRptStkMinMax IsNot Nothing AndAlso inModelo.FazTestesRptStkMinMax), False)
                                    RepositorioStocks.ValidaStocks(Of tbControloValidacaoStock)(inCtx, inModelo, AcoesFormulario.Adicionar)
                                End If

                            End If
                            trans.Commit()

                        Catch
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

        Public Function ValidaEstado(inFiltro As ClsF3MFiltro, ByRef model As DocumentosVendas) As DocumentosVendas
            Try
                Dim CampoAlterado As String = String.Empty
                Dim Col As String = String.Empty
                Dim IDLinha As Long = 0
                Dim lngID As Long = model.ID

                model.ValidaEstado = 0

                If model.TotalEntidade2 > 0 AndAlso model.IDEntidade2 Is Nothing Then
                    model.ValidaEstado = 1
                End If
                Return model
            Catch
                Throw
            End Try

        End Function

        Public Sub ValidarDocumento(ByRef o As Oticas.DocumentosVendasServicos)
            Dim strRes As String = String.Empty
            Dim dblTotalLinha As Double = 0
            Dim dblTotalDescontosLinha As Double = 0
            Dim lstArtAbaixoPrecoCusto As New List(Of DocumentosVendasLinhas)

            For Each DV In o.Servicos
                Dim TodasAsLinhas As List(Of DocumentosVendasLinhas) = DV.DocumentosVendasLinhas.Concat(o.Diversos).ToList
                For Each DVL In TodasAsLinhas
                    If DVL.IDArtigo IsNot Nothing Then
                        If o.AcaoFormulario <> AcoesFormulario.Adicionar Then
                            If o.ValorPago.Value > 0 Then
                                Throw New Exception(Traducao.EstruturaDocumentos.ValorPago)
                            End If
                        End If

                        If DVL.Quantidade.Value < 1 Then
                            Throw New Exception(Traducao.EstruturaDocumentos.QuantidadeZero)
                        End If

                        If DVL.IDArtigo IsNot Nothing Then
                            If DVL.Descricao Is Nothing Then
                                Throw New Exception(Traducao.EstruturaDocumentos.DescricaoNaoPreenchida)
                            End If
                        End If

                        If DVL.TotalComDescontoLinha.Value < 0 Then
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

                        dblTotalLinha += If(DVL.PrecoUnitario IsNot Nothing, DVL.PrecoUnitario, 0)

                        dblTotalDescontosLinha += If(DVL.ValorDescontoLinha IsNot Nothing, DVL.ValorDescontoLinha, 0) + If(DVL.ValorDescontoCabecalho IsNot Nothing, DVL.ValorDescontoCabecalho, 0)

                        Using inCtx As New BD.Dinamica.Aplicacao
                            Dim prcMedio As Double? = inCtx.tbArtigos.Where(Function(f) f.ID = DVL.IDArtigo).FirstOrDefault?.Medio
                            If DVL.PrecoUnitarioEfetivo < prcMedio Then
                                lstArtAbaixoPrecoCusto.Add(DVL)
                            End If
                        End Using
                    End If
                Next
            Next

            If o.TotalEntidade1 > 0 AndAlso o.IDEntidade1 Is Nothing Then
                Throw New Exception(Traducao.EstruturaDocumentos.Entidade1NaoPreenchida)
            End If

            If o.TotalEntidade2 > 0 AndAlso o.IDEntidade2 Is Nothing Then
                Throw New Exception(Traducao.EstruturaDocumentos.Entidade2NaoPreenchida)
            End If

            Dim idDocumento As Integer = o.ID
            If o.ID > 0 Then
                Dim temDocumentos As Boolean = BDContexto.tbDocumentosVendasLinhas.Any(Function(d) d.IDDocumentoOrigem = idDocumento And d.tbDocumentosVendas.CodigoTipoEstado = TiposEstados.Efetivo)

                If temDocumentos Then
                    Throw New Exception(Traducao.EstruturaDocumentos.DocumentoJaTemDocumentos)
                End If
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

            ' Validação do preço de venda abaixo do custo medio de custo.
            Dim VACM As Boolean? = ClsF3MSessao.ListaPropriedadeStorage(Of Boolean?)("VendaAbaixoCustoMedio")
            If Not IsNothing(VACM) AndAlso Not VACM Then
                If lstArtAbaixoPrecoCusto.Count Then
                    Throw New Exception(Traducao.EstruturaDocumentos.VendaAbaixoCustoMedio.Replace("{0}", String.Join(",", lstArtAbaixoPrecoCusto.Select(Function(s) s.CodigoArtigo).Distinct().ToList())))
                End If
            End If
        End Sub

        Public Shared Sub VerificaData(inCtx As BD.Dinamica.Aplicacao, inDataDocumento As Date,
                       inIDTipoDocSeries As Long?, inIDEstado As Long?)
            Try
                Dim listDocSeries As List(Of tbTiposDocumentoSeries) = inCtx.tbTiposDocumentoSeries.AsNoTracking.Where(Function(f) f.ID = inIDTipoDocSeries).ToList
                Dim dataInicial As Nullable(Of Date) = listDocSeries.Select(Function(e) e.DataInicial).FirstOrDefault
                Dim dataFinal As Nullable(Of Date) = listDocSeries.Select(Function(e) e.DataFinal).FirstOrDefault
                Dim dataUltimoDoc As Nullable(Of Date) = listDocSeries.Select(Function(e) e.DataUltimoDoc).FirstOrDefault

                If (inDataDocumento < dataInicial) Then
                    Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.Aviso_DataInicial)
                ElseIf (inDataDocumento > dataFinal) Then
                    Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.Aviso_DataFinal)
                ElseIf (inDataDocumento < dataUltimoDoc) Then
                    Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.Aviso_DataUltDoc)
                End If
            Catch
                Throw
            End Try
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef inModelo As Oticas.DocumentosVendasServicos, inFiltro As ClsF3MFiltro)

            Dim objID = inModelo.ID
            If BDContexto.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoOrigem = objID).Count > 0 Then
                'TODO TRADUCAO
                Throw New Exception("Não pode remover este serviço porque existem documentos associados.")
            End If

            'DOC SUBSTUICAO
            Dim idsLinhas As Long() = BDContexto.tbDocumentosVendasLinhas.Where(Function(w) w.IDDocumentoVenda = objID).Select(Function(s) s.ID).ToArray()
            Dim hasDocumentoSubstituicao As Boolean = BDContexto.tbDocumentosVendasLinhas.Any(Function(w) idsLinhas.Contains(w.IDLinhaDocumentoOrigemInicial))

            If hasDocumentoSubstituicao Then Throw New Exception("Não pode remover este serviço porque existem documentos associados.")

            AcaoObjTransacao(inModelo, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef inModelo As Oticas.DocumentosVendasServicos, e As tbDocumentosVendas, inAcao As AcoesFormulario)
            Try
                Dim NomeBDGeral As String = ChavesWebConfig.BD.NomeBDGeral
                inCtx.Database.ExecuteSqlCommand("UPDATE [" & NomeBDGeral & "].[dbo].tbUtilizadores set IDSistemaTiposServicos = NULL where ID =" & ClsF3MSessao.RetornaUtilizadorID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    Dim intOrdem As Short = 1

                    'SERVICOS
                    'Dim RemoveuCombinacaoDefeito = False
                    'If Not inModelo.Servicos.Any(Function(a) a.CombinacaoDefeito) Then
                    '    RemoveuCombinacaoDefeito = True
                    '    inCtx.Database.ExecuteSqlCommand("UPDATE [" & NomeBDGeral & "].[dbo].tbUtilizadores set IDSistemaTiposServicos = NULL")
                    'End If

                    For Each Servico In inModelo.Servicos
                        If Servico.CombinacaoDefeito And Servico.AcaoCRUD <> AcoesFormulario.Remover Then 'And Not RemoveuCombinacaoDefeito Then
                            inCtx.Database.ExecuteSqlCommand("UPDATE [" & NomeBDGeral & "].[dbo].tbUtilizadores set IDSistemaTiposServicos = " & Servico.IDTipoServico & " where ID =" & ClsF3MSessao.RetornaUtilizadorID)
                        End If

                        If Servico.AcaoCRUD.Equals(AcoesFormulario.Remover) Then
                            GravaLinhasEntidades(Of tbDocumentosVendasLinhasGraduacoes)(inCtx, e.tbServicos.Where(Function(f) f.ID = Servico.ID).SelectMany(Function(s) s.tbDocumentosVendasLinhasGraduacoes).ToList, AcoesFormulario.Remover, Nothing)
                            GravaLinhasEntidades(Of tbDocumentosVendasLinhas)(inCtx, e.tbServicos.Where(Function(f) f.ID = Servico.ID).SelectMany(Function(s) s.tbDocumentosVendasLinhas).ToList, AcoesFormulario.Remover, Nothing)
                            GravaLinhasEntidades(Of tbServicosFases)(inCtx, e.tbServicos.Where(Function(f) f.ID = Servico.ID).FirstOrDefault.tbServicosFases.ToList, AcoesFormulario.Remover, Nothing)
                            GravaLinhasEntidades(Of tbServicos)(inCtx, e.tbServicos.Where(Function(f) f.ID = Servico.ID).ToList, AcoesFormulario.Remover, Nothing)

                        Else
                            Dim NewServico As New tbServicos
                            Dim IDTipoServico As Long = Servico.IDTipoServico

                            If Servico.AcaoCRUD = AcoesFormulario.Adicionar Then
                                NewServico = Activator.CreateInstance(GetType(tbServicos))
                                Servico.ID = 0

                            Else
                                Dim colEnts As IQueryable(Of tbServicos) = e.tbServicos.Where(Function(f) f.ID = Servico.ID).AsQueryable()
                                NewServico = colEnts.FirstOrDefault()
                            End If

                            Mapear(Servico, NewServico)

                            With NewServico
                                .IDDocumentoVenda = e.ID
                                .DataCriacao = DateAndTime.Now()
                                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                            End With

                            For Each DVL In Servico.DocumentosVendasLinhas
                                If PodeGravarLinha(IDTipoServico, DVL) AndAlso DVL.IDMarca IsNot Nothing Then
                                    With DVL
                                        .IDArtigo = ValidaExisteArtigo(inCtx, Servico, DVL, True)
                                        .IDDocumentoVenda = e.ID
                                        If DVL.AcaoCRUD = AcoesFormulario.Adicionar Then DVL.ID = 0

                                        .Ordem = intOrdem
                                        intOrdem += 1
                                    End With

                                    AtribuiValoresDoArtigo(inCtx, DVL)

                                Else
                                    DVL.AcaoCRUD = AcoesFormulario.Remover
                                End If
                            Next

                            Dim collectionOftbDVL As ICollection(Of tbDocumentosVendasLinhas) = NewServico.tbDocumentosVendasLinhas
                            GravaLinhasEspecifico(Of tbDocumentosVendasLinhas, DocumentosVendasLinhas)(Servico.DocumentosVendasLinhas, collectionOftbDVL, inCtx)

                            'VALIDA LINHAS DAS GRADUACOES
                            ValidaGraduacoes(Servico)
                            'END VALIDA LINHAS DAS GRADUACOES

                            For Each DVLG In Servico.DocumentosVendasLinhasGraduacoes
                                Dim DVLGNew As New tbDocumentosVendasLinhasGraduacoes

                                Mapear(DVLG, DVLGNew)

                                If DVLGNew.ID <> 0 Then
                                    With DVLGNew
                                        .DataAlteracao = DateAndTime.Now()
                                        .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
                                    End With

                                    If NewServico.tbDocumentosVendasLinhasGraduacoes.Where(Function(f) f.ID = DVLGNew.ID).Count Then
                                        Mapear(DVLGNew, NewServico.tbDocumentosVendasLinhasGraduacoes.FirstOrDefault(Function(f) f.ID = DVLGNew.ID))
                                    End If

                                Else
                                    With DVLGNew
                                        .DataCriacao = DateAndTime.Now()
                                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                    End With
                                End If

                                NewServico.tbDocumentosVendasLinhasGraduacoes.Add(DVLGNew) 'ADD GRADUACOES
                            Next

                            'FASES
                            'For Each DVSF In Servico.Fases
                            '    If (DVSF.Observacoes IsNot Nothing AndAlso DVSF.Observacoes.Length) Or DVSF.AcaoCRUD = AcoesFormulario.Remover Then
                            '        Dim DVSFNew As New tbServicosFases
                            '        Mapear(DVSF, DVSFNew)
                            '
                            '        With DVSFNew
                            '            .DataCriacao = DateAndTime.Now()
                            '            .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                            '            If DVSF.AcaoCRUD = AcoesFormulario.Adicionar Then .ID = CLng(0)
                            '        End With
                            '
                            '        NewServico.tbServicosFases.Add(DVSFNew) 'ADD FASES
                            '    End If
                            'Next
                            e.tbServicos.Add(NewServico)

                        End If
                    Next
                    'END SERVICOS

                    'DIVERSOS
                    For Each Diverso In inModelo.Diversos
                        If Not Diverso.IDArtigo Is Nothing Then
                            Dim tbD As New tbDocumentosVendasLinhas

                            Mapear(Diverso, tbD)

                            With tbD
                                .DataCriacao = DateAndTime.Now()
                                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                .IDDocumentoVenda = inModelo.ID

                                If Diverso.AcaoCRUD = AcoesFormulario.Adicionar Then
                                    .ID = Nothing
                                    .IDServico = Nothing
                                End If

                                .Ordem = intOrdem
                                intOrdem += 1
                            End With

                            GravaEntidadeLinha(Of tbDocumentosVendasLinhas)(inCtx, tbD, Diverso.AcaoCRUD, Nothing)
                            'inCtx.SaveChanges()
                        End If
                    Next
                    'END DIVERSOS

                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    inCtx.sp_ControloDocumentos(e.ID, e.IDTipoDocumento, e.IDTiposDocumentoSeries, AcoesFormulario.Remover, "tbDocumentosVendas", F3M.Modelos.Autenticacao.ClsF3MSessao.RetornaUtilizadorNome)

                    GravaLinhasEntidades(Of tbDocumentosVendasLinhasGraduacoes)(inCtx, e.tbServicos.SelectMany(Function(s) s.tbDocumentosVendasLinhasGraduacoes).ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbDocumentosVendasLinhas)(inCtx, e.tbServicos.SelectMany(Function(s) s.tbDocumentosVendasLinhas).ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbDocumentosVendasLinhas)(inCtx, e.tbDocumentosVendasLinhas.Where(Function(f) f.IDDocumentoVenda = e.ID).ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbServicosFases)(inCtx, e.tbServicos.SelectMany(Function(s) s.tbServicosFases.ToList).ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbServicos)(inCtx, e.tbServicos.ToList, AcoesFormulario.Remover, Nothing)
                    'inCtx.SaveChanges()
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub

#End Region

#Region "Funções Auxiliares"
        Private Function RetornaDescricaoServico(inCodigoTipoServico As String) As String
            Try
                Dim res As String = String.Empty

                Select Case inCodigoTipoServico
                    Case "U"
                        res = Traducao.EstruturaDocumentos.Unifocal & ", " & Traducao.EstruturaDocumentos.LongePerto
                    Case "L"
                        res = Traducao.EstruturaDocumentos.Unifocal & ", " & Traducao.EstruturaDocumentos.Longe
                    Case "P"
                        res = Traducao.EstruturaDocumentos.Unifocal & ", " & Traducao.EstruturaDocumentos.Perto
                    Case "B"
                        res = Traducao.EstruturaDocumentos.Bifocal & ", " & Traducao.EstruturaDocumentos.Ambos
                    Case "G"
                        res = Traducao.EstruturaDocumentos.Progressiva & ", " & Traducao.EstruturaDocumentos.Ambos
                    Case "C"
                        res = Traducao.EstruturaDocumentos.LentesContato
                    Case "BOE"
                        res = Traducao.EstruturaDocumentos.BifocalOlhoEsquerdo
                    Case "BOD"
                        res = Traducao.EstruturaDocumentos.BifocalOlhoDireito
                    Case "POE"
                        res = Traducao.EstruturaDocumentos.ProgressivaOlhoEsquerdo
                    Case "POD"
                        res = Traducao.EstruturaDocumentos.ProgressivaOlhoDireito
                End Select

                Return res
            Catch
                Throw
            End Try
        End Function

        Private Function ValidaExisteArtigo(ByRef inCtx As BD.Dinamica.Aplicacao, inServico As Servicos, inSubServico As DocumentosVendasLinhas, DeveCriar As Boolean) As Long
            Try
                Dim res As String = "0"

                Dim strTipo As String = String.Empty

                Dim dblPotCil As Double = 0
                Dim dblPotEsf As Double = 0
                Dim dblPotPrism As Double = 0
                Dim dblAdd As Double = 0
                Dim strRaio As String = String.Empty
                Dim intEixo As Integer = 0
                Dim strSuplementos As String = "0"

                ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 1 " & Now.ToString(“HH:mm:ss.fff”))

                If inSubServico.IDMarca IsNot Nothing Then
                    Dim TA = inCtx.tbMarcas.Where(Function(f) f.ID = inSubServico.IDMarca).FirstOrDefault

                    Using rm As New RepositorioMarcas

                        Select Case inServico.IDTipoServico
                            Case TipoServico.Contacto
                                strTipo = "LC"
                            Case Else
                                Select Case inSubServico.IDTipoOlho
                                    Case TipoOlho.Direito, TipoOlho.Esquerdo
                                        strTipo = "LO"
                                End Select
                        End Select

                        ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 2 " & Now.ToString(“HH:mm:ss.fff”))

                        Select Case strTipo
                            Case "LO"
                                Dim DVLG = inServico.DocumentosVendasLinhasGraduacoes.Where(Function(f) f.IDTipoGraduacao = inSubServico.IDTipoGraduacao And f.IDTipoOlho = inSubServico.IDTipoOlho).FirstOrDefault
                                If DVLG IsNot Nothing Then
                                    dblPotCil = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.PotenciaCilindrica)
                                    dblPotEsf = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.PotenciaEsferica)
                                    dblPotPrism = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.PotenciaPrismatica)
                                    If inSubServico.IDTipoLente = 1 Then ' Unifocal
                                        dblAdd = 0
                                    Else
                                        dblAdd = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.Adicao)
                                    End If

                                    If (inSubServico.IDsSuplementos) IsNot Nothing Then
                                        strSuplementos = String.Join("-", inSubServico.IDsSuplementos)
                                    End If

                                    res = rm.LerIDArtigo(strTipo, inSubServico.IDModelo, , , , , inSubServico.IDTratamentoLente, inSubServico.IDCorLente, strSuplementos, inSubServico.Diametro, dblPotEsf, dblPotCil, dblPotPrism, dblAdd)
                                End If
                            Case "LC"
                                Dim DVLG = inServico.DocumentosVendasLinhasGraduacoes.Where(Function(f) f.IDTipoOlho = inSubServico.IDTipoOlho And f.IDTipoGraduacao = TipoGraduacao.LentesContacto).FirstOrDefault()
                                If DVLG IsNot Nothing Then
                                    dblPotCil = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.PotenciaCilindrica)
                                    dblPotEsf = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.PotenciaEsferica)
                                    dblAdd = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.Adicao)
                                    intEixo = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLG.Eixo)
                                    strRaio = DVLG.RaioCurvatura

                                    Dim Descricao As String = String.Empty
                                    Dim intPosR As Integer = 0
                                    intPosR = InStr(inSubServico.Descricao, "Raio:")
                                    Dim intPos As Integer = 0
                                    intPos = InStr(inSubServico.Descricao, "Diam:")
                                    If intPos = 0 Then intPos = InStr(inSubServico.Descricao, "Diâm:")
                                    If intPos > 0 Then
                                        If intPosR <> 0 AndAlso intPosR < intPos Then
                                            intPos = intPosR
                                        End If
                                        Descricao = inSubServico.Descricao.Substring(0, intPos - 1)
                                        If inServico.IDTipoServico = TipoServico.Contacto Then
                                            Descricao += " Diam:" & inSubServico.Diametro
                                            Descricao += " Raio:" & inSubServico.RaioCurvatura
                                            If inSubServico.PotenciaEsferica <> 0 Then Descricao += " Esf:" & inSubServico.PotenciaEsferica
                                            If inSubServico.PotenciaCilindrica <> 0 Then Descricao += " Cil:" & inSubServico.PotenciaCilindrica
                                            If inSubServico.Adicao <> 0 Then Descricao += " Add:" & inSubServico.Adicao
                                            If inSubServico.Eixo <> 0 Then Descricao += " AX:" & inSubServico.Eixo
                                        End If
                                        inSubServico.Descricao = Descricao
                                    End If

                                    res = rm.LerIDArtigo(strTipo, inSubServico.IDModelo, , , , , , , , inSubServico.Diametro, dblPotEsf, dblPotCil, dblPotPrism, dblAdd, intEixo, strRaio)
                                End If
                            Case Else
                                res = inSubServico.IDArtigo
                        End Select

                        ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 3 " & Now.ToString(“HH:mm:ss.fff”))

                        If ClsUtilitarios.RetornaZeroSeVazio(res) = 0 And DeveCriar Then
                            Dim lngIdTipoArtigo = BDContexto.tbSistemaClassificacoesTiposArtigos.Where(Function(f) f.Codigo = strTipo).FirstOrDefault.ID
                            Dim objLO As New Oticas.ArtigosLentesOftalmicas
                            Dim objLC As New Oticas.ArtigosLentesContato


                            Dim lstLO As New List(Of ArtigosLentesOftalmicas)
                            Dim lstLC As New List(Of ArtigosLentesContato)


                            Select Case lngIdTipoArtigo
                                Case TipoArtigo.LentesOftalmicas
                                    With objLO
                                        .IDModelo = inSubServico.IDModelo

                                        If inSubServico.IDTratamentoLente = 0 Then
                                            .IDTratamentoLente = Nothing
                                        Else
                                            .IDTratamentoLente = inSubServico.IDTratamentoLente
                                        End If

                                        If inSubServico.IDCorLente = 0 Then
                                            .IDCorLente = Nothing
                                        Else
                                            .IDCorLente = inSubServico.IDCorLente
                                        End If

                                        .Diametro = inSubServico.Diametro
                                        .PotenciaCilindrica = dblPotCil
                                        .PotenciaEsferica = dblPotEsf
                                        .PotenciaPrismatica = dblPotPrism
                                        .Adicao = dblAdd
                                        .CodigosSuplementos = 0
                                    End With

                                    lstLO.Add(objLO)

                                Case TipoArtigo.LentesContacto
                                    With objLC
                                        .IDModelo = inSubServico.IDModelo
                                        .Diametro = inSubServico.Diametro
                                        .PotenciaCilindrica = dblPotCil
                                        .PotenciaEsferica = dblPotEsf
                                        .Adicao = dblAdd
                                        .Raio = strRaio
                                        .Raio2 = inSubServico.DetalheRaio
                                        .Eixo = intEixo
                                    End With

                                    lstLC.Add(objLC)
                            End Select

                            ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 4 " & Now.ToString(“HH:mm:ss.fff”))

                            Using ra As New RepositorioArtigos
                                Dim objArtigos As New Oticas.Artigos
                                With objArtigos
                                    .Ativo = True
                                    .Codigo = rm.AtribuirCodigo(1, strTipo)
                                    .Descricao = Left(inSubServico.Descricao, 200)
                                    .IDTipoArtigo = lngIdTipoArtigo
                                    .IDGrupoArtigo = 1
                                    .IDModelo = inSubServico.IDModelo
                                    .IDMarca = inSubServico.IDMarca
                                    .IDUnidade = 1
                                    .IDUnidadeVenda = 1
                                    .IDUnidadeCompra = 1
                                    .IDTipoPreco = 1
                                    .DescricaoVariavel = 1
                                    .DedutivelPercentagem = 100
                                    .IncidenciaPercentagem = 100
                                    .GereLotes = False
                                    .GereStock = True
                                    .DescricaoVariavel = True
                                    .Inventariado = True
                                    .Sistema = False
                                    .IDTaxa = AtribuirIDTaxa(strTipo)
                                    .DataCriacao = DateTime.Now
                                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                    Select Case lngIdTipoArtigo
                                        Case TipoArtigo.LentesOftalmicas
                                            .ArtigosLentesOftalmicas = lstLO

                                            'SUPLEMENTOS
                                            .ArtigosLentesOftalmicasSuplementos = New List(Of ArtigosLentesOftalmicasSuplementos)

                                            If inSubServico.IDsSuplementos IsNot Nothing Then
                                                For Each lin In inSubServico.IDsSuplementos
                                                    Dim _SuplementosLentes As SuplementosLentes = BDContexto.tbSuplementosLentes.Where(Function(f) f.ID = lin).Select(Function(y) New SuplementosLentes With {
                                                                                                                                                         .ID = y.ID, .Descricao = y.Descricao, .Codigo = y.Codigo, .Cor = y.Cor}).FirstOrDefault()

                                                    Dim ALOS As New ArtigosLentesOftalmicasSuplementos
                                                    With ALOS
                                                        .DataCriacao = DateTime.Now()
                                                        .DescricaoSuplementoLente = _SuplementosLentes.Descricao
                                                        .IDSuplementoLente = _SuplementosLentes.ID
                                                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorID
                                                        .IDLoja = ClsF3MSessao.RetornaLojaID
                                                        .Checked = True
                                                    End With

                                                    .ArtigosLentesOftalmicasSuplementos.Add(ALOS)
                                                Next
                                            End If
                                            'END SUPLEMENTOS

                                        Case TipoArtigo.LentesContacto
                                            .ArtigosLentesContato = lstLC
                                    End Select

                                    .ArtigosPrecos = New List(Of ArtigosPrecos)
                                    .ArtigosPrecos.Add(New ArtigosPrecos With {.IDArtigo = objArtigos.ID,
                                                                               .AcaoCRUD = AcoesFormulario.Adicionar,
                                                                               .IDCodigoPreco = (From x In BDContexto.tbSistemaCodigosPrecos
                                                                                                 Where x.Codigo = TiposVisualizacaoArtigos.PV1
                                                                                                 Select x.ID).FirstOrDefault(),
                                                                               .ValorComIva = inSubServico.PrecoUnitario,
                                                                               .ValorSemIva = inSubServico.PrecoUnitario * 100 / (100 + inSubServico.TaxaIva)})
                                End With

                                ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 6 " & Now.ToString(“HH:mm:ss.fff”))

                                ra.AdicionaObj(objArtigos, New ClsF3MFiltro)
                                res = objArtigos.ID
                            End Using
                        End If
                    End Using
                Else
                    res = 0 'temporário
                End If
                ClsUtilitarios.CodeTrace("REC.log", "Func ValidaExisteArtigo : 7 " & Now.ToString(“HH:mm:ss.fff”))

                Return CLng(res)
            Catch
                Throw
            End Try
        End Function

        Public Sub PreencheSubServicos(item As DocumentosVendasServicos)
            Try
                Dim intCasasDecimaisTotais As Integer = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                Dim NomeBDGeral As String = ChavesWebConfig.BD.NomeBDGeral

                Dim IDSistemaTiposServicos As Nullable(Of Long) = BDContexto.Database.SqlQuery(Of Nullable(Of Long))("SELECT IDSistemaTiposServicos FROM [" & NomeBDGeral & "].[dbo].[tbUtilizadores] Where ID =" & ClsF3MSessao.RetornaUtilizadorID).FirstOrDefault

                'For Each item In query
                Using ctx As New BD.Dinamica.Aplicacao
                    item.RegistoBloqueado = RepositorioDocumentos.RegistoBloqueadoVendas(ctx, item.ID, item.IDTipoDocumento)

                    Dim lstServicos As List(Of tbServicos) = ctx.tbServicos.Where(Function(f) f.IDDocumentoVenda = item.ID).ToList

                    If lstServicos.Any() Then

                        For Each Sv In lstServicos
                            Dim lstArtigosIds As Long?() = Sv.tbDocumentosVendasLinhas.Select(Function(artigo) artigo.IDArtigo).ToArray()
                            Dim lstTbArtigos As New List(Of tbArtigos)
                            If Not lstArtigosIds Is Nothing AndAlso lstArtigosIds.Count Then lstTbArtigos = ctx.tbArtigos.Where(Function(w) lstArtigosIds.Any(Function(id) id = w.ID)).ToList()

                            Dim Servico As New Servicos With {
                                .ID = Sv.ID,
                                .AcaoCRUD = AcoesFormulario.Alterar,
                                .DescricaoServico = RetornaDescricaoServico(Sv.tbSistemaTiposServicos.Codigo),
                                .IDTipoServico = Sv.tbSistemaTiposServicos.ID,
                                .IDTipoServicoAux = Sv.tbSistemaTiposServicos.ID,
                                .IDMedicoTecnico = Sv.IDMedicoTecnico,
                                .DescricaoMedicoTecnico = If(Sv.tbMedicosTecnicos IsNot Nothing, Sv.tbMedicosTecnicos.Nome, String.Empty),
                                .DataReceita = Sv.DataReceita,
                                .VerPrismas = Sv.VerPrismas,
                                .VisaoIntermedia = Sv.VisaoIntermedia,
                                .DataEntregaLonge = Sv.DataEntregaLonge,
                                .DataEntregaPerto = Sv.DataEntregaPerto,
                                .BoxLonge = Sv.BoxLonge,
                                .BoxPerto = Sv.BoxPerto,
                                .CombinacaoDefeito = If(IDSistemaTiposServicos IsNot Nothing AndAlso IDSistemaTiposServicos = .IDTipoServico, True, False)
                            }
                            'DOC SUBSTUICAO
                            Dim idsLinhas As Long() = Sv.tbDocumentosVendasLinhas.Select(Function(s) s.ID).ToArray()
                            Servico.IDDocumentosVendasServicosSubstituicaoArtigos = ctx.tbDocumentosVendasLinhas.
                                Where(Function(w) idsLinhas.Contains(w.IDLinhaDocumentoOrigemInicial))?.
                                FirstOrDefault()?.
                                IDDocumentoVenda
                            'DVL
                            AddSubServicosDocumentosVendasLinhas(Servico, Sv.ID)
                            For Each DVL In Sv.tbDocumentosVendasLinhas.ToList()
                                Dim DVLNew As DocumentosVendasLinhas = Servico.DocumentosVendasLinhas.Find(Function(f) f.IDTipoOlho = DVL.IDTipoOlho And f.IDTipoGraduacao = DVL.IDTipoGraduacao)
                                Mapear(DVL, DVLNew)

                                With DVLNew
                                    .AcaoCRUD = AcoesFormulario.Alterar
                                    .CodigoArtigo = (From x In lstTbArtigos Where x.ID = DVLNew.IDArtigo Select x.Codigo).FirstOrDefault()
                                    .IDMarca = DVL.tbArtigos.IDMarca
                                    .DescricaoMarca = DVL.tbArtigos.tbMarcas.Descricao
                                    .TotalSemDescontoLinha = Math.Round(CDbl(DVLNew.Quantidade * DVLNew.PrecoUnitario), intCasasDecimaisTotais)
                                End With

                                If Not DVLNew.IDCampanha Is Nothing Then DVLNew.Campanha = DVL.tbCampanhas.Descricao
                                If Not DVLNew.IDTaxaIva Is Nothing Then DVLNew.CodigoIva = DVL.tbIVA.Codigo

                                Dim LinhaLenOft = DVL.tbArtigos.tbLentesOftalmicas.FirstOrDefault()
                                If LinhaLenOft IsNot Nothing Then
                                    With DVLNew
                                        .IDTratamentoLente = LinhaLenOft.IDTratamentoLente
                                        .IDModelo = LinhaLenOft.IDModelo
                                        .IndiceRefracao = LinhaLenOft.tbModelos?.IndiceRefracao
                                        .Fotocromatica = LinhaLenOft.tbModelos?.Fotocromatica
                                        .IDCorLente = LinhaLenOft.IDCorLente
                                        .IDTipoLente = LinhaLenOft.tbModelos.IDTipoLente
                                        .IDMateria = LinhaLenOft.tbModelos.IDMateriaLente
                                        .IDsSuplementos = LinhaLenOft.tbLentesOftalmicasSuplementos.Select(Function(f) f.IDSuplementoLente).ToList()
                                        .PotenciaCilindrica = LinhaLenOft.PotenciaCilindrica
                                        .PotenciaPrismatica = LinhaLenOft.PotenciaPrismatica
                                        .PotenciaEsferica = LinhaLenOft.PotenciaEsferica
                                        .Adicao = LinhaLenOft.Adicao
                                    End With

                                Else
                                    Dim LinhaLenCont = DVL.tbArtigos.tbLentesContato.FirstOrDefault()
                                    If LinhaLenCont IsNot Nothing Then
                                        With DVLNew
                                            .IDModelo = LinhaLenCont.IDModelo
                                            .IndiceRefracao = LinhaLenCont.tbModelos?.IndiceRefracao
                                            .Fotocromatica = LinhaLenCont.tbModelos?.Fotocromatica
                                            .IDTipoLente = LinhaLenCont.tbModelos.IDTipoLente
                                            .RaioCurvatura = LinhaLenCont.Raio
                                            .DetalheRaio = LinhaLenCont.Raio2
                                            .PotenciaEsferica = LinhaLenCont.PotenciaEsferica
                                            .PotenciaCilindrica = LinhaLenCont.PotenciaCilindrica
                                            .Eixo = LinhaLenCont.Eixo
                                            .Adicao = LinhaLenCont.Adicao
                                        End With
                                    End If
                                End If
                            Next

                            'DVLG
                            AddSubServicosDocumentosVendasLinhasGraduacoes(Servico)
                            For Each dvlg In Sv.tbDocumentosVendasLinhasGraduacoes.ToList()
                                Dim DVLGNew As DocumentosVendasLinhasGraduacoes = Servico.DocumentosVendasLinhasGraduacoes.Find(Function(f) f.IDTipoOlho = dvlg.IDTipoOlho And f.IDTipoGraduacao = dvlg.IDTipoGraduacao)
                                Mapear(dvlg, DVLGNew)
                                DVLGNew.PotenciaCilindrica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaCilindrica)
                                DVLGNew.PotenciaEsferica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaEsferica)
                                DVLGNew.PotenciaPrismatica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaPrismatica)
                                DVLGNew.AcaoCRUD = AcoesFormulario.Alterar
                            Next

                            Dim LinhasLonge = Sv.tbDocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Longe And f.IDDocumentoVenda = item.ID)
                            Dim LinhasPerto = Sv.tbDocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Perto And f.IDDocumentoVenda = item.ID)
                            Dim LinhasLentesContacto = Sv.tbDocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.LentesContacto And f.IDDocumentoVenda = item.ID)


                            Dim ts As Double

                            Servico.TotalComparticipadoLonge = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasLonge.Sum(Function(s) s.ValorEntidade1 + s.ValorEntidade2)), intCasasDecimaisTotais)
                            Servico.TotalComparticipadoPerto = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasPerto.Sum(Function(s) s.ValorEntidade1 + s.ValorEntidade2)), intCasasDecimaisTotais)
                            Servico.TotalComparticipadoLentesContacto = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasLentesContacto.Sum(Function(s) s.ValorEntidade1 + s.ValorEntidade2)), intCasasDecimaisTotais)

                            Servico.TotalLonge = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasLonge.Sum(Function(s) s.TotalFinal)), intCasasDecimaisTotais)
                            Servico.TotalPerto = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasPerto.Sum(Function(s) s.TotalFinal)), intCasasDecimaisTotais)
                            Servico.TotalLentesContacto = Math.Round(ClsUtilitarios.RetornaZeroSeVazioDuplo(LinhasLentesContacto.Sum(Function(s) s.TotalFinal)), intCasasDecimaisTotais)

                            ts = IIf(Servico.IDTipoServico <> TipoServico.Contacto, Servico.TotalLonge + Servico.TotalPerto, Servico.TotalLentesContacto)

                            Servico.TotalServico = Math.Round(ts, intCasasDecimaisTotais)

                            'AddSubServicosFases(Servico)
                            item.Servicos.Add(Servico)
                        Next
                    Else
                        item.Servicos.Add(AddSubServico)
                    End If

                    Dim TMS As Double = item.Servicos.Sum(Function(s) s.TotalServico)
                    Dim TMR As Double = item.Servicos.Sum(Function(s) s.DocumentosVendasLinhas.Sum(Function(s1) s1.TotalFinal))

                    item.TotalMoedaServicos = Math.Round(TMS, intCasasDecimaisTotais)
                    item.TotalMoedaReferencia = Math.Round(TMR, intCasasDecimaisTotais)

                    item.TotalMoedaDocumento = lstServicos?.FirstOrDefault()?.tbDocumentosVendas?.TotalMoedaDocumento


                    item.ServicoFases.AddRange(RetornaFasesServico(ctx, item.Servicos))
                End Using

                item.Diversos.AddRange(BDContexto.tbDocumentosVendasLinhas _
                    .Where(Function(f) f.IDServico Is Nothing And f.IDDocumentoVenda = item.ID) _
                    .Select(Function(s) New DocumentosVendasLinhas With {
                        .ID = s.ID, .IDCampanha = s.IDCampanha, .IDArtigo = s.IDArtigo, .Descricao = s.Descricao,
                        .IDTipoOlho = s.IDTipoOlho, .Quantidade = s.Quantidade, .ValorDescontoLinha = s.ValorDescontoLinha,
                        .PrecoUnitario = s.PrecoUnitario, .PrecoUnitarioEfetivo = s.PrecoUnitarioEfetivo, .PrecoUnitarioEfetivoSemIva = s.PrecoUnitarioEfetivoSemIva, .ValorDescontoEfetivoSemIva = s.ValorDescontoEfetivoSemIva, .Desconto1 = s.Desconto1,
                        .TotalComDescontoLinha = s.TotalComDescontoLinha, .ValorDescontoCabecalho = s.ValorDescontoCabecalho, .TotalComDescontoCabecalho = s.TotalComDescontoCabecalho,
                        .TotalFinal = s.TotalFinal, .ValorUnitarioEntidade1 = s.ValorUnitarioEntidade1, .ValorUnitarioEntidade2 = s.ValorUnitarioEntidade2,
                        .ValorEntidade1 = s.ValorEntidade1, .ValorEntidade2 = s.ValorEntidade2,
                        .IDTaxaIva = s.IDTaxaIva, .TaxaIva = s.TaxaIva, .CodigoTaxaIva = s.CodigoTaxaIva, .ValorIVA = s.ValorIVA, .ValorIncidencia = s.ValorIncidencia,
                        .CodigoIva = s.tbIVA.Codigo,
                        .IDUnidade = s.IDUnidade,
                        .CodigoUnidade = s.CodigoUnidade,
                        .DescricaoVariavel = s.tbArtigos.DescricaoVariavel, .MotivoIsencaoIva = s.tbIVA.Mencao, .CodigoMotivoIsencaoIva = s.tbIVA.tbSistemaCodigosIVA.Codigo,
                        .SiglaPais = s.SiglaPais, .IDRegimeIva = s.IDRegimeIva, .RegimeIva = s.RegimeIva,
                        .CodigoArtigo = ((From x In BDContexto.tbArtigos Where x.ID = s.IDArtigo Select x.Codigo).FirstOrDefault()),
                        .PrecoTotal = s.PrecoTotal,
                        .ValorImposto = s.ValorImposto,
                        .IDEspacoFiscal = s.IDEspacoFiscal,
                        .EspacoFiscal = s.EspacoFiscal,
                        .TotalSemDescontoLinha = Math.Round(CDbl((s.PrecoUnitario * s.Quantidade)), intCasasDecimaisTotais),
                        .Campanha = s.tbCampanhas.Descricao,
                        .AcaoCRUD = CShort(AcoesFormulario.Alterar),
                        .Ordem = s.Ordem}).OrderBy(Function(o) o.Ordem).ToList())



            Catch
                Throw
            End Try
        End Sub

        ''' <summary>
        ''' Funcao que adiciona um sub servico
        ''' </summary>
        ''' <param name="IDTipoServico"></param>
        ''' <returns></returns>
        Public Function AddSubServico(Optional ByVal IDTipoServico As Long = 0) As Servicos
            Dim DVSL As New Servicos With {.ID = Nothing}
            Dim NomeBDGeral As String = ChavesWebConfig.BD.NomeBDGeral
            Dim IDSistemaTiposServicos As Nullable(Of Long) = BDContexto.Database.SqlQuery(Of Nullable(Of Long))("SELECT IDSistemaTiposServicos FROM [" & NomeBDGeral & "].[dbo].[tbUtilizadores] Where ID =" & ClsF3MSessao.RetornaUtilizadorID).FirstOrDefault

            If IDTipoServico <> 0 Then
                With DVSL
                    .CombinacaoDefeito = IDSistemaTiposServicos = IDTipoServico
                    .IDTipoServico = IDTipoServico
                    .IDTipoServicoAux = IDTipoServico
                End With

            ElseIf IDSistemaTiposServicos IsNot Nothing Then
                With DVSL
                    .CombinacaoDefeito = If(IDTipoServico = 0, True, False)
                    .IDTipoServico = If(IDTipoServico = 0, IDSistemaTiposServicos, IDTipoServico)
                    .IDTipoServicoAux = If(IDTipoServico = 0, IDSistemaTiposServicos, IDTipoServico)
                End With

            Else
                With DVSL
                    .CombinacaoDefeito = False
                    Dim o = BDContexto.tbSistemaTiposServicos.Where(Function(f) f.Codigo = "U").FirstOrDefault
                    .IDTipoServico = o.ID
                    .IDTipoServicoAux = o.ID
                End With
            End If

            AddSubServicosDocumentosVendasLinhas(DVSL, 0)
            AddSubServicosDocumentosVendasLinhasGraduacoes(DVSL)

            Return DVSL
        End Function

        Public Function AddSubServicoByModel(modelo As Servicos) As Servicos
            Dim DVSL As New Servicos
            DVSL = modelo

            DVSL.ID = Nothing
            DVSL.AcaoCRUD = AcoesFormulario.Adicionar

            For Each lin In DVSL.DocumentosVendasLinhasGraduacoes
                lin.ID = Nothing
                lin.AcaoCRUD = AcoesFormulario.Adicionar
            Next

            Dim i As Integer = 1
            For Each lin In DVSL.DocumentosVendasLinhas
                lin.ID = i
                lin.AcaoCRUD = AcoesFormulario.Adicionar
                i += i
            Next

            'AddSubServicosFases(DVSL)

            Return DVSL
        End Function

        Public Function ValidaExisteArtigo(inModelo As DocumentosVendasServicos, inServico As Servicos, inObjFiltro As ClsF3MFiltro) As Servicos
            Try
                Dim array_OD_OE() As Long = (From x In BDContexto.tbSistemaTiposOlhos
                                             Where x.Codigo = "OD" Or x.Codigo = "OE"
                                             Select x.ID).ToArray()

                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 1 " & Now.ToString(“HH:mm:ss.fff”))

                Dim blnMudou As Boolean = False

                For Each DVSL In inServico.DocumentosVendasLinhas.Where(Function(f) f.Descricao IsNot Nothing AndAlso f.Descricao.Length)
                    If array_OD_OE.Contains(DVSL.IDTipoOlho) Then

                        Dim Graduacoes = (From x In inServico.DocumentosVendasLinhasGraduacoes
                                          Where x.IDTipoOlho = DVSL.IDTipoOlho And x.IDTipoGraduacao = DVSL.IDTipoGraduacao
                                          Select New With {.Adicao = x.Adicao, .PotenciaEsferica = x.PotenciaEsferica, .PotenciaPrismatica = x.PotenciaPrismatica, .PotenciaCilindrica = x.PotenciaCilindrica,
                                                    .Raio = x.RaioCurvatura, .Raio2 = x.DetalheRaio, .Eixo = x.Eixo}).FirstOrDefault()

                        If inServico.IDTipoServico = TipoServico.Contacto Then
                            With DVSL
                                .RaioCurvatura = Graduacoes.Raio
                                .DetalheRaio = Graduacoes.Raio2
                                .PotenciaEsferica = Graduacoes.PotenciaEsferica
                                .PotenciaCilindrica = Graduacoes.PotenciaCilindrica
                                .Eixo = Graduacoes.Eixo
                                .Adicao = Graduacoes.Adicao
                            End With

                        Else
                            With DVSL
                                .Adicao = Graduacoes.Adicao
                                .PotenciaEsferica = Graduacoes.PotenciaEsferica
                                .PotenciaPrismatica = Graduacoes.PotenciaPrismatica
                                .PotenciaCilindrica = Graduacoes.PotenciaCilindrica
                            End With
                        End If

                        ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 2 " & Now.ToString(“HH:mm:ss.fff”))

                        Dim IDArtigo As Long = ValidaExisteArtigo(BDContexto, inServico, DVSL, False)

                        ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 3 " & Now.ToString(“HH:mm:ss.fff”))

                        If IDArtigo <> 0 Then
                            Dim Artigo As tbArtigos = BDContexto.tbArtigos.Where(Function(f) f.ID = IDArtigo).FirstOrDefault

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 3.1 " & Now.ToString(“HH:mm:ss.fff”))

                            With DVSL
                                .CodigoArtigo = Artigo.Codigo
                                .IDArtigo = Artigo.ID
                                If .PrecoUnitario Is Nothing OrElse .PrecoUnitario = 0 Then
                                    .PrecoUnitario = Artigo.tbArtigosPrecos?.FirstOrDefault().ValorComIva
                                End If
                                .Descricao = Artigo.Descricao
                            End With
                        Else
                            With DVSL
                                .IDArtigo = CLng(0)
                                .CodigoArtigo = If(inServico.IDTipoServico = TipoServico.Contacto, "LC", "LO")
                            End With

                            ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 3.2 " & Now.ToString(“HH:mm:ss.fff”))

                            Dim Descricao As String = String.Empty
                            Dim intPos As Integer = 0
                            intPos = InStr(DVSL.Descricao, "Diam:")
                            If intPos = 0 Then intPos = InStr(DVSL.Descricao, "Diâm:")
                            If intPos > 0 Then
                                Descricao = DVSL.Descricao.Substring(0, intPos - 1)
                                If inServico.IDTipoServico = TipoServico.Contacto Then
                                    Descricao += " Diam:" & DVSL.Diametro
                                    Descricao += " Raio:" & DVSL.RaioCurvatura
                                    If DVSL.PotenciaEsferica <> 0 Then Descricao += " Esf:" & DVSL.PotenciaEsferica
                                    If DVSL.PotenciaCilindrica <> 0 Then Descricao += " Cil:" & DVSL.PotenciaCilindrica
                                    If DVSL.Adicao <> 0 Then Descricao += " Add:" & DVSL.Adicao
                                    If DVSL.Eixo <> 0 Then Descricao += " AX:" & DVSL.Eixo
                                Else
                                    Descricao += " Diam:" & DVSL.Diametro
                                    If DVSL.PotenciaEsferica <> 0 Then Descricao += " Esf:" & DVSL.PotenciaEsferica
                                    If DVSL.PotenciaCilindrica <> 0 Then Descricao += " Cil:" & DVSL.PotenciaCilindrica
                                    If DVSL.IDTipoLente = 1 Then ' Unifocal
                                    Else
                                        If DVSL.Adicao <> 0 Then Descricao += " Add:" & DVSL.Adicao
                                    End If
                                    If DVSL.PotenciaPrismatica <> 0 Then Descricao += " Prism:" & DVSL.PotenciaPrismatica
                                End If
                                blnMudou = DVSL.Descricao <> Descricao
                                DVSL.Descricao = Descricao
                            End If

                            Using rpMarcas As New RepositorioMarcas
                                Dim dblPreco As Double = 0
                                Dim suplementos As String() = Nothing

                                If Not DVSL.IDsSuplementos Is Nothing AndAlso DVSL.IDsSuplementos.Any() Then
                                    suplementos = DVSL.IDsSuplementos.Select(Function(s) s.ToString).ToArray()
                                End If

                                dblPreco = rpMarcas.LerPrecoVenda(
                                    If(inServico.IDTipoServico = TipoServico.Contacto, "LC", "LO"),
                                    If(DVSL.IDModelo Is Nothing, 0, DVSL.IDModelo),
                                    If(DVSL.IDTratamentoLente Is Nothing, 0, DVSL.IDTratamentoLente),
                                    If(DVSL.IDCorLente Is Nothing, 0, DVSL.IDCorLente),
                                    suplementos,
                                    If(DVSL.Diametro Is Nothing, "0", DVSL.Diametro),
                                    If(DVSL.PotenciaEsferica Is Nothing, 0, DVSL.PotenciaEsferica),
                                    If(DVSL.PotenciaCilindrica Is Nothing, 0, DVSL.PotenciaCilindrica), String.Empty, 0)

                                If dblPreco <> 0 AndAlso (DVSL.PrecoUnitario = 0 OrElse blnMudou) Then
                                    DVSL.PrecoUnitario = dblPreco
                                End If
                            End Using
                        End If
                    End If
                Next
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 4 " & Now.ToString(“HH:mm:ss.fff”))

                inModelo.Servicos(inModelo.Servicos.FindIndex(Function(f) f.ID = inServico.ID)) = inServico
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 5 " & Now.ToString(“HH:mm:ss.fff”))
                Calcula(inObjFiltro, inModelo)
                ClsUtilitarios.CodeTrace("REC.log", "Servicos: ValidaExisteArtigo : 6 " & Now.ToString(“HH:mm:ss.fff”))

                Return inServico
            Catch
                Throw
            End Try
        End Function

        Private Sub AddSubServicosDocumentosVendasLinhas(DVSL As Servicos, IDServico As Long)
            With DVSL.DocumentosVendasLinhas
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 1, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 2, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 3, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Aro, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 4, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 5, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 6, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Aro, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 7, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
                .Add(New DocumentosVendasLinhas With {.AcaoCRUD = AcoesFormulario.Adicionar, .ID = 8, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
            End With
        End Sub

        Private Sub AddSubServicosDocumentosVendasLinhasGraduacoes(DVSL As Servicos)
            With DVSL.DocumentosVendasLinhasGraduacoes
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Intermedio})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Intermedio})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
                .Add(New DocumentosVendasLinhasGraduacoes With {.IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
            End With
        End Sub

        Public Function GetProximoNumero(ByVal lngIDTipoDocumentoSerie As Long) As Long
            Dim Ultimo = BDContexto.tbDocumentosVendas.Where(Function(f) f.IDTiposDocumentoSeries = lngIDTipoDocumentoSerie).OrderByDescending(Function(f) f.NumeroDocumento).FirstOrDefault

            If Ultimo IsNot Nothing Then
                Return Ultimo.NumeroDocumento + 1
            Else
                Return 1
            End If
        End Function

        Public Function PreencherIncidencias(inObjFiltro As ClsF3MFiltro, modelo As DocumentosVendasServicos) As List(Of DocumentosVendasLinhas)
            Dim newDV As New DocumentosVendas
            Dim res As New List(Of DocumentosVendasLinhas)

            Mapear(modelo, newDV)
            newDV.DocumentosVendasLinhas = modelo.Servicos.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover).SelectMany(Function(s) s.DocumentosVendasLinhas.Where(Function(f) f.Descricao IsNot Nothing)).ToList()

            If modelo.Diversos IsNot Nothing Then
                newDV.DocumentosVendasLinhas.AddRange(modelo.Diversos.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover).ToList())
            End If

            Using ctx As New BD.Dinamica.Aplicacao
                Using rpDoc As New RepositorioDocumentos
                    res = rpDoc.PreencherIncidencias(Of DocumentosVendasLinhas)(ctx, newDV)
                End Using
            End Using

            'Using rp As New RepositorioDocumentosVendas
            '    res = rp.PreencherIncidencias(inObjFiltro, newDV)
            'End Using

            Return res
        End Function

#End Region

#Region "Cálculos"

        Public Function Calcula(inFiltro As ClsF3MFiltro, inModelo As DocumentosVendasServicos) As DocumentosVendasServicos
            Try
                Dim newDV As New DocumentosVendas
                Dim intCasasDecimaisTotais As Integer = 0
                If Not inModelo.IDMoeda Is Nothing Then
                    Dim lngIDMoeda As Integer = inModelo.IDMoeda
                    intCasasDecimaisTotais = BDContexto.tbMoedas.Where(Function(f) f.ID = lngIDMoeda).FirstOrDefault.CasasDecimaisTotais
                    intCasasDecimaisPrecosUnitarios = BDContexto.tbMoedas.Where(Function(f) f.ID = lngIDMoeda).FirstOrDefault.CasasDecimaisPrecosUnitarios
                Else
                    intCasasDecimaisTotais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                    intCasasDecimaisPrecosUnitarios = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios
                End If

                Mapear(inModelo, newDV)

                newDV.DocumentosVendasLinhas = inModelo.Servicos.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover) _
                    .SelectMany(Function(s)
                                    Select Case s.IDTipoServico
                                        Case TipoServico.Contacto
                                            Return s.DocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.LentesContacto)

                                            'Case TipoServico.Longe
                                            '    Return s.DocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Longe)
                                            '
                                            'Case TipoServico.Perto
                                            '    Return s.DocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Perto)

                                        Case TipoServico.LongePerto
                                            Return s.DocumentosVendasLinhas.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Longe Or f.IDTipoGraduacao = TipoGraduacao.Perto)

                                        Case Else
                                            Return s.DocumentosVendasLinhas
                                    End Select
                                End Function).ToList()

                newDV.DocumentosVendasLinhas.ForEach(Sub(s)
                                                         Dim dvlg = inModelo.Servicos.Where(Function(f) f.ID = s.IDServico) _
                                                                                .Select(Function(s1) s1.DocumentosVendasLinhasGraduacoes _
                                                                                .Where(Function(f2) Not IsNothing(f2.IDTipoOlho) AndAlso Not IsNothing(f2.IDTipoGraduacao) AndAlso f2.IDTipoGraduacao = s.IDTipoGraduacao AndAlso f2.IDTipoOlho = s.IDTipoOlho).FirstOrDefault).FirstOrDefault
                                                         If dvlg IsNot Nothing Then
                                                             s.PotenciaCilindrica = dvlg.PotenciaCilindrica
                                                             s.PotenciaEsferica = dvlg.PotenciaEsferica
                                                             s.PotenciaPrismatica = dvlg.PotenciaPrismatica
                                                             s.Adicao = dvlg.Adicao
                                                             s.RaioCurvatura = dvlg.RaioCurvatura
                                                             s.DetalheRaio = dvlg.DetalheRaio
                                                             s.Eixo = dvlg.Eixo
                                                         End If
                                                     End Sub)

                newDV.DocumentosVendasLinhas.AddRange(inModelo.Diversos.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover).ToList())

                Using rp As New RepositorioDocumentosVendas
                    rp.Calcula(inFiltro, newDV)
                End Using

                Mapear(newDV, inModelo)
                inModelo.Servicos.ForEach(
                    Sub(fe)
                        Dim dvlServ = newDV.DocumentosVendasLinhas.Where(Function(f) f.IDServico IsNot Nothing AndAlso f.IDServico = fe.ID).ToList

                        Dim L As List(Of DocumentosVendasLinhas) = dvlServ.Where(Function(f) f.IDTipoGraduacao IsNot Nothing AndAlso f.IDTipoGraduacao = TipoGraduacao.Longe).ToList()
                        fe.TotalLonge = Math.Round(CDbl(L.Sum(Function(f) f.TotalFinal)), intCasasDecimaisTotais)
                        fe.TotalComparticipadoLonge = Math.Round(CDbl(L.Sum(Function(f) f.ValorEntidade1 + f.ValorEntidade2)), intCasasDecimaisTotais)

                        Dim P As List(Of DocumentosVendasLinhas) = dvlServ.Where(Function(f) f.IDTipoGraduacao IsNot Nothing AndAlso f.IDTipoGraduacao = TipoGraduacao.Perto).ToList()
                        fe.TotalPerto = Math.Round(CDbl(P.Sum(Function(f) f.TotalFinal)), intCasasDecimaisTotais)
                        fe.TotalComparticipadoPerto = Math.Round(CDbl(P.Sum(Function(f) f.ValorEntidade1 + f.ValorEntidade2)), intCasasDecimaisTotais)

                        Dim LC As List(Of DocumentosVendasLinhas) = dvlServ.Where(Function(f) f.IDTipoGraduacao IsNot Nothing AndAlso f.IDTipoGraduacao = TipoGraduacao.LentesContacto).ToList()
                        fe.TotalLentesContacto = Math.Round(CDbl(LC.Sum(Function(f) f.TotalFinal)), intCasasDecimaisTotais)
                        fe.TotalComparticipadoLentesContacto = Math.Round(CDbl(LC.Sum(Function(f) f.ValorEntidade1 + f.ValorEntidade2)), intCasasDecimaisTotais)

                        Dim ts As Double = dvlServ.Sum(Function(s) s.TotalFinal)
                        fe.TotalServico = Math.Round(ts, intCasasDecimaisTotais)
                    End Sub)

                Dim TMR As Double = newDV.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover).Sum(Function(s) s.TotalFinal + s.ValorEntidade1)
                Dim TMS As Double = newDV.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover And f.IDTipoOlho <> TipoOlho.Diversos).Sum(Function(s) s.TotalFinal + s.ValorEntidade1)
                inModelo.TotalMoedaReferencia = Math.Round(TMR, intCasasDecimaisTotais)
                inModelo.TotalMoedaServicos = Math.Round(TMS, intCasasDecimaisTotais)

                Dim removidos = inModelo.Diversos.Where(Function(f) f.AcaoCRUD = AcoesFormulario.Remover)
                inModelo.Diversos = newDV.DocumentosVendasLinhas.Where(Function(f) f.IDTipoOlho = TipoOlho.Diversos).ToList
                inModelo.Diversos.AddRange(removidos)

                inModelo.Diversos.OrderBy(Function(f) f.Ordem)
                Return inModelo
            Catch
                Throw
            End Try
        End Function

        ''' <summary>
        ''' função retorna id da taxa em fução do tipo
        ''' </summary>
        ''' <param name="strTipoArtigo"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Function AtribuirIDTaxa(ByVal strTipoArtigo As String) As String
            Dim strCodigoTaxa As String = String.Empty

            If strTipoArtigo = "LO" Or strTipoArtigo = "LC" Then
                strCodigoTaxa = "RED"
            Else
                strCodigoTaxa = "NOR"
            End If

            Dim lngID As Long? = (From x In BDContexto.tbIVA
                                  Where x.tbSistemaTiposIVA.Codigo = strCodigoTaxa
                                  Select x.ID).FirstOrDefault()
            Return lngID
        End Function
#End Region

        'VER +
        Public Function GetDocumentoVendaPendenteWithTransaction(ByVal IDDocumentoVendaPendente As Long) As DocumentosVendasPendentes
            Return GetDocumentoVendaPendenteWithTransaction(BDContexto, IDDocumentoVendaPendente)
        End Function

        Public Function GetDocumentoVendaPendenteWithTransaction(inCtx As BD.Dinamica.Aplicacao, ByVal IDDocumentoVendaPendente As Long) As DocumentosVendasPendentes
            Return (From x In inCtx.tbDocumentosVendas
                    Join y In inCtx.tbMoedas On y.ID Equals x.IDMoeda
                    Where x.ID = IDDocumentoVendaPendente
                    Select New DocumentosVendasPendentes With {
                        .IDDocumentoVenda = x.ID, .IDEntidade = x.IDEntidade, .IDTipoDocumento = x.IDTipoDocumento, .Documento = x.Documento,
                        .NumeroDocumento = x.NumeroDocumento, .DataVencimento = x.DataDocumento,
                        .DataDocumento = x.DataDocumento,
                        .TotalMoedaDocumento = x.TotalMoedaDocumento,
                        .ValorPendente = Math.Round(x.TotalClienteMoedaDocumento.Value - x.ValorPago.Value, y.CasasDecimaisTotais.Value),
                        .ValorPendenteAux = Math.Round(x.TotalClienteMoedaDocumento.Value - x.ValorPago.Value, y.CasasDecimaisTotais.Value),
                        .GereContaCorrente = x.tbTiposDocumento.GereContaCorrente,
                        .GereCaixasBancos = x.tbTiposDocumento.GereCaixasBancos,
                        .IDTiposDocumentoSeries = x.IDTiposDocumentoSeries,
                        .NomeFiscal = x.NomeFiscal, .MoradaFiscal = x.MoradaFiscal, .IDCodigoPostalFiscal = x.IDCodigoPostalFiscal, .IDConcelhoFiscal = x.IDConcelhoFiscal,
                        .IDDistritoFiscal = x.IDDistritoFiscal, .CodigoPostalFiscal = x.CodigoPostalFiscal, .DescricaoCodigoPostalFiscal = x.DescricaoCodigoPostalFiscal,
                        .DescricaoConcelhoFiscal = x.DescricaoConcelhoFiscal, .DescricaoDistritoFiscal = x.DescricaoDistritoFiscal, .ContribuinteFiscal = x.ContribuinteFiscal,
                        .SiglaPaisFiscal = x.SiglaPaisFiscal,
                        .CodigoSistemaNaturezas = "R", .DescricaoSistemaNaturezas = "D"}).FirstOrDefault()
        End Function

        Public Function LerDocumentosAssociados(inObjFiltro As ClsF3MFiltro) As DocumentosVendas
            Try
                Dim iddocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "iddocumento", GetType(Long))
                Dim tipodocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "tipodocumento", GetType(Long))
                Dim totalentidade2 As Double = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "totalentidade2", GetType(Double))
                Dim opcao As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "opcao", GetType(String))
                Dim origem As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "origem", GetType(String)) 'servicos

                Dim DocumentoVenda As New DocumentosVendas

                Dim lngID As Long? = BDContexto.tbSistemaTiposDocumentoFiscal.Where(Function(f) f.Tipo = "FT").FirstOrDefault.ID
                Dim lngNumero As Long? = BDContexto.tbDocumentosVendas.Where(Function(f) f.ID = iddocumento).FirstOrDefault.NumeroDocumento
                If lngNumero Is Nothing Then
                    lngNumero = 0
                End If
                Dim lngIDSerie As Long? = BDContexto.tbTiposDocumentoSeries.Where(Function(f) f.IDTiposDocumento = lngID).FirstOrDefault.ID


                If opcao = "entidade2" Then
                    'ler as linhas com os valores de entidade2
                    Dim lngDocumentoVenda As Long? = (From x In BDContexto.tbDocumentosVendasLinhas
                                                      Where x.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado _
                                                        AndAlso x.IDDocumentoOrigem = CLng(iddocumento) AndAlso (Not x.tbDocumentosVendas.OrigemEntidade2 Is Nothing) AndAlso (x.CodigoArtigo = "DV-RED" Or x.CodigoArtigo = "DV-NOR")
                                                      Select x.tbDocumentosVendas.ID).FirstOrDefault()

                    If origem = "servicos" Then
                        If lngDocumentoVenda <> 0 Then
                            DocumentoVenda.ID = lngDocumentoVenda
                        End If
                    Else
                        Dim ArmazemPorDefeito As New tbArmazensLocalizacoes

                        Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
                        If IsNumeric(strIDLoc) AndAlso strIDLoc <> 0 Then
                            ArmazemPorDefeito = BDContexto.tbArmazensLocalizacoes.Where(Function(w) w.ID = strIDLoc).FirstOrDefault()
                        End If

                        If lngDocumentoVenda = 0 Then
                            Dim tbDocumentosVendas As tbDocumentosVendas = BDContexto.tbDocumentosVendas.Where(Function(f) f.ID = iddocumento).FirstOrDefault
                            Dim LstLinhas As List(Of tbDocumentosVendasLinhas) = tbDocumentosVendas.tbDocumentosVendasLinhas.ToList

                            If LstLinhas.Count > 0 Then
                                With DocumentoVenda
                                    .IDTipoDocumento = lngID
                                    .IDTiposDocumentoSeries = lngIDSerie
                                    .DataCriacao = DateAndTime.Now()
                                    .DataDocumento = Date.Now().Date
                                    .DataHoraEstado = DateAndTime.Now()
                                    .DataVencimento = DateAndTime.Now()
                                    .DataCarga = DateAndTime.Now()
                                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                    .IDEntidade = tbDocumentosVendas.IDEntidade
                                    .DescricaoEntidade = tbDocumentosVendas.tbClientes?.Nome
                                    .IDMoeda = tbDocumentosVendas.IDMoeda
                                    .TaxaConversao = tbDocumentosVendas.TaxaConversao
                                    .IDEstado = tbDocumentosVendas.IDEstado
                                    .DescricaoEstado = tbDocumentosVendas.tbEstados?.Descricao
                                    .CodigoTipoEstado = tbDocumentosVendas.CodigoTipoEstado
                                    .UtilizadorEstado = tbDocumentosVendas.UtilizadorEstado

                                    .IDEntidade2 = tbDocumentosVendas.IDEntidade2
                                    .NumeroBeneficiario2 = tbDocumentosVendas.NumeroBeneficiario2
                                    .Parentesco2 = tbDocumentosVendas.Parentesco2

                                    .PercentagemDesconto = tbDocumentosVendas.PercentagemDesconto
                                    .ValorDesconto = tbDocumentosVendas.ValorDesconto

                                    Dim Entidade = (From x In BDContexto.tbEntidades
                                                    Where x.ID = .IDEntidade2 And Not x.IDClienteEntidade Is Nothing
                                                    Select New With {.IDClienteEntidade = x.IDClienteEntidade,
                                                                                  .DescricaoClienteEntidade = x.tbClientes2.Nome,
                                                                                  .IDCondicaoPagamento = x.tbClientes2.IDCondicaoPagamento,
                                                                                  .NContribuinte = x.tbClientes2.NContribuinte,
                                                                                  .IDEspacoFiscal = x.tbClientes2.IDEspacoFiscal,
                                                                                  .IDLocalOperacao = x.tbClientes2.IDLocalOperacao,
                                                                                  .IDPais = x.tbClientes2.IDPais,
                                                                                  .DescricaoPaisFiscal = x.tbClientes2.tbPaises.Descricao}).FirstOrDefault()

                                    If Not Entidade Is Nothing Then
                                        .IDEntidade = Entidade.IDClienteEntidade
                                        .DescricaoEntidade = Entidade.DescricaoClienteEntidade
                                        .NomeFiscal = Entidade.DescricaoClienteEntidade
                                        .IDCondicaoPagamento = Entidade.IDCondicaoPagamento
                                        .ContribuinteFiscal = Entidade.NContribuinte
                                        .IDEspacoFiscal = Entidade.IDEspacoFiscal
                                        .IDLocalOperacao = Entidade.IDLocalOperacao
                                        .IDPaisFiscal = Entidade.IDPais
                                        .DescricaoPaisFiscal = Entidade.DescricaoPaisFiscal

                                    Else
                                        .IDEntidade = tbDocumentosVendas.IDEntidade
                                        '.DescricaoEntidade = tbDocumentosVendas.tbEntidades.Descricao
                                        .NomeFiscal = tbDocumentosVendas.NomeFiscal
                                        .IDCondicaoPagamento = tbDocumentosVendas.IDCondicaoPagamento
                                        .ContribuinteFiscal = tbDocumentosVendas.ContribuinteFiscal
                                        .IDEspacoFiscal = tbDocumentosVendas.IDEspacoFiscal
                                        .IDLocalOperacao = tbDocumentosVendas.IDLocalOperacao
                                        .IDPaisFiscal = tbDocumentosVendas.IDPaisFiscal
                                    End If
                                End With

                                Dim intOrdem As Integer = 1
                                For Each linha In LstLinhas.ToList()
                                    Dim newLinha As New DocumentosVendasLinhas
                                    Mapear(linha, newLinha)
                                    Dim dblvalor As Double = 0
                                    With newLinha
                                        .ID = CLng(0)
                                        .AcaoCRUD = CShort(AcoesFormulario.Adicionar)
                                        .IDServico = Nothing
                                        .IDDocumentoVenda = 0
                                        .Diametro = Nothing
                                        .IDEstado = Nothing
                                        .IDModelo = Nothing
                                        .IDTipoLente = Nothing
                                        .IDTipoOlho = Nothing
                                        .IDTratamentoLente = Nothing
                                        .IDTipoGraduacao = Nothing
                                        .ValorEntidade1 = CDbl(0)
                                        .ValorUnitarioEntidade1 = CDbl(0)

                                        dblvalor = CDbl(.PrecoUnitarioEfetivo) - CDbl(.ValorUnitarioEntidade2)
                                        .IDDocumentoOrigem = iddocumento
                                        .ValorUnitarioEntidade2 = dblvalor
                                        .ValorEntidade2 = dblvalor * .Quantidade

                                        Dim strTiposIVACodigo As String = BDContexto.tbIVA.Where(Function(f) f.ID = .IDTaxaIva).FirstOrDefault().tbSistemaTiposIVA.Codigo

                                        Dim strCodigoArtigo As String = "DV-" & strTiposIVACodigo


                                        Dim Artigo As Oticas.Artigos = (From x In BDContexto.tbArtigos
                                                                        Where x.Codigo = strCodigoArtigo
                                                                        Select New Oticas.Artigos With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao, .IDMarca = x.IDMarca, .DescricaoMarca = x.tbMarcas.Descricao}).FirstOrDefault()

                                        .IDArtigo = Artigo.ID
                                        .CodigoArtigo = Artigo.Codigo
                                        .TotalFinal = .TotalComDescontoCabecalho - .ValorEntidade2
                                        .PrecoTotal = .TotalFinal
                                        .Ordem = intOrdem

                                        .IDArmazem = ArmazemPorDefeito?.IDArmazem : .DescricaoArmazem = ArmazemPorDefeito?.tbArmazens?.Descricao
                                        .IDArmazemLocalizacao = ArmazemPorDefeito?.ID : .CodigoArmazemLocalizacao = ArmazemPorDefeito?.Codigo : .DescricaoArmazemLocalizacao = ArmazemPorDefeito?.Descricao
                                        .CodigoIva = strTiposIVACodigo

                                        Dim strQry As String = "select lotes.id From tbArtigosLotes As lotes Left Join tbArtigos As art On lotes.IDArtigo = art.ID Left Join tbSistemaOrdemLotes as sisOL on sisOL.ID = art.IDOrdemLoteMovSaida left Join tbCCStockArtigos as ccSA on ccSA.IDArtigo = lotes.IDArtigo And ccSA.IDArtigoLote = lotes.ID Left Join tbStockArtigos as sA on SA.IDArtigo = lotes.IDArtigo And sA.IDArtigoLote = lotes.ID " &
                                                            "where lotes.IDArtigo = art.ID And art.id = " & Artigo.ID & " order by (case sisOL.Codigo when 'DVDASC' then lotes.DataValidade END) ASC, (case sisOL.Codigo when 'FIFO' then lotes.DataCriacao END) ASC, (case sisOL.Codigo when 'DVDDSC' then lotes.DataValidade END) DESC, (case sisOL.Codigo when 'LIFO' then lotes.DataCriacao END) DESC, (case sisOL.Codigo when 'ULM' then ccSA.DataDocumento END) DESC "
                                        Dim IDLote As Nullable(Of Long) = BDContexto.Database.SqlQuery(Of Nullable(Of Long))(strQry).FirstOrDefault
                                        .IDLote = IDLote

                                        intOrdem += 1
                                    End With
                                    DocumentoVenda.DocumentosVendasLinhas.Add(newLinha)
                                Next
                            End If

                            Using rp As New RepositorioDocumentosVendas
                                rp.Calcula(inObjFiltro, DocumentoVenda, Nothing)
                            End Using
                        End If

                    End If

                    If (DocumentoVenda.IDEntidade2 IsNot Nothing) Then
                        'DocumentoVenda.IDEntidade = DocumentoVenda.IDEntidade2
                        'DocumentoVenda.DescricaoEntidade2 = DocumentoVenda.DescricaoEntidade2
                    End If

                    Return DocumentoVenda
                ElseIf opcao = "documentoVenda" Then

                    If origem = "servicos" Then

                        DocumentoVenda = (From x In BDContexto.tbDocumentosVendasLinhas
                                          Join y In BDContexto.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                                          Group Join z In BDContexto.tbDocumentosVendas On z.ID Equals x.IDDocumentoOrigemInicial Into w = Group
                                          From z In w.DefaultIfEmpty
                                          Where (x.IDDocumentoOrigem = iddocumento And x.IDTipoDocumentoOrigem = tipodocumento Or (x.IDDocumentoOrigemInicial = z.ID AndAlso x.IDLinhaDocumentoOrigemInicial Is Nothing AndAlso z.NumeroDocumento = lngNumero AndAlso z.IDTiposDocumentoSeries = lngIDSerie)) _
                                            And (Not x.tbDocumentosVendas.OrigemEntidade2 Or x.tbDocumentosVendas.OrigemEntidade2 Is Nothing) _
                                            And y.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado _
                                            And Not (y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo And y.tbTiposDocumento.Adiantamento = True) _
                                            And y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.NotaCredito And
                                            x.CodigoArtigo <> "DV-NOR" AndAlso x.CodigoArtigo <> "DV-RED"
                                          Select New DocumentosVendas With {.ID = x.tbDocumentosVendas.ID, .IDTipoDocumento = x.tbDocumentosVendas.IDTipoDocumento,
                                                                            .Documento = x.tbDocumentosVendas.Documento,
                                                                            .IDEntidade2 = x.tbDocumentosVendas.tbEntidades1.ID,
                                                                            .DescricaoEntidade2 = x.tbDocumentosVendas.tbEntidades1.Descricao,
                                                                            .NumeroDocumento = x.tbDocumentosVendas.NumeroDocumento,
                                                                            .IDTiposDocumentoSeries = x.tbDocumentosVendas.IDTiposDocumentoSeries}).FirstOrDefault()

                    Else
                        DocumentoVenda = (From x In BDContexto.tbDocumentosVendasLinhas
                                          Join y In BDContexto.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                                          Where x.IDDocumentoOrigem = iddocumento _
                                            And x.IDTipoDocumentoOrigem = tipodocumento _
                                            And (Not x.tbDocumentosVendas.OrigemEntidade2 Or x.tbDocumentosVendas.OrigemEntidade2 Is Nothing) _
                                            And y.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado _
                                            And Not (y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo And y.tbTiposDocumento.Adiantamento = True) _
                                            And y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.NotaCredito
                                          Select New DocumentosVendas With {.ID = x.tbDocumentosVendas.ID, .IDTipoDocumento = x.tbDocumentosVendas.IDTipoDocumento,
                                                                            .Documento = x.tbDocumentosVendas.Documento,
                                                                            .IDEntidade2 = x.tbDocumentosVendas.tbEntidades1.ID,
                                                                            .DescricaoEntidade2 = x.tbDocumentosVendas.tbEntidades1.Descricao,
                                                                            .NumeroDocumento = x.tbDocumentosVendas.NumeroDocumento,
                                                                            .IDTiposDocumentoSeries = x.tbDocumentosVendas.IDTiposDocumentoSeries}).FirstOrDefault()
                    End If

                    Return If(DocumentoVenda IsNot Nothing, DocumentoVenda, New DocumentosVendas)
                Else
                    DocumentoVenda = BDContexto.tbDocumentosVendasLinhas _
                        .Where(Function(f) f.IDDocumentoOrigem = iddocumento And f.IDTipoDocumentoOrigem = tipodocumento And f.tbDocumentosVendas.IDTipoDocumento = lngID AndAlso
                        f.tbDocumentosVendas.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo) _
                        .Select(Function(x) New DocumentosVendas With {
                                    .ID = x.ID, .IDTipoDocumento = x.tbDocumentosVendas.IDTipoDocumento, .Documento = x.tbDocumentosVendas.Documento,
                                    .NumeroDocumento = x.tbDocumentosVendas.NumeroDocumento, .IDTiposDocumentoSeries = x.tbDocumentosVendas.IDTiposDocumentoSeries}).FirstOrDefault()

                    Return If(DocumentoVenda IsNot Nothing, DocumentoVenda, New DocumentosVendas)
                End If
            Catch
                Throw
            End Try
        End Function


        Public Function ValidaAnulados(inObjFiltro As ClsF3MFiltro) As DocumentosVendas
            Try
                Dim iddocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "iddocumento", GetType(Long))
                Dim tipodocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, "tipodocumento", GetType(Long))
                Dim DocumentosVendas As New DocumentosVendas
                Dim DocumentoVenda As DocumentosVendas = BDContexto.tbDocumentosVendasLinhas _
                    .Where(Function(f) f.IDDocumentoOrigem = iddocumento And f.IDTipoDocumentoOrigem = tipodocumento And f.tbDocumentosVendas.IDTipoDocumento = iddocumento) _
                    .Select(Function(x) New DocumentosVendas With {
                        .ID = x.ID, .IDTipoDocumento = x.tbDocumentosVendas.IDTipoDocumento, .Documento = x.tbDocumentosVendas.Documento,
                        .NumeroDocumento = x.tbDocumentosVendas.NumeroDocumento, .IDTiposDocumentoSeries = x.tbDocumentosVendas.IDTiposDocumentoSeries}).FirstOrDefault()

                Return DocumentoVenda
            Catch
                Throw
            End Try
        End Function

        ''' <summary>
        ''' Funcao que atribui valores do artigo as linhas do servico
        ''' </summary>
        ''' <param name="inCtx">DBContext</param>
        ''' <param name="inDocumentoVendasLinha"></param>
        ''' <remarks></remarks>
        Private Sub AtribuiValoresDoArtigo(inCtx As BD.Dinamica.Aplicacao, ByRef inDocumentoVendasLinha As DocumentosVendasLinhas)
            Dim IDArtigo As Long = inDocumentoVendasLinha.IDArtigo
            Dim Artigo As Oticas.Artigos = (From x In inCtx.tbArtigos
                                            Where x.ID = IDArtigo
                                            Select New Oticas.Artigos With {
                                                 .IDTaxa = x.IDTaxa, .Taxa = x.tbIVA.Taxa,
                                                 .CodigoTaxa = x.tbIVA.tbSistemaCodigosIVA.Codigo, .CodigoMotivoIsencaoIva = x.tbIVA.tbSistemaCodigosIVA.Codigo, .MotivoIsencaoIva = x.tbIVA.tbSistemaCodigosIVA.Descricao,
                                                 .CodigoTipoIVA = x.tbIVA.tbSistemaTiposIVA.Codigo, .IDTipoIva = x.tbIVA.tbSistemaTiposIVA.ID, .DescricaoTaxa = x.tbIVA.tbSistemaTiposIVA.Descricao,
                                                 .CodigoUnidade = x.tbUnidades.Codigo, .IDUnidade = x.IDUnidade, .NumCasasDecUnidade = x.tbUnidades.NumeroDeCasasDecimais,
                                                 .CodigoBarrasArtigo = x.CodigoBarras}).FirstOrDefault()

            With inDocumentoVendasLinha
                .IDTaxaIva = Artigo.IDTaxa
                .TaxaIva = Artigo.Taxa
                .CodigoTaxaIva = Artigo.CodigoTaxa
                .CodigoMotivoIsencaoIva = Artigo.CodigoMotivoIsencaoIva
                .MotivoIsencaoIva = Artigo.MotivoIsencaoIva
                .CodigoTipoIva = Artigo.CodigoTipoIVA
                .IDTipoIva = Artigo.IDTipoIva
                .CodigoUnidade = Artigo.CodigoUnidade
                .IDUnidade = Artigo.IDUnidade
                .NumCasasDecUnidade = Artigo.NumCasasDecUnidade
                .CodigoBarrasArtigo = Artigo.CodigoBarrasArtigo
            End With
        End Sub

        ''' <summary>
        ''' Funcao que verifica se o tipo de linha está de acordo c/ o tipo de servico
        ''' </summary>
        ''' <param name="IDTipoServico"></param>
        ''' <param name="DVL"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function PodeGravarLinha(ByVal IDTipoServico As Long, ByVal DVL As DocumentosVendasLinhas) As Boolean
            Dim blnReturn As Boolean = False

            Select Case IDTipoServico
                Case 1 'UNIFOCAL LONGE / PERTO
                    If DVL.IDTipoGraduacao = TipoGraduacao.Longe OrElse DVL.IDTipoGraduacao = TipoGraduacao.Perto Then
                        blnReturn = True
                    End If

                Case 2 'UNIFOCAL LONGE
                    If DVL.IDTipoGraduacao = TipoGraduacao.Longe Then
                        blnReturn = True
                    End If

                Case 3 'UNIFOCAL PERTO
                    If DVL.IDTipoGraduacao = TipoGraduacao.Perto Then
                        blnReturn = True
                    End If

                Case 4, 7, 8 'BIFOCAL
                    If DVL.IDTipoGraduacao = TipoGraduacao.Longe Then
                        blnReturn = True
                    End If

                Case 5, 9, 10 'PROGRESSIVA
                    If DVL.IDTipoGraduacao = TipoGraduacao.Longe Then
                        blnReturn = True
                    End If

                Case 6 'LENTES DE CONTACTO
                    If DVL.IDTipoGraduacao = TipoGraduacao.LentesContacto Then
                        blnReturn = True
                    End If
            End Select

            Return blnReturn
        End Function

        ''' <summary>
        ''' funcao que valida a lista de graduacoes mediante o tipo de servico / VisaoIntermedia / VerPrismas
        ''' </summary>
        ''' <param name="Servico"></param>
        ''' <remarks></remarks>
        Private Sub ValidaGraduacoes(ByRef Servico As Servicos)
            Dim IDTipoServico As Long = Servico.IDTipoServico
            Dim ListOfGraduacoes As List(Of DocumentosVendasLinhasGraduacoes) = Servico.DocumentosVendasLinhasGraduacoes

            Select Case IDTipoServico
                Case 6 ' LENTES DE CONTACTO
                    For Each lin In ListOfGraduacoes.Where(Function(f) f.IDTipoGraduacao <> TipoGraduacao.LentesContacto)
                        EmptyModelGraducaoes(lin)
                    Next

                Case Else 'OCULOS
                    For Each lin In ListOfGraduacoes.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.LentesContacto)
                        EmptyModelGraducaoes(lin)
                    Next

                    If Not Servico.VisaoIntermedia Then
                        'For Each lin In ListOfGraduacoes.Where(Function(f) f.IDTipoGraduacao = TipoGraduacao.Intermedio)
                        '    EmptyModelGraducaoes(lin)
                        'Next
                    End If

                    If Not Servico.VerPrismas Then

                    End If
            End Select
        End Sub

        ''' <summary>
        ''' funcao que poe as graducoes = 0  / "0" / String.Empty
        ''' </summary>
        ''' <param name="inModel"></param>
        ''' <remarks></remarks>
        Private Sub EmptyModelGraducaoes(ByRef inModel As DocumentosVendasLinhasGraduacoes)
            With inModel
                .AcuidadeVisual = "0"
                .Adicao = CDbl(0)
                .Altura = CDbl(0)
                .AnguloPantoscopico = "0"
                .BasePrismatica = "0"
                .DetalheRaio = "0"
                .DistanciaVertex = "0"
                .DNP = CDbl(0)
                .Eixo = CInt(0)
                .PotenciaCilindrica = CDbl(0)
                .PotenciaEsferica = CDbl(0)
                .PotenciaPrismatica = CDbl(0)
                .RaioCurvatura = "0"
                .DetalheRaio = "0"
            End With
        End Sub

        'TODO - VER ESTA FUÇÃO
        ''' <summary>
        ''' funcao replica da generica GravaLinhas2 c/ a diferenca aqui => OrElse acaoAux.Equals(CShort(AcoesFormulario.Remover)))
        ''' </summary>
        ''' <typeparam name="TipoEntidade2"></typeparam>
        ''' <typeparam name="TipoObjeto2"></typeparam>
        ''' <param name="listaObjs"></param>
        ''' <param name="colEnts"></param>
        ''' <remarks></remarks>
        Private Sub GravaLinhasEspecifico(Of TipoEntidade2 As Class, TipoObjeto2 As Class)(ByRef listaObjs As List(Of TipoObjeto2), ByRef colEnts As ICollection(Of TipoEntidade2), inCtx As DbContext)
            Try
                If listaObjs IsNot Nothing AndAlso listaObjs.Count > 0 Then
                    For Each objLinha As TipoObjeto2 In listaObjs
                        Dim objID As Long = CLng(ClsUtilitarios.DaPropriedadedoModeloReflection(objLinha, CamposGenericos.ID))
                        Dim acaoAux As Short? = CShort(ClsUtilitarios.DaPropriedadedoModeloReflection(objLinha, CamposGenericos.AcaoCRUD))
                        Dim entLinha As TipoEntidade2 = Nothing

                        If acaoAux.Equals(CShort(AcoesFormulario.Adicionar)) AndAlso objID.Equals(0) Then
                            entLinha = Activator.CreateInstance(GetType(TipoEntidade2))

                        ElseIf colEnts IsNot Nothing AndAlso objID > 0 AndAlso (acaoAux.Equals(CShort(AcoesFormulario.Alterar)) OrElse acaoAux.Equals(CShort(AcoesFormulario.Remover))) Then
                            Dim lstCondicoes As New List(Of tbColunasListasPersonalizadas)
                            Dim queryAux As IQueryable(Of TipoEntidade2) = colEnts.AsQueryable

                            lstCondicoes.Add(
                                New tbColunasListasPersonalizadas With {
                                    .ColunaVista = CamposGenericos.ID,
                                    .OperadorCondicao = LINQ.Equal,
                                    .ValorCondicao = objID,
                                    .TipoColuna = TipoCampoVistas.Inteiro})

                            ClsF3MLINQ.ExecutaFiltros(lstCondicoes, queryAux)
                            entLinha = queryAux.FirstOrDefault
                        End If

                        If entLinha IsNot Nothing Then
                            Mapear(objLinha, entLinha)
                            PreeEntDadosUtilizador(entLinha, objID, acaoAux)

                            If acaoAux.Equals(CShort(AcoesFormulario.Adicionar)) AndAlso objID.Equals(0) Then
                                colEnts.Add(entLinha)
                                'GravaEntidadeLinha(Of TipoEntidade2)(inCtx, entLinha, AcoesFormulario.Adicionar, Nothing)
                            ElseIf acaoAux.Equals(CShort(AcoesFormulario.Remover)) AndAlso objID > 0 Then
                                GravaEntidadeLinha(Of TipoEntidade2)(inCtx, entLinha, AcoesFormulario.Remover, Nothing)
                            End If
                        End If
                    Next
                End If
            Catch
                Throw
            End Try
        End Sub

        ''' <summary>
        ''' funcao que verifica se o documento tem ENTIDADE 1 ou ENTIDADE 2
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Friend Function BlnExitemEntidade1ou2(ByVal IDDocumentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbDocumentosVendas
                    Where x.ID = IDDocumentoVenda _
                    And x.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo _
                    And ((Not x.IDEntidade1 Is Nothing And x.TotalEntidade1 > 0) Or (Not x.IDEntidade2 Is Nothing And x.TotalEntidade2 > 0))
                    Select x).Count > 0
        End Function

        ''' <summary>
        ''' funcao que verifica se as linhas do documento e o serviço são diferentes (SV,FT)
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>

        Protected Friend Function BlnDocumentoServicoDIFF(ByVal IDDocumentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbDocumentosVendasLinhas
                    Join y In BDContexto.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                    Join z In BDContexto.tbDocumentosVendas On z.ID Equals x.IDDocumentoOrigemInicial
                    Where (x.IDDocumentoOrigemInicial = IDDocumentoVenda And x.IDLinhaDocumentoOrigemInicial Is Nothing) And (x.IDDocumentoOrigemInicial <> x.IDDocumentoOrigem) And (Not x.tbDocumentosVendas.OrigemEntidade2 Or x.tbDocumentosVendas.OrigemEntidade2 Is Nothing) _
                        And y.tbEstados.tbSistemaTiposEstados.Codigo = TiposEstados.Efetivo _
                        And Not (y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo And y.tbTiposDocumento.Adiantamento = True) _
                        And y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.NotaCredito
                    Select x).Count > 0
        End Function

        ''' <summary>
        ''' funcao que verifica se o documento tem documentos associados
        ''' </summary>
        ''' <param name="IDDocumentoVenda"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Friend Function BlnExistemDocsAssociados(ByVal IDDocumentoVenda As Long) As Boolean
            Return (From x In BDContexto.tbDocumentosVendasLinhas
                    Join y In BDContexto.tbDocumentosVendas On y.ID Equals x.IDDocumentoVenda
                    Join z In BDContexto.tbDocumentosVendas On z.ID Equals x.IDDocumentoOrigem
                    Where x.IDDocumentoOrigem = IDDocumentoVenda _
                        And x.IDTipoDocumentoOrigem = z.IDTipoDocumento _
                        And (Not x.tbDocumentosVendas.OrigemEntidade2 Or x.tbDocumentosVendas.OrigemEntidade2 Is Nothing) _
                        And y.tbEstados.tbSistemaTiposEstados.Codigo <> TiposEstados.Anulado _
                        And Not (y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo And y.tbTiposDocumento.Adiantamento = True) _
                        And y.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.NotaCredito
                    Select x).Count > 0
        End Function

        'FUNCAO PARA O REP DOS ARTIGOS!
        Protected Friend Function GetArtigosAux(ByVal IDArtigo As Long) As Oticas.Artigos
            Return (From x In BDContexto.tbArtigos
                    Where x.ID = IDArtigo
                    Select New Oticas.Artigos With {.ID = x.ID, .Codigo = x.Codigo, .Descricao = x.Descricao}).FirstOrDefault()
        End Function

        ''' <summary>
        ''' Funcao que preenche os dados fiscais do cliente
        ''' </summary>
        ''' <param name="inCtx"></param>
        ''' <param name="inModelo"></param>
        ''' <returns></returns>
        Private Function PreencheDadosFiscaisCliente(inCtx As BD.Dinamica.Aplicacao, inModelo As DocumentosVendasServicos) As DocumentosVendasServicos
            Dim cli As Clientes = inCtx.Database.SqlQuery(Of Clientes)("SELECT  * FROM tbClientes WHERE ID=" & inModelo.IDEntidade).FirstOrDefault()

            Dim strQueryCliMorada As String = ""
            strQueryCliMorada += "  SELECT tbCP.Codigo AS DescricaoCodigoPostal, tbC.Descricao AS DescricaoConcelho, tbD.Descricao AS DescricaoDistrito, * "
            strQueryCliMorada += "  FROM tbClientesMoradas AS tbCliMor "
            strQueryCliMorada += "    INNER Join tbCodigosPostais AS tbCP ON tbCP.ID = tbCliMor.IDCodigoPostal "
            strQueryCliMorada += "    INNER Join tbConcelhos AS tbC ON tbC.ID = tbCliMor.IDConcelho "
            strQueryCliMorada += "    INNER Join tbDistritos AS tbD ON tbD.ID = tbCliMor.IDDistrito "
            strQueryCliMorada += "  WHERE IDCliente =" & inModelo.IDEntidade

            Dim cliMorada As ClientesMoradas = inCtx.Database.SqlQuery(Of ClientesMoradas)(strQueryCliMorada).FirstOrDefault()

            With inModelo
                .IDCondicaoPagamento = cli.IDCondicaoPagamento
                .ContribuinteFiscal = cli.NContribuinte
                .IDEspacoFiscal = cli.IDEspacoFiscal
                .IDRegimeIva = cli.IDRegimeIva
                .IDLocalOperacao = cli.IDLocalOperacao
                .IDPaisFiscal = cli.IDPais
                .DataNascimento = cli.DataNascimento

                If Not cliMorada Is Nothing Then
                    .MoradaFiscal = cliMorada.Morada
                    .IDPaisFiscal = cliMorada.IDPais

                    .IDCodigoPostalFiscal = cliMorada.IDCodigoPostal
                    .DescricaoCodigoPostalFiscal = cliMorada.DescricaoCodigoPostal

                    .IDConcelhoFiscal = cliMorada.IDConcelho
                    .DescricaoConcelhoFiscal = cliMorada.DescricaoConcelho

                    .IDDistritoFiscal = cliMorada.IDDistrito
                    .DescricaoDistritoFiscal = cliMorada.DescricaoDistrito
                End If
            End With

            Return inModelo
        End Function

        ''' <summary>
        ''' Funcao que mapeia os dados do cliente para o documento de venda
        ''' </summary>
        ''' <param name="inIDEntidade"></param>
        ''' <param name="inModelo"></param>
        Public Sub ImportarClientesToServico(ByVal inIDEntidade As Long, inModelo As DocumentosVendasServicos)
            'preenche entitdade
            Using rpClientes As New RepositorioClientes
                rpClientes.PreencheEntidadeForClass(Of DocumentosVendasServicos)(inIDEntidade, inModelo)
            End Using

            With inModelo
                'set flag flgImpFromClientesToSV to true
                .flgImpFromClientesToSV = True
            End With
        End Sub

        ''' <summary>
        ''' VER + TARDE
        ''' </summary>
        ''' <param name="inIDArtigo"></param>
        ''' <returns></returns>
        Protected Friend Function RetornaPreco(inIDArtigo As Long) As Double
            Dim artigosPrecos As List(Of tbArtigosPrecos) = BDContexto.tbArtigosPrecos.Where(Function(w) w.IDArtigo = inIDArtigo).ToList

            If Not artigosPrecos Is Nothing AndAlso artigosPrecos.Count Then
                Return artigosPrecos.Where(Function(w) w.tbSistemaCodigosPrecos.Codigo = "PV1").Select(Function(s) s.ValorComIva).FirstOrDefault
            End If

            Return CDbl(0)
        End Function

#Region "FASES"
        ''' <summary>
        ''' Funcao que retorna as fases do servico
        ''' </summary>
        ''' <param name="ctx"></param>
        ''' <param name="servicos"></param>
        ''' <returns></returns>
        Private Function RetornaFasesServico(ctx As BD.Dinamica.Aplicacao, servicos As List(Of Servicos)) As List(Of ServicosFases)
            Dim servicosFases As New List(Of ServicosFases)

            Dim tiposFases As List(Of TiposFases)
            Using rpTiposFases As New RepositorioTiposFases
                tiposFases = rpTiposFases.Lista(New ClsF3MFiltro).ToList()
            End Using

            Dim servicosPorTipo = servicos.GroupBy(Function(s) s.IDTipoServico).ToDictionary(Function(elem) elem.Key, Function(elem) elem.Count())
            Dim numServicoPorTipo As New Dictionary(Of Long, Integer)

            For Each servico As Servicos In servicos
                Dim numServicoTexto As String = ""

                If servicosPorTipo(servico.IDTipoServico) > 1 Then
                    If Not numServicoPorTipo.ContainsKey(servico.IDTipoServico) Then
                        numServicoPorTipo.Add(servico.IDTipoServico, 0)
                    End If

                    Dim numServico = numServicoPorTipo(servico.IDTipoServico) + 1
                    numServicoPorTipo(servico.IDTipoServico) = numServico

                    numServicoTexto = numServico & " - "
                End If

                If servico.IDTipoServico = 1 Then
                    'ADD LONGE
                    servicosFases.Add(RetornaServicoFase(servico, 2, numServicoTexto & "Unifocal, Longe", tiposFases))
                    'ADD PERTO
                    servicosFases.Add(RetornaServicoFase(servico, 3, numServicoTexto & "Unifocal, Perto", tiposFases))
                Else
                    'ADD
                    servicosFases.Add(RetornaServicoFase(servico, servico.IDTipoServico, numServicoTexto & servico.DescricaoServico, tiposFases))
                End If
            Next

            Return servicosFases
        End Function

        ''' <summary>
        ''' Funcao que retorna as fases de um subservico
        ''' </summary>
        ''' <param name="servico"></param>
        ''' <param name="idTipoServico"></param>
        ''' <param name="descricaoServico"></param>
        ''' <param name="tiposFases"></param>
        ''' <returns></returns>
        Private Function RetornaServicoFase(servico As Servicos, idTipoServico As Long, descricaoServico As String, tiposFases As List(Of TiposFases)) As ServicosFases
            Dim servicoFase As New ServicosFases With {.IDServico = servico.ID, .Descricao = descricaoServico, .IDTipoServico = idTipoServico}

            Dim fasesDoServico As New List(Of DocumentosVendasServicosFases)
            Using rp As New RepositorioDocumentosVendasServicosFases
                fasesDoServico = rp.ListaFasesByServico(servico.ID, idTipoServico)
            End Using

            Dim fasesServico As List(Of TiposFases)
            Select Case servico.IDTipoServico
                Case 6
                    fasesServico = tiposFases.Where(Function(w) w.Ativo AndAlso w.IDSistemaClassificacoesTiposArtigos = 3).OrderBy(Function(o) o.Ordem).ToList()
                Case Else
                    fasesServico = tiposFases.Where(Function(w) w.Ativo AndAlso w.IDSistemaClassificacoesTiposArtigos = 1).OrderBy(Function(o) o.Ordem).ToList()
            End Select

            servicoFase.Fases.AddRange(fasesDoServico)
            servicoFase.Fases.AddRange(fasesServico.Where(Function(w) fasesDoServico.All(Function(a) a.IDTipoFase <> w.ID)).Select(Function(s)
                                                                                                                                       Return New DocumentosVendasServicosFases With {
                                                                                                                                          .IDServico = servico.ID, .IDTipoServico = idTipoServico, .IDTipoFase = s.ID,
                                                                                                                                          .DescricaoTiposFases = s.Descricao, .Data = String.Empty, .Observacoes = String.Empty,
                                                                                                                                          .Ordem = s.Ordem}
                                                                                                                                   End Function))

            servicoFase.Fases = servicoFase.Fases.OrderBy(Function(o) o.Ordem).ToList()
            Return servicoFase
        End Function
#End Region

#Region "IMPORTAÇÂO"

        Public Function ObtemListaSubServicosImportar(ByVal idCliente As Long) As List(Of DocumentosVendasServicos)
            Dim lstServicos As List(Of DocumentosVendasServicos) =
                (From s In BDContexto.tbServicos
                 Join dv In BDContexto.tbDocumentosVendas On s.IDDocumentoVenda Equals dv.ID
                 Join ts In BDContexto.tbSistemaTiposServicos On s.IDTipoServico Equals ts.ID
                 Group Join mt In BDContexto.tbMedicosTecnicos On s.IDMedicoTecnico Equals mt.ID Into Group
                 From mt In Group.DefaultIfEmpty()
                 Where dv.IDEntidade = idCliente
                 Select New DocumentosVendasServicos With {
                     .ID = s.ID,
                     .DataDocumento = dv.DataDocumento,
                     .Documento = dv.Documento,
                     .Descricao = ts.Codigo,
                     .IDMedicoTecnico = s.IDMedicoTecnico,
                     .DescricaoMedicoTecnico = mt.Nome,
                     .DataReceita = s.DataReceita,
                     .Observacoes = dv.Observacoes
                 }) _
                 .OrderByDescending(Function(s) s.DataDocumento) _
                 .ToList()

            For Each servico In lstServicos
                Dim idServico As Long = servico.ID
                servico.Descricao = RetornaDescricaoServico(servico.Descricao)

                Dim lstGraduacoes As List(Of DocumentosVendasLinhasGraduacoes) =
                    (From g In BDContexto.tbDocumentosVendasLinhasGraduacoes
                     Where g.IDServico = idServico
                     Select New DocumentosVendasLinhasGraduacoes With {
                         .IDTipoOlho = g.IDTipoOlho,
                         .IDTipoGraduacao = g.IDTipoGraduacao,
                         .PotenciaEsferica = g.PotenciaEsferica,
                         .PotenciaCilindrica = g.PotenciaCilindrica,
                         .PotenciaPrismatica = g.PotenciaPrismatica,
                         .BasePrismatica = g.BasePrismatica,
                         .Adicao = g.Adicao,
                         .Eixo = g.Eixo,
                         .RaioCurvatura = g.RaioCurvatura,
                         .DetalheRaio = g.DetalheRaio,
                         .DNP = g.DNP,
                         .Altura = g.Altura,
                         .AcuidadeVisual = g.AcuidadeVisual,
                         .AnguloPantoscopico = g.AnguloPantoscopico,
                         .DistanciaVertex = g.DistanciaVertex
                     }).ToList

                servico.GraduacoesImportacao = lstGraduacoes
            Next

            Return lstServicos
        End Function

#End Region

#Region "COMMUNICATION - SMS"
        Public Overrides Function GetCommunicationSmsProperties(id As Long) As ClsF3MCommunicationSms
            Dim entityToSendSmsId As Long = tabela.AsNoTracking().FirstOrDefault(Function(entity) entity.ID = id).IDEntidade
            Dim phoneNumber As String = BDContexto.tbClientesContatos.OrderBy(Function(entity) entity.Ordem)?.FirstOrDefault(Function(entity) entity.IDCliente = entityToSendSmsId)?.Telemovel
            Return New ClsF3MCommunicationSms With {.EntityId = id, .EntityToSendSmsId = entityToSendSmsId, .MobilePhoneNumber = phoneNumber}
        End Function
#End Region

#Region "user new feature"
        Public Function userFeature() As Boolean
            Dim sessionUser As String = ClsF3MSessao.RetornaUtilizadorNome()
            Dim isNewUserOnFeature As Boolean = BDContexto.tbNewFeatureNotifications.Any(Function(entity) entity.Feature = "ServiceDocuments" AndAlso entity.UserFeature = sessionUser)

            If Not isNewUserOnFeature Then
                BDContexto.tbNewFeatureNotifications.Add(New tbNewFeatureNotifications With {
                                                         .Feature = "ServiceDocuments",
                                                         .UserFeature = sessionUser,
                                                         .Sistema = True, .Ativo = True,
                                                         .UtilizadorCriacao = sessionUser, .DataCriacao = Now()})
                BDContexto.SaveChanges()
            End If

            Return Not isNewUserOnFeature
        End Function
#End Region
    End Class
End Namespace