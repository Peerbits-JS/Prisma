@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType TextosBase
@Code
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
                                .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
                        .Modelo = Model,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS4}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDTiposTextoBase",
                         .Controlador = "../Sistema/SistemaTiposTextoBase",
                         .Label = Traducao.EstruturaAplicacaoTermosBase.TiposTextoBase,
                         .TipoEditor = Mvc.Componentes.F3MDropDownList,
                         .AtributosHtml = New With {.class = "textbox-titulo"},
                         .Modelo = Model,
                         .ViewClassesCSS = {ClassesCSS.XS3}})

                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Ativo,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .ViewClassesCSS = {ClassesCSS.XS2}})
                End Code
            </div>
            <div class="row form-container">
                @Code
                    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Texto",
                        .TipoEditor = Mvc.Componentes.F3MTextArea,
                        .Label = Traducao.EstruturaAplicacaoTermosBase.Texto,
                        .Modelo = Model,
                        .ViewClassesCSS = {ClassesCSS.XS12}})
                End Code
            </div>
        </div>
    </div>
</div>