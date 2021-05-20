@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Autenticacao
@ModelType Bancos

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/Bancos/Detalhe.vbhtml", Model)

@CODE
    Dim AcaoForm As Int16 = Model.AcaoFormulario
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                                .Modelo = Model,
                                .TipoEditor = Mvc.Componentes.F3MTexto,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS2}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS5}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Sigla",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Sigla,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <!--Nav tabs-->
                <ul class="nav nav-pills f3m-tabs__ul" role="tablist">
                    <li role="presentation" class="nav-item"><a href="#tabDefinicao" class="nav-link active" role="tab" data-toggle="tab" aria-expanded="true">@Traducao.EstruturaAplicacaoTermosBase.Definicao</a></li>
                    <li role="presentation" class="nav-item"><a href="#tabMorada" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Moradas_Contatos</a></li>
                    <li role="presentation" class="nav-item"><a href="#tabObservacoes" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Observacoes</a></li>
                </ul>
                <div class="tab-content">
                    <div id="tabDefinicao" role="tabpanel" class="tab-pane fade show active">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CodigoBP",
                                                        .Label = Traducao.EstruturaAplicacaoTermosBase.CodigoBP,
                                                        .Modelo = Model,
                                                        .TipoEditor = Mvc.Componentes.F3MTexto,
                                                        .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "PaisIban",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.PaisIban,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "BicSwift",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.BicSwift,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "NomeFichSepa",
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.NomeFichSepa,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})
                            End Code
                        </div>
                    </div>
                    <div id="tabMorada" role="tabpanel" class="tab-pane fade show">
                        <div class="form-container">
                            @Code
                                ViewBag.VistaParcial = True
                            End Code
                            @Html.Partial("~/Areas/TabelasAuxiliares/Views/BancosMoradas/Index.vbhtml")
                        </div>
                        <div class="form-container seguintesgrelhas">
                            @Code
                                ViewBag.VistaParcial = True
                            End Code
                            @Html.Partial("~/Areas/TabelasAuxiliares/Views/BancosContatos/Index.vbhtml")
                        </div>
                    </div>
                    <div id="tabObservacoes" role="tabpanel" class="tab-pane fade show">
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