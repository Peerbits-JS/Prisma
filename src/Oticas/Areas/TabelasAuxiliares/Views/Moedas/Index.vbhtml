@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresMoedas")

    Dim gf As New ClsMvcKendoGrid

    Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/Moedas/Index.vbhtml", gf)

    gf.GrelhaHTML = Html.F3M().Grelha(Of Moedas)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)