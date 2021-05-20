@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas

@Scripts.Render("~/bundles/f3m/jsTiposFases")

@Code
    Layout = URLs.SharedLayoutTabelas

    'COLUNAS
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo, .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao, .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaTiposFases",
                 .TipoEditor = Mvc.Componentes.F3MDropDownList,
                 .Controlador = "../Sistema/SistemaTiposFases/",
                 .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaClassificacoesTiposArtigos",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Controlador = "../Sistema/SistemaClassificacoesTiposArtigos/",
                .Accao = "ListaComboTiposFases",
                .FuncaoJSChange = "TiposFasesSistemaClassificacoesTiposArtigosChange",
                .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaTiposOlhos",
                .TipoEditor = Mvc.Componentes.F3MDropDownList,
                .Controlador = "../Sistema/SistemaTiposOlhos/",
                .FuncaoJSEnviaParams = "TiposFasesSistemaTiposOlhosEnviaParams",
                .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem, .LarguraColuna = 100})

    'GRELHA
    Dim gf As New ClsMvcKendoGrid With {.Campos = listaCol, .FuncaoJavascriptGridEdit = "TiposFasesGridEdit"}
    With gf
        .CamposOrdenar = New Dictionary(Of String, String) From {{"IDSistemaClassificacoesTiposArtigos", "asc"}, {"Ordem", "asc"}}
        .GrelhaHTML = Html.F3M().Grelha(Of TiposFases)(gf).ToHtmlString()
    End With
End Code

@Html.Partial(gf.PartialViewInterna, gf)