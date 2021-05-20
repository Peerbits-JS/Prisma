@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@Code
    Layout = URLs.SharedLayoutTabelas
    @Scripts.Render("~/bundles/f3m/jsTiposConsultas")

    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 250})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDTemplate",
        .Label = "Estrutura",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Exames/Templates/",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDMapaVista1",
        .Label = "Receita",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../TabelasAuxiliares/MapasVistas/",
        .FuncaoJSEnviaParams = "TiposConsultasReceitaEnviaParametros",
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDMapaVista2",
        .Label = "Relatório",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../TabelasAuxiliares/MapasVistas/",
        .FuncaoJSEnviaParams = "TiposConsultasRelatorioEnviaParametros",
        .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New TiposConsultas().GetType,
        .CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Descricao, "asc"}},
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of TiposConsultas)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code