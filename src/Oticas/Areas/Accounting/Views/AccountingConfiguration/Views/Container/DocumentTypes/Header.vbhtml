@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.AccountingConfiguration

<div class="@ClassesCSS.XS5">
    <label>
        @Traducao.EstruturaContabilidadeConfiguracao.AlternativaPara
        <strong id="lblAlternativa">@Model.GetLabelAternativeCode()</strong>
    </label>
    <div class="row formul-group">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "AlternativeCode",
                .Modelo = Model,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .EEditavel = False,
                .AtributosHtml = New With {.class = "textbox-titulo"},
                .ViewClassesCSS = {ClassesCSS.XS2}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "AlternativeDescription",
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MTexto,
                    .EObrigatorio = True,
                    .Label = Traducao.EstruturaContabilidadeConfiguracao.Alternativa,
                    .AtributosHtml = New With {.class = "textbox-titulo"},
                    .ViewClassesCSS = {ClassesCSS.XS6}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IsPreset",
                    .Label = Traducao.EstruturaContabilidadeConfiguracao.PreDefinida,
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                    .AtributosHtml = New With {.class = "textbox-titulo"},
                    .ViewClassesCSS = {ClassesCSS.XS4 + " f3m-checkbox-sem-top"}})
        End Code
    </div>
</div>

<div class="@ClassesCSS.XS3">
    <div class="row formul-group">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "JournalCode",
                        .Label = Traducao.EstruturaContabilidadeConfiguracao.Diario,
                        .Modelo = Model,
                        .TipoEditor = Mvc.Componentes.F3MTexto,
                        .EObrigatorio = True,
                        .AtributosHtml = New With {.class = "textbox-titulo"},
                        .ViewClassesCSS = {ClassesCSS.XS6}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DocumentCode",
                    .Label = Traducao.EstruturaContabilidadeConfiguracao.CodDoc,
                    .Modelo = Model,
                    .TipoEditor = Mvc.Componentes.F3MTexto,
                    .EObrigatorio = True,
                    .AtributosHtml = New With {.class = "textbox-titulo"},
                    .ViewClassesCSS = {ClassesCSS.XS6}})
            End Code
    </div>
</div>

<div class="@ClassesCSS.XS4">
    <label>@Traducao.EstruturaContabilidadeConfiguracao.RefletePelaContaFinanceira</label>
    <div class="row">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ReflectsIVAClassByFinancialAccount",
                    .Label = Traducao.EstruturaContabilidadeConfiguracao.ClasseIVA,
                    .Modelo = Model,
                    .FuncaoJSChange = "ContabilidadeConfigTiposDocsIVAClassChange",
                    .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                    .ViewClassesCSS = {ClassesCSS.XS6 + " f3m-checkbox-sem-top"}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "ReflectsCostCenterByFinancialAccount",
                .Label = Traducao.EstruturaContabilidadeConfiguracao.CentroCusto,
                .Modelo = Model,
                .FuncaoJSChange = "ContabilidadeConfigTiposDocsCostCenterChange",
                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                .ViewClassesCSS = {ClassesCSS.XS6 + " f3m-checkbox-sem-top"}})
        End Code
    </div>
</div>