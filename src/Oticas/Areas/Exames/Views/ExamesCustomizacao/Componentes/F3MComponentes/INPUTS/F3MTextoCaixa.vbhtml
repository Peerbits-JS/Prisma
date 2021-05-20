@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

<div class="obs-holder">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
            .Label = Model.Label,
            .TipoEditor = Mvc.Componentes.F3MTextArea,
            .Modelo = Model,
            .EObrigatorio = Model.EObrigatorio,
            .AtributosHtml = New With {.class = "textarea-input" & " " & CStr(Model.AtributosHtml)},
            .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
            .CampoValor = "Texto",
            .ViewClassesCSS = {CStr(Model.ViewClassesCSS)}})
    End Code
</div>