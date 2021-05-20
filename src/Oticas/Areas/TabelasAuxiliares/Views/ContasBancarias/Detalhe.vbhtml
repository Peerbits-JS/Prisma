@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Autenticacao
@Imports Traducao.Traducao
@ModelType ContasBancarias

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/ContasBancarias/Detalhe.vbhtml", Model)

@CODE
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Codigo",
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                                .Modelo = Model,
                                .EEditavel = If(Model.AcaoFormulario = AcoesFormulario.Adicionar, True, False),
                                .TipoEditor = Mvc.Componentes.F3MTexto,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS2}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Descricao",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDBanco",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Banco,
                        .Controlador = "./Bancos",
                        .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                        .TipoEditor = Mvc.Componentes.F3MLookup,
                        .EEditavel = True,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS2}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Ativo",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .ViewClassesCSS = {ClassesCSS.XS1}})
                End Code
            </div>
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <!--Nav tabs-->
                <ul class="nav nav-pills f3m-tabs__ul" role="tablist">
                    <li class="nav-item" role="presentation"><a href="#tabDefinicao" class="nav-link active" role="tab" data-toggle="tab" aria-expanded="true">@Traducao.EstruturaAplicacaoTermosBase.Definicao</a></li>
                    <li class="nav-item" role="presentation"><a href="#tabMoradaContatos" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Moradas_Contatos</a></li>
                    <li class="nav-item" role="presentation"><a href="#tabObservacoes" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Observacoes</a></li>
                </ul>
                <div class="tab-content">
                    <div id="tabDefinicao" role="tabpanel" class="tab-pane fade show active">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMoeda",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Moeda,
                                    .Controlador = "../TabelasAuxiliares/Moedas",
                                    .TipoEditor = Mvc.Componentes.F3MLookup,
                                    .EEditavel = True,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Plafond",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Plafond,
                                    .TipoEditor = Mvc.Componentes.F3MNumero,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TaxaPlafond",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.TaxaPlafond,
                                    .TipoEditor = Mvc.Componentes.F3MNumero,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})
                            End Code
                        </div>
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PaisIban",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.PaisIban,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NIB",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.NIB,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "SaldoReconciliado",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.SaldoReconciliado,
                                    .TipoEditor = Mvc.Componentes.F3MMoeda,
                                    .EEditavel = False,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "SaldoTotal",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.SaldoTotal,
                                    .TipoEditor = Mvc.Componentes.F3MMoeda,
                                    .EEditavel = False,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})
                            End Code
                        </div>
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "SepaPrv",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.SepaPrvID,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "VariavelContabilidade",
                                '    .Label = Traducao.EstruturaAplicacaoTermosBase.VariavelContabilidade,
                                '    .Modelo = Model,
                                '    .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ContaCaixa",
                                                        .Label = Traducao.EstruturaAplicacaoTermosBase.ContaCaixa,
                                                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                        .Modelo = Model,
                                                        .ValorPorDefeito = False,
                                                        .ViewClassesCSS = {ClassesCSS.XS2}})
                            End Code
                        </div>
                    </div>
                    <div id="tabMoradaContatos" role="tabpanel" class="tab-pane fade">
                        <div class="form-container">
                            @Code
                                ViewBag.VistaParcial = True
                            End Code
                            @Html.Partial("~/Areas/TabelasAuxiliares/Views/ContasBancariasMoradas/Index.vbhtml")
                        </div>
                        <div class="form-container seguintesgrelhas">
                            @Code
                                ViewBag.VistaParcial = True
                            End Code
                            @Html.Partial("~/Areas/TabelasAuxiliares/Views/ContasBancariasContatos/Index.vbhtml")
                        </div>
                    </div>
                    <div id="tabObservacoes" role="tabpanel" class="tab-pane fade">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Observacoes",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.Observacoes,
                                    .Modelo = Model,
                                    .TipoEditor = Mvc.Componentes.F3MTextArea,
                                    .ViewClassesCSS = {ClassesCSS.XS12}})
                            End Code
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

