@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Modelos.Constantes
@Code
    Layout = URLs.SharedLayoutTabelas
    @Scripts.Render("~/bundles/f3m/jsFormularioArtigosUnidades")
    
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../TabelasAuxiliares/Unidades" 

    listaCol.Add(New ClsF3MCampo With {.Id = "IDUnidade",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .OpcaoMenuDescAbrev = "Unidades",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDUnidadeConversao",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .OpcaoMenuDescAbrev = "Unidades",
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "FatorConversao",
        .LarguraColuna = 150})

    Dim gf As New ClsMvcKendoGrid With {
        .Tipo = New UnidadesRelacoes().GetType,
        .TituloGrelhaDeLinhas = Traducao.EstruturaArtigos.UNIDADES,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().Grelha(Of UnidadesRelacoes)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code