﻿@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "CasasDecimaisTotais",
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "CasasDecimaisIva",
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "CasasDecimaisPrecosUnitarios",
        .LarguraColuna = 150})

    Dim gf As New ClsMvcKendoGrid With {
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of SistemaMoedas)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code