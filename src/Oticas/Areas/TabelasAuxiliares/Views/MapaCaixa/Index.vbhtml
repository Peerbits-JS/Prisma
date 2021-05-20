@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.ID,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.DataDocumento,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "TotalMoeda",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "TotalMoedaReferencia",
        .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New MapaCaixa().GetType,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of MapaCaixa)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code