@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .Label = Traducao.EstruturaAplicacaoTermosBase.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .Label = Traducao.EstruturaAplicacaoTermosBase.Descricao,
        .LarguraColuna = 300})

    'listaCol.Add(New ClsF3MCampo With {.Id = "VariavelContabilidade",
    '    .LarguraColuna = 200,
    '    .Label = Traducao.EstruturaAplicacaoTermosBase.VariavelContabilidade,
    '    .TooltipDaColunaNaGrelha = "VarCont"})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New GruposArtigo().GetType,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of GruposArtigo)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)