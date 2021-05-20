@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid
@Code
    @<script>var TipoPai = 'DocumentosVendas';</script>
    @Styles.Render("~/Content/handsontablestyle")
    @Scripts.Render("~/bundles/handsontable")
    @Scripts.Render("~/bundles/f3m/jsDocumentosVendasUtils")
    Layout = URLs.SharedLayoutFuncionalidades

    Dim htmlStr As String = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString

    Model.GrelhaHTML = htmlStr
    @Html.Partial(Model.PartialViewInterna, Model)
End Code