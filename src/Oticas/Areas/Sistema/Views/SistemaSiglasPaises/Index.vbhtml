@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

  
    listaCol.Add(New ClsF3MCampo With {.Id = "Sigla",
        .LarguraColuna = 150})

    Dim gf As New ClsMvcKendoGrid With {
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of SistemaSiglasPaises)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code