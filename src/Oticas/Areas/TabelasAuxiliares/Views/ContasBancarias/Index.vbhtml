@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid
@Code
    Layout = URLs.SharedLayoutFuncionalidades
    Dim htmlStr As String = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString

    Model.GrelhaHTML = htmlStr
    @Html.Partial(Model.PartialViewInterna, Model)
End Code