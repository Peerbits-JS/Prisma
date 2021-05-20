@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Code
    Dim funcJS As String = Mvc.Grelha.Javascript.EnviaParams
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim tabURL As String = "../TabelasAuxiliares/Unidades"

    If bool Then
        funcJS = "ArtigosEnviaParametros"
    Else
        Layout = URLs.SharedLayoutTabelas
    End If

    @Scripts.Render("~/bundles/f3m/jsFormularioArtigosUnidades")
    
    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ordem,
        .LarguraColuna = 200,
        .EVisivel = False})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDAUUnidade",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Label = Traducao.EstruturaArtigos.UNIDADE,
        .Controlador = tabURL,
        .OpcaoMenuDescAbrev = MenusComuns.Unidades,
        .LarguraColuna = 300})
       
    listaCol.Add(New ClsF3MCampo With {.Id = "IDUnidadeConversao",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Label = Traducao.EstruturaArtigos.DESCRICAOUNIDADECONV,
        .Controlador = tabURL,
        .OpcaoMenuDescAbrev = MenusComuns.Unidades,
        .LarguraColuna = 300})

    listaCol.Add(New ClsF3MCampo With {.Id = "FatorConversao",
        .Label = Traducao.EstruturaArtigos.FATORCONVERSAO,
        .LarguraColuna = 120})

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = funcJS,
        .FuncaoJavascriptGridEdit = "ArtigosUnidadesEdita",
        .GravaNoCliente = True,
        .Campos = listaCol}

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosUnidades)(gf).ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code