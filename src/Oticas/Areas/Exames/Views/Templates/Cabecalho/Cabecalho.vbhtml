@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Modeltype Oticas.Templates

<div class="row desContainer">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
             .Label = Traducao.EstruturaClientes.Codigo,
             .TipoEditor = Mvc.Componentes.F3MTexto,
             .Modelo = Model,
             .ViewClassesCSS = {ClassesCSS.XS4},
             .AtributosHtml = New With {.class = "textbox-titulo"}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
            .Label = Traducao.EstruturaClientes.Descricao,
            .TipoEditor = Mvc.Componentes.F3MTexto,
            .Modelo = Model,
            .ViewClassesCSS = {ClassesCSS.XS6},
            .AtributosHtml = New With {.class = "textbox-titulo"}})

        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
             .Label = Traducao.EstruturaClientes.Ativo,
             .Modelo = Model,
             .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
             .ViewClassesCSS = {ClassesCSS.XS2}})
    End Code
</div>
