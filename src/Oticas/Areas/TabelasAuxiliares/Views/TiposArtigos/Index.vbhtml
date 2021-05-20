@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Traducao.Traducao
@Code
    Layout = URLs.SharedLayoutTabelas
    @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresTiposArtigos")

    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../Sistema/SistemaClassificacoesTiposArtigos"
    Dim tabURLGeral As String = "../Sistema/SistemaClassificacoesTiposArtigosGeral"

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaClassificacaoGeral",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = tabURLGeral,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSistemaClassificacao",
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = tabURL,
        .LarguraColuna = 150})

    '    listaCol.Add(New ClsF3MCampo With {.Id = "VariavelContabilidade",
    '.TooltipDaColunaNaGrelha = "VarCont",
    '.LarguraColuna = 100})

    Dim gf As New ClsMvcKendoGrid With {
.Tipo = New TiposArtigos().GetType,
.FuncaoJavascriptGridEdit = "TiposArtigosEditaGrelha",
.Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of TiposArtigos)(gf).ToHtmlString()
End Code

@Html.Partial(gf.PartialViewInterna, gf)