@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@code
    Dim DescontosLinha As Double = 0
    Dim SubTotal As Double = 0
    Dim TotalIVA As Double = 0
    Dim OutrosDescontos As Double = 0
    Dim TotalEntidade1 As Double = 0
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario

    Dim simbMoedaAux As String = " " & Model.Simbolo
    Dim casasDecPerc As Byte = Model.CasasDecimaisPercentagem
    Dim casasDecTotais As Byte = Model.CasasDecimaisTotais
    Dim casasDecPrecosUni As Byte = Model.CasasDecimaisPrecosUnitarios
    Dim casasDecIVA As Byte = Model.CasasDecimaisIva

    If Model.SubTotal IsNot Nothing Then
        SubTotal = Model.SubTotal
    End If

    If Model.DescontosLinha IsNot Nothing Then
        DescontosLinha = Model.DescontosLinha
    End If

    If Model.TotalIVA IsNot Nothing Then
        TotalIVA = Model.TotalIVA
    End If

    If Model.OutrosDescontos IsNot Nothing Then
        OutrosDescontos = Model.OutrosDescontos
    End If

    If Model.TotalEntidade1 IsNot Nothing Then
        TotalEntidade1 = Model.TotalEntidade1
    End If
End Code

<div id="TotaisArtigos">
    <ul class="list-unstyled total-soma">
        <li>
            @Traducao.EstruturaAplicacaoTermosBase.Total
            <span>@Traducao.EstruturaTiposDocumento.Servicos + @Traducao.EstruturaTiposDocumento.Artigos</span>
        </li>        
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalMoedaDocumento",
                .AlinhamentoLabel = AlinhamentoColuna.Direita,
                .ValorMinimo = 0,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = casasDecTotais,
                .Modelo = Model,
                .FuncaoJSChange = "ServicosCalculaDescontoGlobal",
                .AtributosHtml = New With {.class = " sem-label"}})
        End code
    </ul>
    <div class="valor-soma">
        <ul class="list-unstyled">
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.SubTotal</div>
                <div><strong><span id="IdSubtotal">@(FormatNumber(SubTotal, casasDecTotais))</span><span class="Currency">@(simbMoedaAux)</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.DescontoLinha</div>
                <div><strong><span id="DescontosLinha">@(FormatNumber(DescontosLinha, casasDecTotais))</span><span class="Currency">@(simbMoedaAux)</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.DescontoGlobal</div>
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PercentagemDesconto",
                .AlinhamentoLabel = AlinhamentoColuna.Direita,
                .ValorMinimo = 0,
                .ValorMaximo = 100,
                .Formato = "#.000000 \%",
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = 6,
                .Modelo = Model,
                .FuncaoJSChange = "ServicosCalculaDescontoGlobal",
                .AtributosHtml = New With {.class = " sem-label"}})
                End code

                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ValorDesconto",
                                        .TipoEditor = Mvc.Componentes.F3MNumero,
                                        .ValorMinimo = 0,
                                        .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                        .CasasDecimais = casasDecTotais,
                                        .Modelo = Model,
                                        .FuncaoJSChange = "ServicosCalculaDescontoGlobal",
                                        .AtributosHtml = New With {.class = " sem-label"}})
                End code
            </li>
            <li>
                <div id="elemFloatingDescontos" class="def-resumo clsF3MElemFloating hidden">
                    <a class="clsF3MElemFloatingText hidden">
                        <span class="">@Traducao.EstruturaAplicacaoTermosBase.OutrosDescontos</span>
                    </a>
                    <div class="set-resumo abre-dir set-position" style="width:100px; min-width: 130px;">
                        <div class="form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalPontos",
                                            .Label = Traducao.EstruturaAplicacaoTermosBase.TotalPontos,
                                            .TipoEditor = Mvc.Componentes.F3MNumero,
                                            .ValorMinimo = 0,
                                            .CasasDecimais = casasDecTotais,
                                            .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                            .Modelo = Model,
                                            .FuncaoJSChange = "ServicosCalculaDescontoGlobal"})
                            End code
                        </div>
                        <div class="form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalValesOferta",
                                            .Label = Traducao.EstruturaAplicacaoTermosBase.TotalValesOferta,
                                            .TipoEditor = Mvc.Componentes.F3MNumero,
                                            .ValorMinimo = 0,
                                            .CasasDecimais = casasDecTotais,
                                            .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                            .Modelo = Model,
                                            .FuncaoJSChange = "ServicosCalculaDescontoGlobal"})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ValorImposto",
                                            .Label = Traducao.EstruturaAplicacaoTermosBase.Valor,
                                            .TipoEditor = Mvc.Componentes.F3MNumero,
                                            .CasasDecimais = 2,
                                            .Modelo = Model,
                                            .EEditavel = False,
                                            .EVisivel = False,
                                            .ViewClassesCSS = {ClassesCSS.XS6}})

                            End code
                        </div>
                    </div>
                </div>
                <div><strong><span id="IdOutrosDescontos">@(FormatNumber(OutrosDescontos, casasDecTotais))</span><span class="Currency">@(simbMoedaAux)</span></strong></div>
            </li>
            <li>
                <div id="elemFloatingIncidencias" class="def-resumo clsF3MElemFloating">
                    <a class="clsF3MElemFloatingText f3mlink">
                        <span id="spanTotalIva">@(Traducao.EstruturaAplicacaoTermosBase.TotalIva)</span>
                    </a>
                    <div class="set-resumo abre-dir set-position" style="width:250px; min-width:200px;">
                        <div class="handson-container">
                            <div id="hdsnIncidencias"></div>
                        </div>
                    </div>
                </div>
                <div><strong><span id="IdTotalIva">@(FormatNumber(TotalIVA, casasDecTotais))</span><span class="Currency">@(simbMoedaAux)</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.TotalEntidade1</div>
                <div><strong><span id="IdTotalEntidade1">@(FormatNumber(TotalEntidade1, casasDecTotais))</span><span class="Currency">@(simbMoedaAux)</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.TotalEntidade2</div>
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalEntidade2",
                                .TipoEditor = Mvc.Componentes.F3MNumero,
                                .ValorMinimo = 0,
                                .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                .CasasDecimais = casasDecTotais,
                                .Modelo = Model,
                                .FuncaoJSChange = "ServicosCalculaDescontoGlobal",
                                .AtributosHtml = New With {.class = "sem-label"}})
                End code
            </li>
        </ul>
    </div>
</div>