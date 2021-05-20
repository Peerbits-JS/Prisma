@Imports F3M.Modelos.Constantes
@Code
    @Html.Partial(ClsConstantes.RetornaURL(URLs.PartialF3MAdicionaF4, Me.Context), New With {
                                                        .JSBundle = String.Empty,
                                                        .Titulo = Traducao.EstruturaMenus.DocumentosVenda,
                                                        .TipoNome = "DocumentosVendas",
                                                        .Modelo = Model,
                                                        .JSFuncaoF4 = String.Empty,
                                                        .TemHT = True})

    @Scripts.Render("~/bundles/f3m/jsbaseformulariosopcoes")
    @Scripts.Render("~/bundles/f3m/jsDocumentosComum")
    @Scripts.Render("~/bundles/f3m/jsFormularioDocumentosVendas")
End Code