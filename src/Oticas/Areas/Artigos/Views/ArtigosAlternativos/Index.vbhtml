@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Code
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim listaCol = New List(Of ClsF3MCampo)
    Dim funcJSEP As String = "ArtigosEnviaParametros"
    Dim funcJSEPA As String = "ArtigosAssociadosEnviaParametros"
    Dim tabURL As String = "../TabelasAuxiliares/" & MenusComuns.DimensoesLinhas

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha1",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 120})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha2",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 120})
    
    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoAlternativo",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = "../" & Menus.Artigos & "/" & Menus.Artigos & "",
        .ControladorAccaoExtra = .Controlador & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSChange = "ArtigosAssociadosChange",
        .OpcaoMenuDescAbrev = Menus.Artigos,
        .LarguraColuna = 120})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha1Alternativo",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 120})

    listaCol.Add(New ClsF3MCampo With {.Id = "IDArtigoDimensaoLinha2Alternativo",
        .TipoEditor = Mvc.Componentes.F3MLookup,
        .Controlador = tabURL,
        .ControladorAccaoExtra = tabURL & "/" & URLs.ViewIndexGrelha,
        .FuncaoJSEnviaParams = funcJSEPA,
        .OpcaoMenuDescAbrev = MenusComuns.DimensoesLinhas,
        .LarguraColuna = 120})
    
    If Not bool Then
        Layout = URLs.SharedLayoutFuncionalidades
    End If
    
    @Scripts.Render("~/bundles/f3m/jsFormularioArtigos")
    @Scripts.Render("~/bundles/f3m/jsFormularioArtigosAssociados")

    Dim gf As New ClsMvcKendoGrid With {
        .FuncaoJavascriptEnviaParams = funcJSEPA,
        .FuncaoJavascriptGridDataBound = "ArtigosAssociadosDataBound",
        .FuncaoJavascriptGridEdit = "ArtigosAssociadosEditaGrelha",
        .TituloGrelhaDeLinhas = Traducao.EstruturaArtigos.ALTERNATIVOS,
        .Campos = listaCol}
    
    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of Oticas.ArtigosAlternativos)(gf).ToHtmlString()
  
    @<div class="f3m-window">
        @Html.Partial(gf.PartialViewInterna, gf)
    </div>
End Code