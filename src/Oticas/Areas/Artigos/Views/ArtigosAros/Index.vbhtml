@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

@Code
    Dim blnTemDocumentos As Boolean = False
    If Model.AcaoFormulario = AcoesFormulario.Alterar Then
        blnTemDocumentos = ViewBag.blnTemDocumentos
    End If
End Code

<fieldset Class="fsStyle">
    <legend Class="legendStyle">@Traducao.EstruturaArtigos.Aros</legend>
    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDModelo",
                .Label = Traducao.EstruturaArtigos.Modelo,
                .Modelo = Model,
                .Controlador = "../TabelasAuxiliares/ModelosArtigos",
                .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
                .FuncaoJSEnviaParams = "ArtigosIDModeloEnviaParams",
                .TipoEditor = Mvc.Componentes.F3MLookup,
                .EEditavel = Model.AcaoFormulario = AcoesFormulario.Adicionar,
                .ViewClassesCSS = {ClassesCSS.XS3}})
        End Code
    </div>

    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CodigoCor",
                .Label = Traducao.EstruturaArtigos.Cor,
                .Modelo = Model,
                .EEditavel = Not blnTemDocumentos,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Tamanho",
                .Label = Traducao.EstruturaArtigos.Tamanho,
                .Modelo = Model,
                .EEditavel = Not blnTemDocumentos,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "Hastes",
                .Label = Traducao.EstruturaArtigos.Hastes,
                .Modelo = Model,
                .EEditavel = Not blnTemDocumentos,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .ViewClassesCSS = {ClassesCSS.XS4}})
        End Code
    </div>
    <div class="row form-container">
        @Code
            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CorGenerica",
               .Label = Traducao.EstruturaArtigos.CorGenerica,
               .Modelo = Model,
               .TipoEditor = Mvc.Componentes.F3MTexto,
               .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CorLente",
                .Label = Traducao.EstruturaArtigos.CorLente,
                .Modelo = Model,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .ViewClassesCSS = {ClassesCSS.XS3}})

            Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "TipoLente",
                .Label = Traducao.EstruturaArtigos.TiposLente,
                .Modelo = Model,
                .TipoEditor = Mvc.Componentes.F3MTexto,
                .ViewClassesCSS = {ClassesCSS.XS4}})
        End Code
    </div>
</fieldset>