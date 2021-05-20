@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@ModelType SetoresAtividade

@Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/SetoresAtividade/Detalhe.vbhtml", Model)

@Code
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
                                .AtributosHtml = New With {.class = "textbox-titulo"},
                                .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    'Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "VariavelContabilidade",
                    '     .Label = Traducao.EstruturaAplicacaoTermosBase.VariavelContabilidade,
                    '     .Modelo = Model,
                    '     .AtributosHtml = New With {.class = "textbox-titulo"},
                    '     .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                                        .Modelo = Model,
                                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>
            <div class="row">
                <div class="@(ClassesCSS.XS12)">
                    @Code ViewBag.VistaParcial = True End Code
                    @Html.Partial("~/Areas/TabelasAuxiliares/Views/SetoresAtividadeIdiomas/Index.vbhtml")
                </div>
            </div>
        </div>

    </div>
</div>