@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas

@Scripts.Render("~/bundles/f3m/jsImpostoSelo")

@Code
    Layout = URLs.SharedLayoutTabelas
    Dim casasDec As Integer = ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem
    Dim casasDecMPU As Integer = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo,
        .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDVerbaIS",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../Sistema/SistemaVerbasIS",
        .CampoTexto = CamposGenericos.Codigo,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "Percentagem",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = casasDec,
        .ValorMinimo = 0,
        .ValorMaximo = 100,
        .LarguraColuna = 100})

    listaCol.Add(New ClsF3MCampo With {.Id = "Valor",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = casasDecMPU,
        .LarguraColuna = 120})

    listaCol.Add(New ClsF3MCampo With {.Id = "LimiteMinimo",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = casasDecMPU,
        .LarguraColuna = 120})

    listaCol.Add(New ClsF3MCampo With {.Id = "LimiteMaximo",
        .TipoEditor = Mvc.Componentes.F3MNumero,
        .CasasDecimais = casasDecMPU,
        .LarguraColuna = 120})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New ImpostoSelo().GetType,
        .Campos = listaCol,
        .FuncaoJavascriptGridEdit = "ImpostoSeloGridEdit"}

    gf.GrelhaHTML = Html.F3M().Grelha(Of ImpostoSelo)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code