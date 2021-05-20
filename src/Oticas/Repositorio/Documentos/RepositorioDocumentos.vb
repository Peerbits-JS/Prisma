Imports F3M
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports System.Data.Entity

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentos(Of ContextoBD As {DbContext, New}, TipoEntidade As Class, TipoObjeto As Class)
        Inherits RepositorioGenerico(Of ContextoBD, TipoEntidade, TipoObjeto)

        Sub New()
            MyBase.New()
        End Sub


#Region "CALCULA GERAL DOCUMENTOS"

        Public Shared Function CalculaGeralDoc(Of TDocBD As Class, TDocMOD As CabecalhoDocumento, TDocLinhasBD As Class, TDocLinhasMOD As DocumentosLinhas)(
                    ByRef ctx As DbContext, ByRef doc As CabecalhoDocumento, ByVal colunaAlterada As String) As CabecalhoDocumento
            ' ***************** CARREGAR A INFORMAÇÃO POR DEFEITO *****************
            ' Se a coluna alterada corresponde ao código do artigo vamos inicializar algumas propriedades
            ' mas apenas para a linha que está a ser alterada
            Dim acaoLinha As AcoesFormulario = AcoesFormulario.Adicionar

            Dim idTipoDocumento As Long = doc.IDTipoDocumento
            Dim tipoDocDB As tbTiposDocumento = ctx.Set(Of tbTiposDocumento)().AsNoTracking _
                .Include("tbSistemaTiposDocumentoMovStock") _
                .Where(Function(td) td.ID = idTipoDocumento) _
                .FirstOrDefault

            doc.CodigoSisTiposMovStock = tipoDocDB.tbSistemaTiposDocumentoMovStock?.Codigo
            doc.TipoDocGereStock = tipoDocDB.GereStock

            ' Lista de todas as linhas que vêm no modelo
            Dim lstDocLinhas As List(Of TDocLinhasMOD) = ClsUtilitarios.DaPropriedadedoModeloReflection(doc, GetType(TDocLinhasMOD).Name)

            If lstDocLinhas IsNot Nothing AndAlso lstDocLinhas.Count > 0 Then
                Select Case colunaAlterada
                    Case "CodigoArtigo"
                        Dim funcWhere As Func(Of TDocLinhasMOD, Boolean) = Function(dl) CObj(dl).CarregaInfPorDefeito

                        For Each linhaDoc In lstDocLinhas.Where(funcWhere)
                            acaoLinha = If(linhaDoc.AcaoCRUD, AcoesFormulario.Adicionar)

                            ' Só considera as linhas com ID artigo, para não fazer nada com as linhas dos titulos/separadores
                            If acaoLinha <> AcoesFormulario.Remover And linhaDoc.IDArtigo <> 0 Then
                                ' Carregar a informação geral a aplicar por defeito ao atigo
                                ' Inclui: descrição variável, preço unitário, unidades, quantidades, ...
                                CarregaInfGeralPorDefeitoArtigo(Of TDocMOD, TDocLinhasMOD)(ctx, doc, linhaDoc)
                                ' Carregar o lote por defeito
                                CarregaLotePorDefeito(ctx, doc, linhaDoc)
                                ' Carrega os armazéns por defeito
                                CarregaArmazemPorDefeito(ctx, doc, linhaDoc)

                                linhaDoc.Descricao = TrataDescricaoAtigoIdioma(ctx, doc, linhaDoc)

                                ' Depois de carregar a linha marca a propriedade para não voltar a mexer
                                linhaDoc.CarregaInfPorDefeito = False
                            End If
                        Next
                    Case "TaxaIva", "CodigoTaxaIva"
                        For Each linhaDoc In lstDocLinhas
                            acaoLinha = If(linhaDoc.AcaoCRUD, AcoesFormulario.Adicionar)
                            ' Só considera as linhas com ID artigo, para não fazer nada com as linhas dos titulos/separadores
                            If acaoLinha <> AcoesFormulario.Remover AndAlso linhaDoc.IDArtigo <> 0 Then
                                PreencherTaxaIvaDaLinha(ctx, doc, linhaDoc, False)
                            End If
                        Next

                    Case "Desconto1"
                        For Each linhaDoc In lstDocLinhas
                            acaoLinha = If(linhaDoc.AcaoCRUD, 0)
                            ' Só considera as linhas com ID artigo, para não fazer nada com as linhas dos titulos/separadores
                            If acaoLinha <> AcoesFormulario.Remover AndAlso linhaDoc.IDArtigo <> 0 Then
                            Else
                                linhaDoc.Desconto1 = 0
                            End If
                        Next
                    Case "Desconto2"
                        For Each linhaDoc In lstDocLinhas
                            acaoLinha = If(linhaDoc.AcaoCRUD, AcoesFormulario.Adicionar)
                            ' Só considera as linhas com ID artigo, para não fazer nada com as linhas dos titulos/separadores
                            If acaoLinha <> AcoesFormulario.Remover And linhaDoc.IDArtigo <> 0 Then
                            Else
                                linhaDoc.Desconto2 = 0
                            End If
                        Next
                    Case "IDEntidade"
                        For Each linhaDoc In lstDocLinhas
                            linhaDoc.Descricao = TrataDescricaoAtigoIdioma(ctx, doc, linhaDoc)
                        Next
                End Select
            End If

            ' ***************** TRATAR UNIDADES E CALCULAR TOTAIS *****************
            If lstDocLinhas Is Nothing OrElse lstDocLinhas.Count = 0 Then
                ' Se o documento não tem linhas os totais são inicializados
                With doc
                    .SubTotal = Nothing
                    .TotalMoedaDocumento = Nothing
                    .TotalMoedaReferencia = Nothing
                    .ValorImposto = Nothing
                End With
            Else
                Dim TotalMoedaDocumento As Double = 0
                Dim TotalMoedaDocumentoAnterior As Double = 0
                Dim TotalImpostoMoedaDocumento As Double = 0
                Dim TotalImpostoMoedaDocumentoAnterior As Double = 0
                Dim TotalDescontosLinha As Double = 0
                Dim TotalDescontosLinhaAnterior As Double = 0
                Dim SubTotal As Double = 0

                Dim intCasasDecTotais As Integer?
                Dim intCasasDecImposto As Integer?
                Dim intCasasDecPrecosUni As Integer?

                ' Preencher as casas decimais a usar
                If doc.IDMoeda IsNot Nothing Then
                    intCasasDecTotais = doc.CasasDecimaisTotais
                    intCasasDecImposto = doc.CasasDecimaisIva
                    intCasasDecPrecosUni = doc.CasasDecimaisPrecosUnitarios
                Else
                    intCasasDecTotais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais
                    intCasasDecImposto = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisIva
                    intCasasDecPrecosUni = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios
                End If

                Dim lstUnidades As List(Of tbUnidades) = ctx.Set(Of tbUnidades)().AsNoTracking.ToList

                For Each DSL In lstDocLinhas
                    acaoLinha = If(DSL.AcaoCRUD, AcoesFormulario.Adicionar)
                    ' Só considera as linhas com ID artigo, para não fazer nada com as linhas dos titulos/separadores
                    If acaoLinha <> AcoesFormulario.Remover AndAlso DSL.IDArtigo <> 0 Then
                        ' Se foi marcado que é preciso rever as taxas de iva então NÃO vamos proceder à revisão 
                        ' das regras das quantidades nem ao recalculo destas
                        If doc.ReverTaxasIva = False Then
                            ' Preencher a informação das unidades e determinar as respetivas quantidades
                            PreencherInfUnidadeQtds(ctx, DSL, lstUnidades)
                        End If

                        'tratar o caso especial das linhas importadas
                        If DSL.DocumentoOrigemCarregaPrecoTaxasPorDefeito Then
                            ' Carregar o preço unitario
                            DSL.PrecoUnitario =
                                    PreenchePUnitarioArtigo(
                                        ctx, doc.CodigoSistemaTiposDocumentoPrecoUnitario,
                                        If(doc.IDEntidade Is Nothing, 0, doc.IDEntidade), DSL.IDArtigo)

                            If DSL.PrecoUnitario Is Nothing Then
                                DSL.PrecoUnitario = 0
                            End If

                            DSL.PrecoUnitario = ClsUtilitarios.ConverteValorMoeda(DSL.PrecoUnitario,
                                    ClsF3MSessao.RetornaParametros.MoedaReferencia.TaxaConversao, If(doc.TaxaConversao, 0),
                                    doc.CasasDecimaisPrecosUnitarios)

                            ' Carregar a informação do IVA
                            PreencherTaxaIvaDaLinha(Of TDocMOD, TDocLinhasMOD)(ctx, doc, DSL, True)

                            Dim idart As Long = DSL.IDArtigo
                            Dim artigo As tbArtigos = ctx.Set(Of tbArtigos)().Where(Function(a) a.ID = idart AndAlso a.Ativo).FirstOrDefault

                            ' Tipo de preço
                            DSL.IDTipoPreco = artigo.IDTipoPreco
                            DSL.CodigoTipoPreco = Nothing
                            DSL.PercIncidencia = artigo.IncidenciaPercentagem
                            DSL.PercDeducao = artigo.DedutivelPercentagem

                            DSL.DocumentoOrigemCarregaPrecoTaxasPorDefeito = False
                        End If

                        ' Atribuir os valores para a definição das casas decimais a aplicar nas linhas
                        DSL.CasasDecimaisPrecosUnitarios = intCasasDecPrecosUni
                        DSL.CasasDecimaisTotais = intCasasDecTotais
                        DSL.CasasDecimaisIva = intCasasDecImposto

                        ' Valores da linha
                        If doc.DocNaoValorizado = True Then
                            DSL.PrecoUnitario = Nothing
                            DSL.PrecoTotal = Nothing
                            DSL.PrecoTotalAnterior = Nothing
                            DSL.IDTaxaIva = Nothing
                            DSL.CodigoTaxaIva = Nothing
                            DSL.TaxaIva = Nothing
                            DSL.CodigoMotivoIsencaoIva = Nothing
                            DSL.MotivoIsencaoIva = Nothing
                            DSL.IDTipoIva = Nothing
                            DSL.IDCodigoIva = Nothing
                            DSL.IDEspacoFiscal = Nothing
                            DSL.IDRegimeIva = Nothing
                            DSL.ValorIncidencia = Nothing
                            DSL.ValorIVA = Nothing
                            DSL.ValorIvaAnterior = Nothing
                            DSL.CodigoTipoIva = Nothing
                            DSL.CodigoRegiaoIva = Nothing
                            DSL.PercIncidencia = Nothing
                            DSL.PercDeducao = Nothing
                            DSL.ValorIvaDedutivel = Nothing
                            DSL.Desconto1 = Nothing
                            DSL.Desconto2 = Nothing
                            DSL.ValorDescontoLinha = Nothing
                            DSL.ValorDescontoLinhaAnterior = Nothing
                        Else
                            ' Atualizar os valores da linha
                            If DSL.Quantidade Is Nothing Then
                                DSL.Quantidade = 0
                            End If

                            DSL.Quantidade = Math.Round(CDbl(DSL.Quantidade), CInt(DSL.NumCasasDecUnidade), MidpointRounding.AwayFromZero)

                            If DSL.PrecoUnitario Is Nothing Then
                                DSL.PrecoUnitario = 0
                            End If

                            If DSL.Desconto1 Is Nothing Then
                                DSL.Desconto1 = 0
                            End If

                            If DSL.Desconto2 Is Nothing Then
                                DSL.Desconto2 = 0
                            End If

                            If DSL.Desconto1 > 100 Then
                                DSL.Desconto1 = 100
                            End If

                            If DSL.Desconto2 > 100 Then
                                DSL.Desconto2 = 100
                            End If

                            '   Garantir que não tem valores negativos
                            If DSL.Quantidade < 0 Then DSL.Quantidade = 1
                            If DSL.QuantidadeStock < 0 Then DSL.QuantidadeStock = 1
                            If DSL.QuantidadeStock2 < 0 Then DSL.QuantidadeStock2 = 1
                            If DSL.PrecoUnitario < 0 Then DSL.PrecoUnitario = 0
                            If DSL.Desconto1 < 0 Then DSL.Desconto1 = 0
                            If DSL.Desconto2 < 0 Then DSL.Desconto2 = 0

                            If colunaAlterada = "CodigoArtigo" Then
                                Select Case GetType(TDocMOD).Name
                                    Case GetType(DocumentosCompras).Name
                                        '   Sugerir por defeito os descontos do fornecedor
                                        Dim entBD As tbFornecedores = ctx.Set(Of tbFornecedores)().Find(doc.IDEntidade)

                                        If entBD IsNot Nothing Then
                                            DSL.Desconto1 = entBD.Desconto1
                                            DSL.Desconto2 = entBD.Desconto2
                                        End If
                                    Case GetType(DocumentosVendas).Name
                                        '   Sugerir por defeito os descontos do Cliente
                                        Dim entBD As tbClientes = ctx.Set(Of tbClientes)().Find(doc.IDEntidade)

                                        If entBD IsNot Nothing Then
                                            DSL.Desconto1 = entBD.Desconto1
                                            DSL.Desconto2 = entBD.Desconto2
                                        End If
                                End Select
                            End If

                            '   Totalizar os valores anteriores
                            TotalMoedaDocumentoAnterior += If(DSL.PrecoTotalAnterior, 0)
                            TotalImpostoMoedaDocumentoAnterior += If(DSL.ValorIvaAnterior, 0)
                            TotalDescontosLinhaAnterior += If(DSL.ValorDescontoLinhaAnterior, 0)

                            ' Determinar os novos valores
                            DSL.PrecoTotal = Math.Round(CDbl(DSL.PrecoUnitario * DSL.Quantidade), If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)

                            ' Tratar Desconto1 e Desconto2  
                            DSL.ValorDescontoLinha = 0.0
                            DSL.ValorDescontoLinha = Math.Round(If(DSL.PrecoTotal, 0.0) * (If(DSL.Desconto1, 0.0) / 100), If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                            DSL.ValorDescontoLinha += Math.Round((If(DSL.PrecoTotal, 0.0) - If(DSL.ValorDescontoLinha, 0.0)) * (If(DSL.Desconto2, 0.0) / 100), If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                            DSL.TotalSemDescontoLinha = DSL.PrecoTotal
                            DSL.TotalComDescontoLinha = DSL.PrecoTotal - DSL.ValorDescontoLinha
                            DSL.PrecoTotal = DSL.PrecoTotal - DSL.ValorDescontoLinha
                            DSL.PrecoTotalAnterior = DSL.PrecoTotal

                            ' Se foi marcado que é preciso rever as taxas de iva então vamos proceder à sua revisão/atualização
                            If doc.ReverTaxasIva = True Then
                                PreencherTaxaIvaDaLinha(Of TDocMOD, TDocLinhasMOD)(ctx, CObj(doc), DSL, True)
                            End If

                            If DSL.TaxaIva Is Nothing Then
                                DSL.TaxaIva = 0
                            End If

                            Select Case GetType(TDocMOD).Name
                                Case GetType(DocumentosCompras).Name
                                    'Portes
                                    If DSL.ValorDescontoCabecalho Is Nothing OrElse DSL.CodigoSistemaClassificacoesTiposArtigos = TiposFormaPagamento.PermutaBens Then
                                        DSL.ValorDescontoCabecalho = 0.0
                                    End If

                                    DSL.ValorIncidencia = DSL.PrecoTotal
                                    DSL.ValorIVA = Math.Round(CDbl(DSL.PrecoTotal * (DSL.TaxaIva / 100)), If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                                Case Else
                                    DSL.ValorIncidencia = Math.Round(CDbl(DSL.PrecoTotal * (If(DSL.PercIncidencia, 0) / 100)), If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                                    DSL.ValorIVA = Math.Round(CDbl(DSL.ValorIncidencia * (DSL.TaxaIva / 100)), If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                            End Select

                            DSL.ValorIvaAnterior = DSL.ValorIVA
                            DSL.ValorIvaDedutivel = Math.Round(CDbl(DSL.ValorIVA * (If(DSL.PercDeducao, 0) / 100)), If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)

                            ' Totalizar os novos valores para o cabeçalho
                            TotalMoedaDocumento += DSL.PrecoTotal
                            TotalImpostoMoedaDocumento += DSL.ValorIVA
                            TotalDescontosLinha += DSL.ValorDescontoLinha
                        End If
                    End If
                Next

                ' Preencher as propriedades dos totais no modelo
                If doc.DocNaoValorizado = True Then
                    With doc
                        .TotalMoedaDocumento = Nothing
                        .TotalMoedaReferencia = Nothing
                        .ValorImposto = Nothing
                        .SubTotal = Nothing
                        .DescontosLinha = Nothing
                    End With
                Else
                    With doc
                        If .TotalMoedaDocumento Is Nothing Then
                            .TotalMoedaDocumento = 0
                        End If
                        If .TotalMoedaReferencia Is Nothing Then
                            .TotalMoedaReferencia = 0
                        End If
                        If .SubTotal Is Nothing Then
                            .SubTotal = 0
                        End If
                        If .PercentagemDesconto Is Nothing Then
                            .PercentagemDesconto = 0
                        End If
                        If .ValorDesconto Is Nothing Then
                            .ValorDesconto = 0
                        End If
                        If .ValorImposto Is Nothing Then
                            .ValorImposto = 0
                        End If
                        If .DescontosLinha Is Nothing Then
                            .DescontosLinha = 0
                        End If

                        ' Se tem mais que uma linha significa que os totais correspondem ao somatório das linhas
                        ' Se apenas tem uma linha é preciso retirar os valores anteriores e acrescentar os novos
                        If lstDocLinhas.Count > 1 Then
                            ' Acrescentar os novos valores
                            .TotalMoedaDocumento = Math.Round(TotalMoedaDocumento + TotalImpostoMoedaDocumento, If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                            .ValorImposto = Math.Round(TotalImpostoMoedaDocumento, If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                            .DescontosLinha = TotalDescontosLinha
                        Else
                            ' Retirar o valor anterior da linha
                            .TotalMoedaDocumento -= Math.Round(TotalMoedaDocumentoAnterior + TotalImpostoMoedaDocumentoAnterior, If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                            .ValorImposto -= Math.Round(TotalImpostoMoedaDocumentoAnterior, If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                            .DescontosLinha -= Math.Round(TotalDescontosLinhaAnterior, If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)

                            ' Acrescentar os novos valores
                            .TotalMoedaDocumento += Math.Round(TotalMoedaDocumento + TotalImpostoMoedaDocumento, If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                            .ValorImposto += Math.Round(TotalImpostoMoedaDocumento, If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                            .DescontosLinha += Math.Round(TotalDescontosLinha, If(intCasasDecTotais, 0), MidpointRounding.AwayFromZero)
                        End If

                        ' Calcular o valor na moeda de referência
                        .TotalMoedaReferencia = ClsUtilitarios.ConverteValorMoeda(.TotalMoedaDocumento, If(doc.TaxaConversao, 0), ClsF3MSessao.RetornaParametros.MoedaReferencia.TaxaConversao, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
                        .SubTotal = Math.Round(CDbl(.TotalMoedaDocumento + .DescontosLinha), If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                        .TotalIva = Math.Round(CDbl(.ValorImposto), If(intCasasDecImposto, 0), MidpointRounding.AwayFromZero)
                    End With
                End If

                ' Depois de se tratar tudo referente ao documento, marcamos-o como não sendo preciso voltar a rever as taxas de iva
                ' Só volta a ser necessário rever as taxas de iva se o regime de iva, o espaço fiscal, o local da operação e a própria entidade forem alteradas
                doc.ReverTaxasIva = False
            End If

            Return doc
        End Function

        Public Shared Sub CarregaInfGeralPorDefeitoArtigo(Of TDocMOD As Class, TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef doc As CabecalhoDocumento, ByRef linhaDoc As TDocLinhasMOD)
            Dim idArtigo As Long = linhaDoc.IDArtigo
            Dim artigoDB = ctx.Set(Of tbArtigos)().AsNoTracking _
                .Include("tbUnidades") _
                .Include("tbUnidades1") _
                .Include("tbUnidades2") _
                .Include("tbUnidades3") _
                .Include("tbTiposArtigos") _
                .Include("tbTiposArtigos.tbSistemaClassificacoesTiposArtigos") _
                .Include("tbDimensoes") _
                .Include("tbDimensoes1") _
                .Include("tbSistemaTiposPrecos") _
                .Include("tbSistemaTiposPrecos1") _
                .Where(Function(a) a.ID = idArtigo AndAlso a.Ativo) _
                .FirstOrDefault()

            Dim artigo As New Oticas.Artigos

            artigo.IDUnidade = artigoDB.IDUnidade
            artigo.CodigoUnidade = If(artigoDB.tbUnidades IsNot Nothing, artigoDB.tbUnidades.Codigo, String.Empty)
            artigo.DescricaoUnidade = If(artigoDB.tbUnidades IsNot Nothing, artigoDB.tbUnidades.Descricao, String.Empty)
            artigo.NumCasasDecUnidade = If(artigoDB.tbUnidades IsNot Nothing, artigoDB.tbUnidades.NumeroDeCasasDecimais, 0)
            artigo.CasasDecimaisUnidadeStock = If(artigoDB.tbUnidades IsNot Nothing, artigoDB.tbUnidades.NumeroDeCasasDecimais, 0)

            linhaDoc.IDUnidadeStock = artigo.IDUnidade
            linhaDoc.CodigoUnidadeStock = artigo.CodigoUnidade
            linhaDoc.DescricaoUnidadeStock = artigo.DescricaoUnidade
            linhaDoc.NumCasasDecUnidadeStk = artigo.NumCasasDecUnidade
            linhaDoc.CodigoSistemaClassificacoesTiposArtigos = If(artigoDB.tbTiposArtigos IsNot Nothing, artigoDB.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo, String.Empty)

            'Modifica a unidade no caso de compras
            Select Case GetType(TDocMOD).Name
                Case GetType(DocumentosCompras).Name
                    artigo.IDUnidade = artigoDB.IDUnidadeCompra
                    artigo.CodigoUnidade = If(artigoDB.tbUnidades1 IsNot Nothing, artigoDB.tbUnidades1.Codigo, String.Empty)
                    artigo.DescricaoUnidade = If(artigoDB.tbUnidades1 IsNot Nothing, artigoDB.tbUnidades1.Descricao, String.Empty)
                    artigo.NumCasasDecUnidade = If(artigoDB.tbUnidades1 IsNot Nothing, artigoDB.tbUnidades1.NumeroDeCasasDecimais, 0)
                    artigo.CasasDecimaisUnidadeStock = If(artigoDB.tbUnidades1 IsNot Nothing, artigoDB.tbUnidades1.NumeroDeCasasDecimais, 0)
                Case GetType(DocumentosVendas).Name
                    artigo.IDUnidade = artigoDB.IDUnidadeVenda
                    artigo.CodigoUnidade = If(artigoDB.tbUnidades2 IsNot Nothing, artigoDB.tbUnidades2.Codigo, String.Empty)
                    artigo.DescricaoUnidade = If(artigoDB.tbUnidades2 IsNot Nothing, artigoDB.tbUnidades2.Descricao, String.Empty)
                    artigo.NumCasasDecUnidade = If(artigoDB.tbUnidades2 IsNot Nothing, artigoDB.tbUnidades2.NumeroDeCasasDecimais, 0)
                    artigo.CasasDecimaisUnidadeStock = If(artigoDB.tbUnidades2 IsNot Nothing, artigoDB.tbUnidades2.NumeroDeCasasDecimais, 0)
            End Select

            artigo.IDUnidadeStock2 = artigoDB.tbUnidades3?.ID
            artigo.CodigoUnidadeStock2 = If(artigoDB.tbUnidades3 IsNot Nothing, artigoDB.tbUnidades3.Codigo, String.Empty)
            artigo.DescricaoUnidadeStock2 = If(artigoDB.tbUnidades3 IsNot Nothing, artigoDB.tbUnidades3.Descricao, String.Empty)
            artigo.NumCasasDec2UnidadeStock = If(artigoDB.tbUnidades3 IsNot Nothing, artigoDB.tbUnidades3.NumeroDeCasasDecimais, 0)
            artigo.UnidStkConvVariavel = If(artigoDB.tbTiposArtigos IsNot Nothing, artigoDB.tbTiposArtigos.StkUnidade1, False)
            artigo.Controla2UnidStk = If(artigoDB.tbTiposArtigos IsNot Nothing, artigoDB.tbTiposArtigos.StkUnidade2, False)
            artigo.Codigo = artigoDB.Codigo
            artigo.CodigoBarras = artigoDB.CodigoBarras
            artigo.Descricao = artigoDB.Descricao
            artigo.DescricaoVariavel = artigoDB.DescricaoVariavel
            artigo.IDTipoDimensao = artigoDB.IDTipoDimensao
            artigo.IDDimensaoPrimeira = artigoDB.IDDimensaoPrimeira

            artigo.CodigoDimensaoPrimeira = If(artigoDB.tbDimensoes IsNot Nothing, artigoDB.tbDimensoes.Codigo, String.Empty)
            artigo.DescricaoDimensaoPrimeira = If(artigoDB.tbDimensoes IsNot Nothing, artigoDB.tbDimensoes.Descricao, String.Empty)
            artigo.IDDimensaoSegunda = artigoDB.IDDimensaoSegunda

            artigo.CodigoDimensaoSegunda = If(artigoDB.tbDimensoes1 IsNot Nothing, artigoDB.tbDimensoes1.Codigo, String.Empty)
            artigo.DescricaoDimensaoSegunda = If(artigoDB.tbDimensoes1 IsNot Nothing, artigoDB.tbDimensoes1.Descricao, String.Empty)
            artigo.IDTipoPreco = artigoDB.IDTipoPreco
            artigo.CodigoTipoPreco = If(artigoDB.tbSistemaTiposPrecos IsNot Nothing, artigoDB.tbSistemaTiposPrecos.Codigo, String.Empty)
            artigo.IDTipoPeso = artigoDB.IDTipoPeso
            artigo.CodigoTipoPeso = If(artigoDB.tbSistemaTiposPrecos1 IsNot Nothing, artigoDB.tbSistemaTiposPrecos1.Codigo, String.Empty)
            artigo.IncidenciaPercentagem = If(artigoDB.IncidenciaPercentagem, 0)
            artigo.DedutivelPercentagem = If(artigoDB.DedutivelPercentagem, 0)
            artigo.GereStock = artigoDB.GereStock

            ' Controla se a leitura dos precos será feita na grelha principal ou na das dimensões
            linhaDoc.LerPreco = If(artigo.IDTipoPreco, TipoPrecoArtigo.Unico) = TipoPrecoArtigo.Unico
            linhaDoc.LerPeso = If(artigo.IDTipoPeso, TipoPrecoArtigo.Unico) = TipoPrecoArtigo.Unico

            If artigoDB Is Nothing Then
                If doc.DocNaoValorizado = True Then
                    ' Preço unitário
                    linhaDoc.PrecoUnitario = Nothing
                Else
                    ' Preço unitário
                    linhaDoc.PrecoUnitario = 0.0
                End If

                ' IVA
                linhaDoc.IDTaxaIva = Nothing
                linhaDoc.CodigoTaxaIva = Nothing
                linhaDoc.TaxaIva = Nothing
                linhaDoc.CodigoMotivoIsencaoIva = Nothing
                linhaDoc.MotivoIsencaoIva = Nothing
                linhaDoc.IDTipoIva = Nothing
                linhaDoc.IDCodigoIva = Nothing
                linhaDoc.CodigoTipoIva = Nothing
                linhaDoc.CodigoRegiaoIva = Nothing
                linhaDoc.PercIncidencia = Nothing
                linhaDoc.PercDeducao = Nothing

                ' Controla se a leitura das quantidades será feita na grelha principal ou na das dimensões
                linhaDoc.LerQuantidade = False
                linhaDoc.LerPreco = False

                ' Unidade da linha e quantidade
                linhaDoc.IDUnidade = Nothing
                linhaDoc.CodigoUnidade = Nothing
                linhaDoc.DescricaoUnidade = Nothing
                linhaDoc.Quantidade = Nothing

                ' Unidade variável de stock
                linhaDoc.IDUnidadeStock = Nothing
                linhaDoc.CodigoUnidadeStock = Nothing
                linhaDoc.DescricaoUnidadeStock = Nothing
                linhaDoc.QuantidadeStock = Nothing
                linhaDoc.FatorConvUnidStk = Nothing
                linhaDoc.OperacaoConvUnidStk = Nothing

                ' 2ª Unidade de stock
                linhaDoc.IDUnidadeStock2 = Nothing
                linhaDoc.CodigoUnidadeStock2 = Nothing
                linhaDoc.DescricaoUnidadeStock2 = Nothing
                linhaDoc.QuantidadeStock2 = Nothing
                linhaDoc.FatorConv2UnidStk = Nothing
                linhaDoc.OperacaoConv2UnidStk = Nothing

                ' Variáveis para o controlo de leitura das unidades
                linhaDoc.UnidStkConvVariavel = False
                linhaDoc.LerQtdConvUnidStk = False
                linhaDoc.LerQtdConvUnidStkDim = False
                linhaDoc.Controla2UnidStk = False
                linhaDoc.LerQtdConv2UnidStk = False

                ' Número de casas decimais das quantidades
                linhaDoc.NumCasasDecUnidade = 0
                linhaDoc.NumCasasDecUnidadeStk = 0
                linhaDoc.NumCasasDec2UnidadeStk = 0

                ' Descrição
                linhaDoc.Descricao = Nothing
                linhaDoc.DescricaoVariavel = False

                ' Tipo de preço
                linhaDoc.IDTipoPreco = Nothing
                linhaDoc.CodigoTipoPreco = Nothing

                ' Tipo de peso
                linhaDoc.IDTipoPeso = Nothing
                linhaDoc.CodigoTipoPeso = Nothing

                ' Informação das dimensões do artigo
                linhaDoc.DescricaoArtigoDimensao1 = Nothing
                linhaDoc.DescricaoArtigoDimensao2 = Nothing

                ' Gere stock
                linhaDoc.GereStock = False
            Else
                If doc.DocNaoValorizado = True Then
                    ' Preço unitário
                    linhaDoc.PrecoUnitario = Nothing
                    ' IVA
                    linhaDoc.IDTaxaIva = Nothing
                    linhaDoc.CodigoTaxaIva = Nothing
                    linhaDoc.TaxaIva = Nothing
                    linhaDoc.CodigoMotivoIsencaoIva = Nothing
                    linhaDoc.MotivoIsencaoIva = Nothing
                    linhaDoc.IDTipoIva = Nothing
                    linhaDoc.IDCodigoIva = Nothing
                    linhaDoc.CodigoTipoIva = Nothing
                    linhaDoc.CodigoRegiaoIva = Nothing
                    linhaDoc.PercIncidencia = Nothing
                    linhaDoc.PercDeducao = Nothing
                Else
                    If doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockTransformacaoArtComposto Then
                        ' Para o artigo de transformação o preço é carregado com base no método de calculo definido na ficha
                        linhaDoc.PrecoUnitario = 0
                    Else
                        'Custos Retorna TipoDocPrecoUnit dos Parametros Empresa 'ESPECIFICO DOCUMENTOS DE CUSTO' @JLB 14/03/2018
                        Select Case GetType(TDocMOD).Name
                            Case GetType(DocumentosCustos).Name
                                doc.CodigoSistemaTiposDocumentoPrecoUnitario = GetTipoDocPrecUnitByParametrosContexto(ctx, linhaDoc.IDArtigo, doc.CodigoSistemaTiposDocumentoPrecoUnitario)
                        End Select

                        ' Carregar o preço unitario
                        linhaDoc.PrecoUnitario = PreenchePUnitarioArtigo(ctx, doc.CodigoSistemaTiposDocumentoPrecoUnitario, If(doc.IDEntidade Is Nothing, 0, doc.IDEntidade), linhaDoc.IDArtigo)
                        If linhaDoc.PrecoUnitario Is Nothing Then
                            linhaDoc.PrecoUnitario = 0
                        End If

                        linhaDoc.PrecoUnitario = ClsUtilitarios.ConverteValorMoeda(linhaDoc.PrecoUnitario, ClsF3MSessao.RetornaParametros.MoedaReferencia.TaxaConversao, If(doc.TaxaConversao, 0), doc.CasasDecimaisPrecosUnitarios)
                    End If

                    ' Carregar a informação do IVA
                    PreencherTaxaIvaDaLinha(ctx, doc, linhaDoc, True)

                    ' Tipo de preço
                    linhaDoc.IDTipoPreco = Nothing
                    linhaDoc.CodigoTipoPreco = Nothing

                    ' Tipo de Peso
                    linhaDoc.IDTipoPeso = Nothing
                    linhaDoc.CodigoTipoPreco = Nothing
                    linhaDoc.PercIncidencia = artigo.IncidenciaPercentagem

                    ' A percentagem de dedução apenas é aplicada se o documento corresponde a uma entrada
                    Dim codTipoMovimento As String = String.Empty
                    Dim idTipoDocumento As Long = doc.IDTipoDocumento
                    Dim tipoDocumento As tbTiposDocumento = ctx.Set(Of tbTiposDocumento)() _
                            .Include("tbSistemaTiposDocumentoMovStock") _
                            .Where(Function(td) td.ID = idTipoDocumento) _
                            .FirstOrDefault

                    If tipoDocumento IsNot Nothing AndAlso tipoDocumento.tbSistemaTiposDocumentoMovStock IsNot Nothing Then
                        codTipoMovimento = tipoDocumento.tbSistemaTiposDocumentoMovStock.Codigo
                    End If

                    If codTipoMovimento Is Nothing Then
                        linhaDoc.PercDeducao = 0
                    Else
                        If codTipoMovimento <> SistemaMovimentacaoStock.Entrada Then
                            linhaDoc.PercDeducao = 0
                        Else
                            linhaDoc.PercDeducao = artigo.DedutivelPercentagem
                        End If
                    End If
                End If

                ' Controla se a leitura das quantidades será feita na grelha principal ou na das dimensões
                linhaDoc.LerQuantidade = artigo.IDDimensaoPrimeira Is Nothing AndAlso artigo.IDDimensaoSegunda Is Nothing
                linhaDoc.LerPreco = If(artigo.IDTipoPreco, TipoPrecoArtigo.Unico) = TipoPrecoArtigo.Unico
                linhaDoc.LerPeso = If(artigo.IDTipoPeso, TipoPrecoArtigo.Unico) = TipoPrecoArtigo.Unico

                ' Inicializar a quantidade nas linhas
                ' Se o artigo não tem dimensões a quantidade é inicializada a 1
                ' Se o artigo tem dimensões a quantidade é inicializada a 0
                Dim qtdInicial As Double = 0
                Dim qtdInicialStk As Double = 0

                If linhaDoc.LerQuantidade = True Then
                    If linhaDoc.Quantidade IsNot Nothing AndAlso linhaDoc.Quantidade > 0 Then
                        qtdInicial = linhaDoc.Quantidade
                    Else
                        qtdInicial = 1
                    End If

                    If linhaDoc.QuantidadeStock IsNot Nothing AndAlso linhaDoc.QuantidadeStock > 0 Then
                        qtdInicialStk = linhaDoc.QuantidadeStock
                    Else
                        qtdInicialStk = 1
                    End If
                End If

                'Modifica a unidade no caso de compras
                Select Case GetType(TDocMOD).Name
                    Case GetType(DocumentosCompras).Name
                        linhaDoc.IDUnidade = artigo.IDUnidade
                        linhaDoc.CodigoUnidade = artigo.CodigoUnidade
                        linhaDoc.DescricaoUnidade = artigo.DescricaoUnidade
                        linhaDoc.NumCasasDecUnidade = artigo.NumCasasDecUnidade
                        linhaDoc.Quantidade = qtdInicial

                        ' Unidade variável de stock
                        linhaDoc.QuantidadeStock = qtdInicialStk
                        linhaDoc.FatorConvUnidStk = 1
                        linhaDoc.OperacaoConvUnidStk = "Multiplica"
                    Case GetType(DocumentosVendas).Name
                        linhaDoc.IDUnidade = artigo.IDUnidade
                        linhaDoc.CodigoUnidade = artigo.CodigoUnidade
                        linhaDoc.DescricaoUnidade = artigo.DescricaoUnidade
                        linhaDoc.NumCasasDecUnidade = artigo.NumCasasDecUnidade
                        linhaDoc.Quantidade = qtdInicial

                        ' Unidade variável de stock
                        linhaDoc.QuantidadeStock = qtdInicialStk
                        linhaDoc.FatorConvUnidStk = 1
                        linhaDoc.OperacaoConvUnidStk = "Multiplica"
                    Case Else
                        ' Carregar a informação das unidades
                        If artigo.UnidStkConvVariavel = True Then
                            ' Se o tipo de artigo do artigo tem 1ª unidade de stock com conversão variável, carregamos a
                            ' unidade da ficha independentemente de ter ou não relações de conversão com outras unidades
                            ' Unidade da linha
                            linhaDoc.IDUnidade = artigo.IDUnidade
                            linhaDoc.CodigoUnidade = artigo.CodigoUnidade
                            linhaDoc.DescricaoUnidade = artigo.DescricaoUnidade
                            linhaDoc.NumCasasDecUnidade = artigo.NumCasasDecUnidade
                            linhaDoc.Quantidade = qtdInicial

                            ' Unidade variável de stock
                            linhaDoc.IDUnidadeStock = artigo.IDUnidade
                            linhaDoc.CodigoUnidadeStock = artigo.CodigoUnidade
                            linhaDoc.DescricaoUnidadeStock = artigo.DescricaoUnidade
                            linhaDoc.NumCasasDecUnidadeStk = artigo.NumCasasDecUnidade
                            linhaDoc.QuantidadeStock = qtdInicialStk
                            linhaDoc.FatorConvUnidStk = 1
                            linhaDoc.OperacaoConvUnidStk = "Multiplica"
                        Else
                            'CG foi colocado em comentário o código abaixo porque nos stocks a unidade = unidade de stock,
                            'não é necessário verificar se existe relações entre elas
                            ' Unidade da linha
                            linhaDoc.IDUnidade = artigo.IDUnidade
                            linhaDoc.CodigoUnidade = artigo.CodigoUnidade
                            linhaDoc.DescricaoUnidade = artigo.DescricaoUnidade
                            linhaDoc.NumCasasDecUnidade = artigo.NumCasasDecUnidade
                            linhaDoc.Quantidade = qtdInicial

                            ' Unidade variável de stock
                            linhaDoc.IDUnidadeStock = artigo.IDUnidade
                            linhaDoc.CodigoUnidadeStock = artigo.CodigoUnidade
                            linhaDoc.DescricaoUnidadeStock = artigo.DescricaoUnidade
                            linhaDoc.NumCasasDecUnidadeStk = artigo.NumCasasDecUnidade
                            linhaDoc.QuantidadeStock = qtdInicialStk
                            linhaDoc.FatorConvUnidStk = 1
                            linhaDoc.OperacaoConvUnidStk = "Multiplica"
                        End If
                End Select

                ' 2ª Unidade de stock
                If artigo.Controla2UnidStk = True Then
                    linhaDoc.IDUnidadeStock2 = artigo.IDUnidadeStock2
                    linhaDoc.CodigoUnidadeStock2 = artigo.CodigoUnidadeStock2
                    linhaDoc.DescricaoUnidadeStock2 = artigo.DescricaoUnidadeStock2
                    linhaDoc.NumCasasDec2UnidadeStk = artigo.NumCasasDec2UnidadeStock
                    linhaDoc.QuantidadeStock2 = 0.0
                    linhaDoc.FatorConv2UnidStk = 0.0
                    linhaDoc.OperacaoConv2UnidStk = "Multiplica"
                Else
                    linhaDoc.IDUnidadeStock2 = Nothing
                    linhaDoc.CodigoUnidadeStock2 = Nothing
                    linhaDoc.DescricaoUnidadeStock2 = Nothing
                    linhaDoc.NumCasasDec2UnidadeStk = 0
                    linhaDoc.QuantidadeStock2 = Nothing
                    linhaDoc.FatorConv2UnidStk = Nothing
                    linhaDoc.OperacaoConv2UnidStk = Nothing
                End If

                ' Variáveis para o controlo de leitura das unidades
                If artigo.UnidStkConvVariavel = False Then
                    ' Se não tem stock com conversão variável, não lemos a quantidade de stock
                    linhaDoc.UnidStkConvVariavel = False
                    linhaDoc.LerQtdConvUnidStk = False
                Else
                    If linhaDoc.LerQuantidade = False Then
                        ' Se tem stock com conversão variável mas o artigo tem dimensões, não lemos a quantidade de stock na grelha principal
                        linhaDoc.UnidStkConvVariavel = False
                        linhaDoc.LerQtdConvUnidStk = False
                    Else
                        ' Se tem stock com conversão variável e o artigo não tem dimensões, lemos a quantidade de stock na grelha principal
                        ' mas apenas se a unidade da linha é diferente da unidade de stock
                        linhaDoc.UnidStkConvVariavel = True

                        If linhaDoc.IDUnidade = linhaDoc.IDUnidadeStock Then
                            linhaDoc.LerQtdConvUnidStk = False
                        Else
                            linhaDoc.LerQtdConvUnidStk = True
                        End If
                    End If
                End If

                ' Variavel para controlo da leitura da quantidade de stock nas dims
                If artigo.UnidStkConvVariavel = False Then
                    linhaDoc.LerQtdConvUnidStkDim = False
                Else
                    If linhaDoc.IDUnidade = linhaDoc.IDUnidadeStock Then
                        linhaDoc.LerQtdConvUnidStkDim = False
                    Else
                        linhaDoc.LerQtdConvUnidStkDim = True
                    End If
                End If

                If artigo.Controla2UnidStk = False Then
                    ' Se não tem 2ª unidade de stock, não lemos a quantidade da 2ª unidade de stock
                    linhaDoc.Controla2UnidStk = False
                    linhaDoc.LerQtdConv2UnidStk = False
                Else
                    If linhaDoc.LerQuantidade = False Then
                        ' Se tem 2ª unidade de stock mas o artigo tem dimensões, não lemos a quantidade da 2ª unidade de stock na grelha principal
                        linhaDoc.Controla2UnidStk = False
                        linhaDoc.LerQtdConv2UnidStk = False
                    Else
                        ' Se tem 2ª unidade de stock e o artigo não tem dimensões, lemos a quantidade da 2ª unidade de stock na grelha principal
                        ' mas apenas se a unidade da linha é diferente da 2ª unidade de stock
                        linhaDoc.Controla2UnidStk = True

                        If linhaDoc.IDUnidade = linhaDoc.IDUnidadeStock2 Then
                            linhaDoc.LerQtdConv2UnidStk = False
                        Else
                            linhaDoc.LerQtdConv2UnidStk = True
                        End If
                    End If
                End If

                ' Descrição
                linhaDoc.CodigoArtigo = artigo.Codigo
                linhaDoc.Descricao = artigo.Descricao
                linhaDoc.DescricaoVariavel = artigo.DescricaoVariavel
                linhaDoc.CodigoBarrasArtigo = artigo.CodigoBarras

                ' Representa o tipo de dimensão do artigo
                ' Isto é muito importante, pois todo o funcionamento da leitura e armanezamento da informação estão dependentes
                ' desta propriedade da linha, inclusivé para o IndexDB
                linhaDoc.IDArtigoTipoDimensao = artigo.IDTipoDimensao

                ' Tipo de preço
                linhaDoc.IDTipoPreco = artigo.IDTipoPreco
                linhaDoc.CodigoTipoPreco = artigo.CodigoTipoPreco

                ' Tipo de Peso
                linhaDoc.IDTipoPeso = artigo.IDTipoPeso
                linhaDoc.CodigoTipoPeso = artigo.CodigoTipoPeso

                ' Informação das dimensões do artigo
                linhaDoc.CodigoArtigoDimensao1 = artigo.CodigoDimensaoPrimeira
                linhaDoc.CodigoArtigoDimensao2 = artigo.CodigoDimensaoSegunda
                linhaDoc.DescricaoArtigoDimensao1 = artigo.DescricaoDimensaoPrimeira
                linhaDoc.DescricaoArtigoDimensao2 = artigo.DescricaoDimensaoSegunda

                ' Gere stock
                linhaDoc.GereStock = artigo.GereStock
            End If
        End Sub

        Public Shared Function GetTipoDocPrecUnitByParametrosContexto(ByRef ctx As DbContext, ByVal idArtigo As Long, ByVal inCodSistTipoDocPrecoUnit As String, Optional ByVal inCodigoClassificaTipoArt As String = "") As String
            Dim artigoDB As tbArtigos = ctx.Set(Of tbArtigos) _
                .Include("tbTiposArtigos.tbSistemaClassificacoesTiposArtigos") _
                .Where(Function(a) a.ID = idArtigo AndAlso a.Ativo) _
                .FirstOrDefault()

            Dim classificacaoTipoArtigo As String = artigoDB.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo

            If Not String.IsNullOrEmpty(inCodigoClassificaTipoArt) Then
                classificacaoTipoArtigo = inCodigoClassificaTipoArt
            End If

            If classificacaoTipoArtigo = F3M.Modelos.Constantes.SistemaClassificacoesTiposArtigos.OutrosServicos OrElse classificacaoTipoArtigo = F3M.Modelos.Constantes.SistemaClassificacoesTiposArtigos.ServicosSubContratados Then
                Dim strSqlQuery As String = "SELECT dbo.GetStringPartByDelimeter(ConteudoLista,'|', cast(ValorCampo as int) + 1) as ParamTipoPreco FROM tbParametrosCamposContexto WHERE CodigoCampo = 'Servicos'"
                Dim strPrecParamContx As String = ctx.Database.SqlQuery(Of String)(strSqlQuery).AsQueryable().FirstOrDefault()

                If Not String.IsNullOrEmpty(strPrecParamContx) Then
                    Select Case strPrecParamContx.ToLower
                        Case "upc"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUUltimoPrecoCusto
                        Case "customedio"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUCustoMedio
                        Case "custopadrao"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUCustoPadrao
                    End Select
                End If
            Else
                Dim strSqlQuery As String = "SELECT dbo.GetStringPartByDelimeter(ConteudoLista,'|', cast(ValorCampo as int) + 1) as ParamTipoPreco FROM tbParametrosCamposContexto WHERE CodigoCampo = 'MateriasPrimas'"
                Dim strPrecParamContx As String = ctx.Database.SqlQuery(Of String)(strSqlQuery).AsQueryable().FirstOrDefault()

                If Not String.IsNullOrEmpty(strPrecParamContx) Then
                    Select Case strPrecParamContx.ToLower
                              'CMedioProducao|UPCProducao|CPadraoProducao
                        Case "upcproducao"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUUltimoPrecoCusto
                        Case "cmedioproducao"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUCustoMedio
                        Case "cpadraoproducao"
                            inCodSistTipoDocPrecoUnit = TipoPUnitTipoDocumento.TipoPUCustoPadrao
                    End Select
                End If

            End If

            Return inCodSistTipoDocPrecoUnit
        End Function

        Public Shared Function PreenchePUnitarioArtigo(ByRef ctx As DbContext, ByVal codigoTipoDocPrecoUnitario As String, ByVal idEntidade As Long, ByVal idArtigo As Long) As Double
            Dim precoUnitarioArtigo As Double = 0.0

            Dim artigo = ctx.Set(Of tbArtigos)().AsNoTracking.Where(Function(a) a.ID = idArtigo AndAlso a.Ativo).FirstOrDefault()

            If artigo IsNot Nothing Then
                Select Case codigoTipoDocPrecoUnitario
                    Case TipoPUnitTipoDocumento.TipoPUVazio
                        precoUnitarioArtigo = 0.0
                    Case TipoPUnitTipoDocumento.TipoPUCustoPadrao
                        precoUnitarioArtigo = If(artigo.Padrao, 0.0)
                    Case TipoPUnitTipoDocumento.TipoPUCustoMedio
                        precoUnitarioArtigo = If(artigo.Medio, 0.0)
                    Case TipoPUnitTipoDocumento.TipoPUUltimoPrecoCusto
                        precoUnitarioArtigo = If(artigo.UltimoPrecoCusto, 0.0)
                    Case TipoPUnitTipoDocumento.TipoPUDefParaAEntidade
                        precoUnitarioArtigo = If(idEntidade = 0, 0.0, ListaPrcUnitArtigo(ctx, idArtigo, ListaTipoPUnitarioEntidade(ctx, idEntidade)))
                    Case TipoPUnitTipoDocumento.TipoPUPV1
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 1)
                    Case TipoPUnitTipoDocumento.TipoPUPV2
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 2)
                    Case TipoPUnitTipoDocumento.TipoPUPV3
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 3)
                    Case TipoPUnitTipoDocumento.TipoPUPV4
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 4)
                    Case TipoPUnitTipoDocumento.TipoPUPV5
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 5)
                    Case TipoPUnitTipoDocumento.TipoPUPV6
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 6)
                    Case TipoPUnitTipoDocumento.TipoPUPV7
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 7)
                    Case TipoPUnitTipoDocumento.TipoPUPV8
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 8)
                    Case TipoPUnitTipoDocumento.TipoPUPV9
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 9)
                    Case TipoPUnitTipoDocumento.TipoPUPV10
                        precoUnitarioArtigo = ListaPrcUnitArtigo(ctx, idArtigo, 10)
                End Select
            End If

            Return precoUnitarioArtigo
        End Function

        Private Shared Function ListaPrcUnitArtigo(ByRef ctx As DbContext, ByVal idArtigo As Long, ByVal idCodigoPreco As Long) As Double
            Dim artigoPreco As tbArtigosPrecos =
                ctx.Set(Of tbArtigosPrecos)() _
                    .AsNoTracking _
                    .Where(Function(ap) ap.IDArtigo = idArtigo AndAlso ap.IDCodigoPreco = idCodigoPreco AndAlso ap.Ativo) _
                    .FirstOrDefault

            Return If(artigoPreco Is Nothing, 0.0, If(artigoPreco.ValorSemIva, 0.0))
        End Function

        Public Shared Function ListaTipoPUnitarioEntidade(ByRef ctx As DbContext, ByVal idEntidade As Long) As Long
            Dim cliente As tbClientes = ctx.Set(Of tbClientes).AsNoTracking.Where(Function(c) c.ID = idEntidade).FirstOrDefault

            Return If(cliente Is Nothing, 0, cliente.IDPrecoSugerido)
        End Function

        Public Shared Sub PreencherTaxaIvaDaLinha(Of TDOCMOD As Class, TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef doc As TDOCMOD, ByRef linhaDoc As TDocLinhasMOD, ByVal reverTaxasIva As Boolean)
            Dim idTaxaIVACarregar As Long = 0

            If reverTaxasIva = True Then
                If CObj(doc).IDEntidade Is Nothing Then
                    ' Se o documento não tem entidade, marcar para carregar o iva da ficha do artigo
                    idTaxaIVACarregar = 0
                Else
                    ' Se o documento tem entidade, carregar qual o tipo de taxa de iva a carregar tendo em conta a informação introduzida
                    Dim IDParametrosCamposContextoTaxasIva As Long = 0

                    If CObj(doc).IDRegimeIva = RegimeIva.InversaoSujeitoPassivo Then
                        If CObj(doc).IDEspacoFiscal = EspacoFiscal.Nacional Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.InversaoSujeitoPassivoNacional
                        ElseIf CObj(doc).IDEspacoFiscal = EspacoFiscal.Intracomunitario Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.InversaoSujeitoPassivoIntracomunitario
                        End If
                    ElseIf CObj(doc).IDRegimeIva = RegimeIva.Isento Then
                        If CObj(doc).IDEspacoFiscal = EspacoFiscal.Nacional Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.IsentoNacional
                        ElseIf CObj(doc).IDEspacoFiscal = EspacoFiscal.Externo Then
                            IDParametrosCamposContextoTaxasIva = ParametrosCamposContextoTaxasIva.IsentoExterno
                        End If
                    End If

                    If IDParametrosCamposContextoTaxasIva = 0 Then
                        ' Como não foi encontrada nenhum tipo de taxa de iva a carregar, vamos marcar para carregar o iva da ficha do artigo
                        idTaxaIVACarregar = 0
                    Else
                        ' vamos à tabela dos parametros da empresa carregar a taxa correspondente
                        Dim paramsContexto = ctx.Set(Of tbParametrosCamposContexto)().AsNoTracking.Where(Function(p) p.ID = IDParametrosCamposContextoTaxasIva).FirstOrDefault()

                        If paramsContexto Is Nothing Then
                            idTaxaIVACarregar = 0
                        Else
                            idTaxaIVACarregar = If(String.IsNullOrEmpty(paramsContexto.ValorCampo), 0, paramsContexto.ValorCampo)
                        End If
                    End If
                End If

                ' Carregar a informação do Iva tendo em conta a taxa obtida
                If idTaxaIVACarregar = 0 Then
                    ' Se não foi indicada nenhuma taxa vamos carregar a do artigo
                    Dim idArtigo As Long = linhaDoc.IDArtigo
                    Dim artigoBD = ctx.Set(Of tbArtigos)().AsNoTracking _
                        .Include("tbIVA") _
                        .Where(Function(a) a.ID = idArtigo AndAlso a.Ativo) _
                        .FirstOrDefault()

                    If artigoBD IsNot Nothing Then
                        idTaxaIVACarregar = If(artigoBD.tbIVA IsNot Nothing, artigoBD.tbIVA.ID, String.Empty)
                    End If
                End If
            Else
                idTaxaIVACarregar = linhaDoc.IDTaxaIva
            End If

            If idTaxaIVACarregar = 0 Then
                linhaDoc.IDTaxaIva = Nothing
                linhaDoc.CodigoTaxaIva = Nothing
                linhaDoc.TaxaIva = Nothing
                linhaDoc.IDTipoIva = Nothing
                linhaDoc.IDCodigoIva = Nothing
                linhaDoc.CodigoMotivoIsencaoIva = Nothing
                linhaDoc.MotivoIsencaoIva = Nothing
                linhaDoc.IDEspacoFiscal = Nothing
                linhaDoc.IDRegimeIva = Nothing
                linhaDoc.CodigoTipoIva = Nothing
                linhaDoc.CodigoRegiaoIva = Nothing
            Else
                Dim codigoRegiaoIva As String = String.Empty

                If reverTaxasIva = True Then
                    ' Se o local da operação existe na taxa do iva, carregar a taxa do iva do local da operação
                    If CObj(doc).IDLocalOperacao IsNot Nothing Then
                        Dim idLocalOperacao As Long = CObj(doc).IDLocalOperacao

                        Dim ivaRegiaoDB = ctx.Set(Of tbIVARegioes)().AsNoTracking _
                            .Include("tbSistemaRegioesIVA") _
                            .Where(Function(ir) ir.IDIva = idTaxaIVACarregar AndAlso ir.IDRegiao = idLocalOperacao AndAlso ir.Ativo) _
                            .FirstOrDefault()

                        If ivaRegiaoDB IsNot Nothing Then
                            idTaxaIVACarregar = ivaRegiaoDB.IDIvaRegiao
                            codigoRegiaoIva = ivaRegiaoDB.tbSistemaRegioesIVA.Codigo
                        End If
                    End If
                End If

                Dim ivaDB = ctx.Set(Of tbIVA)().AsNoTracking _
                    .Include("tbSistemaCodigosIVA") _
                    .Include("tbSistemaTiposIVA") _
                    .Where(Function(i) i.ID = idTaxaIVACarregar AndAlso i.Ativo) _
                    .FirstOrDefault()

                If ivaDB Is Nothing Then
                    linhaDoc.IDTaxaIva = Nothing
                    linhaDoc.CodigoTaxaIva = Nothing
                    linhaDoc.TaxaIva = Nothing
                    linhaDoc.IDTipoIva = Nothing
                    linhaDoc.IDCodigoIva = Nothing
                    linhaDoc.CodigoMotivoIsencaoIva = Nothing
                    linhaDoc.MotivoIsencaoIva = Nothing
                    linhaDoc.IDEspacoFiscal = Nothing
                    linhaDoc.IDRegimeIva = Nothing
                    linhaDoc.CodigoTipoIva = Nothing
                    linhaDoc.CodigoRegiaoIva = Nothing
                Else
                    linhaDoc.IDTaxaIva = ivaDB.ID
                    linhaDoc.CodigoTaxaIva = ivaDB.Codigo
                    linhaDoc.TaxaIva = CDbl(ivaDB.Taxa)
                    linhaDoc.IDTipoIva = ivaDB.IDTipoIva
                    linhaDoc.IDCodigoIva = ivaDB.IDCodigoIva

                    If Math.Round(CDbl(linhaDoc.TaxaIva), ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem, MidpointRounding.AwayFromZero) = Math.Round(0.0, ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem, MidpointRounding.AwayFromZero) Then
                        linhaDoc.CodigoMotivoIsencaoIva = If(ivaDB.tbSistemaCodigosIVA IsNot Nothing, ivaDB.tbSistemaCodigosIVA.Codigo, String.Empty)
                        linhaDoc.MotivoIsencaoIva = ivaDB.Mencao
                    Else
                        linhaDoc.CodigoMotivoIsencaoIva = Nothing
                        linhaDoc.MotivoIsencaoIva = Nothing
                    End If

                    linhaDoc.IDEspacoFiscal = CObj(doc).IDEspacoFiscal
                    linhaDoc.IDRegimeIva = CObj(doc).IDRegimeIva
                    linhaDoc.CodigoRegiaoIva = codigoRegiaoIva
                    linhaDoc.CodigoTipoIva = If(ivaDB.tbSistemaTiposIVA IsNot Nothing, ivaDB.tbSistemaTiposIVA.Codigo, String.Empty)
                End If
            End If
        End Sub

        Private Shared Sub PreencherInfUnidadeQtds(Of TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef docLinha As TDocLinhasMOD, ByRef lstUnidades As List(Of tbUnidades))
            Dim casasDecimaisLinha As Integer = 0
            Dim casasDecimaisUnidadeStock As Integer = 0
            Dim casasDecimaisUnidadeStock2 As Integer = 0

            ' Unidade da linha
            If docLinha.IDUnidade Is Nothing Then
                docLinha.NumCasasDecUnidade = Nothing
            Else
                Dim idUnidade As Long = docLinha.IDUnidade
                Dim unidade = lstUnidades.Where(Function(u) u.ID = idUnidade).FirstOrDefault()

                If unidade IsNot Nothing Then
                    docLinha.NumCasasDecUnidade = unidade.NumeroDeCasasDecimais
                End If

                casasDecimaisLinha = docLinha.NumCasasDecUnidade
            End If

            ' Unidade de stock
            If docLinha.IDUnidadeStock Is Nothing Then
                docLinha.NumCasasDecUnidadeStk = Nothing
                docLinha.FatorConvUnidStk = Nothing
                docLinha.OperacaoConvUnidStk = Nothing
                docLinha.QuantidadeStock = Nothing
            Else
                casasDecimaisUnidadeStock = docLinha.NumCasasDecUnidadeStk

                If docLinha.IDUnidade Is Nothing Then
                    docLinha.FatorConvUnidStk = 0.0
                    docLinha.OperacaoConvUnidStk = "Multiplica"
                    docLinha.QuantidadeStock = Math.Round(0.0, casasDecimaisUnidadeStock, MidpointRounding.AwayFromZero)
                Else
                    Dim idUnidadeStock As Long = docLinha.IDUnidadeStock
                    Dim unidade = lstUnidades.Where(Function(u) u.ID = idUnidadeStock).FirstOrDefault()

                    If unidade IsNot Nothing Then
                        docLinha.NumCasasDecUnidadeStk = unidade.NumeroDeCasasDecimais
                    End If

                    If docLinha.IDArtigo Is Nothing OrElse docLinha.IDArtigo = 0 Then
                        docLinha.FatorConvUnidStk = 1
                        docLinha.OperacaoConvUnidStk = "Multiplica"
                    Else
                        Dim fatorUnidadeStock As Hashtable = CarregaFatorArtigoUnidade(ctx, docLinha.IDArtigo, docLinha.IDUnidade, docLinha.IDUnidadeStock)

                        docLinha.FatorConvUnidStk = fatorUnidadeStock.Item("Fator")
                        docLinha.OperacaoConvUnidStk = fatorUnidadeStock.Item("Operacao")
                    End If

                    ' Só calcula se o artigo não tem dimensões
                    If docLinha.LerQuantidade = True Then
                        If docLinha.OperacaoConvUnidStk = "Multiplica" Then
                            ' Mutiplica para obter a quantidade de stock
                            docLinha.QuantidadeStock = Math.Round(CDbl(docLinha.Quantidade * docLinha.FatorConvUnidStk), casasDecimaisUnidadeStock, MidpointRounding.AwayFromZero)
                        Else
                            ' Divide para obter a quantidade de stock
                            If docLinha.FatorConvUnidStk > 0 Then
                                docLinha.QuantidadeStock = Math.Round(CDbl(docLinha.Quantidade / docLinha.FatorConvUnidStk), casasDecimaisUnidadeStock, MidpointRounding.AwayFromZero)
                            Else
                                docLinha.QuantidadeStock = Math.Round(0.0, casasDecimaisUnidadeStock, MidpointRounding.AwayFromZero)
                            End If
                        End If
                    End If
                End If

                ' Variáveis para o controlo de leitura das unidades
                If docLinha.UnidStkConvVariavel = True Then
                    ' Se tem stock com conversão variável e o artigo não tem dimensões, lemos a quantidade de stock na grelha principal
                    ' mas apenas se a unidade da linha é diferente da unidade de stock
                    If docLinha.IDUnidade = docLinha.IDUnidadeStock Then
                        docLinha.LerQtdConvUnidStk = False
                    Else
                        docLinha.LerQtdConvUnidStk = True
                    End If
                End If
            End If

            ' Variavel para controlo da leitura da quantidade de stock nas dims
            ' É preciso ir novamente à ficha do artigo para validar o acesso, pois as outras variáveis são para as linhas sem dimensões
            If docLinha.IDArtigo Is Nothing OrElse docLinha.IDArtigo = 0 Then
                docLinha.LerQtdConvUnidStkDim = False
            Else
                Dim idArtigo As Long = docLinha.IDArtigo
                Dim artigoDB = ctx.Set(Of tbArtigos)().AsNoTracking _
                    .Include("tbTiposArtigos") _
                    .Where(Function(a) a.ID = idArtigo AndAlso a.Ativo) _
                    .FirstOrDefault()

                Dim artigo As New Oticas.Artigos

                If artigoDB Is Nothing Then
                    docLinha.LerQtdConvUnidStkDim = False
                Else
                    artigo.UnidStkConvVariavel = If(artigoDB.tbTiposArtigos IsNot Nothing, artigoDB.tbTiposArtigos.StkUnidade1, String.Empty)

                    If artigo.UnidStkConvVariavel = False Then
                        docLinha.LerQtdConvUnidStkDim = False
                    Else
                        If docLinha.IDUnidade = docLinha.IDUnidadeStock Then
                            docLinha.LerQtdConvUnidStkDim = False
                        Else
                            docLinha.LerQtdConvUnidStkDim = True
                        End If
                    End If
                End If
            End If

            ' 2ª unidade de stock
            If docLinha.IDUnidadeStock2 Is Nothing Then
                docLinha.NumCasasDec2UnidadeStk = Nothing
                docLinha.FatorConv2UnidStk = Nothing
                docLinha.OperacaoConv2UnidStk = Nothing
                docLinha.QuantidadeStock2 = Nothing
            Else
                casasDecimaisUnidadeStock2 = docLinha.NumCasasDec2UnidadeStk

                If docLinha.IDUnidade Is Nothing Then
                    docLinha.FatorConv2UnidStk = 0.0
                    docLinha.OperacaoConv2UnidStk = "Multiplica"
                    docLinha.QuantidadeStock2 = Math.Round(0.0, casasDecimaisUnidadeStock2, MidpointRounding.AwayFromZero)
                Else
                    Dim idUnidadeStock2 As Long = docLinha.IDUnidadeStock2
                    Dim unidadeStockDB = lstUnidades.Where(Function(u) u.ID = idUnidadeStock2).FirstOrDefault()

                    If unidadeStockDB IsNot Nothing Then
                        docLinha.NumCasasDec2UnidadeStk = unidadeStockDB.NumeroDeCasasDecimais
                    End If

                    If docLinha.IDArtigo Is Nothing OrElse docLinha.IDArtigo = 0 Then
                        docLinha.FatorConv2UnidStk = 1
                        docLinha.OperacaoConv2UnidStk = "Multiplica"
                    Else
                        Dim fatorUnidStock2 As Hashtable = CarregaFatorArtigoUnidade(ctx, docLinha.IDArtigo, docLinha.IDUnidade, docLinha.IDUnidadeStock2)

                        docLinha.FatorConv2UnidStk = fatorUnidStock2.Item("Fator")
                        docLinha.OperacaoConv2UnidStk = fatorUnidStock2.Item("Operacao")
                    End If

                    ' Só calcula se o artigo não tem dimensões
                    If docLinha.LerQuantidade = True Then
                        If docLinha.OperacaoConv2UnidStk = "Multiplica" Then
                            docLinha.QuantidadeStock2 = Math.Round(CDbl(docLinha.Quantidade * docLinha.FatorConv2UnidStk), casasDecimaisUnidadeStock2, MidpointRounding.AwayFromZero)
                        Else
                            If docLinha.FatorConv2UnidStk > 0 Then
                                docLinha.QuantidadeStock2 = Math.Round(CDbl(docLinha.Quantidade / docLinha.FatorConv2UnidStk), casasDecimaisUnidadeStock2, MidpointRounding.AwayFromZero)
                            Else
                                docLinha.QuantidadeStock2 = Math.Round(0.0, casasDecimaisUnidadeStock2, MidpointRounding.AwayFromZero)
                            End If
                        End If
                    End If
                End If

                If docLinha.Controla2UnidStk = True Then
                    ' Se tem 2ª unidade de stock e o artigo não tem dimensões, lemos a quantidade da 2ª unidade de stock na grelha principal
                    ' mas apenas se a unidade da linha é diferente da 2ª unidade de stock
                    If docLinha.IDUnidade = docLinha.IDUnidadeStock2 Then
                        docLinha.LerQtdConv2UnidStk = False
                    Else
                        docLinha.LerQtdConv2UnidStk = True
                    End If
                End If
            End If
        End Sub

        Public Shared Function CarregaFatorArtigoUnidade(ByRef ctx As DbContext, ByVal idArtigo As Long, ByVal idUnidadeLinha As Long, ByVal idUnidadeRelacionada As Long) As Hashtable
            Dim fatorOperacao As New Hashtable()

            If idUnidadeLinha = idUnidadeRelacionada Then
                fatorOperacao.Add("Operacao", "Multiplica")
                fatorOperacao.Add("Fator", 1.0)
            Else
                fatorOperacao.Add("Operacao", "Multiplica")
                fatorOperacao.Add("Fator", 0.0)
            End If

            ' ARTIGOS UNIDADES
            ' 1º carrego o fator nas relações nas unidades do artigo do lado esquerdo
            Dim artigoUnidadeEsq = ctx.Set(Of tbArtigosUnidades)().AsNoTracking.Where(Function(au) au.IDArtigo = idArtigo AndAlso au.IDUnidade = idUnidadeLinha AndAlso au.IDUnidadeConversao = idUnidadeRelacionada AndAlso au.Ativo).FirstOrDefault()

            If artigoUnidadeEsq IsNot Nothing Then
                If artigoUnidadeEsq.FatorConversao <> 0 Then
                    fatorOperacao.Item("Operacao") = "Multiplica"
                    fatorOperacao.Item("Fator") = artigoUnidadeEsq.FatorConversao

                    Return fatorOperacao
                End If
            End If

            ' 2º carrego o fator nas relações nas unidades do artigo do lado direito
            Dim artigoUnidadeDir = ctx.Set(Of tbArtigosUnidades)().AsNoTracking.Where(Function(au) au.IDArtigo = idArtigo AndAlso au.IDUnidade = idUnidadeRelacionada AndAlso au.IDUnidadeConversao = idUnidadeLinha AndAlso au.Ativo).FirstOrDefault()

            If artigoUnidadeDir IsNot Nothing Then
                If artigoUnidadeDir.FatorConversao <> 0 Then
                    fatorOperacao.Item("Operacao") = "Divide"
                    fatorOperacao.Item("Fator") = artigoUnidadeDir.FatorConversao

                    Return fatorOperacao
                End If
            End If

            ' RELAÇÕES UNIDADES
            ' 3º carrego o fator nas relações das unidades da lista geral do lado esquerdo (relações unidades)
            Dim unidadeRelEsq = ctx.Set(Of tbUnidadesRelacoes)().AsNoTracking.Where(Function(ur) ur.IDUnidade = idUnidadeLinha AndAlso ur.IDUnidadeConversao = idUnidadeRelacionada AndAlso ur.Ativo).FirstOrDefault()

            If unidadeRelEsq IsNot Nothing Then
                If unidadeRelEsq.FatorConversao <> 0 Then
                    fatorOperacao.Item("Operacao") = "Multiplica"
                    fatorOperacao.Item("Fator") = unidadeRelEsq.FatorConversao

                    Return fatorOperacao
                End If
            End If

            ' 4º carrego o fator nas relações das unidades da lista geral do lado direito (relações unidades)
            Dim unidadeRelDir = ctx.Set(Of tbUnidadesRelacoes)().AsNoTracking.Where(Function(ur) ur.IDUnidade = idUnidadeRelacionada AndAlso ur.IDUnidadeConversao = idUnidadeLinha AndAlso ur.Ativo).FirstOrDefault()

            If unidadeRelDir IsNot Nothing Then
                If unidadeRelDir.FatorConversao <> 0 Then
                    fatorOperacao.Item("Operacao") = "Divide"
                    fatorOperacao.Item("Fator") = unidadeRelDir.FatorConversao

                    Return fatorOperacao
                End If
            End If

            Return fatorOperacao
        End Function

        Public Shared Function TrataDescricaoAtigoIdioma(Of TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef doc As CabecalhoDocumento, ByRef linhaDoc As TDocLinhasMOD) As String
            Dim descricaoIdioma As String = String.Empty

            If doc.IDEntidade IsNot Nothing Then
                Dim codigoTipoEntidade = ctx.Database.SqlQuery(Of String)("SELECT codigo FROM tbsistemaTiposEntidade WHERE ID = " & doc.IDTipoEntidade).AsQueryable().FirstOrDefault()

                If linhaDoc.IDArtigo IsNot Nothing Then
                    Dim queryIdioma As String = String.Empty

                    If codigoTipoEntidade = "Clt" Then
                        queryIdioma = "SELECT IDIdioma FROM tbClientes WHERE ID = " & doc.IDEntidade
                    ElseIf codigoTipoEntidade = "Fnd" Then
                        queryIdioma = "SELECT IDIdioma FROM tbFornecedores WHERE ID = " & doc.IDEntidade
                    End If

                    Dim idIdioma As Long = ctx.Database.SqlQuery(Of Long)(queryIdioma).FirstOrDefault()
                    descricaoIdioma = ctx.Database.SqlQuery(Of String)("SELECT Descricao FROM tbArtigosIdiomas WHERE IDIdioma = " & idIdioma & " AND IDArtigo = " & linhaDoc.IDArtigo).AsQueryable().FirstOrDefault()
                End If
            End If

            If String.IsNullOrEmpty(descricaoIdioma) Then
                If linhaDoc.IDArtigo IsNot Nothing Then
                    descricaoIdioma = ctx.Database.SqlQuery(Of String)("SELECT Descricao FROM tbArtigos WHERE ID = " & linhaDoc.IDArtigo).AsQueryable().FirstOrDefault()
                Else
                    descricaoIdioma = linhaDoc.Descricao
                End If
            End If

            Return descricaoIdioma
        End Function

        Public Shared Sub CarregaArmazemPorDefeito(Of TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef doc As CabecalhoDocumento, ByRef linhaDoc As TDocLinhasMOD)
            Dim idArtigo As Long = linhaDoc.IDArtigo

            Dim artigoArmazemLocDB = ctx.Set(Of tbArtigosArmazensLocalizacoes)().AsNoTracking _
                .Include("tbArmazens") _
                .Include("tbArmazensLocalizacoes") _
                .Where(Function(aal) aal.IDArtigo = idArtigo AndAlso aal.PorDefeito) _
                .FirstOrDefault()

            Dim artigoArmazemLoc As New ArtigosArmazensLocalizacoes

            If artigoArmazemLocDB Is Nothing Then
                If ClsF3MSessao.RetornaParametros.Lojas Is Nothing Then
                    With linhaDoc
                        ' Armazém de saída
                        .IDArmazem = Nothing
                        .DescricaoArmazem = Nothing
                        .IDArmazemLocalizacao = Nothing
                        .CodigoArmazemLocalizacao = Nothing
                        .DescricaoArmazemLocalizacao = Nothing
                        ' Armazém de entrada
                        .IDArmazemDestino = Nothing
                        .DescricaoArmazemDestino = Nothing
                        .IDArmazemLocalizacaoDestino = Nothing
                        .CodigoArmazemLocalizacaoDestino = Nothing
                        .DescricaoArmazemLocalizacaoDestino = Nothing
                    End With
                Else
                    Dim idLocalizacao As String = ClsF3MSessao.RetornaParametros.Lojas.ParametroArmazemLocalizacao

                    If IsNumeric(idLocalizacao) Then
                        Dim armazemLocalizacao = ctx.Set(Of tbArmazensLocalizacoes)().AsNoTracking _
                            .Include("tbArmazens") _
                            .Where(Function(al) al.ID = idLocalizacao) _
                            .FirstOrDefault()

                        If armazemLocalizacao IsNot Nothing Then
                            If doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockInicial _
                                    OrElse doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockEntradaStock _
                                    OrElse doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockTransformacaoArtComposto _
                                    OrElse doc.CodigoSisTiposMovStock = SistemaMovimentacaoStock.Entrada Then

                                With linhaDoc
                                    .IDArmazemDestino = armazemLocalizacao.IDArmazem
                                    .DescricaoArmazemDestino = If(armazemLocalizacao.tbArmazens IsNot Nothing, armazemLocalizacao.tbArmazens.Descricao, String.Empty)
                                    .IDArmazemLocalizacaoDestino = armazemLocalizacao.ID
                                    .CodigoArmazemLocalizacaoDestino = armazemLocalizacao.Codigo
                                    .DescricaoArmazemLocalizacaoDestino = armazemLocalizacao.Descricao
                                End With
                            Else
                                With linhaDoc
                                    .IDArmazem = armazemLocalizacao.IDArmazem
                                    .DescricaoArmazem = If(armazemLocalizacao.tbArmazens IsNot Nothing, armazemLocalizacao.tbArmazens.Descricao, String.Empty)
                                    .IDArmazemLocalizacao = armazemLocalizacao.ID
                                    .CodigoArmazemLocalizacao = armazemLocalizacao.Codigo
                                    .DescricaoArmazemLocalizacao = armazemLocalizacao.Descricao
                                End With
                            End If
                        Else
                            With linhaDoc
                                ' Armazém de saída
                                .IDArmazem = Nothing
                                .DescricaoArmazem = Nothing
                                .IDArmazemLocalizacao = Nothing
                                .CodigoArmazemLocalizacao = Nothing
                                .DescricaoArmazemLocalizacao = Nothing
                                ' Armazém de entrada
                                .IDArmazemDestino = Nothing
                                .DescricaoArmazemDestino = Nothing
                                .IDArmazemLocalizacaoDestino = Nothing
                                .CodigoArmazemLocalizacaoDestino = Nothing
                                .DescricaoArmazemLocalizacaoDestino = Nothing
                            End With
                        End If
                    End If
                End If
            Else
                artigoArmazemLoc.ID = artigoArmazemLocDB.ID
                artigoArmazemLoc.IDArmazem = artigoArmazemLocDB.IDArmazem
                artigoArmazemLoc.DescricaoArmazem = If(artigoArmazemLocDB.tbArmazens IsNot Nothing, artigoArmazemLocDB.tbArmazens.Descricao, String.Empty)
                artigoArmazemLoc.IDArmazemLocalizacao = artigoArmazemLocDB.IDArmazemLocalizacao
                artigoArmazemLoc.CodigoArmazemLocalizacao = If(artigoArmazemLocDB.tbArmazensLocalizacoes IsNot Nothing, artigoArmazemLocDB.tbArmazensLocalizacoes.Codigo, String.Empty)
                artigoArmazemLoc.DescricaoArmazemLocalizacao = If(artigoArmazemLocDB.tbArmazensLocalizacoes IsNot Nothing, artigoArmazemLocDB.tbArmazensLocalizacoes.Descricao, String.Empty)

                ' Tipo doc Ini, doc Entrada, transferencias e transformaçao composto
                If doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockInicial OrElse
                       doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockEntradaStock OrElse
                       doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockTransformacaoArtComposto OrElse
                       doc.CodigoSisTiposMovStock = SistemaMovimentacaoStock.Entrada Then

                    With linhaDoc
                        ' Armazém de saída
                        .IDArmazem = Nothing
                        .DescricaoArmazem = Nothing
                        .IDArmazemLocalizacao = Nothing
                        .CodigoArmazemLocalizacao = Nothing
                        .DescricaoArmazemLocalizacao = Nothing
                        ' Armazém de entrada
                        .IDArmazemDestino = artigoArmazemLoc.IDArmazem
                        .DescricaoArmazemDestino = artigoArmazemLoc.DescricaoArmazem
                        .IDArmazemLocalizacaoDestino = artigoArmazemLoc.IDArmazemLocalizacao
                        .CodigoArmazemLocalizacaoDestino = artigoArmazemLoc.CodigoArmazemLocalizacao
                        .DescricaoArmazemLocalizacaoDestino = artigoArmazemLoc.DescricaoArmazemLocalizacao
                    End With
                Else
                    With linhaDoc
                        ' Armazém de saída
                        .IDArmazem = artigoArmazemLoc.IDArmazem
                        .DescricaoArmazem = artigoArmazemLoc.DescricaoArmazem
                        .IDArmazemLocalizacao = artigoArmazemLoc.IDArmazemLocalizacao
                        .CodigoArmazemLocalizacao = artigoArmazemLoc.CodigoArmazemLocalizacao
                        .DescricaoArmazemLocalizacao = artigoArmazemLoc.DescricaoArmazemLocalizacao
                        ' Armazém de entrada
                        .IDArmazemDestino = Nothing
                        .DescricaoArmazemDestino = Nothing
                        .IDArmazemLocalizacaoDestino = Nothing
                        .CodigoArmazemLocalizacaoDestino = Nothing
                        .DescricaoArmazemLocalizacaoDestino = Nothing
                    End With
                End If
            End If
        End Sub

        Public Shared Sub CarregaLotePorDefeito(Of TDocLinhasMOD As DocumentosLinhas)(ByRef ctx As DbContext, ByRef doc As CabecalhoDocumento, ByRef linhaDoc As TDocLinhasMOD)
            Dim idArtigo As Long = linhaDoc.IDArtigo

            Dim artigoDB As tbArtigos = ctx.Set(Of tbArtigos)().AsNoTracking _
                .Include("tbSistemaOrdemLotes1") _
                .Include("tbSistemaOrdemLotes2") _
                .Where(Function(a) a.ID = idArtigo AndAlso a.Ativo) _
                .FirstOrDefault()

            Dim artigo As New Oticas.Artigos

            artigo.GereLotes = artigoDB.GereLotes
            artigo.CodigoOrdemLoteMovEntrada = If(artigoDB.tbSistemaOrdemLotes1 IsNot Nothing, artigoDB.tbSistemaOrdemLotes1.Codigo, String.Empty)
            artigo.CodigoOrdemLoteMovSaida = If(artigoDB.tbSistemaOrdemLotes2 IsNot Nothing, artigoDB.tbSistemaOrdemLotes2.Codigo, String.Empty)

            If artigoDB Is Nothing Then
                linhaDoc.GereLotes = False
                linhaDoc.IDLote = Nothing
                linhaDoc.CodigoLote = Nothing
                linhaDoc.DescricaoLote = Nothing
                linhaDoc.DataFabricoLote = Nothing
                linhaDoc.DataValidadeLote = Nothing
            Else
                ' Só prossegue se o artigo gere lotes
                linhaDoc.GereLotes = artigoDB.GereLotes

                If artigoDB.GereLotes = False Then
                    linhaDoc.IDLote = Nothing
                    linhaDoc.CodigoLote = Nothing
                    linhaDoc.DescricaoLote = Nothing
                    linhaDoc.DataFabricoLote = Nothing
                    linhaDoc.DataValidadeLote = Nothing
                Else
                    ' Identificar qual o critério a usar
                    Dim criterioMov As String = String.Empty

                    If doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockInicial OrElse
                            doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockEntradaStock OrElse
                            doc.CodigoTipoDocumento = TiposSistemaTiposDocumento.StockTransformacaoArtComposto Then
                        criterioMov = artigo.CodigoOrdemLoteMovEntrada
                    Else
                        criterioMov = artigo.CodigoOrdemLoteMovSaida
                    End If

                    ' Carregar o lote por defeito tendo em conta o critério a usar
                    If String.IsNullOrEmpty(criterioMov) Then
                        linhaDoc.IDLote = Nothing
                        linhaDoc.CodigoLote = Nothing
                        linhaDoc.DescricaoLote = Nothing
                        linhaDoc.DataFabricoLote = Nothing
                        linhaDoc.DataValidadeLote = Nothing
                    Else
                        Dim artigosLotesDB As tbArtigosLotes = Nothing
                        Dim artigoLoteQuery = ctx.Set(Of tbArtigosLotes)().AsNoTracking.Where(Function(al) al.IDArtigo = idArtigo AndAlso al.Ativo)

                        Select Case criterioMov
                            Case ConstSistemaOrdemLotes.DataValidadeAscendente
                                ' Data de validade ascendente
                                artigosLotesDB = artigoLoteQuery.OrderBy(Function(al) al.DataValidade).ThenBy(Function(al) al.ID).FirstOrDefault()
                            Case ConstSistemaOrdemLotes.DataValidadeDescendente
                                ' Data de validade descendente
                                artigosLotesDB = artigoLoteQuery.OrderByDescending(Function(al) al.DataValidade).ThenByDescending(Function(al) al.ID).FirstOrDefault()
                            Case ConstSistemaOrdemLotes.FIFO
                                ' O primeiro a entrar é o primeiro a sair
                                artigosLotesDB = artigoLoteQuery.OrderBy(Function(al) al.DataCriacao).ThenBy(Function(al) al.ID).FirstOrDefault()
                            Case ConstSistemaOrdemLotes.LIFO
                                ' O último a entrar é o primeiro a sair
                                artigosLotesDB = artigoLoteQuery.OrderByDescending(Function(al) al.DataCriacao).ThenByDescending(Function(al) al.ID).FirstOrDefault()
                            Case ConstSistemaOrdemLotes.ULM
                                ' O último lote movimentado
                                ' A consulta é feita utilizando os movimentos da conta corrente dos artigos
                                Dim contaCorrenteArtigo = ctx.Set(Of tbCCStockArtigos)().AsNoTracking _
                                    .Where(Function(cc) cc.IDArtigo = idArtigo AndAlso cc.IDArtigoLote IsNot Nothing) _
                                    .OrderByDescending(Function(cc) cc.DataDocumento) _
                                    .ThenByDescending(Function(cc) cc.ID) _
                                    .FirstOrDefault()

                                If contaCorrenteArtigo IsNot Nothing Then
                                    Dim idArtigoLote As Long = contaCorrenteArtigo.IDArtigoLote

                                    artigosLotesDB = artigoLoteQuery.Where(Function(al) al.ID = idArtigoLote).FirstOrDefault()
                                End If
                            Case ConstSistemaOrdemLotes.LMQ
                                ' O lote com menor quantidade
                                ' A consulta é feita utilizando o ficheiro que totaliza o stock
                                Dim stockArtigo = ctx.Set(Of tbStockArtigos)().AsNoTracking _
                                    .Where(Function(sa) sa.IDArtigo = idArtigo AndAlso sa.IDArtigoLote IsNot Nothing) _
                                    .OrderBy(Function(sa) sa.Quantidade) _
                                    .FirstOrDefault()

                                If stockArtigo IsNot Nothing Then
                                    Dim idArtigoLote As Long = stockArtigo.IDArtigoLote

                                    artigosLotesDB = artigoLoteQuery.Where(Function(al) al.ID = idArtigoLote).FirstOrDefault()
                                End If
                        End Select

                        ' A informação que está a ser carregada é a que vai ser guardada na base dados
                        If artigosLotesDB Is Nothing Then
                            With linhaDoc
                                .IDLote = Nothing
                                .CodigoLote = Nothing
                                .DescricaoLote = Nothing
                                .DataFabricoLote = Nothing
                                .DataValidadeLote = Nothing
                            End With
                        Else
                            With linhaDoc
                                .IDLote = artigosLotesDB.ID
                                .CodigoLote = artigosLotesDB.Codigo
                                .DescricaoLote = artigosLotesDB.Descricao
                                .DataFabricoLote = artigosLotesDB.DataFabrico
                                .DataValidadeLote = artigosLotesDB.DataValidade
                            End With
                        End If
                    End If
                End If
            End If
        End Sub

#End Region

#Region "IMPORTAÇÃO DOCUMENTOS"

        Public Shared Function ListaDocsLinhas(Of TDocBD As Class, TDocMOD As CabecalhoDocumento, TDocLinhasBD As Class, TDocLinhasMOD As DocumentosLinhas)(
            ctx As DbContext, filtro As ClsF3MFiltro, ByRef lstDocs As List(Of TDocMOD), ByRef lstLinhasDocs As List(Of TDocLinhasMOD), ByVal idTipoDoc As Long?, ByVal campoIDDoc As String, ByVal campoIDLinhaDoc As String) As List(Of TDocLinhasMOD)
            Dim lstlinhasDocumentos As List(Of TDocLinhasMOD) = Nothing

            If lstDocs IsNot Nothing AndAlso lstDocs.Count > 0 Then
                Dim lstDocsIDs As List(Of Long) = lstDocs.
                        Where(Function(w) w.ID <> 0).
                        Select(Function(s) s.ID).ToList

                Dim tabID As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, "TabID", GetType(String))
                Dim docAtualID As Long? = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, CamposGenericos.IDDocumento, GetType(Long?))
                Dim indexMaxAux As Long? = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, "IndexMax", GetType(Long?))
                Dim indexMax As Long = If(indexMaxAux, 0)
                Dim ordemMaxAux As Long? = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(filtro, "OrdemMax", GetType(Long?))
                Dim ordemMax As Long = If(ordemMaxAux, 1)

                Dim funcSel As Func(Of TDocLinhasBD, TDocLinhasMOD) =
                        Function(docLinBD) MapeiaDLEsp(Of TDocBD, TDocMOD, TDocLinhasBD, TDocLinhasMOD)(
                                ctx, filtro, docLinBD, idTipoDoc, campoIDDoc, campoIDLinhaDoc, tabID, docAtualID, indexMax, ordemMax)

                Dim funcWhere As Func(Of TDocLinhasBD, Boolean) =
                        Function(w)
                            Dim IDDoc As Long? = ClsUtilitarios.DaPropriedadedoModeloReflection(w, campoIDDoc)
                            Return IDDoc IsNot Nothing AndAlso lstDocsIDs.Contains(IDDoc)
                        End Function

                If lstLinhasDocs IsNot Nothing AndAlso lstLinhasDocs.Count > 0 Then
                    Dim lstDocLinsIDs As List(Of Long) = lstLinhasDocs.
                            Where(Function(w) w.ID <> 0).
                            Select(Function(s) s.ID).ToList

                    funcWhere =
                        Function(w)
                            Dim IDDocLin As Long? = CObj(w).ID
                            Return IDDocLin IsNot Nothing AndAlso lstDocLinsIDs.Contains(IDDocLin)
                        End Function
                End If

                Dim nomeDocDB As String = GetType(TDocBD).Name

                lstlinhasDocumentos =
                    ctx.Set(Of TDocLinhasBD)().AsNoTracking _
                        .Include(nomeDocDB).Include(nomeDocDB & ".tbMoedas") _
                        .Include(nomeDocDB & ".tbTiposDocumento").Include(nomeDocDB & ".tbTiposDocumento.tbSistemaNaturezas").Include(nomeDocDB & ".tbTiposDocumento.tbSistemaTiposDocumento") _
                        .Include("tbArtigos").Include("tbArtigos.tbTiposArtigos").Include("tbArtigos.tbSistemaTiposPrecos") _
                        .Include("tbArmazens").Include("tbArmazensLocalizacoes") _
                        .Include("tbArmazens1").Include("tbArmazensLocalizacoes1") _
                        .Include("tbUnidades").Include("tbUnidades1").Include("tbUnidades2") _
                        .Include("tbIVA") _
                        .Where(funcWhere) _
                        .Select(funcSel) _
                        .OrderBy(Function(a) a.DocumentoReferencia) _
                        .ToList
            End If

            Return lstlinhasDocumentos
        End Function

        Private Shared Function MapeiaDLEsp(Of TDocBD As Class, TDocMOD As CabecalhoDocumento, TDocLinhasBD As Class, TDocLinhasMOD As DocumentosLinhas)(
            inCtx As DbContext, inObjFiltro As ClsF3MFiltro, inDocLinhaBD As TDocLinhasBD, inTipoDocOrigem As String, inCampoDocID As String, inCampoDocLinID As String, inTabID As String, inDocAtualID As Long?, ByRef inIndexMax As Long, ByRef inOrdemMax As Long) As TDocLinhasMOD

            Dim oTDocBD As Object = ClsUtilitarios.DaPropriedadedoModeloReflection(inDocLinhaBD, GetType(TDocBD).Name)
            Dim oDocLinhaBD As Object = inDocLinhaBD
            Dim docLinMOD As TDocLinhasMOD = Nothing

            Dim oTArtBD As tbArtigos = ClsUtilitarios.DaPropriedadedoModeloReflection(oDocLinhaBD, GetType(tbArtigos).Name)

            ' Comparação de Naturezas entre documentos para função de cálculo de quantidades
            Dim oTDocOrigemBD As tbTiposDocumento =
                inCtx.Set(Of tbTiposDocumento)().AsNoTracking _
                    .Include("tbSistemaNaturezas") _
                    .Include("tbSistemaTiposDocumentoFiscal") _
                    .Include("tbSistemaTiposDocumento") _
                    .Include("tbSistemaTiposDocumentoMovStock") _
                    .Where(Function(w) w.ID = CLng(inTipoDocOrigem)) _
                    .FirstOrDefault

            Dim mesmaNatureza As Boolean = oTDocBD?.tbTiposDocumento?.tbSistemaNaturezas?.Codigo = oTDocOrigemBD?.tbSistemaNaturezas?.Codigo

            Dim strTpFiscal As String = If(oTDocOrigemBD?.tbSistemaTiposDocumentoFiscal?.Tipo, String.Empty)
            Dim strSisTpAtual As String = If(oTDocOrigemBD?.tbSistemaTiposDocumento?.Tipo, String.Empty)
            Dim strSisTpOrigem As String = If(oTDocBD?.tbTiposDocumento?.tbSistemaTiposDocumento?.Tipo, String.Empty)

            docLinMOD = Mapeia(Of TDocBD, TDocLinhasBD, TDocLinhasMOD)(inDocLinhaBD, inCampoDocID)

            If oTDocBD?.tbTiposDocumento?.DocNaoValorizado Then
                If oTDocOrigemBD?.DocNaoValorizado = False Then
                    docLinMOD.DocumentoOrigemCarregaPrecoTaxasPorDefeito = True
                End If
            End If

            If oTDocOrigemBD?.DocNaoValorizado Then
                If oTDocBD?.tbTiposDocumento?.DocNaoValorizado = False Then
                    docLinMOD.PrecoUnitario = Nothing
                    docLinMOD.PrecoTotal = Nothing
                    docLinMOD.PrecoTotalAnterior = Nothing
                    docLinMOD.IDTaxaIva = Nothing
                    docLinMOD.CodigoTaxaIva = Nothing
                    docLinMOD.TaxaIva = Nothing
                    docLinMOD.CodigoMotivoIsencaoIva = Nothing
                    docLinMOD.MotivoIsencaoIva = Nothing
                    docLinMOD.IDTipoIva = Nothing
                    docLinMOD.IDCodigoIva = Nothing
                    docLinMOD.IDEspacoFiscal = Nothing
                    docLinMOD.IDRegimeIva = Nothing
                    docLinMOD.ValorIncidencia = Nothing
                    docLinMOD.ValorIVA = Nothing
                    docLinMOD.ValorIvaAnterior = Nothing
                    docLinMOD.CodigoTipoIva = Nothing
                    docLinMOD.CodigoRegiaoIva = Nothing
                    docLinMOD.PercIncidencia = Nothing
                    docLinMOD.PercDeducao = Nothing
                    docLinMOD.ValorIvaDedutivel = Nothing
                    docLinMOD.Desconto1 = Nothing
                    docLinMOD.Desconto2 = Nothing
                    docLinMOD.ValorDescontoLinha = Nothing
                    docLinMOD.ValorDescontoLinhaAnterior = Nothing
                End If
            End If

            ' Mapear DL Especifico
            Dim IDDoc As Long? = ClsUtilitarios.DaPropriedadedoModeloReflection(oTDocBD, CamposGenericos.ID)

            ClsUtilitarios.AtribuiPropriedadedoModeloReflection(docLinMOD, inCampoDocID, IDDoc)

            'Trata Armazens
            If mesmaNatureza = False Then
                If docLinMOD.IDArmazem IsNot Nothing Then
                    docLinMOD.IDArmazemDestino = docLinMOD.IDArmazem
                    docLinMOD.IDArmazemLocalizacaoDestino = docLinMOD.IDArmazemLocalizacao
                    docLinMOD.DescricaoArmazemDestino = docLinMOD.DescricaoArmazem
                    docLinMOD.DescricaoArmazemLocalizacaoDestino = docLinMOD.DescricaoArmazemLocalizacao
                    docLinMOD.CodigoArmazemLocalizacaoDestino = docLinMOD.CodigoArmazemLocalizacao
                    docLinMOD.IDArmazem = Nothing
                    docLinMOD.IDArmazemLocalizacao = Nothing
                    docLinMOD.DescricaoArmazem = Nothing
                    docLinMOD.DescricaoArmazemLocalizacao = Nothing
                    docLinMOD.CodigoArmazemLocalizacao = Nothing
                ElseIf docLinMOD.IDArmazemDestino IsNot Nothing Then
                    docLinMOD.IDArmazem = docLinMOD.IDArmazemDestino
                    docLinMOD.IDArmazemLocalizacao = docLinMOD.IDArmazemLocalizacaoDestino
                    docLinMOD.DescricaoArmazem = docLinMOD.DescricaoArmazemDestino
                    docLinMOD.DescricaoArmazemLocalizacao = docLinMOD.DescricaoArmazemLocalizacaoDestino
                    docLinMOD.CodigoArmazemLocalizacao = docLinMOD.CodigoArmazemLocalizacaoDestino
                    docLinMOD.IDArmazemDestino = Nothing
                    docLinMOD.IDArmazemLocalizacaoDestino = Nothing
                    docLinMOD.DescricaoArmazemDestino = Nothing
                    docLinMOD.DescricaoArmazemLocalizacaoDestino = Nothing
                    docLinMOD.CodigoArmazemLocalizacaoDestino = Nothing
                End If
            End If

            With docLinMOD
                Dim tbDLNome As String = GetType(TDocLinhasMOD).Name

                If tbDLNome.Equals(GetType(DocumentosStockLinhas).Name) Then
                    Dim idLDSIni As Long? = If(oDocLinhaBD.IDLinhaDocumentoStockInicial, oDocLinhaBD.ID)

                    CObj(docLinMOD).IDLinhaDocumentoStock = oDocLinhaBD.ID
                    CObj(docLinMOD).IDLinhaDocumentoStockInicial = idLDSIni

                ElseIf tbDLNome.Equals(GetType(DocumentosComprasLinhas).Name) Then
                    Dim relTDS As TDocBD = ClsUtilitarios.DaPropriedadedoModeloReflection(oDocLinhaBD, GetType(TDocBD).Name)
                    Dim idLDCIni As Long? = Nothing
                    Dim idLDCIniAux As Long? = Nothing
                    Dim idLDSIni As Long? = Nothing
                    Dim idLDSIniAux As Long? = Nothing
                    Dim idLSubContIni As Long? = Nothing

                    If oDocLinhaBD.GetType.BaseType.Name.ToLower() = "tbdocumentossubcontratacaolinhas" Then
                        Dim idLSubContIniAux As Long? = oDocLinhaBD.IDLinhaDocumentoSubContratacaoInicial
                        idLSubContIniAux = oDocLinhaBD.ID

                        If idLSubContIniAux IsNot Nothing Then
                            idLSubContIni = idLSubContIniAux
                        ElseIf idLSubContIniAux Is Nothing AndAlso idLDCIniAux Is Nothing Then
                            idLSubContIni = oDocLinhaBD.ID
                        End If

                        CObj(docLinMOD).IDLinhaDocumentoSubContratacao = oDocLinhaBD.ID
                        CObj(docLinMOD).IDLinhaDocumentoSubContratacaoInicial = idLSubContIni
                    Else
                        idLDCIniAux = oDocLinhaBD.IDLinhaDocumentoCompraInicial
                        idLDSIniAux = oDocLinhaBD.IDLinhaDocumentoStockInicial

                        If idLDCIniAux IsNot Nothing Then
                            idLDCIni = idLDCIniAux
                        ElseIf idLDCIniAux Is Nothing AndAlso idLDSIniAux Is Nothing Then
                            idLDCIni = oDocLinhaBD.ID
                        ElseIf idLDSIniAux IsNot Nothing Then
                            idLDSIni = idLDSIniAux
                        ElseIf idLDSIniAux Is Nothing AndAlso idLDCIniAux Is Nothing Then
                            idLDSIni = oDocLinhaBD.ID
                        End If

                        CObj(docLinMOD).IDLinhaDocumentoCompra = oDocLinhaBD.ID
                        CObj(docLinMOD).IDLinhaDocumentoCompraInicial = idLDCIni
                        CObj(docLinMOD).IDLinhaDocumentoStockInicial = idLDSIni
                    End If

                ElseIf tbDLNome.Equals(GetType(DocumentosVendasLinhas).Name) Then

                    If CObj(docLinMOD).IDDocOrigemMod Is Nothing Then
                        CObj(docLinMOD).IDDocOrigemMod = oTDocBD.ID
                        CObj(docLinMOD).IDTPDocOrigemMod = oTDocBD.IDTipoDocumento
                        CObj(docLinMOD).DocOrigemMod = oTDocBD.Documento
                    End If

                    CObj(docLinMOD).IDLinhaDocumentoVenda = oDocLinhaBD.ID
                    CObj(docLinMOD).PrecoUnitarioEfetivoMoedaRef = oDocLinhaBD.PrecoUnitarioEfetivoMoedaRef
                    CObj(docLinMOD).PrecoUnitarioEfetivoMoedaRefOrigem = oDocLinhaBD.PrecoUnitarioEfetivoMoedaRef
                ElseIf tbDLNome.Equals(GetType(DocumentosCustosLinhas).Name) Then
                    Dim idLDCIni As Long? = Nothing
                    Dim idLDCIniAux As Long? = Nothing
                    Dim idLDCustIni As Long? = Nothing
                    Dim idLDCustIniAux As Long? = Nothing

                    If oDocLinhaBD.GetType.BaseType.Name.ToLower() = "tbdocumentoscompraslinhas" Then
                        idLDCIniAux = oDocLinhaBD.IDLinhaDocumentoCompraInicial
                        If idLDCIniAux IsNot Nothing Then
                            idLDCIni = idLDCIniAux
                        ElseIf idLDCIniAux Is Nothing AndAlso idLDCustIniAux Is Nothing Then
                            idLDCIni = oDocLinhaBD.ID
                        End If

                        CObj(docLinMOD).IDLinhaDocumentoCompra = oDocLinhaBD.ID
                        CObj(docLinMOD).IDLinhaDocumentoCompraInicial = idLDCIni
                    Else
                        idLDCustIniAux = oDocLinhaBD.IDLinhaDocumentoCustosInicial
                        If idLDCustIniAux IsNot Nothing Then
                            idLDCustIni = idLDCustIniAux
                        ElseIf idLDCustIniAux Is Nothing AndAlso idLDCIniAux Is Nothing Then
                            idLDCustIni = oDocLinhaBD.ID
                        End If

                        CObj(docLinMOD).IDLinhaDocumentoCustos = oDocLinhaBD.ID
                        CObj(docLinMOD).IDLinhaDocumentoCustosInicial = idLDCustIni
                    End If
                End If

                .ID = 0
                .AcaoCRUD = AcoesFormulario.Adicionar
                .AcaoFormulario = AcoesFormulario.Adicionar

                .IDTipoDocumentoOrigem = oTDocBD.IDTipoDocumento
                .IDDocumentoOrigem = IDDoc
                .IDLinhaDocumentoOrigem = oDocLinhaBD.ID
                .NumeroDocumentoOrigem = oTDocBD.NumeroDocumento
                .VossoNumeroDocumentoOrigem = oTDocBD.VossoNumeroDocumento
                .DocumentoOrigem = oTDocBD.Documento
                .DocumentoReferencia = If(String.IsNullOrEmpty(.VossoNumeroDocumentoOrigem), .DocumentoOrigem, .VossoNumeroDocumentoOrigem)
                .DataDocOrigem = oTDocBD.DataDocumento

                ' Doc Orig INICIAL
                Dim idTDIni As Long? = If(oDocLinhaBD.IDTipoDocumentoOrigemInicial, .IDTipoDocumentoOrigem)
                Dim idDIni As Long? = If(oDocLinhaBD.IDDocumentoOrigemInicial, .IDDocumentoOrigem)
                Dim idLDIni As Long? = If(oDocLinhaBD.IDLinhaDocumentoOrigemInicial, .IDLinhaDocumentoOrigem)
                Dim docOrigIni As String = If(oDocLinhaBD.DocumentoOrigemInicial, .DocumentoOrigem)

                .IDTipoDocumentoOrigemInicial = idTDIni
                .IDDocumentoOrigemInicial = idDIni
                .DocumentoOrigemInicial = docOrigIni
                .IDLinhaDocumentoOrigemInicial = idLDIni

                .IDTiposDocumentoSeriesOrigem = oTDocBD.IDTiposDocumentoSeries
                .IDDocumento = oTDocBD.ID
                .IDTipoDocumento = oTDocBD.IDTipoDocumento
                .IDTiposDocumentoSeries = oTDocBD.IDTiposDocumentoSeries

                .GereStock = CBool(oTArtBD?.GereStock)
                .DescricaoVariavel = If(oDocLinhaBD.IDArtigo Is Nothing OrElse oDocLinhaBD.IDArtigo = 0, True,
                        If(oTDocBD.Assinatura IsNot Nothing, False, If(oTArtBD IsNot Nothing, oTArtBD.DescricaoVariavel, True)))

                .GereLotes = CBool(oTArtBD?.GereLotes)

                If oTDocOrigemBD?.tbSistemaTiposDocumentoMovStock?.Codigo = SistemaMovimentacaoStock.Entrada Then
                    .PercDeducao = CObj(oTArtBD).DedutivelPercentagem
                End If

                ' QUANTIDADES
                If tbDLNome.Equals(GetType(DocumentosCustosLinhas).Name) OrElse
                        ((tbDLNome.Equals(GetType(DocumentosVendasLinhas).Name) OrElse tbDLNome.Equals(GetType(DocumentosComprasLinhas).Name)) AndAlso strTpFiscal = TiposDocumentosFiscal.NotaDebito) Then
                    .Quantidade = CDbl(oDocLinhaBD.Quantidade)
                    .QuantidadeStock = CDbl(oDocLinhaBD.QuantidadeStock)
                    .QuantidadeStock2 = CDbl(oDocLinhaBD.QuantidadeStock2)
                Else
                    If tbDLNome.Equals(GetType(DocumentosComprasLinhas).Name) AndAlso strSisTpAtual = TiposSistemaTiposDocumento.ComprasFinanceiro AndAlso strSisTpOrigem = TiposSistemaTiposDocumento.ComprasTransporte Then
                        .Quantidade = CDbl(oDocLinhaBD.Quantidade)
                        .QuantidadeStock = CDbl(oDocLinhaBD.QuantidadeStock)
                        .QuantidadeStock2 = CDbl(oDocLinhaBD.QuantidadeStock2)
                    Else
                        .Quantidade = If(mesmaNatureza,
                            CDbl(oDocLinhaBD.Quantidade) - CDbl(oDocLinhaBD.QuantidadeSatisfeita) + CDbl(oDocLinhaBD.QuantidadeDevolvida),
                            CDbl(oDocLinhaBD.Quantidade) - CDbl(oDocLinhaBD.QuantidadeDevolvida))
                        .QuantidadeStock = If(mesmaNatureza,
                            CDbl(oDocLinhaBD.QuantidadeStock) - CDbl(oDocLinhaBD.QtdStockSatisfeita) + CDbl(oDocLinhaBD.QtdStockDevolvida),
                            CDbl(oDocLinhaBD.QuantidadeStock) - CDbl(oDocLinhaBD.QtdStockDevolvida))
                        .QuantidadeStock2 = If(mesmaNatureza,
                            CDbl(oDocLinhaBD.QuantidadeStock2) - CDbl(oDocLinhaBD.QtdStock2Satisfeita) + CDbl(oDocLinhaBD.QtdStock2Devolvida),
                            CDbl(oDocLinhaBD.QuantidadeStock2) - CDbl(oDocLinhaBD.QtdStock2Devolvida))
                    End If
                End If

                .QuantidadeSatisfeita = Nothing
                .QuantidadeDevolvida = Nothing

                .QtdStockSatisfeita = Nothing
                .QtdStockDevolvida = Nothing
                .QtdStockAcerto = Nothing

                .QtdStock2Satisfeita = Nothing
                .QtdStock2Devolvida = Nothing
                .QtdStock2Acerto = Nothing

                .Satisfeito = False

                .LerQuantidade = If(oTArtBD.IDDimensaoPrimeira IsNot Nothing OrElse oTArtBD.IDDimensaoSegunda IsNot Nothing, False, If(oDocLinhaBD.IDArtigo Is Nothing OrElse oDocLinhaBD.IDArtigo = 0, False, True))
                .LerQtdConvUnidStk = (oTArtBD.tbTiposArtigos.StkUnidade1) AndAlso (If(oTArtBD.IDDimensaoPrimeira IsNot Nothing OrElse oTArtBD.IDDimensaoSegunda IsNot Nothing, False, True)) AndAlso (oDocLinhaBD.IDUnidade <> oDocLinhaBD.IDUnidadeStock) AndAlso If(oDocLinhaBD.IDArtigo Is Nothing OrElse oDocLinhaBD.IDArtigo = 0, False, True)
                .LerQtdConvUnidStkDim = (oTArtBD.tbTiposArtigos.StkUnidade1) AndAlso (If(oTArtBD.IDDimensaoPrimeira Is Nothing AndAlso oTArtBD.IDDimensaoSegunda Is Nothing, False, True)) AndAlso (oDocLinhaBD.IDUnidade <> oDocLinhaBD.IDUnidadeStock)
                .LerQtdConv2UnidStk = (oTArtBD.tbTiposArtigos.StkUnidade2) AndAlso (If(oTArtBD.IDDimensaoPrimeira IsNot Nothing OrElse oTArtBD.IDDimensaoSegunda IsNot Nothing, False, True)) AndAlso (oDocLinhaBD.IDUnidade <> oDocLinhaBD.IDUnidadeStock2) AndAlso If(oDocLinhaBD.IDArtigo Is Nothing OrElse oDocLinhaBD.IDArtigo = 0, False, True)
                .CasasDecimaisPrecosUnitarios = If(oTDocBD.tbMoedas?.CasasDecimaisPrecosUnitarios, CInt(oTDocBD.tbMoedas?.CasasDecimaisPrecosUnitarios), ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios)
                .CasasDecimaisTotais = If(oTDocBD.tbMoedas?.CasasDecimaisTotais, CInt(oTDocBD.tbMoedas?.CasasDecimaisTotais), ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisTotais)
                .CasasDecimaisIva = If(oTDocBD.tbMoedas?.CasasDecimaisIva, CInt(oTDocBD.tbMoedas?.CasasDecimaisIva), ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisIva)
                .LerPreco = If(oTArtBD?.tbSistemaTiposPrecos?.ID, TipoPrecoArtigo.Unico) = TipoPrecoArtigo.Unico

                'Artigo
                ' Codigo Artigo PA
                Dim idArtigoPA As Long = oDocLinhaBD.IDArtigoPA
                Dim artigoPA = inCtx.Set(Of tbArtigos)().AsNoTracking.Where(Function(a) a.ID = idArtigoPA).FirstOrDefault

                .CodigoArtigoPara = If(artigoPA IsNot Nothing, artigoPA.Codigo, String.Empty)
                .DescricaoArtigoPara = If(artigoPA IsNot Nothing, artigoPA.Descricao, String.Empty)

                ' Gerais
                .DataCriacao = Now
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                .DataAlteracao = Nothing
                .UtilizadorAlteracao = Nothing
                .F3MMarcador = Nothing
                ' ACAO UID
                If .DocumentoOrigemCarregaPrecoTaxasPorDefeito Then
                    .IndexLinhaEmAlteracao = inIndexMax
                End If

                .AcaoUID = String.Concat(inTabID, "_", inDocAtualID, "_", inIndexMax)
                '.IndexLinhaEmAlteracao = inIndexMax
                inIndexMax += 1
                ' ORDEM
                .Ordem = inOrdemMax
                inOrdemMax += 1
            End With

            Return docLinMOD
        End Function

        Public Shared Function Mapeia(Of TDocBD As Class, TDocLinhasBD As Class, TDocLinhasMOD As DocumentosLinhas)(inDocLinBD As TDocLinhasBD, inCampoDocID As String) As TDocLinhasMOD
            Dim docLinMOD As TDocLinhasMOD = Activator.CreateInstance(Of TDocLinhasMOD)

            Dim oDocLinhaBD As Object = inDocLinBD

            If docLinMOD IsNot Nothing AndAlso oDocLinhaBD IsNot Nothing Then
                With docLinMOD
                    Mapear(inDocLinBD, docLinMOD)

                    ' Armazens
                    .IDArmazem = oDocLinhaBD.IDArmazem
                    .DescricaoArmazem = oDocLinhaBD.tbArmazens?.Descricao
                    .IDArmazemLocalizacao = oDocLinhaBD.IDArmazemLocalizacao
                    .CodigoArmazemLocalizacao = oDocLinhaBD.tbArmazensLocalizacoes?.Codigo
                    .DescricaoArmazemLocalizacao = oDocLinhaBD.tbArmazensLocalizacoes?.Descricao
                    .IDArmazemDestino = oDocLinhaBD.IDArmazemDestino
                    .DescricaoArmazemDestino = oDocLinhaBD.tbArmazens1?.Descricao
                    .IDArmazemLocalizacaoDestino = oDocLinhaBD.IDArmazemLocalizacaoDestino
                    .CodigoArmazemLocalizacaoDestino = oDocLinhaBD.tbArmazensLocalizacoes1?.Codigo
                    .DescricaoArmazemLocalizacaoDestino = oDocLinhaBD.tbArmazensLocalizacoes1?.Descricao
                    .IDTaxaIva = oDocLinhaBD.IDTaxaIva
                    .CodigoTaxaIva = oDocLinhaBD.CodigoTaxaIva
                    .DescricaoTaxaIva = oDocLinhaBD.tbIVA?.Descricao
                    .TaxaIva = oDocLinhaBD.TaxaIva

                    ' Unidades
                    .IDUnidade = oDocLinhaBD.IDUnidade
                    .CodigoUnidade = oDocLinhaBD.CodigoUnidade
                    .DescricaoUnidade = oDocLinhaBD.tbUnidades?.Descricao
                    .NumCasasDecUnidade = oDocLinhaBD.NumCasasDecUnidade
                    .IDUnidadeStock = oDocLinhaBD.IDUnidadeStock
                    .CodigoUnidadeStock = oDocLinhaBD.tbUnidades1?.Codigo
                    .DescricaoUnidadeStock = oDocLinhaBD.tbUnidades1?.Descricao
                    .NumCasasDecUnidadeStk = oDocLinhaBD.NumCasasDecUnidadeStk
                    .FatorConvUnidStk = oDocLinhaBD.FatorConvUnidStk
                    .OperacaoConvUnidStk = oDocLinhaBD.OperacaoConvUnidStk
                    .IDUnidadeStock2 = oDocLinhaBD.IDUnidadeStock2
                    .CodigoUnidadeStock2 = oDocLinhaBD.tbUnidades2?.Codigo
                    .DescricaoUnidadeStock2 = oDocLinhaBD.tbUnidades2?.Descricao
                    .NumCasasDec2UnidadeStk = oDocLinhaBD.NumCasasDec2UnidadeStk
                End With
            End If

            Return docLinMOD
        End Function

#End Region

    End Class
End Namespace