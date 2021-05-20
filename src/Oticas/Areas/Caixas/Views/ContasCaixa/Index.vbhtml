@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Constanteskendo
@Imports F3M.Modelos.Grelhas

@Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresContasCaixa")

@Code
    Layout = URLs.SharedLayoutTabelas

    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {
        .Id = "IDLoja",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../Admin/Lojas",
        .LarguraColuna = 150
    })

    listaCol.Add(New ClsF3MCampo With {
        .Id = CamposGenericos.Codigo,
        .LarguraColuna = 150
    })

    listaCol.Add(New ClsF3MCampo With {
        .Id = CamposGenericos.Descricao,
        .LarguraColuna = 300
    })

    listaCol.Add(New ClsF3MCampo With {
        .Id = "PorDefeito",
        .LarguraColuna = 100
    })

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptGridEdit = "ContasCaixaEdita",
        .Tipo = New ContasCaixa().GetType,
        .CamposOrdenar = New Dictionary(Of String, String) From {
            {"DescricaoLoja", "asc"},
            {"Codigo", "asc"}
        },
        .Campos = listaCol
    }

    gf.GrelhaHTML = Html.F3M().Grelha(Of ContasCaixa)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)