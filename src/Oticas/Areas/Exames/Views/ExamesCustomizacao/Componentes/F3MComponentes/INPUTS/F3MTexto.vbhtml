@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

@Code
    Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
        .Label = Model.Label,
        .TipoEditor = Mvc.Componentes.F3MTexto,
        .Modelo = Model,
        .EObrigatorio = Model.EObrigatorio,
        .AtributosHtml = New With {.class = CStr(Model.AtributosHtml)},
        .ViewClassesCSS = {CStr(Model.ViewClassesCSS)}})
End Code