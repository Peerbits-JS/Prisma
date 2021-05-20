@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)

    If Not bool Then
        Layout = URLs.SharedLayoutTabelas
    End If

    Dim gf As New ClsMvcKendoGrid

    @Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/Localizacoes/IndexGrelhaCab.vbhtml", gf)

    gf.GrelhaHTML = Html.F3M().Grelha(Of Localizacoes)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code