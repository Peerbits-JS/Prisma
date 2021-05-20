@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@ModelType CondicoesPagamento

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/CondicoesPagamento/Detalhe.vbhtml", Model)

@Code
    Dim IDSistemaTiposEntidadeDefeito As Long = ViewBag.IDSistemaTiposEntidadeDefeito
    Dim TipoSistemaTiposEntidadeDefeito As String = ViewBag.TipoSistemaTiposEntidadeDefeito
    Dim DescricaoSistemaTiposCondDataVencimento As String = ViewBag.DescricaoSistemaTiposCondDataVencimento
    Dim NumTipoEnt As Integer = ViewBag.NumTotalTipoEntidades
    Dim funcJSIDTipoCondDataVencimentoChange = "CondicoesPagamentoIDTipoCondDataVencimentoComboChange"
    Dim funcJSIDTipoentidadeChange = "CondicoesPagamentoIDTipoEntidadeChange"

    Html.F3M().Hidden(CamposEspecificos.CodigoSistemaTipoEntidade, TiposEntidade.ClientesFornecedores)
    Html.F3M().Hidden("UltimaEntidade", ViewBag.UltimaEntidade)
End Code

<div class="@(ClassesCSS.FormPrinc)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            <div class="row desContainer">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
                                .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
                                .Modelo = Model,
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>

            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Prazo",
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Prazo,
                        .Modelo = Model,
                        .ValorMinimo = 0,
                        .ValorMaximo = 999,
                        .CasasDecimais = 0,
                        .ViewClassesCSS = {ClassesCSS.XS2}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoCondDataVencimento",
                         .CampoTexto = "Descricao",
                         .CampoValor = "ID",
                         .Label = Traducao.EstruturaAplicacaoTermosBase.Condicao,
                         .Controlador = "../Sistema/SistemaTiposCondDataVencimento",
                         .FuncaoJSEnviaParams = "CondicoesPagamentoEnviaParametros",
                         .FuncaoJSChange = funcJSIDTipoCondDataVencimentoChange,
                         .TipoEditor = Mvc.Componentes.F3MDropDownList,
                         .Modelo = Model,
                         .OpcaoMenuDescAbrev = Menus.CondicoesPagamento,
                         .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ValorCondicao",
                         .Label = Traducao.EstruturaAplicacaoTermosBase.ValorCondicao,
                         .ValorMinimo = 0,
                         .CasasDecimais = 0,
                         .ValorMaximo = 31,
                         .Modelo = Model,
                         .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>
            @Code
                Dim hstTabs As New Hashtable
                hstTabs.Add("#tabDescontos", Traducao.EstruturaAplicacaoTermosBase.DescontosLiq)
                hstTabs.Add("#tabIdiomas", Traducao.EstruturaAplicacaoTermosBase.Idiomas)
            End Code

            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <!--Nav tabs-->
                <ul class="nav nav-pills f3m-tabs__ul f3m-tabs__ul--margin-top" role="tablist">
                    @*<li role="presentation" ><a href="#tabDescontos" role="tab" data-toggle="tab" aria-expanded="true">@Traducao.EstruturaAplicacaoTermosBase.DescontosLiq</a></li>*@
                    <li role="presentation" class="nav-item"><a href="#tabIdiomas" class="nav-link active" role="tab" data-toggle="tab" aria-expanded="false">@Traducao.EstruturaAplicacaoTermosBase.Idiomas</a></li>
                </ul>

                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane" id="tabDescontos">
                        <div class="row form-container">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTipoEntidade",
                                                         .CampoTexto = "Tipo",
                                                         .ValorID = IDSistemaTiposEntidadeDefeito,
                                                         .ValorDescricao = TipoSistemaTiposEntidadeDefeito,
                                                         .Label = Traducao.EstruturaAplicacaoTermosBase.TipoEntidade,
                                                         .TipoEditor = Mvc.Componentes.F3MDropDownList,
                                                         .Controlador = "../Sistema/SistemaTiposEntidade",
                                                         .Modelo = Model,
                                                         .FuncaoJSEnviaParams = "CondicoesPagamentoEnviaParametrosTiposEntidade",
                                                         .FuncaoJSChange = funcJSIDTipoentidadeChange,
                                                         .FuncaoJSDataBound = "CondicoesPagamentoJSDataBound",
                                                         .ViewClassesCSS = {ClassesCSS.XS3}})

                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DescontosIncluiIva",
                                    .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                    .Label = Traducao.EstruturaAplicacaoTermosBase.DescontosIncluiIva,
                                    .Modelo = Model,
                                    .ViewClassesCSS = {ClassesCSS.XS2}})
                            End Code
                        </div>

                        @Code
                            ViewBag.VistaParcial = True
                        End Code
                        <div disabled="disabled">
                            @Html.Partial("~/Areas/TabelasAuxiliares/Views/CondicoesPagamentoDescontos/Index.vbhtml")
                        </div>

                    </div>
                    <div role="tabpanel" class="tab-pane fade show active" id="tabIdiomas">

                        @Code ViewBag.VistaParcial = True End Code
                        @Html.Partial("~/Areas/TabelasAuxiliares/Views/CondicoesPagamentoIdiomas/Index.vbhtml")

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>