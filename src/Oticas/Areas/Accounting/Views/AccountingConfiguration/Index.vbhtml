@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid
@Code
    @Styles.Render("~/Content/handsontablestyle")
    @Scripts.Render("~/bundles/handsontable")

    Layout = URLs.SharedLayoutFuncionalidades

    Dim htmlStr As String = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString

    Model.GrelhaHTML = htmlStr
    @Html.Partial(Model.PartialViewInterna, Model)
End Code