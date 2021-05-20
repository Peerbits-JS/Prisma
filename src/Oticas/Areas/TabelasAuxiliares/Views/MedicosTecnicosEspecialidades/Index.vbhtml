@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    'Dim gf As New Kendo.Mvc.UI.TreeList(Of PerfisAcessos) With {
    '  .Tipo = New PerfisAcessos().GetType,
    '  .PartialViewInterna = "~/Views/Partials/F3MTreeView.vbhtml",
    '  .Id = F3M.Constantes.CamposEspecificos.TreeListPerfisGeral}

    'gf.TreeHTML = Html.F3M().TreeList(Of PerfisAcessos)(gf).ToHtmlString()



    'Html.F3M().TreeList(Of PerfisAcessos)(New ClsF3MCampo With {
    '                               .Id = F3M.Constantes.CamposEspecificos.TreeListPerfisGeral,
    '                               .Controlador = "PerfisAcessos/",
    '                               .Accao = "ListaMenus"}).Render()





End Code

@*@Html.Partial(gf.PartialViewInterna, gf)*@

