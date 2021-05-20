@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    'listaCol.Add(New ClsF3MCampo With {.Id = "VariavelContabilidade",
    '    .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Concorrencia,
        .EEscondido = True})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = GetType(Familias),
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of Familias)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)