@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@ModelType ClsMvcKendoGrid

@*TODO*@
<script src="~/Scripts/ong/funcionalidades/docs/docs.servicos.substituicao/f3m.docs.servicos.substituicao.index.js"></script>

@Code
    @Styles.Render("~/Content/handsontablestyle")
    @Scripts.Render("~/bundles/handsontable")
    Layout = URLs.SharedLayoutFuncionalidades
    Dim htmlStr As String = Html.Partial(URLs.ViewIndexGrelhaF, Model).ToHtmlString

    Model.GrelhaHTML = htmlStr
    @Html.Partial(Model.PartialViewInterna, Model)
End Code