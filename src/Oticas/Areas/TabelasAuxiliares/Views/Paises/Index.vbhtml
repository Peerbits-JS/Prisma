@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Constanteskendo
@Imports F3M.Modelos.Grelhas
@Code
    Layout = URLs.SharedLayoutTabelas
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .EEditavel = False,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDSigla",
          .TipoEditor = Mvc.Componentes.F3MDropDownList,
          .CampoTexto = "Sigla",
          .EEditavel = False,
          .Controlador = "../Sistema/SistemaSiglasPaises",
          .LarguraColuna = 130})

    'listaCol.Add(New ClsF3MCampo With {.Id = "VariavelContabilidade",
    '    .TooltipDaColunaNaGrelha = "VarCont",
    '    .LarguraColuna = 200})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New Paises().GetType,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of Paises)(gf).ToHtmlString()


End Code
@Html.Partial(gf.PartialViewInterna, gf)