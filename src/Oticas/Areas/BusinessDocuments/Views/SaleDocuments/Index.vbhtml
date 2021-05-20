@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid

@Code
    Layout = URLs.SharedLayoutFuncionalidades
    Model.GrelhaHTML = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString
    @Html.Partial(Model.PartialViewInterna, Model)
End Code