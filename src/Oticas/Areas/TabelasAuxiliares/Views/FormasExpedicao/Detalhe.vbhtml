@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType FormasExpedicao
@Code
    @Scripts.Render("~/bundles/f3m/jsFormularioFormasExpedicao")
    @Html.Partial(URLs.PartialTopo, Model)
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
            @Code ViewBag.VistaParcial = True End Code
            @Html.Partial("~/Areas/TabelasAuxiliares/Views/FormasExpedicaoIdiomas/Index.vbhtml")
        </div>
    </div>
</div>