@Imports F3M.Modelos.Grelhas
@Code
    Dim gf As New ClsMvcKendoGrid
    
    @Html.Partial("~/F3M/Areas/UtilitariosComum/Views/SAFT/Index.vbhtml", New With {.Modelo = Model, .Grelha = gf})
    
    gf.GrelhaHTML = Html.F3M().Grelha(Of Oticas.SAFTPT)(gf).ToHtmlString()
    
    @Html.Partial(gf.PartialViewInterna, gf)
End Code