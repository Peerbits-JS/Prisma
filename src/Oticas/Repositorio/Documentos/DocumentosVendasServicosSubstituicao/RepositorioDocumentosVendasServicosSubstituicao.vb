Imports System.Data.Entity
Imports F3M.Core.Components.Extensions
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.Comum
Imports Kendo.Mvc
Imports Kendo.Mvc.UI
Imports Oticas.BD.Dinamica
Imports Oticas.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosVendasServicosSubstituicao
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDocumentosVendas, DocumentosVendasServicosSubstituicao)

        Private ReadOnly _repositorioTipoDocumento As RepositorioTiposDocumento

#Region "CONSTRUCTOR"
        Sub New()
            _repositorioTipoDocumento = New RepositorioTiposDocumento()
        End Sub
#End Region

#Region "GRID"
        Protected Overrides Function ListaCamposGrelha(request As DataSourceRequest, objFiltro As ClsF3MFiltro) As IQueryable(Of DocumentosVendasServicosSubstituicao)
            Return tabela.
                Select(Function(s) New DocumentosVendasServicosSubstituicao With {
                .ID = s.ID, .DescricaoLoja = s.tbLojas.Descricao,
                .Documento = s.Documento,
                .DataDocumento = s.DataDocumento,
                .NomeFiscal = s.NomeFiscal,
                .DescricaoEstado = s.tbEstados.Descricao,
                .IDTipoDocumento = s.IDTipoDocumento,
                .CodigoSistemaTiposDocumento = s.tbTiposDocumento.tbSistemaTiposDocumento.Tipo,
                .DescricaoSplitterLadoDireito = s.Documento,
                .IDServico = s.tbServicos.FirstOrDefault.ID})
        End Function

        Public Overrides Function GridDataFilters(objFiltro As ClsF3MFiltro) As List(Of IFilterDescriptor)
            Return New List(Of IFilterDescriptor) From {
                New FilterDescriptor With {.Member = "CodigoSistemaTiposDocumento", .Value = "SubstituicaoArtigos"}}
        End Function
#End Region

#Region "READ"
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbDocumentosVendas)) As IQueryable(Of DocumentosVendasServicosSubstituicao)
            Dim funcSel As Func(Of tbDocumentosVendas, Oticas.DocumentosVendasServicosSubstituicao) = Function(s) MapeiaEsp(s)

            Return inQuery.Select(funcSel).AsQueryable
        End Function

        Public Function MapeiaEsp(docBd As tbDocumentosVendas) As Oticas.DocumentosVendasServicosSubstituicao
            Dim docMOD As New Oticas.DocumentosVendasServicosSubstituicao
            'Dim idDocumentoOriemInical As Long = docBd.tbDocumentosVendasLinhas.FirstOrDefault().IDLinhaDocumentoOrigemInicial

            If docBd IsNot Nothing Then
                ' Mapeia Generico
                RepositorioDocumentos.MapeiaCamposGen(Of tbDocumentosVendas, Oticas.DocumentosVendasServicosSubstituicao, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosVendasLinhas, Oticas.DocumentosVendasLinhas)(docBd, docMOD, Nothing)
                ' Mapeia Especifico
                With docMOD
                    .IDLoja = docBd.IDLoja
                    .CodigoTipoEstado = docBd.CodigoTipoEstado
                    .DescricaoSplitterLadoDireito = docBd.Documento
                    .IDServico = GetIdServicoOrigem(docBd)
                    .DescricaoServico = RetornaDescricaoServico(.IDServico) : .DescricaoTipoServico = RetornaDescricaoTipoServico(.IDServico)
                    .RegistoBloqueado = True
                    PreencheSubServicosEditar(docBd.tbServicos.FirstOrDefault(), docMOD, .IDServico)
                End With
            End If

            Return docMOD
        End Function
#End Region

#Region "CREATE"
        Public Function GetServico(IDServico As Long) As DocumentosVendasServicosSubstituicao
            Dim model As New DocumentosVendasServicosSubstituicao

            Dim estado As F3M.Estados = F3M.Repositorio.Comum.RepositorioEstados.ValoresPorDefeito(Of tbEstados)(BDContexto, TiposEntidadeEstados.ServicosSubstituicao)
            Dim tipoDocumentoSerie = _repositorioTipoDocumento.ObtemSeriePorDefeitoServicosSubstituicao()

            With model
                .IDEstado = estado.ID : .DescricaoEstado = estado.Descricao : .CodigoEstado = estado.Codigo
                .IDTipoDocumento = tipoDocumentoSerie.IDTiposDocumento : .CodigoTipoDocumento = tipoDocumentoSerie.CodigoTipoDocumento : .DescricaoTiposDocumentoSeries = tipoDocumentoSerie.DescricaoSerie
                .DescricaoTipoDocumento = tipoDocumentoSerie.DescricaoTipoDocumento : .IDTiposDocumentoSeries = tipoDocumentoSerie.ID : .CodigoTipoEstado = estado.CodigoTipoEstado
                .CodigoSerie = tipoDocumentoSerie.CodigoSerie
                .CodigoDescricaoTipoDocumento = tipoDocumentoSerie.CodigoDescricao
                .NumeroDocumento = 0 : .DataDocumento = DateAndTime.Now()

                If Not String.IsNullOrEmpty(.CodigoTipoDocumento) AndAlso Not String.IsNullOrEmpty(.CodigoSerie) Then
                    .Documento = .CodigoTipoDocumento & Operadores.EspacoEmBranco & .CodigoSerie & Operadores.Slash
                End If
            End With

            Dim serv As tbServicos = BDContexto.tbServicos.FirstOrDefault(Function(w) w.ID = IDServico)
            With model
                .IDServico = IDServico : .DescricaoServico = RetornaDescricaoServico(serv) : .DescricaoTipoServico = RetornaDescricaoTipoServico(serv)
            End With

            PreencheSubServiceCreate(serv, model)

            Return model
        End Function

        Public Sub PreencheSubServiceCreate(serv As tbServicos, model As DocumentosVendasServicosSubstituicao)
            Dim Servico As New Servicos With {.ID = serv.ID, .IDTipoServico = serv.tbSistemaTiposServicos.ID, .VerPrismas = serv.VerPrismas, .VisaoIntermedia = serv.VisaoIntermedia}

            AddSubServicosDocumentosVendasLinhas(Servico, serv.ID)
            For Each artigo As tbDocumentosVendasLinhas In serv.tbDocumentosVendasLinhas.ToList()
                Dim artigoSubstituicao As DocumentosVendasServicosSubstituicaoArtigos = Servico.Artigos.FirstOrDefault(Function(f) f.IDTipoOlho = artigo.IDTipoOlho AndAlso f.IDTipoGraduacao = artigo.IDTipoGraduacao)

                With artigoSubstituicao
                    .IdLinhaDocumentoOrigemInicial = artigo.ID
                    .IdArtigoOrigem = artigo.IDArtigo
                    .DiametroOrigem = artigo.Diametro
                    .CodigoArtigoOrigem = artigo.tbArtigos.Codigo
                    .DescricaoArtigoOrigem = artigo.Descricao
                    .IDTipoServico = serv.IDTipoServico
                    .IDTipoArtigo = artigo.tbArtigos.IDTipoArtigo
                    .DiametroDestino = .DiametroOrigem
                End With
            Next
            Servico.Artigos = Servico.Artigos.Where(Function(w) w.IdArtigoOrigem <> 0).ToList()

            AddSubServicosDocumentosVendasLinhasGraduacoes(Servico)
            For Each graduacao As tbDocumentosVendasLinhasGraduacoes In serv.tbDocumentosVendasLinhasGraduacoes.ToList()
                Dim graduacaoSubstituicao As DocumentosVendasLinhasGraduacoes = Servico.DocumentosVendasLinhasGraduacoes.FirstOrDefault(Function(f) f.IDTipoOlho = graduacao.IDTipoOlho AndAlso f.IDTipoGraduacao = graduacao.IDTipoGraduacao)
                Mapear(graduacao, graduacaoSubstituicao)
            Next

            model.Servico = Servico
        End Sub
#End Region

#Region "CREATE - CRUD"
        Public Overrides Sub AdicionaObj(ByRef model As DocumentosVendasServicosSubstituicao, filtro As ClsF3MFiltro)
            'get context
            Using ctx As New Aplicacao
                'start transaction
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                    Try
                        Dim idServicoOrigem As Long = model.IDServico
                        Dim idDocumentoVendaOrigem As Long = ctx.tbServicos.FirstOrDefault(Function(s) s.ID = idServicoOrigem).tbDocumentosVendas.ID

                        Dim docOrigem As tbDocumentosVendas = ctx.tbDocumentosVendas.
                            Include(Function(entity) entity.tbServicos).
                            AsNoTracking().
                            FirstOrDefault(Function(s) s.ID = idDocumentoVendaOrigem)

                        Dim serv As tbServicos = docOrigem.tbServicos.FirstOrDefault(Function(s) s.ID = idServicoOrigem)
                        Dim docVenda As New tbDocumentosVendas
                        docVenda = docOrigem.Map(Of tbDocumentosVendas)

                        Dim docSerie As tbTiposDocumentoSeries = RepositorioDocumentos.AdicionaDocumento(
                            Of tbDocumentosVendas,
                            DocumentosVendasServicosSubstituicao,
                            tbTiposDocumentoSeries,
                            tbEstados)(ctx, model, filtro)

                        Dim ERasc As Boolean = RepositorioDocumentos.ERascunho(Of tbEstados)(ctx, model)
                        RepositorioDocumentos.DefineNumeroDocumento(Of tbDocumentosVendas, tbTiposDocumentoSeries)(ctx, model, docSerie, ERasc, 0)

                        With docVenda
                            .ID = 0 : .F3MMarcador = Nothing
                            .IDTipoDocumento = model.IDTipoDocumento : .IDTiposDocumentoSeries = model.IDTiposDocumentoSeries
                            .NumeroDocumento = model.NumeroDocumento : .DataDocumento = model.DataDocumento
                            .Documento = String.Concat(docSerie.tbTiposDocumento.Codigo, " ", docSerie.CodigoSerie, "/", .NumeroDocumento)
                            .IDEstado = model.IDEstado : .UtilizadorEstado = ClsF3MSessao.RetornaUtilizadorNome()
                            .IDCondicaoPagamento = Nothing
                            .IDLoja = ClsF3MSessao.RetornaLojaID
                            .Observacoes = String.Empty
                            .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now() : .UtilizadorAlteracao = String.Empty : .UtilizadorAlteracao = Nothing
                            'reset lines
                            .tbDocumentosVendasAnexos = New List(Of tbDocumentosVendasAnexos)
                            .tbDocumentosVendasLinhas = New List(Of tbDocumentosVendasLinhas)
                            .tbDocumentosVendasFormasPagamento = New List(Of tbDocumentosVendasFormasPagamento)
                            .tbDocumentosVendasPendentes = New List(Of tbDocumentosVendasPendentes)
                            .tbPagamentosVendasLinhas = New List(Of tbPagamentosVendasLinhas)
                            .tbRecibosLinhas = New List(Of tbRecibosLinhas)
                            .tbServicos = New List(Of tbServicos)
                        End With

                        MapeiaGradsAdicionar(ctx, serv, model)

                        MapeiaArtigosAdicionar(ctx, serv, model)

                        With serv
                            .ID = 0 : .F3MMarcador = Nothing : .IDDocumentoVenda = 0
                        End With

                        docVenda.tbServicos.Add(serv)

                        With docVenda
                            'reset values
                            .OutrosDescontos = 0 : .TotalPontos = 0 : .TotalValesOferta = 0 : .ValorDesconto = 0 : .ValorPortes = 0
                            .TotalEntidade1 = 0 : .TotalEntidade2 = 0
                            .ValorPago = 0
                            'calcs
                            .TotalClienteMoedaDocumento = 0 : .TotalClienteMoedaReferencia = .TotalClienteMoedaDocumento
                            .TotalIva = 0 : .SubTotal = 0 : .ValorImposto = 0
                            .TotalMoedaDocumento = 0 : .TotalMoedaReferencia = .TotalMoedaDocumento
                        End With

                        With ctx
                            .tbDocumentosVendas.Add(docVenda)
                            .Entry(docVenda).State = EntityState.Added
                            .SaveChanges()
                        End With

                        For Each lin In docVenda.tbServicos.FirstOrDefault.tbDocumentosVendasLinhas
                            With lin
                                .IDDocumentoVenda = docVenda.ID
                            End With
                        Next

                        model.ID = docVenda.ID

                        'exec sp
                        ExecSp(ctx, docVenda.ID, docVenda.IDTipoDocumento, AcoesFormulario.Adicionar)

                        'lets commit it!
                        trans.Commit()

                    Catch ex As Exception
                        'rollback it!
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Sub MapeiaGradsAdicionar(ctx As Aplicacao, serv As tbServicos, model As DocumentosVendasServicosSubstituicao)
            For Each grad As tbDocumentosVendasLinhasGraduacoes In serv.tbDocumentosVendasLinhasGraduacoes
                With grad
                    .ID = 0 : .F3MMarcador = Nothing : .IDServico = 0
                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now()
                    .UtilizadorAlteracao = Nothing : .DataAlteracao = Nothing

                    Dim graduacao As DocumentosVendasLinhasGraduacoes = model.Servico.DocumentosVendasLinhasGraduacoes.FirstOrDefault(Function(w) w.IDTipoGraduacao = grad.IDTipoGraduacao AndAlso w.IDTipoOlho = grad.IDTipoOlho)

                    If Not graduacao Is Nothing Then
                        With grad
                            .PotenciaEsferica = graduacao.PotenciaEsferica
                            .PotenciaCilindrica = graduacao.PotenciaCilindrica
                            .PotenciaPrismatica = graduacao.PotenciaPrismatica
                            .BasePrismatica = graduacao.BasePrismatica
                            .Adicao = graduacao.Adicao
                            .Eixo = graduacao.Eixo
                            .RaioCurvatura = graduacao.RaioCurvatura
                            .DetalheRaio = graduacao.DetalheRaio
                            .DNP = graduacao.DNP
                            .Altura = graduacao.Altura
                            .AcuidadeVisual = graduacao.AcuidadeVisual
                            .AnguloPantoscopico = graduacao.AnguloPantoscopico
                            .DistanciaVertex = graduacao.DistanciaVertex
                        End With
                    End If
                End With
            Next
        End Sub

        Private Sub MapeiaArtigosAdicionar(ctx As Aplicacao, serv As tbServicos, model As DocumentosVendasServicosSubstituicao)
            Dim armazemPorDefeito As tbArmazensLocalizacoes = RetornaArmazemLocalizacaoLoja(ctx)
            Dim artigosRemove As New List(Of tbDocumentosVendasLinhas)

            For Each art As tbDocumentosVendasLinhas In serv.tbDocumentosVendasLinhas
                Dim artigo As DocumentosVendasServicosSubstituicaoArtigos = model.Servico.Artigos.
                    FirstOrDefault(Function(w) w.Id <> 0 AndAlso w.IDTipoGraduacao = art.IDTipoGraduacao AndAlso w.IDTipoOlho = art.IDTipoOlho AndAlso Not String.IsNullOrEmpty(w.CodigoArtigoDestino))

                If Not artigo Is Nothing Then
                    With art
                        .ID = 0 : .F3MMarcador = Nothing : .IDServico = 0 : .IDDocumentoVenda = 0
                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now()
                        .UtilizadorAlteracao = Nothing : .DataAlteracao = Nothing
                        .tbDocumentosComprasLinhas = New List(Of tbDocumentosComprasLinhas)
                        .tbDocumentosVendasLinhas1 = New List(Of tbDocumentosVendasLinhas)
                        .tbDocumentosVendasLinhasDimensoes = New List(Of tbDocumentosVendasLinhasDimensoes)
                    End With

                    Dim graduacao As DocumentosVendasLinhasGraduacoes = model.Servico.DocumentosVendasLinhasGraduacoes.
                    FirstOrDefault(Function(w) w.IDTipoGraduacao = artigo.IDTipoGraduacao AndAlso w.IDTipoOlho = artigo.IDTipoOlho)

                    With art
                        If (artigo.IdArtigoDestino = 0) Then
                            Dim propduct As tbArtigos = RetornaArtigo(ctx, artigo, graduacao)
                            If propduct Is Nothing Then
                                Dim insertedProduct As tbArtigos = InsereArtigo(ctx, serv, artigo, graduacao)

                                With artigo
                                    .IdArtigoDestino = insertedProduct.ID
                                    .CodigoArtigoDestino = insertedProduct.Codigo : .CodigoBarrasArtigoDestino = insertedProduct.CodigoBarras
                                    .DescricaoArtigoDestino = insertedProduct.Descricao
                                End With

                            Else
                                With artigo
                                    .IdArtigoDestino = propduct.ID
                                    .CodigoArtigoDestino = propduct.Codigo : .CodigoBarrasArtigoDestino = propduct.CodigoBarras
                                    .DescricaoArtigoDestino = propduct.Descricao
                                End With
                            End If

                            'valores a 0
                            .PrecoUnitario = 0 : .PrecoUnitarioEfetivo = 0 : .PrecoTotal = 0
                            .ValorImposto = 0
                            .TotalFinal = 0
                            .ValorIncidencia = 0 : .ValorIVA = 0
                            .PrecoUnitarioEfetivoSemIva = 0
                            .TotalComDescontoCabecalho = 0 : .TotalComDescontoLinha = 0

                        Else
                            If artigo.CustoMedioArtigoDestino Is Nothing Then artigo.CustoMedioArtigoDestino = 0
                            If artigo.TaxaIvaArtigoDestino Is Nothing Then artigo.TaxaIvaArtigoDestino = 0

                            .PrecoUnitario = artigo.CustoMedioArtigoDestino : .PrecoUnitarioEfetivo = .PrecoUnitario : .PrecoTotal = Math.Round(CDbl(.PrecoUnitario * .Quantidade), 4)
                            .ValorIncidencia = Math.Round(CDbl(.PrecoTotal * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                            .TotalFinal = .PrecoTotal
                            .ValorIVA = .TotalFinal - .ValorIncidencia : .ValorImposto = .ValorIVA
                            .PrecoUnitarioEfetivoSemIva = Math.Round(CDbl(.PrecoUnitario * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                            .TotalComDescontoCabecalho = .TotalFinal : .TotalComDescontoLinha = .TotalFinal
                        End If

                        .CodigoArtigo = artigo.CodigoArtigoDestino : .CodigoBarrasArtigo = artigo.CodigoBarrasArtigoDestino
                        .Diametro = artigo.DiametroDestino
                        .IDArtigo = artigo.IdArtigoDestino
                        .Descricao = artigo.DescricaoArtigoDestino
                        .IDLinhaDocumentoOrigemInicial = artigo.IdLinhaDocumentoOrigemInicial
                        .IDDocumentoOrigemInicial = serv.IDDocumentoVenda
                        'armazem
                        .IDArmazem = armazemPorDefeito?.IDArmazem
                        .IDArmazemLocalizacao = armazemPorDefeito?.ID
                        'valores a 0
                        .Desconto1 = 0 : .Desconto2 = 0
                        .ValorDescontoLinha = 0
                        .ValorDescontoCabecalho = 0 : .ValorDescontoEfetivoSemIva = 0
                        .ValorUnitarioEntidade1 = 0 : .ValorUnitarioEntidade2 = 0
                        .ValorEntidade1 = 0 : .ValorEntidade2 = 0
                    End With

                Else
                    artigosRemove.Add(art)
                End If
            Next

            For Each linha As tbDocumentosVendasLinhas In artigosRemove
                serv.tbDocumentosVendasLinhas.Remove(linha)
            Next
        End Sub
#End Region

#Region "UPDATE"
        Private Sub PreencheSubServicosEditar(sv As tbServicos, item As DocumentosVendasServicosSubstituicao, idServicoOrigem As Long)
            Dim lstArtigosIds As Long?() = sv.tbDocumentosVendasLinhas.Select(Function(artigo) artigo.IDArtigo).ToArray()
            Dim lstTbArtigos As List(Of tbArtigos) = BDContexto.tbArtigos.Where(Function(w) lstArtigosIds.Any(Function(id) id = w.ID)).ToList()

            Dim Servico As New Servicos With {.ID = sv.ID, .IDTipoServico = sv.tbSistemaTiposServicos.ID, .VerPrismas = sv.VerPrismas, .VisaoIntermedia = sv.VisaoIntermedia}

            AddSubServicosDocumentosVendasLinhas(Servico, sv.ID)

            Dim linhasOrigem As List(Of tbDocumentosVendasLinhas) = BDContexto.tbDocumentosVendasLinhas.Where(Function(w) w.IDServico = idServicoOrigem).ToList()

            For Each lin As tbDocumentosVendasLinhas In linhasOrigem
                Dim DVL As tbDocumentosVendasLinhas = sv.tbDocumentosVendasLinhas.FirstOrDefault(Function(w) w.IDLinhaDocumentoOrigemInicial = lin.ID)

                If Not DVL Is Nothing Then 'foi substituida
                    Dim DVLNew As DocumentosVendasServicosSubstituicaoArtigos = Servico.
                   Artigos.
                   Find(Function(f) f.IDTipoOlho = DVL.IDTipoOlho AndAlso f.IDTipoGraduacao = DVL.IDTipoGraduacao)

                    Dim linhaOrigem As tbDocumentosVendasLinhas = linhasOrigem.FirstOrDefault(Function(w) w.ID = DVL.IDLinhaDocumentoOrigemInicial)
                    With DVLNew
                        .Id = DVL.ID
                        .IdLinhaDocumentoOrigemInicial = DVL.IDLinhaDocumentoOrigemInicial
                        .IdArtigoDestino = DVL.IDArtigo
                        .DiametroDestino = DVL.Diametro
                        .CodigoArtigoDestino = DVL.tbArtigos.Codigo
                        .DescricaoArtigoDestino = DVL.Descricao
                        .IDTipoServico = sv.IDTipoServico
                        .IDTipoArtigo = DVL.tbArtigos.IDTipoArtigo
                        .IDMarca = DVL.tbArtigos.IDMarca
                        .DiametroOrigem = linhaOrigem.Diametro
                        .IdArtigoOrigem = linhaOrigem.IDArtigo
                        .CodigoArtigoOrigem = linhaOrigem.tbArtigos.Codigo
                        .DescricaoArtigoOrigem = linhaOrigem.tbArtigos.Descricao
                        .CodigoBarrasArtigoDestino = linhaOrigem.tbArtigos.CodigoBarras
                        .CustoMedioArtigoDestino = linhaOrigem.tbArtigos.Medio
                        .TaxaIvaArtigoDestino = linhaOrigem.tbArtigos.tbIVA.Taxa
                    End With

                    Dim LinhaLenOft = DVL.tbArtigos.tbLentesOftalmicas.FirstOrDefault()
                    If LinhaLenOft IsNot Nothing Then
                        With DVLNew
                            .IDModelo = LinhaLenOft.IDModelo : .DescricaoModelo = LinhaLenOft.tbModelos.Descricao
                            .IDTratamentoLente = LinhaLenOft.IDTratamentoLente : .DescricaoTratamentoLente = LinhaLenOft.tbTratamentosLentes?.Descricao
                            .IDCorLente = LinhaLenOft.IDCorLente : .DescricaoCorLente = LinhaLenOft.tbCoresLentes?.Descricao
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
                                .IDModelo = LinhaLenCont.IDModelo : .DescricaoModelo = LinhaLenCont.tbModelos.Descricao
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

                Else 'não foi substituida
                    Dim artigoSubstituicao As DocumentosVendasServicosSubstituicaoArtigos = Servico.Artigos.FirstOrDefault(Function(f) f.IDTipoOlho = lin.IDTipoOlho AndAlso f.IDTipoGraduacao = lin.IDTipoGraduacao)

                    With artigoSubstituicao
                        .Id = CLng(0)
                        .IdLinhaDocumentoOrigemInicial = lin.ID
                        .IdArtigoOrigem = lin.IDArtigo
                        .DiametroOrigem = lin.Diametro
                        .CodigoArtigoOrigem = lin.tbArtigos.Codigo
                        .DescricaoArtigoOrigem = lin.Descricao
                        .IDTipoArtigo = lin.tbArtigos.IDTipoArtigo
                        .DiametroDestino = .DiametroOrigem
                        .IDTipoServico = lin.tbServicos.IDTipoServico
                    End With
                End If
            Next

            Servico.Artigos = Servico.Artigos.Where(Function(w) w.IdArtigoOrigem <> 0).ToList()

            'DVLG
            AddSubServicosDocumentosVendasLinhasGraduacoes(Servico)
            For Each dvlg In sv.tbDocumentosVendasLinhasGraduacoes.ToList()
                Dim DVLGNew As DocumentosVendasLinhasGraduacoes = Servico.DocumentosVendasLinhasGraduacoes.Find(Function(f) f.IDTipoOlho = dvlg.IDTipoOlho And f.IDTipoGraduacao = dvlg.IDTipoGraduacao)
                Mapear(dvlg, DVLGNew)

                With DVLGNew
                    .PotenciaCilindrica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaCilindrica)
                    .PotenciaEsferica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaEsferica)
                    .PotenciaPrismatica = ClsUtilitarios.RetornaZeroSeVazioDuplo(DVLGNew.PotenciaPrismatica)
                End With
            Next

            item.Servico = Servico
        End Sub
#End Region

#Region "UPDATE - CRUD "
        Public Overrides Sub EditaObj(ByRef model As DocumentosVendasServicosSubstituicao, filtro As ClsF3MFiltro)
            'get context
            Using ctx As New Aplicacao
                'start transaction
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                    Try
                        Dim idDocVenda As Long = model.ID
                        Dim dbSetDocVenda As tbDocumentosVendas = ctx.tbDocumentosVendas.FirstOrDefault(Function(w) w.ID = idDocVenda)

                        MapeiaGradsEditar(ctx, dbSetDocVenda.tbServicos.FirstOrDefault(), model)

                        MapeiaArtigosEditar(ctx, dbSetDocVenda.tbServicos.FirstOrDefault(), model)

                        With dbSetDocVenda
                            .IDLoja = ClsF3MSessao.RetornaLojaID
                            .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome() : .DataAlteracao = DateAndTime.Now()
                            'reset values
                            .OutrosDescontos = 0 : .TotalPontos = 0 : .TotalValesOferta = 0 : .ValorDesconto = 0 : .ValorPortes = 0
                            .TotalEntidade1 = 0 : .TotalEntidade2 = 0
                            .ValorPago = 0
                            'calcs
                            .TotalClienteMoedaDocumento = 0 : .TotalClienteMoedaReferencia = .TotalClienteMoedaDocumento
                            .TotalIva = 0 : .SubTotal = 0 : .ValorImposto = 0
                            .TotalMoedaDocumento = 0 : .TotalMoedaReferencia = .TotalMoedaDocumento
                        End With

                        With ctx
                            .Entry(dbSetDocVenda).State = EntityState.Modified
                            .SaveChanges()
                        End With

                        'exec sps
                        ExecSp(ctx, dbSetDocVenda.ID, dbSetDocVenda.IDTipoDocumento, AcoesFormulario.Remover)
                        ExecSp(ctx, dbSetDocVenda.ID, dbSetDocVenda.IDTipoDocumento, AcoesFormulario.Adicionar)

                        'lets commit it!
                        trans.Commit()
                    Catch ex As Exception
                        'rollback it!
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Sub MapeiaGradsEditar(ctx As Aplicacao, serv As tbServicos, model As DocumentosVendasServicosSubstituicao)
            For Each grad As tbDocumentosVendasLinhasGraduacoes In serv.tbDocumentosVendasLinhasGraduacoes
                With grad
                    .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome() : .DataAlteracao = DateAndTime.Now()

                    Dim graduacao As DocumentosVendasLinhasGraduacoes = model.Servico.DocumentosVendasLinhasGraduacoes.FirstOrDefault(Function(w) w.IDTipoGraduacao = grad.IDTipoGraduacao AndAlso w.IDTipoOlho = grad.IDTipoOlho)

                    If Not graduacao Is Nothing Then
                        With grad
                            .PotenciaEsferica = graduacao.PotenciaEsferica
                            .PotenciaCilindrica = graduacao.PotenciaCilindrica
                            .PotenciaPrismatica = graduacao.PotenciaPrismatica
                            .BasePrismatica = graduacao.BasePrismatica
                            .Adicao = graduacao.Adicao
                            .Eixo = graduacao.Eixo
                            .RaioCurvatura = graduacao.RaioCurvatura
                            .DetalheRaio = graduacao.DetalheRaio
                            .DNP = graduacao.DNP
                            .Altura = graduacao.Altura
                            .AcuidadeVisual = graduacao.AcuidadeVisual
                            .AnguloPantoscopico = graduacao.AnguloPantoscopico
                            .DistanciaVertex = graduacao.DistanciaVertex
                        End With
                    End If
                End With
            Next
        End Sub

        Private Sub MapeiaArtigosEditar(ctx As Aplicacao, serv As tbServicos, model As DocumentosVendasServicosSubstituicao)
            For Each artigo As DocumentosVendasServicosSubstituicaoArtigos In model.Servico.Artigos
                Dim graduacao As DocumentosVendasLinhasGraduacoes = model.Servico.DocumentosVendasLinhasGraduacoes.
                    FirstOrDefault(Function(w) w.IDTipoGraduacao = artigo.IDTipoGraduacao AndAlso w.IDTipoOlho = artigo.IDTipoOlho)

                If artigo.Id = 0 AndAlso Not String.IsNullOrEmpty(artigo.CodigoArtigoDestino) Then
                    'adiciona
                    MapeiaArtigosEditar_Adiciona(ctx, serv, artigo, graduacao)

                ElseIf artigo.Id <> 0 AndAlso Not String.IsNullOrEmpty(artigo.CodigoArtigoDestino) Then
                    'edita
                    MapeiaArtigosEditar_Edita(ctx, serv, artigo, graduacao)

                ElseIf artigo.Id <> 0 AndAlso String.IsNullOrEmpty(artigo.CodigoArtigoDestino) Then
                    'remove
                    MapeiaArtigosEditar_Remove(ctx, serv, artigo, graduacao)
                End If
            Next
        End Sub

        Private Sub MapeiaArtigosEditar_Adiciona(ctx As Aplicacao, serv As tbServicos, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes)
            Dim linhaOrigem As tbDocumentosVendasLinhas = ctx.tbDocumentosVendasLinhas.AsNoTracking().FirstOrDefault(Function(s) s.ID = artigo.IdLinhaDocumentoOrigemInicial)

            If Not linhaOrigem Is Nothing Then
                Dim armazemPorDefeito As tbArmazensLocalizacoes = RetornaArmazemLocalizacaoLoja(ctx)
                Dim novaLinha As New tbDocumentosVendasLinhas
                novaLinha = linhaOrigem.Map(Of tbDocumentosVendasLinhas)

                With novaLinha
                    .ID = 0 : .F3MMarcador = Nothing : .IDServico = 0 : .IDDocumentoVenda = serv.IDDocumentoVenda
                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now()
                    .UtilizadorAlteracao = Nothing : .DataAlteracao = Nothing
                    .tbDocumentosComprasLinhas = New List(Of tbDocumentosComprasLinhas)
                    .tbDocumentosVendasLinhas1 = New List(Of tbDocumentosVendasLinhas)
                    .tbDocumentosVendasLinhasDimensoes = New List(Of tbDocumentosVendasLinhasDimensoes)
                End With

                With novaLinha
                    If (artigo.IdArtigoDestino = 0) Then
                        Dim product As tbArtigos = RetornaArtigo(ctx, artigo, graduacao)

                        If product Is Nothing Then
                            Dim insertedProduct As tbArtigos = InsereArtigo(ctx, serv, artigo, graduacao)
                            With artigo
                                .IdArtigoDestino = insertedProduct.ID
                                .DescricaoArtigoDestino = insertedProduct.Descricao
                                .CodigoArtigoDestino = insertedProduct.Codigo : .CodigoBarrasArtigoDestino = insertedProduct.CodigoBarras
                            End With

                        Else
                            With artigo
                                .IdArtigoDestino = product.ID
                                .DescricaoArtigoDestino = product.Descricao
                                .CodigoArtigoDestino = product.Codigo : .CodigoBarrasArtigoDestino = product.CodigoBarras
                            End With
                        End If

                        'valores a 0
                        .PrecoUnitario = 0 : .PrecoUnitarioEfetivo = 0 : .PrecoTotal = 0
                        .ValorImposto = 0
                        .TotalFinal = 0
                        .ValorIncidencia = 0 : .ValorIVA = 0
                        .PrecoUnitarioEfetivoSemIva = 0

                    Else
                        If artigo.CustoMedioArtigoDestino Is Nothing Then artigo.CustoMedioArtigoDestino = 0
                        If artigo.TaxaIvaArtigoDestino Is Nothing Then artigo.TaxaIvaArtigoDestino = 0

                        .PrecoUnitario = artigo.CustoMedioArtigoDestino : .PrecoUnitarioEfetivo = .PrecoUnitario : .PrecoTotal = Math.Round(CDbl(.PrecoUnitario * .Quantidade), 4)
                        .ValorIncidencia = Math.Round(CDbl(.PrecoTotal * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                        .TotalFinal = .PrecoTotal
                        .ValorIVA = .TotalFinal - .ValorIncidencia : .ValorImposto = .ValorIVA
                        .PrecoUnitarioEfetivoSemIva = Math.Round(CDbl(.PrecoUnitario * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                        .TotalComDescontoCabecalho = .TotalFinal : .TotalComDescontoLinha = .TotalFinal
                    End If

                    .CodigoArtigo = artigo.CodigoArtigoDestino : .CodigoBarrasArtigo = artigo.CodigoBarrasArtigoDestino
                    .Diametro = artigo.DiametroDestino
                    .IDArtigo = artigo.IdArtigoDestino
                    .Descricao = artigo.DescricaoArtigoDestino
                    .IDLinhaDocumentoOrigemInicial = artigo.IdLinhaDocumentoOrigemInicial
                    .IDDocumentoOrigemInicial = serv.IDDocumentoVenda
                    'armazem
                    .IDArmazem = armazemPorDefeito?.IDArmazem
                    .IDArmazemLocalizacao = armazemPorDefeito?.ID
                    'valores a 0
                    .Desconto1 = 0 : .Desconto2 = 0
                    .ValorDescontoLinha = 0 : .TotalComDescontoLinha = 0
                    .ValorDescontoCabecalho = 0 : .TotalComDescontoCabecalho = 0 : .ValorDescontoEfetivoSemIva = 0
                    .ValorUnitarioEntidade1 = 0 : .ValorUnitarioEntidade2 = 0
                    .ValorEntidade1 = 0 : .ValorEntidade2 = 0
                End With

                ctx.Entry(novaLinha).State = EntityState.Added
                serv.tbDocumentosVendasLinhas.Add(novaLinha)
            End If
        End Sub

        Private Sub MapeiaArtigosEditar_Edita(ctx As Aplicacao, serv As tbServicos, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes)
            Dim artigoBd As tbDocumentosVendasLinhas = serv.tbDocumentosVendasLinhas.FirstOrDefault(Function(s) s.ID = artigo.Id)

            If Not artigoBd Is Nothing Then
                With artigoBd
                    .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome() : .DataAlteracao = DateAndTime.Now()

                    If (artigo.IdArtigoDestino = 0) Then
                        Dim product As tbArtigos = RetornaArtigo(ctx, artigo, graduacao)

                        If product Is Nothing Then
                            Dim insertedProduct As tbArtigos = InsereArtigo(ctx, serv, artigo, graduacao)
                            With artigo
                                .IdArtigoDestino = insertedProduct.ID
                                .DescricaoArtigoDestino = insertedProduct.Descricao
                                .CodigoArtigoDestino = insertedProduct.Codigo : .CodigoBarrasArtigoDestino = insertedProduct.CodigoBarras
                            End With

                        Else
                            With artigo
                                .IdArtigoDestino = product.ID
                                .DescricaoArtigoDestino = product.Descricao
                                .CodigoArtigoDestino = product.Codigo : .CodigoBarrasArtigoDestino = product.CodigoBarras
                            End With
                        End If

                        'valores a 0
                        .PrecoUnitario = 0 : .PrecoUnitarioEfetivo = 0 : .PrecoTotal = 0
                        .ValorImposto = 0
                        .TotalFinal = 0
                        .ValorIncidencia = 0 : .ValorIVA = 0
                        .PrecoUnitarioEfetivoSemIva = 0

                    Else
                        If artigo.CustoMedioArtigoDestino Is Nothing Then artigo.CustoMedioArtigoDestino = 0
                        If artigo.TaxaIvaArtigoDestino Is Nothing Then artigo.TaxaIvaArtigoDestino = 0

                        .PrecoUnitario = artigo.CustoMedioArtigoDestino : .PrecoUnitarioEfetivo = .PrecoUnitario : .PrecoTotal = Math.Round(CDbl(.PrecoUnitario * .Quantidade), 4)
                        .ValorIncidencia = Math.Round(CDbl(.PrecoTotal * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                        .TotalFinal = .PrecoTotal
                        .ValorIVA = .TotalFinal - .ValorIncidencia : .ValorImposto = .ValorIVA
                        .PrecoUnitarioEfetivoSemIva = Math.Round(CDbl(.PrecoUnitario * 100 / (100 + artigo.TaxaIvaArtigoDestino)), 4)
                        .TotalComDescontoCabecalho = .TotalFinal : .TotalComDescontoLinha = .TotalFinal
                    End If

                    .CodigoArtigo = artigo.CodigoArtigoDestino : .CodigoBarrasArtigo = artigo.CodigoBarrasArtigoDestino
                    .Diametro = artigo.DiametroDestino
                    .IDArtigo = artigo.IdArtigoDestino
                    .Descricao = artigo.DescricaoArtigoDestino
                    'valores a 0
                    .Desconto1 = 0 : .Desconto2 = 0
                    .ValorDescontoLinha = 0 : .TotalComDescontoLinha = 0
                    .ValorDescontoCabecalho = 0 : .TotalComDescontoCabecalho = 0 : .ValorDescontoEfetivoSemIva = 0
                    .ValorUnitarioEntidade1 = 0 : .ValorUnitarioEntidade2 = 0
                    .ValorEntidade1 = 0 : .ValorEntidade2 = 0
                End With
            End If
        End Sub

        Private Sub MapeiaArtigosEditar_Remove(ctx As Aplicacao, serv As tbServicos, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes)
            Dim artigoBd As tbDocumentosVendasLinhas = serv.tbDocumentosVendasLinhas.FirstOrDefault(Function(s) s.ID = artigo.Id)
            ctx.Entry(Of tbDocumentosVendasLinhas)(artigoBd).State = EntityState.Deleted
        End Sub
#End Region

#Region "DELETE"
        Public Overrides Sub RemoveObj(ByRef model As DocumentosVendasServicosSubstituicao, filtro As ClsF3MFiltro)
            'get context
            Using ctx As New BD.Dinamica.Aplicacao
                'start transaction
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                    Try
                        ExecSp(ctx, model.ID, model.IDTipoDocumento, AcoesFormulario.Remover)

                        RemoveGraduacoes(ctx, model.IDServico)

                        RemoveArtigos(ctx, model.ID)

                        RemoveServico(ctx, model.IDServico)

                        RemoveDocVenda(ctx, model.ID)

                        'lets commit it!
                        trans.Commit()
                    Catch ex As Exception
                        'rollback it!
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Sub RemoveGraduacoes(ctx As Aplicacao, idServico As Long)
            Dim grads As List(Of tbDocumentosVendasLinhasGraduacoes) = ctx.tbDocumentosVendasLinhasGraduacoes.Where(Function(w) w.IDServico = idServico).ToList()

            If grads.Any() Then
                With ctx
                    'remove all lines
                    .tbDocumentosVendasLinhasGraduacoes.RemoveRange(grads)
                    'set state of all lines to deleted
                    grads.ForEach(Sub(f)
                                      .Entry(f).State = EntityState.Deleted
                                  End Sub)
                    'save it
                    .SaveChanges()
                End With
            End If
        End Sub

        Private Sub RemoveArtigos(ctx As BD.Dinamica.Aplicacao, idDocumentoVenda As Long)
            'remove artigos
            Dim artigos As List(Of tbDocumentosVendasLinhas) = ctx.tbDocumentosVendasLinhas.Where(Function(w) w.IDDocumentoVenda = idDocumentoVenda).ToList()

            If artigos.Any() Then
                With ctx
                    'remove all lines
                    .tbDocumentosVendasLinhas.RemoveRange(artigos)
                    'set state of all lines to deleted
                    artigos.ForEach(Sub(f)
                                        .Entry(f).State = EntityState.Deleted
                                    End Sub)
                    'save it
                    .SaveChanges()
                End With
            End If
        End Sub

        Private Sub RemoveServico(ctx As Aplicacao, id As Long)
            'remove grads
            Dim serv As List(Of tbServicos) = ctx.tbServicos.Where(Function(w) w.ID = id).ToList()

            If serv.Any() Then
                With ctx
                    'remove all lines
                    .tbServicos.RemoveRange(serv)
                    'set state of all lines to deleted
                    serv.ForEach(Sub(f)
                                     .Entry(f).State = Entity.EntityState.Deleted
                                 End Sub)
                    'save it
                    .SaveChanges()
                End With
            End If
        End Sub

        Private Sub RemoveDocVenda(ctx As Aplicacao, id As Long)
            'remove doc venda
            Dim docVenda As tbDocumentosVendas = ctx.tbDocumentosVendas.FirstOrDefault(Function(w) w.ID = id)

            If Not docVenda Is Nothing Then
                With ctx
                    'remove all lines
                    .tbDocumentosVendas.Remove(docVenda)
                    'set state of all lines to deleted
                    .Entry(docVenda).State = EntityState.Deleted
                    'save it
                    .SaveChanges()
                End With
            End If
        End Sub
#End Region

#Region "AUX"
        Private Sub AddSubServicosDocumentosVendasLinhas(DVSL As Servicos, IDServico As Long)
            With DVSL.Artigos
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 1, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 2, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 3, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Aro, .IDTipoGraduacao = TipoGraduacao.Longe})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 4, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 5, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 6, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Aro, .IDTipoGraduacao = TipoGraduacao.Perto})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 7, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Direito, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
                .Add(New DocumentosVendasServicosSubstituicaoArtigos With {.Id = 8, .IDServico = IDServico, .IDTipoOlho = TipoOlho.Esquerdo, .IDTipoGraduacao = TipoGraduacao.LentesContacto})
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

        Private Function GetIdServicoOrigem(docBd As tbDocumentosVendas) As Long
            Dim IDLinhaDocumentoOrigemInicial As Long = docBd.tbDocumentosVendasLinhas.FirstOrDefault().IDLinhaDocumentoOrigemInicial
            Return BDContexto.tbDocumentosVendasLinhas.FirstOrDefault(Function(s) s.ID = IDLinhaDocumentoOrigemInicial).IDServico
        End Function

        Private Function RetornaDescricaoServico(idServico As Long) As String
            Dim servico As tbServicos = BDContexto.tbServicos.FirstOrDefault(Function(w) w.ID = idServico)
            Return RetornaDescricaoServico(servico)
        End Function

        Private Function RetornaDescricaoServico(serv As tbServicos) As String
            Dim res As String = String.Empty

            Select Case serv.tbSistemaTiposServicos.Codigo
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

            Return serv.tbDocumentosVendas.Documento & " " & res
        End Function

        Private Function RetornaDescricaoTipoServico(idServico As Long) As String
            Dim servico As tbServicos = BDContexto.tbServicos.FirstOrDefault(Function(w) w.ID = idServico)
            Return RetornaDescricaoTipoServico(servico)
        End Function

        Private Function RetornaDescricaoTipoServico(serv As tbServicos) As String
            Select Case serv.tbSistemaTiposServicos.Codigo
                Case "U"
                    Return Traducao.EstruturaDocumentos.LongePerto
                Case "L"
                    Return Traducao.EstruturaDocumentos.Longe
                Case "P"
                    Return Traducao.EstruturaDocumentos.Perto
                Case "B", "BOE", "BOD"
                    res = Traducao.EstruturaDocumentos.Bifocal
                Case "G", "POE", "POD"
                    Return Traducao.EstruturaDocumentos.Progressiva
            End Select

            Return String.Empty
        End Function

        Private Sub ExecSp(ctx As Aplicacao, id As Long, idTipoDocumento As Long, acaoForm As AcoesFormulario)
            ctx.sp_AtualizaStock(id,
                                 idTipoDocumento,
                                 acaoForm,
                                 NameOf(tbDocumentosVendas),
                                 NameOf(tbDocumentosVendasLinhas),
                                 String.Empty,
                                 NameOf(tbDocumentosVendasLinhas.IDDocumentoVenda),
                                 String.Empty,
                                 ClsF3MSessao.RetornaUtilizadorNome,
                                 False,
                                 False)
        End Sub

        Public Function GetTaxaIva(ctx As Aplicacao) As tbIVA
            Return ctx.tbIVA.FirstOrDefault(Function(w) w.Codigo = "RED")
        End Function

        Public Function GetTipoArtigo(ctx As Aplicacao, serv As tbServicos) As Long
            If serv.IDTipoServico = TipoServico.Contacto Then Return ctx.tbTiposArtigos.FirstOrDefault(Function(s) s.IDSistemaClassificacao = TipoArtigo.LentesContacto AndAlso s.Sistema).ID
            Return ctx.tbTiposArtigos.FirstOrDefault(Function(s) s.IDSistemaClassificacao = TipoArtigo.LentesOftalmicas AndAlso s.Sistema).ID
        End Function

        Private Function RetornaArmazemLocalizacaoLoja(ctx As Aplicacao) As tbArmazensLocalizacoes
            Dim strIDLoc As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao
            If IsNumeric(strIDLoc) AndAlso strIDLoc <> 0 Then Return ctx.tbArmazensLocalizacoes.FirstOrDefault(Function(w) w.ID = strIDLoc)
            Return Nothing
        End Function

        Public Function AtribuirCodigo(ctx As Aplicacao, serv As tbServicos) As String
            Dim intTam As Integer = 3
            Dim tipo As String = If(serv.IDTipoServico = TipoServico.Contacto, "LC", "LO")
            If tipo.Length > 2 Then intTam = tipo.Length + 1

            Dim nextCode As Long? = ctx.Database.SqlQuery(Of Long?)(" " &
                                                                    " select max(cast(substring(a.codigo," & intTam & ",10) as bigint)) as codigo " &
                                                                    " from tbartigos a inner join tbtiposartigos ta on a.idtipoartigo=ta.id " &
                                                                    "   inner join tbSistemaClassificacoesTiposArtigos sta on ta.idsistemaclassificacao=sta.id " &
                                                                    " where ta.codigo like '%" & tipo & "%' and substring(a.codigo," & intTam & ",10) not like '%[^0-9]%'").FirstOrDefault()

            If Not nextCode Is Nothing Then Return tipo & (nextCode + 1)
            Return tipo + "1"
        End Function

        Public Function ValidaExisteArtigo(model As DocumentosVendasServicosSubstituicao) As DocumentosVendasServicosSubstituicao
            Dim artigos As List(Of DocumentosVendasServicosSubstituicaoArtigos) = model.Servico.Artigos.Where(Function(f) Not String.IsNullOrEmpty(f.CodigoArtigoDestino) AndAlso (f.IDTipoOlho = TipoOlho.Direito OrElse f.IDTipoOlho = TipoOlho.Esquerdo)).ToList()

            For Each artigo As DocumentosVendasServicosSubstituicaoArtigos In artigos
                Dim graduacao As DocumentosVendasLinhasGraduacoes = model.Servico.DocumentosVendasLinhasGraduacoes.FirstOrDefault(Function(w) w.IDTipoOlho = artigo.IDTipoOlho AndAlso w.IDTipoGraduacao = artigo.IDTipoGraduacao)

                Dim dbSetArtigo As tbArtigos = RetornaArtigo(artigo, graduacao)
                If dbSetArtigo Is Nothing Then
                    artigo.IdArtigoDestino = 0
                    artigo.CodigoArtigoDestino = If(artigo.IDTipoServico = TipoServico.Contacto, "LC", "LO")
                    artigo.DescricaoArtigoDestino = ControiDescricaoArtigo(artigo, graduacao)

                Else
                    artigo.IdArtigoDestino = dbSetArtigo.ID
                    artigo.CodigoArtigoDestino = dbSetArtigo.Codigo
                    artigo.DescricaoArtigoDestino = dbSetArtigo.Descricao
                End If
            Next

            Return model
        End Function

        Private Function ControiDescricaoArtigo(artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes)
            Dim lst As New List(Of String)
            If Not String.IsNullOrEmpty(artigo.DescricaoMarca) Then lst.Add(artigo.DescricaoMarca)
            If Not String.IsNullOrEmpty(artigo.DescricaoModelo) Then lst.Add(artigo.DescricaoModelo)
            If Not IsNothing(artigo.DescricaoTratamentoLente) Then lst.Add(artigo.DescricaoTratamentoLente)
            If Not IsNothing(artigo.DescricaoCorLente) Then lst.Add(artigo.DescricaoCorLente)
            If artigo.IDsSuplementos?.Any() Then
                lst.AddRange(BDContexto.tbSuplementosLentes.Where(Function(f) artigo.IDsSuplementos.Contains(f.ID)).Select(Function(x) x.Descricao).ToList())
            End If

            Dim descricao As String = String.Join(", ", lst)

            Dim PotEsf = graduacao.PotenciaEsferica
            Dim PotCil = graduacao.PotenciaCilindrica

            If artigo.IDTipoLente = TipoServico.Contacto Then
                descricao += " Diam:" & artigo.DiametroDestino
                descricao += " Raio:" & artigo.RaioCurvatura
                If PotEsf <> 0 Then descricao += " Esf:" & PotEsf
                If PotCil <> 0 Then descricao += " Cil:" & PotCil
                If graduacao.Adicao <> 0 Then descricao += " Add:" & graduacao.Adicao
                If graduacao.Eixo <> 0 Then descricao += " AX:" & graduacao.Eixo

            Else
                descricao += " Diam:" & artigo.DiametroDestino
                If PotEsf <> 0 Then descricao += " Esf:" & PotEsf
                If PotCil <> 0 Then descricao += " Cil:" & PotCil
                If graduacao.Adicao <> 0 Then descricao += " Add:" & graduacao.Adicao
                If graduacao.PotenciaPrismatica <> 0 Then descricao += " Prism:" & graduacao.PotenciaPrismatica
            End If

            Return descricao
        End Function
#End Region

#Region "ARTIGOS"
        Private Function InsereArtigo(ctx As Aplicacao, serv As tbServicos, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes) As tbArtigos
            Dim txIva As tbIVA = GetTaxaIva(ctx)
            Dim dbSetArtigo As New tbArtigos
            With dbSetArtigo
                .Codigo = AtribuirCodigo(ctx, serv) : .Descricao = Left(artigo.DescricaoArtigoDestino, 200)
                .CodigoBarras = .Codigo
                .IDTipoArtigo = GetTipoArtigo(ctx, serv) : .IDGrupoArtigo = 1 : .IDMarca = artigo.IDMarca : .IDTaxa = txIva.ID
                .IDSistemaClassificacao = If(serv.IDTipoServico = TipoServico.Contacto, 3, 1)
                .IDUnidade = 1 : .IDUnidadeVenda = 1 : .IDUnidadeCompra = 1 : .IDTipoPreco = 1 : .DescricaoVariavel = 1
                .DedutivelPercentagem = 100 : .IncidenciaPercentagem = 100
                .GereLotes = False : .GereStock = True : .DescricaoVariavel = True : .Inventariado = True
                .Ativo = True : .Sistema = False
                .DataCriacao = DateTime.Now : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome

                If (artigo.Preco Is Nothing) Then artigo.Preco = 0
                .tbArtigosPrecos = New List(Of tbArtigosPrecos) From {New tbArtigosPrecos With {
                    .IDCodigoPreco = 1, .ValorComIva = artigo.Preco, .ValorSemIva = Math.Round(CDbl(artigo.Preco * 100 / (100 + txIva.Taxa)), 4),
                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome(), .DataCriacao = DateAndTime.Now()
                }}
            End With

            Select Case serv.IDTipoServico
                Case TipoServico.Contacto
                    Dim lc As New tbLentesContato
                    With lc
                        .IDModelo = artigo.IDModelo
                        .Diametro = artigo.DiametroDestino
                        .PotenciaCilindrica = graduacao.PotenciaCilindrica : .PotenciaEsferica = graduacao.PotenciaEsferica : .Adicao = graduacao.Adicao
                        .Raio = graduacao.RaioCurvatura : .Raio2 = artigo.DetalheRaio : .Eixo = graduacao.Eixo
                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now()
                    End With
                    dbSetArtigo.tbLentesContato = New List(Of tbLentesContato) From {lc}

                Case Else
                    Dim lo As New tbLentesOftalmicas
                    With lo
                        .IDModelo = artigo.IDModelo : .Diametro = artigo.DiametroDestino
                        If artigo.IDTratamentoLente = 0 Then .IDTratamentoLente = Nothing Else .IDTratamentoLente = artigo.IDTratamentoLente
                        If artigo.IDCorLente = 0 Then .IDCorLente = Nothing Else .IDCorLente = artigo.IDCorLente
                        .PotenciaCilindrica = graduacao.PotenciaCilindrica : .PotenciaEsferica = graduacao.PotenciaEsferica : .PotenciaPrismatica = graduacao.PotenciaPrismatica : .Adicao = graduacao.Adicao
                        .CodigosSuplementos = String.Empty
                        .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome() : .DataCriacao = DateAndTime.Now()

                        If artigo.IDsSuplementos?.Any() Then
                            .CodigosSuplementos = String.Join("-", artigo.IDsSuplementos)

                            .tbLentesOftalmicasSuplementos = New List(Of tbLentesOftalmicasSuplementos)
                            For Each suplemento As Long In artigo.IDsSuplementos
                                Dim sup As New tbLentesOftalmicasSuplementos
                                With sup
                                    .IDSuplementoLente = suplemento
                                    .DataCriacao = DateTime.Now() : .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorID
                                End With

                                .tbLentesOftalmicasSuplementos.Add(sup)
                            Next
                        End If
                    End With
                    dbSetArtigo.tbLentesOftalmicas = New List(Of tbLentesOftalmicas) From {lo}
            End Select

            With ctx
                .tbArtigos.Add(dbSetArtigo)
                .Entry(dbSetArtigo).State = EntityState.Added
                .SaveChanges()
            End With

            Return dbSetArtigo
        End Function

        Public Function RetornaArtigo(artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes) As tbArtigos
            Return RetornaArtigo(BDContexto, artigo, graduacao)
        End Function

        Public Function RetornaArtigo(ctx As Aplicacao, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes) As tbArtigos
            Select Case artigo.IDTipoServico
                Case TipoServico.Contacto
                    Return RetornaArtigoLC(ctx, artigo, graduacao)

                Case Else
                    Return RetornaArtigoLO(ctx, artigo, graduacao)
            End Select
        End Function

        Private Function RetornaArtigoLC(ctx As Aplicacao, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes) As tbArtigos
            Dim strQry As String = String.Empty, strCond As String = String.Empty, strGraduacao1 As String = String.Empty, strGraduacao2 As String = String.Empty

            strCond = " where idmodelo=" & ClsUtilitarios.EnvolveSQL(artigo.IDModelo)

            If Not String.IsNullOrEmpty(graduacao.RaioCurvatura) Then strCond = strCond & " and raio=" & ClsUtilitarios.EnvolveSQL(graduacao.RaioCurvatura)

            If Not graduacao.Adicao Is Nothing Then strCond = strCond & " and adicao=" & graduacao.Adicao.ToString.Replace(",", ".")

            If Not graduacao.PotenciaEsferica Is Nothing Then strGraduacao1 = " and PotenciaEsferica=" & graduacao.PotenciaEsferica.ToString.Replace(",", ".")
            If Not graduacao.PotenciaCilindrica Is Nothing Then strGraduacao1 = strGraduacao1 & " and PotenciaCilindrica=" & graduacao.PotenciaCilindrica.ToString.Replace(",", ".")

            If Not graduacao.PotenciaEsferica Is Nothing Then strGraduacao2 = " and PotenciaEsferica=" & (graduacao.PotenciaEsferica + graduacao.PotenciaCilindrica).ToString.Replace(",", ".")
            If Not graduacao.PotenciaCilindrica Is Nothing Then strGraduacao2 = strGraduacao2 & " and PotenciaCilindrica=-(" & graduacao.PotenciaCilindrica.ToString.Replace(",", ".") & ")"

            If graduacao.Eixo <> 0 Then strCond = strCond & " and eixo=" & graduacao.Eixo

            If Not String.IsNullOrEmpty(artigo.DiametroDestino) Then strCond = strCond & " and diametro=" & ClsUtilitarios.EnvolveSQL(artigo.DiametroDestino)

            strQry = "select idartigo from tblentescontato with (nolock) " & strCond & strGraduacao1 &
                                " union select idartigo from tblentescontato with (nolock) " & strCond & strGraduacao2


            strQry = "SELECT * FROM tbArtigos AS A INNER JOIN (" & strQry & " ) AS T ON A.ID = T.idartigo"

            Return ctx.Database.SqlQuery(Of tbArtigos)(strQry).FirstOrDefault
        End Function

        Private Function RetornaArtigoLO(ctx As Aplicacao, artigo As DocumentosVendasServicosSubstituicaoArtigos, graduacao As DocumentosVendasLinhasGraduacoes) As tbArtigos
            Dim strQry As String = String.Empty, strCond As String = String.Empty, strGraduacao1 As String = String.Empty, strGraduacao2 As String = String.Empty

            strCond = " where idmodelo = " & ClsUtilitarios.EnvolveSQL(artigo.IDModelo)

            strCond = If(artigo.IDCorLente = 0 OrElse artigo.IDCorLente Is Nothing, strCond & " and IDCorLente is null ", strCond & " and IDCorLente=" & artigo.IDCorLente)

            strCond = If(artigo.IDTratamentoLente = 0 OrElse artigo.IDTratamentoLente Is Nothing, strCond & " and IDTratamentoLente is null ", strCond & " and IDTratamentoLente=" & artigo.IDTratamentoLente)

            strCond = If(artigo.IDsSuplementos?.Any(), strCond & " and codigossuplementos=" & ClsUtilitarios.EnvolveSQL(String.Join("-", artigo.IDsSuplementos)), strCond & " and codigossuplementos=''")

            If Not String.IsNullOrEmpty(artigo.DiametroDestino) Then strCond = strCond & " and diametro=" & ClsUtilitarios.EnvolveSQL(artigo.DiametroDestino)

            If Not graduacao.PotenciaPrismatica Is Nothing Then strCond = strCond & " and PotenciaPrismatica=" & graduacao.PotenciaPrismatica.ToString.Replace(",", ".")

            If graduacao.Adicao <> 0 AndAlso artigo.IDTipoLente IsNot Nothing AndAlso artigo.IDTipoLente = 1 Then ' Unifocal
                graduacao.Adicao = 0
            End If

            strCond = strCond & " and adicao=" & graduacao.Adicao.ToString.Replace(",", ".")

            strGraduacao1 = " and PotenciaEsferica=" & graduacao.PotenciaEsferica.ToString.Replace(",", ".")
            strGraduacao1 = strGraduacao1 & " and PotenciaCilindrica=" & graduacao.PotenciaCilindrica.ToString.Replace(",", ".")

            strGraduacao2 = " and PotenciaEsferica=" & (graduacao.PotenciaEsferica + graduacao.PotenciaCilindrica).ToString.Replace(",", ".")
            strGraduacao2 = strGraduacao2 & " and PotenciaCilindrica=-(" & graduacao.PotenciaCilindrica.ToString.Replace(",", ".") & ")"

            strQry = "select idartigo from tblentesoftalmicas with (nolock) " & strCond & strGraduacao1 &
                " union select idartigo from tblentesoftalmicas with (nolock) " & strCond & strGraduacao2

            strQry = "SELECT * FROM tbArtigos AS A INNER JOIN (" & strQry & " ) AS T ON A.ID = T.idartigo"

            Return ctx.Database.SqlQuery(Of tbArtigos)(strQry).FirstOrDefault
        End Function
#End Region
    End Class
End Namespace