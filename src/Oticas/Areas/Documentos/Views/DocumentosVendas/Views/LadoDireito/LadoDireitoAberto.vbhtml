@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.DocumentosVendas
@code
    Dim DescontosLinha As Double = 0
    Dim SubTotal As Double = 0
    Dim TotalIVA As Double = 0
    Dim OutrosDescontos As Double = 0
    Dim TotalEntidade1 As Double = 0

    If Not IsNothing(Model.SubTotal) Then SubTotal = Model.SubTotal

    If Not IsNothing(Model.DescontosLinha) Then DescontosLinha = Model.DescontosLinha

    If Not IsNothing(Model.TotalIva) Then TotalIVA = Model.TotalIva

    If Not IsNothing(Model.OutrosDescontos) Then OutrosDescontos = Model.OutrosDescontos

    If Not IsNothing(Model.TotalEntidade1) Then TotalEntidade1 = Model.TotalEntidade1

    Dim simbMoedaAux As String = " " & Model.Simbolo
    Dim casasDecTotais As Byte = Model.CasasDecimaisTotais
    Dim casasDecIva As Byte = Model.CasasDecimaisIva

End Code

@Html.Partial("~/F3M/Areas/Comum/Views/Razao/Index.vbhtml",
                                New With {
                                    .Label = Traducao.EstruturaDocumentos.Razao,
                                    .Propriedade = "RazaoEstado",
                                    .Modelo = Model,
                                    .divClassesCSS = "divRazaoEstado" + If(Model.RazaoEstado = Nothing, " hidden", String.Empty),
                                    .InputClassesCSS = {""},
                                    .EEditavel = Funcoes.NaoEEditavel(Model, {Validacao.EstadoAnulado, Validacao.EntregueSAFT})
                                })

<div>
    <ul class="list-unstyled total-soma">
        <li>@Traducao.EstruturaAplicacaoTermosBase.Total</li>
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalMoedaDocumento",
                .AlinhamentoLabel = AlinhamentoColuna.Direita,
                .ValorMinimo = 0,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = casasDecTotais,
                .Modelo = Model,
                .EEditavel = Not Model.flgImpFromServicosToFT2,
                .FuncaoJSChange = "DocumentosVendasDescontoGlobal"})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "SubTotal",
                 .Label = Traducao.EstruturaAplicacaoTermosBase.Valor,
                 .TipoEditor = Mvc.Componentes.F3MNumero,
                 .CasasDecimais = casasDecTotais,
                 .Modelo = Model,
                 .EEditavel = False,
                 .EVisivel = False})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ValorImposto",
                .Label = Traducao.EstruturaAplicacaoTermosBase.Valor,
                .TipoEditor = Mvc.Componentes.F3MNumero,
                .CasasDecimais = casasDecIva,
                .Modelo = Model,
                .EEditavel = False,
                .EVisivel = False,
                .ViewClassesCSS = {ClassesCSS.XS6}})
        End code
    </ul>
    <div class="valor-soma">
        <ul class="list-unstyled">
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.SubTotal</div>
                <div>
                    <strong>
                        <span id="idSubTotal">@(FormatNumber(SubTotal, casasDecTotais) & " " & simbMoedaAux)</span>
                    </strong>
                </div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.DescontoLinha</div>
                <div>
                    <strong>
                        <span id="idDescontoLinha">@(FormatNumber(DescontosLinha, casasDecTotais) & " " & simbMoedaAux)</span>
                    </strong>
                </div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.DescontoGlobal</div>
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PercentagemDesconto",
                        .TipoEditor = Mvc.Componentes.F3MNumero,
                        .AlinhamentoLabel = AlinhamentoColuna.Direita,
                        .ValorMinimo = 0,
                        .ValorMaximo = 100,
                        .Formato = "#.000000 \%",
                        .CasasDecimais = 6,
                        .Modelo = Model,
                        .EEditavel = Not Model.flgImpFromServicosToFT2,
                        .FuncaoJSChange = "DocumentosVendasDescontoGlobal",
                        .AtributosHtml = New With {.class = "sem-label"}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ValorDesconto",
                                        .TipoEditor = Mvc.Componentes.F3MNumero,
                                        .ValorMinimo = 0,
                                        .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                        .CasasDecimais = casasDecTotais,
                                        .Modelo = Model,
                                        .EEditavel = Not Model.flgImpFromServicosToFT2,
                                        .FuncaoJSChange = "DocumentosVendasDescontoGlobal",
                                        .AtributosHtml = New With {.class = "sem-label"}})
                End code
            </li>
            <li>
                <div id="elemFloatingDescontos" class="def-resumo clsF3MElemFloating hidden">
                    <a class="clsF3MElemFloatingText hidden">
                        <span class="">@Traducao.EstruturaAplicacaoTermosBase.OutrosDescontos</span>
                    </a>
                    <div class="set-resumo abre-dir set-position" style="width:200px; min-width: 200px;">
                        <div class="form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TotalPontos",
                                        .Label = Traducao.EstruturaAplicacaoTermosBase.TotalPontos,
                                        .TipoEditor = Mvc.Componentes.F3MNumero,
                                        .ValorMinimo = 0,
                                        .CasasDecimais = casasDecTotais,
                                        .AlinhamentoLabel = AlinhamentoColuna.Direita,
                                        .Modelo = Model,
                                        .EEditavel = Not Model.flgImpFromServicosToFT2,
                                        .FuncaoJSChange = "DocumentosVendasDescontoGlobal"})
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
                                        .EEditavel = Not Model.flgImpFromServicosToFT2,
                                        .FuncaoJSChange = "DocumentosVendasDescontoGlobal"})
                            End code
                        </div>
                    </div>
                </div>
                <div>
                    <strong>
                        <span id="OutrosDescontos">@(FormatNumber(OutrosDescontos, casasDecTotais) & " " & simbMoedaAux)</span>@*<span class="Currency">@(simbMoedaAux)</span>*@
                    </strong>
                </div>
            </li>
            <li>
                <div id="elemFloatingIncidencias" class="def-resumo clsF3MElemFloating">
                    <a class="clsF3MElemFloatingText f3mlink">
                        <span id="spanTotalIva">@(Traducao.EstruturaAplicacaoTermosBase.TotalIva)</span>
                    </a>
                    <div class="set-resumo abre-dir set-position">
                        <div class="handson-container">
                            <div id="hdsnIncidencias"></div>
                        </div>
                    </div>
                </div>
                <div>
                    <strong>
                        <span id="TotalIva">@(FormatNumber(TotalIVA, casasDecIva) & " " & simbMoedaAux)</span>@*<span class="Currency">@(simbMoedaAux)</span>*@
                    </strong>
                </div>
            </li>
            <li>
                <div>@Traducao.EstruturaAplicacaoTermosBase.TotalEntidade1</div>
                <div>
                    <strong>
                        <span id="TotalEntidade1">@(FormatNumber(TotalEntidade1, casasDecTotais) & " " & simbMoedaAux)</span>@*<span class="Currency">@(simbMoedaAux)</span>*@
                    </strong>
                </div>
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
                        .EEditavel = False,
                        .FuncaoJSChange = "DocumentosVendasDescontoGlobal",
                        .AtributosHtml = New With {.class = "sem-label"}})
                End code
            </li>
        </ul>
    </div>
</div>